/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/drawer_sub_categories/utils/index.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../home_page/data_model/new_product_data.dart';

class DrawerSubCategoriesBloc
    extends Bloc<DrawerSubCategoriesEvent, DrawerSubCategoriesState> {
  DrawerSubCategoryRepo? repository;

  DrawerSubCategoriesBloc(this.repository)
      : super(DrawerSubCategoryInitialState()) {
    on<DrawerSubCategoriesEvent>(mapEventToState);
  }

  void mapEventToState(DrawerSubCategoriesEvent event,
      Emitter<DrawerSubCategoriesState> emit) async {
    if (event is FetchDrawerSubCategoryEvent) {
      emit(DrawerSubCategoryInitialState());
      try {
        GetDrawerCategoriesData? data =
            await repository?.getDrawerSubCategories(filters: event.filters);
        emit(FetchDrawerSubCategoryState.success(getCategoriesData: data));
      } catch (e) {
        emit(FetchDrawerSubCategoryState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchCategoryProductsEvent) {
      try {
        NewProductsModel? data =
            await repository?.callCategoriesData(filters: event.filters);
        emit(FetchCategoryProductsState.success(categoriesData: data));
      } catch (e) {
        emit(FetchCategoryProductsState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCartEvent) {
      emit(DrawerSubCategoryInitialState());
      try {
        AddToCartModel? graphQlBaseModel =
            await repository?.callAddToCartAPi(event.productId, event.quantity);
        if (graphQlBaseModel?.success == true) {
          emit(AddToCartState.success(
              graphQlBaseModel: graphQlBaseModel,
              successMsg: graphQlBaseModel?.message ?? ""));
        } else {
          emit(AddToCartState.fail(
              successMsg: graphQlBaseModel?.graphqlErrors ?? ""));
        }
      } catch (e) {
        emit(AddToCartState.fail(
            successMsg: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddWishlistEvent) {
      emit(DrawerSubCategoryInitialState());
      try {
        AddWishListModel? addWishListModel =
            await repository?.addItemToWishlist(event.productId);
        if (addWishListModel?.success == true) {
          emit(AddWishlistState.success(
              response: addWishListModel, message: addWishListModel?.message));
        } else {
          emit(AddWishlistState.fail(message: addWishListModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddWishlistState.fail(
            message: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveWishlistItemEvent) {
      emit(DrawerSubCategoryInitialState());
      try {
        AddToCartModel? removeFromWishlist =
            await repository?.removeItemFromWishlist(event.productId);
        if (removeFromWishlist?.status == true) {
          emit(RemoveWishlistState.success(
              message: removeFromWishlist?.message,
              response: removeFromWishlist));
        } else {
          emit(RemoveWishlistState.success(
              message: removeFromWishlist?.message,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveWishlistState.fail(
            message: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCompareEvent) {
      emit(DrawerSubCategoryInitialState());
      try {
        BaseModel? baseModel =
            await repository?.callAddToCompareListApi(event.productId);
        if (baseModel?.success == true) {
          emit(AddToCompareState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(AddToCompareState.fail(successMsg: baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToCompareState.fail(
            successMsg: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
