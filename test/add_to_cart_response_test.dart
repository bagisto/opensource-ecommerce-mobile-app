import 'package:bagisto_flutter/core/error/error_mapper.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success:false from addProductInCart is an error with its message', () {
    Object? error;
    try {
      CartRepository.parseAddToCartPayload({
        'success': false,
        'message':
            'The requested quantity is not available, please try again later.',
      });
    } catch (e) {
      error = e;
    }

    expect(error, isNotNull);
    expect(
      ErrorMapper.getUserMessage(error!, context: 'adding the product to cart'),
      'The requested quantity is not available, please try again later.',
    );
  });

  test('successful payload parses into the cart', () {
    final cart = CartRepository.parseAddToCartPayload({
      'success': true,
      'message': 'Product added to cart successfully',
      'id': 5,
      'itemsQty': 2,
    });

    expect(cart.id, 5);
  });
}
