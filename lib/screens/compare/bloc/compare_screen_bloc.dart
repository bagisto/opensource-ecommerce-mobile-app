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
import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/compare/event/addtocart_compare_event.dart';
import 'package:bagisto_app_demo/screens/compare/event/addtowishlist_compare_event.dart';
import 'package:bagisto_app_demo/screens/compare/event/compare_loader_event.dart';
import 'package:bagisto_app_demo/screens/compare/event/compare_remove_item_event.dart';
import 'package:bagisto_app_demo/screens/compare/event/compare_screen_base_event.dart';
import 'package:bagisto_app_demo/screens/compare/event/compare_screen_fetch_event.dart';
import 'package:bagisto_app_demo/screens/compare/repository/compare_screen_repository.dart';
import 'package:bagisto_app_demo/screens/compare/state/addtocart_compare_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/addtowishlist_compare_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/comnpare_remove_item_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_base_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_fetch_data_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_initial_state.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_loader_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base_model/graphql_base_model.dart';
import '../../../models/compare_model/compare_product_model.dart';

class CompareScreenBloc
    extends Bloc<CompareScreenBaseEvent, CompareScreenBaseState> {
  CompareScreenRepository? repository;
  BuildContext? context;

  CompareScreenBloc({@required this.repository, this.context})
      : super(CompareScreenInitialState()) {
    on<CompareScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(CompareScreenBaseEvent event,
      Emitter<CompareScreenBaseState> emit) async {
    if (event is CompareScreenFetchEvent) {
      try {
        CompareProductsData compareScreenModel =
            await repository!.callCompareApi();

        emit(CompareScreenFetchDataState.success(
            compareScreenModel: compareScreenModel));
      } catch (e) {
        emit(CompareScreenFetchDataState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is RemoveFromCompareListEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeFromCompareList(
          int.parse(event.productId),
        );
        if (baseModel.status == true) {
          emit(RemoveFromCompareState.success(
              productDeletedId: int.parse(event.productId),
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(RemoveFromCompareState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveFromCompareState.fail(
            error:"SomethingWrong".localized()));
      }
    } else if (event is AddToCartCompareEvent) {
      try {
        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi(
            int.parse(event.productId ?? ""), event.quantity /* event.params*/);
        if (graphQlBaseModel.responseStatus == true) {
          emit(AddToCartCompareState.success(
              response: graphQlBaseModel,
              cartProductId: event.productId,
              successMsg: "AddedToCart".localized()));
        } else {
          emit(AddToCartCompareState.fail(
              error: graphQlBaseModel.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartCompareState.fail(error: "SomethingWrong".localized()));
      }
    } else if (event is AddtoWishlistCompareEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository!.callWishListAddDeleteItem(event.productId);
        // if (addWishListModel.success == true) {
        if (event.datum?.productFlat?.product?.isInWishlist == true) {
          event.datum?.productFlat?.product?.isInWishlist = false;
        } else {
          event.datum?.productFlat?.product?.isInWishlist = true;
        }
        emit(AddtoWishlistCompareState.success(
            response: addWishListModel,
            producDeletedId: event.productId,
            successMsg: addWishListModel!.success));
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit(AddtoWishlistCompareState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is FetchDeleteWishlistItemEvent) {
      try {
        GraphQlBaseModel removeFromWishlist =
            await repository!.removeItemFromWishlist(event.productId);
        if (removeFromWishlist.status == true) {
          if (event.datum != null) {
            if (event.datum?.productFlat?.product?.isInWishlist == true) {
              event.datum?.productFlat?.product?.isInWishlist = false;
            } else {
              event.datum?.productFlat?.product?.isInWishlist = true;
            }
          } else {
            event.datum?.productFlat?.product?.isInWishlist =
                !(event.datum?.productFlat?.product?.isInWishlist ?? true);
          }

          emit(RemoveFromWishlistState.success(
              producDeletedId: event.productId,
              successMsg: removeFromWishlist.success,
              response: removeFromWishlist));
        }
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit(RemoveFromWishlistState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is OnClickCompareLoaderEvent) {
      emit(OnClickCompareLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is RemoveAllCompareListEvent) {
      try {
        GraphQlBaseModel baseModel =
            await repository!.removeAllCompareProducts();
        if (baseModel.status == true) {
          emit(RemoveAllCompareProductState.success(
              baseModel: baseModel, successMsg: baseModel.success));
        } else {
          emit(RemoveAllCompareProductState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveAllCompareProductState.fail(
            error: "SomethingWrong".localized()));
      }
    }
  }
}
