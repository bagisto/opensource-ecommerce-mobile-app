import 'package:bagisto_flutter/features/checkout/data/repository/checkout_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('logged-in checkout addresses carry the account email', () {
    final input = applyCustomerEmail({
      'billingEmail': 'typed@example.com',
      'shippingEmail': 'other@example.com',
      'billingCity': 'Noida',
    }, 'account@example.com');

    expect(input['billingEmail'], 'account@example.com');
    expect(input['shippingEmail'], 'account@example.com');
    expect(input['billingCity'], 'Noida');
  });

  test('without an account email the input is unchanged', () {
    final original = {'billingEmail': 'typed@example.com'};
    expect(applyCustomerEmail(original, null), original);
    expect(applyCustomerEmail(original, ''), original);
  });

  test('shipping email is only set when the input has shipping fields', () {
    final input = applyCustomerEmail({
      'billingEmail': '',
    }, 'account@example.com');
    expect(input.containsKey('shippingEmail'), isFalse);
  });
}
