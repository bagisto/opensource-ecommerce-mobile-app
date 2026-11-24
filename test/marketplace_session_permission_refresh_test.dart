import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The whole panel before the operator switches subscriptions on.
const _everything = SellerCapabilities(
  sellerId: 38,
  permissions: SellerPermissions(
    type: 'all',
    keys: {'dashboard', 'inventories.manage_inventory', 'settings.general'},
  ),
  features: SellerFeatures(subscriptions: false),
);

/// The same seller a moment later, holding "test plan": the server has
/// already reduced the keys by the subscription.
const _onAPlan = SellerCapabilities(
  sellerId: 38,
  permissions: SellerPermissions(
    type: 'custom',
    keys: {'dashboard', 'profile', 'catalog', 'catalog.products'},
  ),
  features: SellerFeatures(subscriptions: true),
  plan: SellerPlanLimits(planId: 3, name: 'test plan'),
);

class _Auth implements SellerAuthRepository {
  @override
  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async => const SellerLoginResult(success: true, token: '107|abc');

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Account implements SellerAccountRepository {
  _Account(this._answers);

  /// Read in order, so the second call can answer differently — which is
  /// what the server does once the operator has switched plans on.
  final List<SellerCapabilities> _answers;
  int reads = 0;

  @override
  Future<SellerCapabilities> capabilities() async {
    final answer = _answers[reads.clamp(0, _answers.length - 1)];
    reads++;
    return answer;
  }

  @override
  Future<SellerProfile> profile() async => const SellerProfile(
    name: 'Ashif',
    email: 'seller@example.com',
    businessName: 'Acme Store',
    isApproved: true,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('refreshing the switches narrows the permissions with them', () async {
    final account = _Account([_everything, _onAPlan]);
    final cubit = SellerSessionCubit(
      authRepository: _Auth(),
      accountRepositoryBuilder: (_) => account,
    );
    addTearDown(cubit.close);

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    expect(cubit.state.permissions.can('inventories.manage_inventory'), isTrue);
    expect(cubit.state.capabilities.planRequired, isFalse);

    // The operator switches subscriptions on while the seller sits on the
    // dashboard; a refresh re-reads the switches.
    await cubit.refreshFeatures();

    // The switches moved — and so did the keys. Emitting only the features
    // left the drawer offering Inventories and Settings, which the new plan
    // withholds and every screen behind them refuses.
    expect(cubit.state.capabilities.features.subscriptions, isTrue);
    expect(
      cubit.state.permissions.can('inventories.manage_inventory'),
      isFalse,
    );
    expect(cubit.state.permissions.can('settings.general'), isFalse);
    expect(cubit.state.permissions.can('catalog.products'), isTrue);
    expect(cubit.state.permissions.type, 'custom');
  });

  test('a failed refresh keeps the keys it already had', () async {
    final account = _Account([_everything]);
    final cubit = SellerSessionCubit(
      authRepository: _Auth(),
      accountRepositoryBuilder: (_) => account,
    );
    addTearDown(cubit.close);

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');
    final before = cubit.state.permissions.keys;

    await cubit.refreshFeatures();

    expect(cubit.state.permissions.keys, before);
  });
}
