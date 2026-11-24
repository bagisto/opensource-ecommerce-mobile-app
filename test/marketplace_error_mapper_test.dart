import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

QueryResult _resultWithErrors(List<String> messages) {
  return QueryResult(
    options: QueryOptions(document: gql('{ __typename }')),
    data: null,
    source: QueryResultSource.network,
    exception: OperationException(
      graphqlErrors: messages
          .map((message) => GraphQLError(message: message))
          .toList(),
    ),
  );
}

void main() {
  test('maps an unauthorized message', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const ['Unauthorized.']),
    );

    expect(error.kind, SellerApiFailure.unauthorized);
    expect(error.message, 'Unauthorized.');
  });

  test('maps a missing resource', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const ['Resource not found.']),
    );

    expect(error.kind, SellerApiFailure.notFound);
  });

  test('maps a permission denial', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const [
        'You do not have permission to perform this action.',
      ]),
    );

    expect(error.kind, SellerApiFailure.forbidden);
  });

  test('maps a validation message', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const ['The SKU field is required.']),
    );

    expect(error.kind, SellerApiFailure.validation);
    expect(error.message, 'The SKU field is required.');
  });

  test('maps the live bad-credentials message', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const ['Please check your credentials and try again.']),
    );

    expect(error.kind, SellerApiFailure.validation);
  });

  test('joins several messages', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithErrors(const [
        'The SKU field is required.',
        'The name field is required.',
      ]),
    );

    expect(
      error.message,
      'The SKU field is required.\nThe name field is required.',
    );
  });
}
