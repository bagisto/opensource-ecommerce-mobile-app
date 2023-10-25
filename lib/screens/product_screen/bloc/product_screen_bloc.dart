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
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base_model/graphql_base_model.dart';
import '../../../models/product_model/product_screen_model.dart' as product;
import '../event/addtocart_product_event.dart';
import '../event/addtocompare_product_event.dart';
import '../event/addtowishlist_product_event.dart';
import '../event/fetch_product_data_event.dart';
import '../event/loader_product_event.dart';
import '../event/product_base_event.dart';
import '../repository/product_repository.dart';
import '../state/addtocart_product_state.dart';
import '../state/addtocompare_product_state.dart';
import '../state/addtowishlist_product_state.dart';
import '../state/fetch_product_state.dart';
import '../state/loader_product_state.dart';
import '../state/product_base_state.dart';
import '../state/product_initial_state.dart';

class ProductScreenBLoc extends Bloc<ProductScreenBaseEvent, ProductBaseState> {
  ProductScreenRepository? repository;
  bool isLoading = false;
  BuildContext? context;

  ProductScreenBLoc({@required this.repository,this.context}) : super(ProductInitialState()){
    on<ProductScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(ProductScreenBaseEvent event,Emitter<ProductBaseState> emit) async{
    if  (event is FetchProductEvent) {
      try {
       product. Product   productData = await repository!.callProductData(event.id!);
        emit (FetchProductState.success(productData: productData));
      } catch (e) {
        emit (FetchProductState.fail(error: e.toString()));
      }
    }else if (event is AddToCartProductEvent) {
      try {

        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi( event.quantity,event.productId??"",  event.downloadLinks,event.groupedParams,
            event.bundleParams,event.configurableParams,event.configurableId??null);
        if(graphQlBaseModel.responseStatus==true) {
          emit (AddToCartProductState.success(response: graphQlBaseModel, successMsg: graphQlBaseModel.message));
        }else{
          emit (AddToCartProductState.fail(error:  graphQlBaseModel.message));
        }
      } catch (e) {
        emit (AddToCartProductState.fail(error:"SomethingWrong".localized()));
      }
    }else if (event is AddToCompareListEvent) {
      try {
        GraphQlBaseModel baseModel =
        await repository!.callAddToCompareListApi(int.parse(event.productId??""));
        if (baseModel.status == true) {
          emit(AddToCompareListState.success(
              baseModel: baseModel, successMsg: baseModel.success));
        } else {
          emit(AddToCompareListState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(AddToCompareListState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is AddtoWishListProductEvent) {
      try {
        AddWishListModel? addWishListModel =
        await repository!.callWishListDeleteItem(event.productId);
        if (addWishListModel?.responseStatus == true) {
          if (event.datum != null) {
            if (event.datum.isInWishlist == true) {
              event.datum.isInWishlist = false;
            } else {
              event.datum.isInWishlist = true;
            }
          } else {
            event.datum.isInWishlist = !(event.datum.isInWishlist ?? true);
          }

          emit(AddToWishListProductState.success(
              response: addWishListModel,
              producDeletedId: event.productId,
              successMsg: addWishListModel!.success));
          // } else {
          //   yield FetchDeleteItemState.fail(error: response.message!);
          // }
        } else {
          emit(AddToWishListProductState.fail(
              error: addWishListModel?.success));
        }
      } catch (e) {
        emit(AddToWishListProductState.fail(
            error: "SomethingWrong".localized()));
      }
    }  else if (event is RemoveFromWishlistEvent) {
      try {
        GraphQlBaseModel removeFromWishlist = await repository!.removeItemFromWishlist(event.productId);
        if(removeFromWishlist.status==true) {
          if (event.datum != null) {
            if (event.datum?.isInWishlist == true) {
              event.datum?.isInWishlist= false;
            } else {
              event.datum?.isInWishlist = true;
            }
          } else {
            event.datum?.isInWishlist= !(event.datum?.isInWishlist ?? true);
          }

          emit (RemoveFromWishlistState.success( producDeletedId: event.productId, successMsg:removeFromWishlist.success,response: removeFromWishlist));
        }
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit (RemoveFromWishlistState.fail(error: "SomethingWrong".localized()));
      }
    }
    else if(event is OnClickProductLoaderEvent){
      emit (OnClickProductLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    }
  }


}
