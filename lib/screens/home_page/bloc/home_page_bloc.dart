/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:developer';

import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/theme_customization.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageBaseState> {
  HomePageRepository? repository;

  HomePageBloc(this.repository) : super(ShowLoaderState()) {
    on<HomePageEvent>(mapEventToState);
  }
  void mapEventToState(
      HomePageEvent event, Emitter<HomePageBaseState> emit) async {
    if (event is AddToCartEvent) {
      try {
        AddToCartModel? graphQlBaseModel =
            await repository?.callAddToCartAPi(event.productId, event.quantity);
        if (graphQlBaseModel?.success == true) {
          emit(AddToCartState.success(
              graphQlBaseModel: graphQlBaseModel,
              successMsg: graphQlBaseModel?.message ?? ""));
        } else {
          emit(AddToCartState.fail(
              error: graphQlBaseModel?.graphqlErrors ?? ""));
        }
      } catch (e) {
        emit(AddToCartState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is FetchAddWishlistHomepageEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository?.addItemToWishlist(event.productId);
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
          emit(FetchAddWishlistHomepageState.success(
              response: addWishListModel,
              productDeletedId: event.productId,
              successMsg: addWishListModel?.message));
        } else {
          emit(FetchAddWishlistHomepageState.fail(
              error: addWishListModel?.graphqlErrors));
        }
      } catch (e) {
        emit(FetchAddWishlistHomepageState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveWishlistItemEvent) {
      try {
        AddToCartModel? removeFromWishlist =
            await repository?.removeItemFromWishlist(event.productId);
        if (removeFromWishlist?.status == true) {
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
              successMsg: removeFromWishlist?.message,
              response: removeFromWishlist));
        } else {
          emit(RemoveWishlistState.success(
              productDeletedId: event.productId,
              successMsg: removeFromWishlist?.message,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveWishlistState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is OnClickLoaderEvent) {
      emit(OnClickLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is AddToCompareHomepageEvent) {
      try {
        BaseModel? baseModel =
            await repository?.callAddToCompareListApi(event.productId);
        if (baseModel?.success == true) {
          emit(AddToCompareHomepageState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(AddToCompareHomepageState.fail(error: baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToCompareHomepageState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchHomeCustomData) {
      try {
        ThemeCustomDataModel? homeSlidersData =
            await repository?.getThemeCustomizationData();
        emit(FetchHomeCustomDataState.success(
          homepageSliders: homeSlidersData,
        ));
      } catch (e) {
        emit(FetchHomeCustomDataState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchAllProductsEvent) {
      try {
        NewProductsModel? products =
            await repository?.getAllProducts(filters: event.filters);
        GlobalData.productsStream.sink.add(products);
        emit(FetchAllProductsState.success(allProducts: products));
        GlobalData.cartCountController.sink
            .add(products?.data?.firstOrNull?.cart?.itemsQty ?? 0);
      } catch (e) {
        emit(FetchAllProductsState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is CartCountEvent) {
      try {
        CartModel? cartDetails = await repository?.cartCountApi();
        emit(FetchCartCountState.success(
          cartDetails: cartDetails,
        ));
      } catch (e) {
        emit(FetchCartCountState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is CustomerDetailsEvent) {
      try {
        AccountInfoModel? accountInfoDetails =
            await repository?.callAccountDetailsApi();
        emit(CustomerDetailsState.success(
            accountInfoDetails: accountInfoDetails));
      } catch (e) {
        emit(CustomerDetailsState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchHomePageCategoriesEvent) {
      try {
        GetDrawerCategoriesData? data =
            await repository?.getHomeCategoriesList(filters: event.filters);
        emit(FetchHomeCategoriesState.success(getCategoriesData: data));
      } catch (e) {
        emit(FetchHomeCategoriesState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchCMSDataEvent) {
      try {
        CmsData? cmsData = await repository?.callCmsData("");
        emit(FetchCMSDataState.success(cmsData: cmsData));
      } catch (e) {
        emit(FetchCMSDataState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is SubscribeNewsLetterEvent) {
      try {
        BaseModel? baseModel =
            await repository?.subscribeNewsletter(event.email);
        if (baseModel?.success == true) {
          emit(SubscribeNewsLetterState.success(baseModel: baseModel));
        } else {
          emit(SubscribeNewsLetterState.fail(baseModel: baseModel));
        }
      } catch (e) {
        emit(SubscribeNewsLetterState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
