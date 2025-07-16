/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

import '../data_model/download_sample_model.dart';
import 'dart:developer';

class ProductScreenBLoc extends Bloc<ProductScreenBaseEvent, ProductBaseState> {
  ProductScreenRepo? repository;

  ProductScreenBLoc(this.repository) : super(ProductInitialState()) {
    on<ProductScreenBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      ProductScreenBaseEvent event, Emitter<ProductBaseState> emit) async {
    if (event is FetchProductEvent) {
      try {
        NewProductsModel? productData = await repository?.getProductDetails([
          {"key": '"url_key"', "value": '"${event.sku}"'}
        ]);
        emit(FetchProductState.success(
            productData: productData?.data?.firstOrNull));
      } catch (e) {
        emit(FetchProductState.fail(error: e.toString()));
      }
    } else if (event is AddToCartProductEvent) {
      try {
        AddToCartModel? cartModel = await repository?.callAddToCartAPi(
          event.quantity,
          event.productId ?? "",
          event.downloadLinks,
          event.groupedParams,
          event.bundleParams,
          event.configurableParams,
          event.configurableId,
          event.bookingParams,
          event.customizableOptions,
          event.customizableFiles,
        );
        if (cartModel?.success == true) {
          emit(AddToCartProductState.success(
              response: cartModel, successMsg: cartModel?.message));
        } else {
          emit(AddToCartProductState.fail(
              error: cartModel?.message ?? cartModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToCartProductState.fail(error: e.toString()));
      }
    } else if (event is AddToCompareListEvent) {
      try {
        BaseModel? baseModel =
            await repository?.callAddToCompareListApi(event.productId ?? "");
        if (baseModel?.status == true) {
          emit(AddToCompareListState.success(
              baseModel: baseModel, successMsg: baseModel?.message));
        } else {
          emit(AddToCompareListState.fail(error: baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToCompareListState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is AddToWishListProductEvent) {
      try {
        AddWishListModel? addWishListModel =
            await repository!.callWishListDeleteItem(event.productId ?? "");
        if (addWishListModel?.success == true) {
          if (event.productData != null) {
            if (event.productData?.isInWishlist == true) {
              event.productData?.isInWishlist = false;
            } else {
              event.productData?.isInWishlist = true;
            }
          } else {
            event.productData?.isInWishlist =
                !(event.productData?.isInWishlist ?? true);
          }

          emit(AddToWishListProductState.success(
              response: addWishListModel,
              productDeletedId: event.productId,
              successMsg: addWishListModel!.message));
        } else {
          emit(AddToWishListProductState.fail(
              error: addWishListModel?.graphqlErrors));
        }
      } catch (e) {
        emit(AddToWishListProductState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is RemoveFromWishlistEvent) {
      try {
        AddToCartModel? removeFromWishlist =
            await repository?.removeItemFromWishlist(event.productId ?? "");
        if (removeFromWishlist?.status == true) {
          if (event.productData != null) {
            if (event.productData?.isInWishlist == true) {
              event.productData?.isInWishlist = false;
            } else {
              event.productData?.isInWishlist = true;
            }
          } else {
            event.productData?.isInWishlist =
                !(event.productData?.isInWishlist ?? true);
          }

          emit(RemoveFromWishlistState.success(
              productDeletedId: event.productId,
              successMsg: removeFromWishlist?.message,
              response: removeFromWishlist));
        }
      } catch (e) {
        emit(RemoveFromWishlistState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is OnClickProductLoaderEvent) {
      emit(OnClickProductLoaderState(
          isReqToShowLoader: event.isReqToShowLoader));
    } else if (event is DownloadProductSampleEvent) {
      try {
        DownloadSampleModel? baseModel =
            await repository?.downloadSample(event.type ?? "", event.id ?? "");
        if (baseModel?.success == true) {
          emit(DownloadProductSampleState.success(
              model: baseModel, fileName: event.fileName));
        } else {
          emit(
              DownloadProductSampleState.fail(error: baseModel?.graphqlErrors));
        }
      } catch (e) {
        emit(DownloadProductSampleState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    } else if (event is GetSlotEvent) {
      try {
        BookingSlotsData? slotList =
            await repository?.getSlots(event.bookingId, event.selectedDate);
        emit(GetSlotState.success(
            slotModel: slotList, successMsg: "Slots fetched successfully"));
      } catch (e) {
        emit(GetSlotState.fail(error: e.toString()));
      }
    }
  }
}
