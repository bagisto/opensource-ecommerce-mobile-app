import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only an explicit "0" guestCheckout blocks guest checkout', () {
    expect(CartRepository.allowsGuestCheckout('1'), isTrue);
    expect(CartRepository.allowsGuestCheckout(''), isTrue);
    expect(CartRepository.allowsGuestCheckout(null), isTrue);
    expect(CartRepository.allowsGuestCheckout('0'), isFalse);
    expect(CartRepository.allowsGuestCheckout(0), isFalse);
    expect(CartRepository.allowsGuestCheckout(false), isFalse);
  });
}
