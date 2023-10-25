/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/screens/wishList/events/delete_item_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/wishlist_loader_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/wishlist_base_event.dart';
import 'package:bagisto_app_demo/screens/wishList/events/addToCartWishlistEvent.dart';
import 'package:bagisto_app_demo/screens/wishList/respository/wishlist_repository.dart';
import 'package:bagisto_app_demo/screens/wishList/state/delete_item_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/fetch_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/loader_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/show_loader_wishlist_state.dart';
import 'package:bagisto_app_demo/screens/wishList/state/addToCartWishlistState.dart';
import 'package:bagisto_app_demo/screens/wishList/state/wishlist_base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../base_model/graphql_base_model.dart';
import '../../../models/wishlist_model/wishlist_model.dart';
import '../events/fetch_wishlist_event.dart';

class WishListBloc extends Bloc<WishListBaseEvent, WishListBaseState> {
  WishListRepository? repository;
  BuildContext? context;

  WishListBloc({@required this.repository,@required this.context}) : super(ShowLoaderWishListState()){
    on<WishListBaseEvent>(mapEventToState);
  }

  void mapEventToState(WishListBaseEvent event,Emitter<WishListBaseState> emit) async {
    if (event is FetchWishListEvent) {
      try {
        WishListData wishListData = await repository!.callWishListApi();
        if (wishListData.status == true) {
          emit (FetchDataState.success(wishListProducts: wishListData));
        } else {
          emit (FetchDataState.fail(error:wishListData.success));
        }
      } catch (e) {
        emit (FetchDataState.fail(error: "SomethingWrong".localized()));
      }
    }
    else if (event is FetchDeleteAddItemEvent) {
      try {
        GraphQlBaseModel removeFromWishlist =
            await repository!.callWishListDeleteItem(event.productId);
        // if (addWishListModel.success == true) {
          emit (FetchDeleteAddItemState.success(response: removeFromWishlist, producDeletedId: event.productId, successMsg: "DeletedSuccess".localized()));
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit (FetchDeleteAddItemState.fail(error:"SomethingWrong".localized()));
      }
    }
    else if (event is AddToCartWishlistEvent) {
      try {
        AddToCartModel addToCartModel =
        await repository!.callAddToCartAPi(int.parse(event.productId));
        if (addToCartModel.status == true) {
        emit (AddToCartWishlistState.success(
            response: addToCartModel,
            cartProductId: event.productId,
            successMsg: addToCartModel.success)
        );
      } else {
          emit(AddToCartWishlistState.fail(error: addToCartModel.success));}
        }catch (e) {
        emit (AddToCartWishlistState.fail(
            error: "SomethingWrong".localized()));
      }

    }else if(event is OnClickWishListLoaderEvent){
      emit (OnClickWishListLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    }
    else if (event is RemoveAllWishlistEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeAllWishListProducts();
        if (baseModel.status == true) {
          emit(RemoveAllWishlistProductState.success(
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(RemoveAllWishlistProductState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveAllWishlistProductState.fail(
            error:"SomethingWrong".localized()));
      }
    }
    else if (event is ShareWishlistEvent) {
      ShareWishlistData ? baseModel = await repository?.shareWishlist(event.shared ?? false);

        if (baseModel?.status == true) {
          emit(ShareWishlistState.success(
              response: baseModel,
              successMsg: baseModel?.success));
        } else {
          emit(ShareWishlistState.fail(error: baseModel?.success));
        }
    }
  }
}
