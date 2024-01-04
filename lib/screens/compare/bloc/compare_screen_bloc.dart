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

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../utils/string_constants.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../data_model/compare_product_model.dart';
import 'compare_base_state.dart';
import 'compare_screen_event.dart';
import 'compare_screen_repository.dart';


class CompareScreenBloc
    extends Bloc<CompareScreenBaseEvent, CompareScreenBaseState> {
  CompareScreenRepository? repository;

  CompareScreenBloc(this.repository)
      : super(CompareScreenInitialState()) {
    on<CompareScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(CompareScreenBaseEvent event,
      Emitter<CompareScreenBaseState> emit) async {
    if (event is CompareScreenFetchEvent) {
      try {
        CompareProductsData? compareScreenModel =
            await repository?.callCompareApi();

        emit(CompareScreenFetchDataState.success(
            compareScreenModel: compareScreenModel));
      } catch (e) {
        emit(CompareScreenFetchDataState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is RemoveFromCompareListEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeFromCompareList(
          int.parse(event.productId ?? ""),
        );
        if (baseModel.status == true) {
          emit(RemoveFromCompareState.success(
              productDeletedId: event.productId.toString(),
              baseModel: baseModel,
              successMsg: baseModel.success));
        } else {
          emit(RemoveFromCompareState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(RemoveFromCompareState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is AddToCartCompareEvent) {
      try {
        AddToCartModel? graphQlBaseModel = await repository?.callAddToCartAPi(int.parse(event.productId??""), event.quantity/* event.params*/);
        if (graphQlBaseModel?.responseStatus == true) {
          emit(AddToCartCompareState.success(
              response: graphQlBaseModel,
              cartProductId: event.productId,
              successMsg: StringConstants.addToCart.localized()));
        }else {
          emit(AddToCartCompareState.fail(error: graphQlBaseModel?.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartCompareState.fail(
            error:"SomethingWrong".localized()));
      }
    } else if (event is AddToWishlistCompareEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository!.callWishListAddDeleteItem(event.productId);
        if (event.data?.product?.isInWishlist == true) {
          event.data?.product?.isInWishlist = false;
        } else {
          event.data?.product?.isInWishlist = true;
        }
        emit(AddToWishlistCompareState.success(
            response: addWishListModel,
            productDeletedId: event.productId,
            successMsg: addWishListModel!.success));
      } catch (e) {
        emit(AddToWishlistCompareState.fail(
            error: "SomethingWrong".localized()));
      }
    }else if (event is FetchDeleteWishlistItemEvent) {
      try {
        GraphQlBaseModel removeFromWishlist = await repository!.removeItemFromWishlist(event.productId);
        if(removeFromWishlist.status==true) {
          if (event.datum != null) {
            if (event.datum?.product?.isInWishlist == true) {
              event.datum?.product?.isInWishlist= false;
            } else {
              event.datum?.product?.isInWishlist = true;
            }
          } else {
            event.datum?.product?.isInWishlist= !(event.datum?.product?.isInWishlist ?? true);
          }

          emit (RemoveFromWishlistState.success( productDeletedId: event.productId.toString(), successMsg:removeFromWishlist.success,response: removeFromWishlist));
        }
      } catch (e) {
        emit (RemoveFromWishlistState.fail(error: "SomethingWrong".localized()));
      }
    }

    else if (event is OnClickCompareLoaderEvent) {
      emit(OnClickCompareLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    }else if (event is RemoveAllCompareListEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!.removeAllCompareProducts();
        if (baseModel.status == true) {
          emit(RemoveAllCompareProductState.success(
              baseModel: baseModel,
              successMsg: baseModel.success));
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
