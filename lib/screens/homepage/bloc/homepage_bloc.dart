/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, empty_catches

import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';
import 'package:bagisto_app_demo/screens/homepage/repository/homepage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base_model/graphql_base_model.dart';
import '../../../helper/application_localization.dart';
import '../../../models/add_to_cart_model/add_to_cart_model.dart';
import '../../../models/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../models/cms_model/cms_model.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../events/add_detelet_item_homepage_event.dart';
import '../events/addtocart_event.dart';
import '../events/addtocompare_homepage_event.dart';
import '../events/fetch_homepage_event.dart';
import '../events/homepage_loading_event.dart';
import '../state/ShowLoaderState.dart';
import '../state/add_wishlist_homepage_state.dart';
import '../state/addtocart_homepage_state.dart';
import '../state/addtocomapre_homepage_state.dart';
import '../state/fetch_homepage_data_state.dart';
import '../state/hoempage_base_state.dart';
import '../state/loader_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageBaseState> {
  HomePageRepository? repository;
  bool isLoading = false;
  BuildContext? context;

  HomePageBloc({this.repository, @required this.context})
      : super(ShowLoaderState()) {
    on<HomePageEvent>(mapEventToState);
  }

  void mapEventToState(
      HomePageEvent event, Emitter<HomePageBaseState> emit) async {
    if (event is AddToCartEvent) {
      try {
        AddToCartModel graphQlBaseModel = await repository!.callAddToCartAPi(
            event.productId!, event.quantity);
        if (graphQlBaseModel.responseStatus == true) {
          emit(AddToCartState.success(
              graphQlBaseModel: graphQlBaseModel,
              successMsg: graphQlBaseModel.message ?? ""));
        } else {
          emit(AddToCartState.fail(error: graphQlBaseModel.message ?? ""));
        }
      } catch (e) {
        emit(AddToCartState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is FetchAddWishlistHomepageEvent) {
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

          emit(FetchAddWishlistHomepageState.success(
              response: addWishListModel,
              producDeletedId: event.productId,
              successMsg: addWishListModel!.message));
        } else {
          emit(FetchAddWishlistHomepageState.fail(
              error: addWishListModel?.success));
        }
      } catch (e) {
        emit(FetchAddWishlistHomepageState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is FetchDeleteAddItemEvent) {
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
              producDeletedId: event.productId,
              successMsg: removeFromWishlist.success,
              response: removeFromWishlist));
        } else {
          emit(RemoveWishlistState.success(
              producDeletedId: event.productId,
              successMsg: removeFromWishlist.success,
              response: removeFromWishlist));
        }
        // } else {
        //   yield FetchDeleteItemState.fail(error: response.message!);
        // }
      } catch (e) {
        emit(RemoveWishlistState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is OnClickLoaderEvent) {
      emit(OnClickLoaderState(isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is AddToCompareHomepageEvent) {
      try {
        GraphQlBaseModel baseModel =
            await repository!.callAddToCompareListApi(event.productId);
        if (baseModel.status == true) {
          emit(AddToCompareHomepageState.success(
              baseModel: baseModel, successMsg: baseModel.success));
        } else {
          emit(AddToCompareHomepageState.fail(error: baseModel.success));
        }
      } catch (e) {
        emit(AddToCompareHomepageState.fail(
            error: "SomethingWrong".localized()));
      }
    }
    if (event is FetchSliderEvent) {
      try {
        HomeSlidersData homeSlidersData = await repository!.homePageSlider();

        emit(FetchHomepageSlidersState.success(
          homepageSliders: homeSlidersData,
        ));
      } catch (e) {
        emit(FetchHomepageSlidersState.fail(
            error: "SomethingWrong".localized()));
      }
    }
    if (event is FetchAdvertisementEvent) {
      try {
        Advertisements advertisementData =
            await repository!.advertisementsApi();
        emit(FetchAdvertisementState.success(
          advertisementData: advertisementData,
        ));
      } catch (e) {
        emit(FetchAdvertisementState.fail(
            error:"SomethingWrong".localized()));
      }
    }
    if (event is CartCountEvent) {
      try {
        Advertisements advertisementData = await repository!.cartCountApi();
        emit(FetchCartCountState.success(
          advertisementData: advertisementData,
        ));
      } catch (e) {
        emit(FetchCartCountState.fail(
            error: "SomethingWrong".localized()));
      }
    }
    if (event is FetchNewProductEvent) {
      try {
        NewProductsModel? newProductsModel = await repository!.newProductApi();
        if (newProductsModel?.status == true) {
          emit(NewProductDataState.success(
            newProductsModel: newProductsModel,
          ));
        } else {
          // emit(NewProductDataState.fail(
          //     error: newProductsModel.success));
        }
      } catch (e) {
        emit(NewProductDataState.fail(
            error: "SomethingWrong".localized()));
      }
    }

    if (event is FetchFeaturedProduct) {
      try {
        NewProductsModel? newProductsModel = await repository!.featuredProduct();
        if (newProductsModel?.status == true) {
          emit(FeaturedProductDataState.success(
            newProductsModel: newProductsModel,
          ));
        } else {
          // emit(NewProductDataState.fail(
          //     error: newProductsModel.success));
        }
      } catch (e) {
        emit(FeaturedProductDataState.fail(
            error: "SomethingWrong".localized()));
      }
    }

    if (event is CurrencyLanguageEvent) {
      try {
        CurrencyLanguageList currencyLanguageList =
            await repository!.getLanguageCurrencyList();
        if (currencyLanguageList.status == true) {
          emit(FetchLanguageCurrencyState.success(
            currencyLanguageList: currencyLanguageList,
          ));
        } else {
        }
      } catch (e) {
        emit(FetchLanguageCurrencyState.fail(
            error: "SomethingWrong".localized()));
      }
    } else if (event is FetchCMSDataEvent) {
      try {
        CmsData cmsData = await repository!.callCmsData("");
        emit(FetchCMSDataState.success(cmsData: cmsData));
      } catch (e) {
        emit(FetchCMSDataState.fail(error: e.toString()));
      }
    }
  }
}
