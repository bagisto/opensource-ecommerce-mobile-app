import 'package:bagisto_flutter/core/utils/phone_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phone numbers follow the storefront rule, not a fixed length', () {
    expect(isValidPhoneNumber('12345'), isTrue);
    expect(isValidPhoneNumber('+919876543210'), isTrue);
    expect(isValidPhoneNumber('98765432101234'), isTrue);
    expect(isValidPhoneNumber('98765-43210'), isFalse);
    expect(isValidPhoneNumber('abc'), isFalse);
    expect(isValidPhoneNumber(''), isFalse);
  });
}
