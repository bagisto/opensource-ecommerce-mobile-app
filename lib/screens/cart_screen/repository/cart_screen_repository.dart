/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import '../../../api/api_client.dart';
import '../../../models/add_to_cart_model/add_to_cart_model.dart';
import '../../../models/cart_model/cart_data_model.dart';
import '../../../models/checkout_models/apply_coupon.dart';

abstract class CartScreenRepository {
  Future<CartModel> getCartData();

  Future<AddToCartModel> updateItemToCart(List<Map<dynamic, String>> item);

  Future<GraphQlBaseModel> removeFromCart(int cartItemId);

  Future<ApplyCoupon> addCoupon(String code);

  Future<ApplyCoupon> removeCoupon();

  Future<GraphQlBaseModel> removeAllCartItem();

  Future<AddToCartModel> moveToWishlist(int id);
}

class CartScreenRepositoryImp implements CartScreenRepository {
  @override
  Future<CartModel> getCartData() async {
    CartModel? cartDetailsModel;
    try {
      cartDetailsModel = await ApiClient().getCartDetails();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return cartDetailsModel!;
  }

  @override
  Future<AddToCartModel> updateItemToCart(
      List<Map<dynamic, String>> item) async {
    AddToCartModel? updateCartModel;
    try {
      updateCartModel = await ApiClient().updateItemToCart(item);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return updateCartModel!;
  }

  @override
  Future<GraphQlBaseModel> removeFromCart(int cartItemId) async {
    GraphQlBaseModel? removeCartProductModel;

    try {
      removeCartProductModel = await ApiClient().removeItemFromCart(
        cartItemId,
      );
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return removeCartProductModel!;
  }

  @override
  Future<ApplyCoupon> addCoupon(String code) async {
    ApplyCoupon? baseModel;
    try {
      baseModel = await ApiClient().applyCoupon(code);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<ApplyCoupon> removeCoupon() async {
    ApplyCoupon? baseModel;
    try {
      baseModel = await ApiClient().removeCoupon();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<AddToCartModel> moveToWishlist(int id) async {
    AddToCartModel? baseModel;
    try {
      baseModel = await ApiClient().moveToWishlist(id);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }

  @override
  Future<GraphQlBaseModel> removeAllCartItem() async {
    GraphQlBaseModel? removeAllCartProductModel;

    try {
      removeAllCartProductModel = await ApiClient().removeAllCartItem();
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return removeAllCartProductModel!;
  }
}
