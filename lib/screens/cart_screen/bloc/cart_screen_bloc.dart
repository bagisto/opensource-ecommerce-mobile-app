/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../utils/string_constants.dart';
import '../cart_model/add_to_cart_model.dart';
import '../cart_model/apply_coupon.dart';
import '../cart_model/cart_data_model.dart';
import 'cart_screen_base_event.dart';
import 'cart_screen_repository.dart';
import 'fetch_cart_data_state.dart';

class CartScreenBloc extends Bloc<CartScreenBaseEvent, CartScreenBaseState> {
  CartScreenRepository? repository;

  CartScreenBloc(this.repository) : super(ShowLoaderCartState()) {
    on<CartScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      CartScreenBaseEvent event, Emitter<CartScreenBaseState> emit) async {
    if (event is FetchCartDataEvent) {
      try {
        CartModel? cartDetailsModel = await repository?.getCartData();
        emit(FetchCartDataState.success(cartDetailsModel: cartDetailsModel));
      } catch (e) {
        emit(FetchCartDataState.fail(error: e.toString()));
      }
    } else if (event is UpdateCartEvent) {
      try {
        AddToCartModel? cartDetailsModel =
            await repository?.updateItemToCart(event.item ?? []);
        emit(UpdateCartState.success(
            cartDetailsModel: cartDetailsModel, item: event.item));
      } catch (e) {
        emit(UpdateCartState.fail(error: e.toString()));
      }
    } else if (event is RemoveCartItemEvent) {
      try {
        AddToCartModel? removeCartProductModel =
            await repository?.removeFromCart(event.cartItemId!);
        emit(RemoveCartItemState.success(
            removeCartProductModel: removeCartProductModel,
            productDeletedId: event.cartItemId));
      } catch (e) {
        emit(RemoveCartItemState.fail(error: e.toString()));
      }
    } else if (event is RemoveAllCartItemEvent) {
      try {
        GraphQlBaseModel? removeCartProductModel =
            await repository?.removeAllCartItem();
        emit(RemoveAllCartItemState.success(
            removeAllCartProductModel: removeCartProductModel));
      } catch (e) {
        emit(RemoveAllCartItemState.fail(error: e.toString()));
      }
    } else if (event is AddCouponCartEvent) {
      try {
        ApplyCoupon? baseModel =
            await repository?.addCoupon(event.code ?? "");
        if (baseModel?.success == true) {
          emit(AddCouponState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(AddCouponState.fail(error: baseModel?.message));
        }
      } catch (e) {
        emit(AddCouponState.fail(error: e.toString()));
      }
    } else if (event is RemoveCouponCartEvent) {
      try {
        ApplyCoupon? baseModel = await repository?.removeCoupon();
        event.cartDetailsModel?.couponCode = null;
        if (baseModel?.success == true) {
          emit(RemoveCouponCartState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(RemoveCouponCartState.fail(error: baseModel?.message ?? ""));
        }
      } catch (e) {
        emit(RemoveCouponCartState.fail(error: e.toString()));
      }
    } else if (event is MoveToCartEvent) {
      try {
        AddToCartModel? baseModel =
            await repository?.moveToWishlist(event.id ?? 0);
        if (baseModel?.status == true) {
          emit(MoveToCartState.success(
            response: baseModel,
            id: event.id,
          ));
        } else {
          emit(MoveToCartState.fail(
              error: baseModel?.message ?? StringConstants.somethingWrong.localized()));
        }
      } catch (e) {
        emit(MoveToCartState.fail(error: e.toString()));
      }
    }
  }
}
