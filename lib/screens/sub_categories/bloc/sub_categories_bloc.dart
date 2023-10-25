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
import 'package:bagisto_app_demo/screens/sub_categories/events/add_delete_wishlist_category_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/addtocart_sub_categories_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/addtocompare_subcategories_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/fetch_sub_categories_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/state/add_delete_item_sub_category_state.dart';
import 'package:bagisto_app_demo/screens/sub_categories/state/addtocart_subcategory_state.dart';
import 'package:bagisto_app_demo/screens/sub_categories/state/addtocompare_subcategory_state.dart';
import 'package:bagisto_app_demo/screens/sub_categories/state/fetch_sub_category_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base_model/graphql_base_model.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/categories_data_model/filter_product_model.dart';
import '../events/loader_sub_categories_event.dart';
import '../events/sub_categories_base_event.dart';
import '../repository/sub_categories_repository.dart';
import '../state/loader_sub_category_state.dart';
import '../state/show_loader_category_state.dart';
import '../state/sub_categories_base_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryBaseEvent, SubCategoriesBaseState> {
  SubCategoriesRepository? repository;
  bool isLoading = false;
  BuildContext? context;

  SubCategoryBloc({@required this.repository,@required this.context}) : super(ShowLoaderCategoryState()){
    on<SubCategoryBaseEvent>(mapEventToState);
  }

  void mapEventToState(SubCategoryBaseEvent event,Emitter<SubCategoriesBaseState> emit) async{
    if (event is FetchSubCategoryEvent) {
      try {
        CategoriesProductModel categoriesData = await repository!.callCategoriesData(event.categorySlug??"",event.order ??"",event.sort ?? "",event.page??1,event.filter ?? []);
        emit (FetchSubCategoryState.success(categoriesData: categoriesData));
      } catch (e) {
        emit (FetchSubCategoryState.fail(error: e.toString()));
      }
    }
    else if (event is FetchDeleteAddItemCategoryEvent) {
      try {
        AddWishListModel? addWishListModel =
        await repository!.callWishListDeleteItem(event.productId);
        if (addWishListModel?.responseStatus == true) {
          if (event.datum != null) {
            if (event.datum?.isInWishlist == true) {
              event.datum?.isInWishlist = false;
            } else {
              event.datum?.isInWishlist = true;
            }
          } else {
            event.datum?.isInWishlist = !(event.datum?.isInWishlist ?? true);
          }

          emit(FetchDeleteAddItemCategoryState.success(
              response: addWishListModel,
              producDeletedId: event.productId,
              successMsg: addWishListModel!.success));
          // } else {
          //   yield FetchDeleteItemState.fail(error: response.message!);
          // }
        } else {
          emit(FetchDeleteAddItemCategoryState.fail(
              error: addWishListModel?.success));
        }
      } catch (e) {
        emit(FetchDeleteAddItemCategoryState.fail(
            error:  "SomethingWrong".localized()));
      }
    }  else if (event is FetchDeleteItemEvent) {
      try {
        GraphQlBaseModel removeFromWishlist = await repository!.removeItemFromWishlist(event.productId);
        if(removeFromWishlist.status==true) {
          if (event.datum != null) {
            if (event.datum?.isInWishlist == true) {
              event.datum?.isInWishlist = false;
            } else {
              event.datum?.isInWishlist = true;
            }
          } else {
            event.datum?.isInWishlist = !(event.datum?.isInWishlist ?? true);
          }

          emit (RemoveWishlistState.success( producDeletedId: event.productId, successMsg:removeFromWishlist.success,response: removeFromWishlist));
        }
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit (RemoveWishlistState.fail(error:  "SomethingWrong".localized()));
      }
    }
    else if (event is AddToCartSubCategoriesEvent) {
      try {
        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi(int.parse(event.productId??""), event.quantity??0 /* event.params*/);
        if (graphQlBaseModel.responseStatus == true) {
          emit(AddToCartSubCategoriesState.success(
              response: graphQlBaseModel,
              successMsg: graphQlBaseModel.message ?? ""));
        } else {
          emit(AddToCartSubCategoriesState.fail(error: graphQlBaseModel.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartSubCategoriesState.fail(
            error:  "SomethingWrong".localized()));
      }
    }
    else if (event is AddToCompareSubCategoryEvent) {
      try {
        GraphQlBaseModel baseModel =
        await repository!.callAddToCompareListApi(int.parse(event.productId??""));
        if (baseModel.status == true) {
          emit(AddToCompareSubCategoryState.success(
              baseModel: baseModel, successMsg: baseModel.success));
        } else {
          emit(AddToCompareSubCategoryState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(AddToCompareSubCategoryState.fail(
            error:  "SomethingWrong".localized()));
      }
    }else if(event is OnClickSubCategoriesLoaderEvent){
      emit (OnClickSubCategoriesLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    }
    else if  (event is FilterFetchEvent) {
      try {
        GetFilterAttribute  filterModel = await repository!.getFilterProducts(event.categorySlug ?? "");
        if (filterModel.status == true) {
          emit (FilterFetchState.success(filterModel: filterModel));
        }  else {
          emit( FilterFetchState.fail(error: filterModel.success??""));
        }
      } catch (e) {
        emit (FilterFetchState.fail(error: e.toString()));
      }
    }

  }

}
