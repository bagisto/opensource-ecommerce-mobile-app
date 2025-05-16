/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/wishList/utils/index.dart';

import '../../cart_screen/cart_model/cart_data_model.dart';

class WishListBloc extends Bloc<WishListBaseEvent, WishListBaseState> {
  WishListRepository? repository;

  WishListBloc(this.repository) : super(ShowLoaderWishListState()) {
    on<WishListBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      WishListBaseEvent event, Emitter<WishListBaseState> emit) async {
    if (event is FetchWishListEvent) {
      try {
        WishListData? wishListData = await repository?.callWishListApi();
        if (wishListData?.status == true) {
          emit(FetchDataState.success(wishListProducts: wishListData));
        } else {
          emit(FetchDataState.fail(
              error: StringConstants.somethingWrong.localized()));
        }
      } catch (e) {
        emit(FetchDataState.fail(
            error: (StringConstants.somethingWrong).localized()));
      }
    } else if (event is FetchDeleteAddItemEvent) {
      try {
        AddToCartModel? removeFromWishlist =
            await repository?.callWishListDeleteItem(event.productId);
        emit(FetchDeleteAddItemState.success(
            response: removeFromWishlist,
            productDeletedId: event.productId,
            successMsg: StringConstants.deletedSuccess.localized()));
      } catch (e) {
        emit(FetchDeleteAddItemState.fail(
            error: (StringConstants.somethingWrong).localized()));
      }
    } else if (event is AddToCartWishlistEvent) {
      try {
        AddToCartModel? addToCartModel = await repository!
            .callAddToCartAPi(int.parse(event.productId), event.quantity);
        if (addToCartModel?.status == true) {
          emit(AddToCartWishlistState.success(
              response: addToCartModel,
              cartProductId: event.productId,
              successMsg: StringConstants.addedToCart.localized()));
        } else {
          emit(AddToCartWishlistState.fail(
              error: addToCartModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToCartWishlistState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is OnClickWishListLoaderEvent) {
      emit(OnClickWishListLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is RemoveAllWishlistEvent) {
      try {
        BaseModel? baseModel = await repository?.removeAllWishListProducts();
        if (baseModel?.success == true) {
          emit(RemoveAllWishlistProductState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(RemoveAllWishlistProductState.fail(
              error: baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(RemoveAllWishlistProductState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is GetCartCountEvent) {
      try {
        CartModel? cartDetails = await repository?.cartCountApi();
        emit(FetchCartCountState.success(cartDetails: cartDetails));
      } catch (e) {
        emit(FetchCartCountState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
