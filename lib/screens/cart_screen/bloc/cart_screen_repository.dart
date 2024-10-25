/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';

abstract class CartScreenRepository {
  Future<CartModel?> getCartData();

  Future<AddToCartModel?> updateItemToCart(List<Map<dynamic, String>> item);

  Future<AddToCartModel?> removeFromCart(int cartItemId);

  Future<ApplyCoupon?> addCoupon(String code);

  Future<ApplyCoupon?> removeCoupon();

  Future<BaseModel?> removeAllCartItem();

  Future<AddToCartModel?> moveToWishlist(int id);
}

class CartScreenRepositoryImp implements CartScreenRepository {
  @override
  Future<CartModel?> getCartData() async {
    CartModel? cartDetailsModel;
    try {
      cartDetailsModel = await ApiClient().getCartDetails();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cartDetailsModel;
  }

  @override
  Future<AddToCartModel?> updateItemToCart(
      List<Map<dynamic, String>> item) async {
    AddToCartModel? updateCartModel;
    try {
      updateCartModel = await ApiClient().updateItemToCart(item);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return updateCartModel;
  }

  @override
  Future<AddToCartModel?> removeFromCart(int cartItemId) async {
    AddToCartModel? removeCartProductModel;

    try {
      removeCartProductModel = await ApiClient().removeItemFromCart(
        cartItemId,
      );
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return removeCartProductModel;
  }

  @override
  Future<ApplyCoupon?> addCoupon(String code) async {
    ApplyCoupon? baseModel;
    try {
      baseModel = await ApiClient().applyCoupon(code);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<ApplyCoupon?> removeCoupon() async {
    ApplyCoupon? baseModel;
    try {
      baseModel = await ApiClient().removeCoupon();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel;
  }

  @override
  Future<AddToCartModel?> moveToWishlist(int id) async {
    AddToCartModel? baseModel;
    try {
      baseModel = await ApiClient().moveCartToWishlist(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel;
  }

  @override
  Future<BaseModel?> removeAllCartItem() async {
    BaseModel? removeAllCartProductModel;

    try {
      removeAllCartProductModel = await ApiClient().removeAllCartItem();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return removeAllCartProductModel;
  }
}
