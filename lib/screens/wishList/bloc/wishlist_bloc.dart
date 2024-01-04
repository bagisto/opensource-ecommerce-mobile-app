/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/wishList/bloc/wishlist_repository.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../utils/string_constants.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../data_model/wishlist_model.dart';
import 'fetch_wishlist_event.dart';
import 'fetch_wishlist_state.dart';


class WishListBloc extends Bloc<WishListBaseEvent, WishListBaseState> {
  WishListRepository? repository;

  WishListBloc(this.repository) : super(ShowLoaderWishListState()){
    on<WishListBaseEvent>(mapEventToState);
  }

  void mapEventToState(WishListBaseEvent event,Emitter<WishListBaseState> emit) async {
    if (event is FetchWishListEvent) {
      try {
        WishListData? wishListData = await repository?.callWishListApi();
        if (wishListData?.status == true) {
          emit (FetchDataState.success(wishListProducts: wishListData));
        } else {
          emit (FetchDataState.fail(error:wishListData?.success));
        }
      } catch (e) {
        emit (FetchDataState.fail(error:  (StringConstants.somethingWrong).localized()));
      }
    }
    else if (event is FetchDeleteAddItemEvent) {
      try {
        GraphQlBaseModel? removeFromWishlist =
            await repository?.callWishListDeleteItem(event.productId);
          emit (FetchDeleteAddItemState.success(response: removeFromWishlist, producDeletedId: event.productId,
              successMsg: StringConstants.deletedSuccess.localized()));
      } catch (e) {
        emit (FetchDeleteAddItemState.fail(error: (StringConstants.somethingWrong).localized()));
      }
    }
    else if (event is AddToCartWishlistEvent) {
      try {
        AddToCartModel? addToCartModel =
        await repository!.callAddToCartAPi(int.parse(event.productId));
        if (addToCartModel?.status == true) {
        emit (AddToCartWishlistState.success(
            response: addToCartModel,
            cartProductId: event.productId,
            successMsg: StringConstants.addedToCart.localized())
        );
      } else {
          emit(AddToCartWishlistState.fail(error: addToCartModel?.success));}
        }catch (e) {
        emit (AddToCartWishlistState.fail(
            error: StringConstants.somethingWrong.localized()));
      }

    }else if(event is OnClickWishListLoaderEvent){
      emit (OnClickWishListLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    }
    else if (event is RemoveAllWishlistEvent) {
      try {
        GraphQlBaseModel? baseModel = await repository?.removeAllWishListProducts();
        if (baseModel?.status == true) {
          emit(RemoveAllWishlistProductState.success(
              baseModel: baseModel,
              successMsg: baseModel?.success));
        } else {
          emit(RemoveAllWishlistProductState.fail(error: baseModel?.success));
        }
      } catch (e) {
        emit(RemoveAllWishlistProductState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
