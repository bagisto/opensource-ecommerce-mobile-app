import 'package:bagisto_flutter/core/graphql/checkout_queries.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the checkout GraphQL document shapes that the live Bagisto schema
/// dictates. Selecting a field the payload type no longer exposes fails
/// validation at runtime, which only shows up as a generic error, so the
/// absence is asserted here instead.
void main() {
  group('CheckoutMutations.createCheckoutOrder', () {
    test('does not select orderIncrementId', () {
      expect(
        CheckoutMutations.createCheckoutOrder.contains('orderIncrementId'),
        isFalse,
      );
    });

    test('still selects orderId as the order number fallback', () {
      expect(CheckoutMutations.createCheckoutOrder, contains('orderId'));
      expect(CheckoutMutations.createCheckoutOrder, contains('success'));
      expect(CheckoutMutations.createCheckoutOrder, contains('message'));
    });
  });

  group('CheckoutQueries.getCustomerSuspension', () {
    test('reads the account email and the suspension flag', () {
      expect(
        CheckoutQueries.getCustomerSuspension,
        contains('readCustomerProfile'),
      );
      expect(CheckoutQueries.getCustomerSuspension, contains('email'));
      expect(CheckoutQueries.getCustomerSuspension, contains('isSuspended'));
    });
  });
}
