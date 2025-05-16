/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';


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
        if (addWishListModel?.success == true) {
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
              successMsg: addWishListModel!.message));
        } else {
          emit(FetchDeleteAddItemCategoryState.fail(
              error: addWishListModel?.graphqlErrors));
        }
      } catch (e) {
        emit(FetchDeleteAddItemCategoryState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is FetchDeleteItemEvent) {
      try {
        AddToCartModel removeFromWishlist =
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
              successMsg: removeFromWishlist.message,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveWishlistState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToCartSubCategoriesEvent) {
      try {
        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi(
            int.parse(event.productId ?? ""), event.quantity /* event.params*/);
        if (graphQlBaseModel.graphqlErrors != true) {
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
        BaseModel baseModel = await repository!
            .callAddToCompareListApi(int.parse(event.productId ?? ""));
        if (baseModel.status == true) {
          emit(AddToCompareSubCategoryState.success(
              baseModel: baseModel, successMsg: baseModel.message));
        } else {
          emit(AddToCompareSubCategoryState.fail(error: baseModel.graphqlErrors));
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
        GetFilterAttribute? filterModel =
            await repository?.getFilterProducts(event.categorySlug ?? "");
        emit(FilterFetchState.success(filterModel: filterModel));
      } catch (e) {
        emit(FilterFetchState.fail(error: e.toString()));
      }
    }
  }
}
