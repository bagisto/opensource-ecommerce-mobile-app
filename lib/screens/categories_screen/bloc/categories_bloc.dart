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
import '../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../utils/string_constants.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';
import 'categories_event.dart';
import 'categories_repository.dart';
import 'categories_state.dart';

class CategoryBloc
    extends Bloc<CategoryBaseEvent, CategoriesBaseState> {
  CategoriesRepository? repository;

  CategoryBloc(this.repository) : super(ShowLoaderCategoryState()) {
    on<CategoryBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      CategoryBaseEvent event, Emitter<CategoriesBaseState> emit) async {
    if (event is FetchSubCategoryEvent) {
      try {
        NewProductsModel? categoriesData = await repository
            ?.callCategoriesData(filters: event.filters, page: event.page);
        emit(FetchSubCategoryState.success(categoriesData: categoriesData));
      } catch (e) {
        emit(FetchSubCategoryState.fail(error: e.toString()));
      }
    } else if (event is FetchDeleteAddItemCategoryEvent) {
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
              productDeletedId: event.productId,
              successMsg: addWishListModel!.success));
        } else {
          emit(FetchDeleteAddItemCategoryState.fail(
              error: addWishListModel?.success));
        }
      } catch (e) {
        emit(FetchDeleteAddItemCategoryState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is FetchDeleteItemEvent) {
      try {
        GraphQlBaseModel removeFromWishlist =
            await repository!.removeItemFromWishlist(event.productId);
        if (removeFromWishlist.status == true) {
          if (event.datum != null) {
            if (event.datum?.isInWishlist == true) {
              event.datum?.isInWishlist = false;
            } else {
              event.datum?.isInWishlist = true;
            }
          } else {
            event.datum?.isInWishlist = !(event.datum?.isInWishlist ?? true);
          }

          emit(RemoveWishlistState.success(
              productDeletedId: event.productId,
              successMsg: removeFromWishlist.success,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveWishlistState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCartSubCategoriesEvent) {
      try {
        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi(
            int.parse(event.productId ?? ""), event.quantity /* event.params*/);
        if (graphQlBaseModel.responseStatus == true) {
          emit(AddToCartSubCategoriesState.success(
              response: graphQlBaseModel,
              successMsg: graphQlBaseModel.message ?? ""));
        } else {
          emit(AddToCartSubCategoriesState.fail(
              error: graphQlBaseModel.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartSubCategoriesState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCompareSubCategoryEvent) {
      try {
        GraphQlBaseModel baseModel = await repository!
            .callAddToCompareListApi(int.parse(event.productId ?? ""));
        if (baseModel.status == true) {
          emit(AddToCompareSubCategoryState.success(
              baseModel: baseModel, successMsg: baseModel.success));
        } else {
          emit(AddToCompareSubCategoryState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(AddToCompareSubCategoryState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is OnClickSubCategoriesLoaderEvent) {
      emit(OnClickSubCategoriesLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is FilterFetchEvent) {
      try {
        GetFilterAttribute filterModel =
            await repository!.getFilterProducts(event.categorySlug ?? "");
        if (filterModel.status == true) {
          emit(FilterFetchState.success(filterModel: filterModel));
        } else {
          emit(FilterFetchState.fail(error: filterModel.success ?? ""));
        }
      } catch (e) {
        emit(FilterFetchState.fail(error: e.toString()));
      }
    }
  }
}
