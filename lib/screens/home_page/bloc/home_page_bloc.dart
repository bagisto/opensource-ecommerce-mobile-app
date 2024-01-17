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
import '../../../data_model/account_models/account_info_details.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/string_constants.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/advertisement_data.dart';
import '../data_model/get_categories_drawer_data_model.dart';
import '../data_model/new_product_data.dart';
import '../data_model/theme_customization.dart';
import 'home_page_event.dart';
import 'home_page_repository.dart';
import 'home_page_state.dart';

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
        if (graphQlBaseModel?.responseStatus == true) {
          emit(AddToCartState.success(
              graphQlBaseModel: graphQlBaseModel,
              successMsg: graphQlBaseModel?.message ?? ""));
        } else {
          emit(AddToCartState.fail(error: graphQlBaseModel?.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is FetchAddWishlistHomepageEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository?.addItemToWishlist(event.productId);
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
          emit(FetchAddWishlistHomepageState.success(
              response: addWishListModel,
              productDeletedId: event.productId,
              successMsg: addWishListModel?.message));
        } else {
          emit(FetchAddWishlistHomepageState.fail(
              error: addWishListModel?.success));
        }
      } catch (e) {
        emit(FetchAddWishlistHomepageState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveWishlistItemEvent) {
      try {
        GraphQlBaseModel? removeFromWishlist =
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
              successMsg: removeFromWishlist?.success,
              response: removeFromWishlist));
        } else {
          emit(RemoveWishlistState.success(
              productDeletedId: event.productId,
              successMsg: removeFromWishlist?.success,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveWishlistState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is OnClickLoaderEvent) {
      emit(OnClickLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is AddToCompareHomepageEvent) {
      try {
        GraphQlBaseModel? baseModel =
            await repository?.callAddToCompareListApi(event.productId);
        if (baseModel?.status == true) {
          emit(AddToCompareHomepageState.success(
              baseModel: baseModel, successMsg: baseModel?.success));
        } else {
          emit(AddToCompareHomepageState.fail(error: baseModel?.success));
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
        emit(
            FetchHomeCustomDataState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchAllProductsEvent) {
      try {
        NewProductsModel? products =
            await repository?.getAllProducts(filters: event.filters);
        GlobalData.productsStream.sink.add(products);
        emit(FetchAllProductsState.success(allProducts: products));
      } catch (e) {
        emit(FetchAllProductsState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is CartCountEvent) {
      try {
        Advertisements? advertisementData = await repository?.cartCountApi();
        emit(FetchCartCountState.success(
          advertisementData: advertisementData,
        ));
      } catch (e) {
        emit(FetchCartCountState.fail(error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is CustomerDetailsEvent) {
      try {
        AccountInfoDetails? accountInfoDetails =
            await repository?.callAccountDetailsApi();
        emit(CustomerDetailsState.success(
            accountInfoDetails: accountInfoDetails));
      } catch (e) {
        emit(CustomerDetailsState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchHomePageCategoriesEvent) {
      try {
        GetDrawerCategoriesData? data =
            await repository?.getHomeCategoriesList(filters: event.filters);
        emit(FetchHomeCategoriesState.success(getCategoriesData: data));
      } catch (e) {
        emit(
            FetchHomeCategoriesState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
