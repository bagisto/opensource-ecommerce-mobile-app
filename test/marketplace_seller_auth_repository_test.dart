import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Builds a client whose link answers with [data] or [errors] without a network.
GraphQLClient clientReturning({
  Map<String, dynamic>? data,
  List<String> errors = const [],
}) {
  final link = Link.function((request, [forward]) async* {
    yield Response(
      data: data,
      errors: errors.map((message) => GraphQLError(message: message)).toList(),
      response: const {},
      context: const Context(),
    );
  });

  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
  );
}

void main() {
  test('login returns the token on success', () async {
    final repository = SellerAuthRepository(
      client: clientReturning(
        data: {
          'createSellerLogin': {
            'sellerLogin': {
              'token': '107|abc',
              'success': true,
              'message': 'You have logged in successfully.',
            },
          },
        },
      ),
    );

    final result = await repository.login(
      email: 'seller@example.com',
      password: 'secret',
    );

    expect(result.success, isTrue);
    expect(result.token, '107|abc');
  });

  test('login throws the server message on bad credentials', () async {
    final repository = SellerAuthRepository(
      client: clientReturning(
        errors: const ['Please check your credentials and try again.'],
      ),
    );

    await expectLater(
      repository.login(email: 'seller@example.com', password: 'wrong'),
      throwsA(
        isA<SellerApiException>()
            .having((e) => e.kind, 'kind', SellerApiFailure.validation)
            .having(
              (e) => e.message,
              'message',
              'Please check your credentials and try again.',
            ),
      ),
    );
  });

  test('sign-up attributes map code, requiredness and options', () async {
    final repository = SellerAuthRepository(
      client: clientReturning(
        data: {
          'sellerAttributes': [
            {
              'code': 'business_name',
              'name': 'Business Name',
              'type': 'text',
              'isRequired': true,
              'options': null,
            },
            {
              'code': 'business_type',
              'name': 'Business Type',
              'type': 'select',
              'isRequired': false,
              'options': [
                {'id': '1', 'label': 'Retail'},
              ],
            },
          ],
        },
      ),
    );

    final attributes = await repository.signUpAttributes();

    expect(attributes, hasLength(2));
    expect(attributes.first.code, 'business_name');
    expect(attributes.first.isRequired, isTrue);
    expect(attributes.last.options.single.label, 'Retail');
  });

  test('register sends custom attributes as code/value pairs', () async {
    final repository = SellerAuthRepository(
      client: clientReturning(
        data: {
          'createSellerRegister': {
            'sellerRegister': {
              'success': true,
              'isApproved': false,
              'message': 'Your shop is awaiting approval.',
            },
          },
        },
      ),
    );

    final message = await repository.register(
      name: 'Demo Seller',
      email: 'demo@example.com',
      slug: 'demo-shop',
      password: 'secret123',
      passwordConfirmation: 'secret123',
      attributes: const {'vatNumber': '123456789'},
    );

    expect(message, 'Your shop is awaiting approval.');
  });
}
