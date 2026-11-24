import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient _clientReturning(Map<String, dynamic> data) {
  final link = Link.function((request, [forward]) async* {
    yield Response(data: data, response: const {}, context: const Context());
  });
  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  );
}

void main() {
  test('profile maps identity and approval state', () async {
    final repository = SellerAccountRepository(
      client: _clientReturning({
        'sellerProfile': {
          'name': 'Ashif',
          'email': 'seller@example.com',
          'slug': 'acme-store',
          'phone': '9999999999',
          'businessName': 'Acme Store',
          'businessDescription': 'We sell quality goods.',
          'logoUrl': 'https://example.com/logo.png',
          'bannerUrl': null,
          'isApproved': true,
          'isSuspended': false,
          'city': 'Pune',
          'state': 'MH',
          'country': 'IN',
        },
      }),
    );

    final profile = await repository.profile();

    expect(profile.name, 'Ashif');
    expect(profile.businessName, 'Acme Store');
    expect(profile.displayName, 'Acme Store');
    expect(profile.isApproved, isTrue);
    expect(profile.isSuspended, isFalse);
    expect(profile.bannerUrl, isNull);
  });

  test('displayName falls back to the personal name', () async {
    final repository = SellerAccountRepository(
      client: _clientReturning({
        'sellerProfile': {
          'name': 'Ashif',
          'email': 'seller@example.com',
          'businessName': null,
          'isApproved': true,
        },
      }),
    );

    final profile = await repository.profile();

    expect(profile.displayName, 'Ashif');
  });

  test('permissions collapse the ACL list into a lookup', () async {
    final repository = SellerAccountRepository(
      client: _clientReturning({
        'sellerAclPermissions': [
          {'key': 'dashboard', 'name': 'Dashboard', 'parent': null, 'level': 0},
          {'key': 'sales', 'name': 'Sales', 'parent': null, 'level': 0},
          {
            'key': 'sales.orders',
            'name': 'Orders',
            'parent': 'sales',
            'level': 1,
          },
        ],
      }),
    );

    final permissions = await repository.permissions();

    expect(permissions.can('sales.orders'), isTrue);
    expect(permissions.can('settings.users'), isFalse);
  });
}
