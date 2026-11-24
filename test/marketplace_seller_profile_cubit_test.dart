import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_capabilities.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_country.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAccountRepository implements SellerAccountRepository {
  _FakeAccountRepository({required this.stored, this.failWith});

  SellerProfile stored;
  final SellerApiException? failWith;
  Map<String, dynamic>? lastInput;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProfile> profile() async => stored;

  @override
  Future<SellerShopInformation?> shopInformation() async => null;

  @override
  Future<List<SellerCountry>> countries() async => const [];

  @override
  Future<List<SellerAclPermission>> aclPermissions() async => const [];

  @override
  Future<SellerCapabilities> capabilities() async => const SellerCapabilities();

  @override
  Future<SellerPermissions> permissions() async => SellerPermissions.none();

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async {
    if (failWith != null) throw failWith!;
    lastInput = input;
    stored = stored.copyWith(
      businessName: input['businessName'] as String?,
      phone: input['phone'] as String?,
    );
    return stored;
  }
}

const _profile = SellerProfile(
  name: 'Ashif',
  email: 'seller@example.com',
  businessName: 'Acme Store',
  phone: '111',
  isApproved: true,
);

void main() {
  test('load reads the profile', () async {
    final cubit = SellerProfileCubit(
      repository: _FakeAccountRepository(stored: _profile),
    );

    await cubit.load();

    expect(cubit.state.status, SellerProfileStatus.loaded);
    expect(cubit.state.profile?.businessName, 'Acme Store');
  });

  test('save sends only the changed fields and keeps the result', () async {
    final repository = _FakeAccountRepository(stored: _profile);
    final cubit = SellerProfileCubit(repository: repository);
    await cubit.load();

    await cubit.save({'businessName': 'Acme Store v2'});

    expect(repository.lastInput, {'businessName': 'Acme Store v2'});
    expect(cubit.state.profile?.businessName, 'Acme Store v2');
    expect(cubit.state.status, SellerProfileStatus.loaded);
    expect(cubit.state.savedAt, isNotNull);
  });

  test('a rejected save surfaces the server message', () async {
    final cubit = SellerProfileCubit(
      repository: _FakeAccountRepository(
        stored: _profile,
        failWith: const SellerApiException(
          'The slug has already been taken.',
          SellerApiFailure.validation,
        ),
      ),
    );
    await cubit.load();

    await cubit.save({'slug': 'taken-slug'});

    expect(cubit.state.status, SellerProfileStatus.failed);
    expect(cubit.state.errorMessage, 'The slug has already been taken.');
  });
}
