import 'package:bagisto_flutter/core/error/error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

OperationException _graphqlError(String message) =>
    OperationException(graphqlErrors: [GraphQLError(message: message)]);

void main() {
  test('unmapped GraphQL errors keep the step context', () {
    final message = ErrorMapper.getUserMessage(
      _graphqlError(
        'Variable "\$input" got invalid value {"firstName":"A","lastName":"B",'
        '"address1":"x","city":"c","state":"UP","country":"IN","postcode":"1",'
        '"phone":"1","defaultAddress":true,"useForShipping":true}; Field '
        '"useForShipping" is not defined by type '
        '"createAddUpdateCustomerAddressInput".',
      ),
      context: 'saving your address book',
    );

    expect(message, contains('saving your address book'));
  });

  test('untranslated server keys are not shown to users', () {
    final message = ErrorMapper.getUserMessage(
      _graphqlError('bagistoapi::app.graphql.product.invalid-id-format'),
      context: 'loading the product',
    );

    expect(message, isNot(contains('::')));
    expect(message, contains('loading the product'));
  });

  test('readable GraphQL errors pass through unchanged', () {
    expect(
      ErrorMapper.getUserMessage(
        _graphqlError('Coupon code is invalid.'),
        context: 'applying the coupon',
      ),
      'Coupon code is invalid.',
    );
  });
}
