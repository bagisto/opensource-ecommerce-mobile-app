import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_auth_storage.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_country.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements SellerAuthRepository {
  _FakeAuthRepository({this.loginResult, this.loginError});

  final SellerLoginResult? loginResult;
  final SellerApiException? loginError;
  bool logoutCalled = false;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async {
    if (loginError != null) throw loginError!;
    return loginResult!;
  }

  @override
  Future<void> logout() async => logoutCalled = true;

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<List<SellerAttribute>> signUpAttributes() async => const [];

  @override
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async => 'ok';
}

class _FakeAccountRepository implements SellerAccountRepository {
  _FakeAccountRepository(this._profile, {this.capabilitiesFail});

  final SellerProfile _profile;

  /// Set to make the capabilities read fail, so a test can prove the session
  /// falls back to the ACL catalogue rather than refusing to open.
  final Object? capabilitiesFail;

  @override
  Future<SellerCapabilities> capabilities() async {
    if (capabilitiesFail != null) throw capabilitiesFail!;
    return const SellerCapabilities(
      sellerId: 38,
      permissions: SellerPermissions(type: 'custom', keys: {'dashboard'}),
      features: SellerFeatures(subscriptions: false, canAssignProduct: false),
    );
  }

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProfile> profile() async => _profile;

  @override
  Future<List<SellerCountry>> countries() async => const [];

  @override
  Future<List<SellerAclPermission>> aclPermissions() async => const [
    SellerAclPermission(key: 'dashboard', name: 'Dashboard', level: 0),
  ];

  @override
  Future<SellerPermissions> permissions() async =>
      const SellerPermissions(type: 'custom', keys: {'dashboard'});

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async =>
      _profile;
}

SellerSessionCubit _cubit({
  required _FakeAuthRepository auth,
  required SellerProfile profile,
  Object? capabilitiesFail,
}) {
  return SellerSessionCubit(
    authRepository: auth,
    accountRepositoryBuilder: (_) =>
        _FakeAccountRepository(profile, capabilitiesFail: capabilitiesFail),
  );
}

const _approvedProfile = SellerProfile(
  name: 'Ashif',
  email: 'seller@example.com',
  businessName: 'Acme Store',
  isApproved: true,
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('sign-in stores the token and becomes active', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    expect(cubit.state.status, SellerSessionStatus.active);
    expect(cubit.state.profile?.businessName, 'Acme Store');
    expect(cubit.state.permissions.can('dashboard'), isTrue);
    expect(await SellerAuthStorage.getToken(), '107|abc');
  });

  test('an unapproved seller lands in pendingApproval', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(
      auth: auth,
      profile: const SellerProfile(
        name: 'New',
        email: 'new@example.com',
        isApproved: false,
      ),
    );

    await cubit.signIn(email: 'new@example.com', password: 'secret');

    expect(cubit.state.status, SellerSessionStatus.pendingApproval);
  });

  test('a suspended seller lands in suspended', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(
      auth: auth,
      profile: const SellerProfile(
        name: 'Blocked',
        email: 'blocked@example.com',
        isApproved: true,
        isSuspended: true,
      ),
    );

    await cubit.signIn(email: 'blocked@example.com', password: 'secret');

    expect(cubit.state.status, SellerSessionStatus.suspended);
  });

  test('a rejected sign-in surfaces the server message', () async {
    final auth = _FakeAuthRepository(
      loginError: const SellerApiException(
        'Please check your credentials and try again.',
        SellerApiFailure.validation,
      ),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.signIn(email: 'seller@example.com', password: 'wrong');

    expect(cubit.state.status, SellerSessionStatus.failed);
    expect(
      cubit.state.errorMessage,
      'Please check your credentials and try again.',
    );
    expect(await SellerAuthStorage.getToken(), isNull);
  });

  test('sign-out clears storage and calls the API', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);
    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    await cubit.signOut();

    expect(auth.logoutCalled, isTrue);
    expect(cubit.state.status, SellerSessionStatus.unauthenticated);
    expect(await SellerAuthStorage.getToken(), isNull);
  });

  test('bootstrap with no stored token is unauthenticated', () async {
    final auth = _FakeAuthRepository();
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.bootstrap();

    expect(cubit.state.status, SellerSessionStatus.unauthenticated);
  });

  test('bootstrap restores an existing session', () async {
    await SellerAuthStorage.saveSession(
      token: 'stored-token',
      name: 'Ashif',
      email: 'seller@example.com',
    );
    final auth = _FakeAuthRepository();
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.bootstrap();

    expect(cubit.state.status, SellerSessionStatus.active);
    expect(cubit.token, 'stored-token');
  });

  test('the session reads what the seller may do', () async {
    // The permission keys used to come from `sellerAclPermissions`, which
    // lists what a role may hold rather than what this account holds.
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    expect(cubit.state.capabilities.sellerId, 38);
    expect(cubit.state.capabilities.features.subscriptions, isFalse);
    expect(cubit.state.capabilities.features.canAssignProduct, isFalse);
    expect(cubit.state.permissions.can('dashboard'), isTrue);
  });

  test('a build without the capabilities query still signs in', () async {
    // Falling back to the ACL catalogue over-grants, which is exactly what the
    // app did before — losing the session would be worse.
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(
      auth: auth,
      profile: _approvedProfile,
      capabilitiesFail: const SellerApiException(
        'Cannot query field "sellerCapabilities"',
        SellerApiFailure.unknown,
      ),
    );

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    expect(cubit.state.status, SellerSessionStatus.active);
    expect(cubit.state.permissions.can('dashboard'), isTrue);
    // Nothing known about the operator's switches, so nothing is hidden.
    expect(cubit.state.capabilities.features.subscriptions, isFalse);
    expect(cubit.state.capabilities.features.canViewCustomers, isTrue);
  });
}
