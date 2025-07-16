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

abstract class ProductScreenRepository {
  Future<NewProductsModel?> getProductDetails(
      List<Map<String, dynamic>>? filters);

  Future<AddToCartModel?> callAddToCartAPi(
      int quantity,
      String productId,
      List downloadLinks,
      List groupedParams,
      List bundleParams,
      List configurableParams,
      String? configurableId,
      Map<String, dynamic>? booking);

  Future<BaseModel?> callAddToCompareListApi(
    String productId,
  );

  Future<AddWishListModel?> callWishListDeleteItem(String wishListProductId);

  Future<AddToCartModel?> removeItemFromWishlist(String wishListProductId);

  Future<DownloadSampleModel?> downloadSample(String type, String id);
}

class ProductScreenRepo implements ProductScreenRepository {
  @override
  Future<NewProductsModel?> getProductDetails(
      List<Map<String, dynamic>>? filters) async {
    NewProductsModel? productData;
    try {
      productData = await ApiClient().getAllProducts(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return productData;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(
      int quantity,
      String productId,
      List downloadLinks,
      List groupedParams,
      List bundleParams,
      List configurableParams,
      String? configurableId,
      Map<String, dynamic>? bookingParams,
      [List<Map<String, dynamic>>? customizableOptions,
      List? customizableFiles]) async {
    AddToCartModel? addToCartModel;
    try {
      addToCartModel = await ApiClient().addToCart(
          quantity,
          productId,
          downloadLinks,
          groupedParams,
          bundleParams,
          configurableParams,
          configurableId,
          bookingParams,
          customizableOptions,
          customizableFiles);
    } catch (error, stacktrace) {
      debugPrint("Error --> >>>>>$error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addToCartModel;
  }

  @override
  Future<BaseModel?> callAddToCompareListApi(String productId) async {
    BaseModel? baseModel;

    try {
      baseModel = await ApiClient().addToCompare(productId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }

    return baseModel;
  }

  @override
  Future<AddWishListModel?> callWishListDeleteItem(
      String wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      addWishListModel = await ApiClient().addToWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->$error");
      debugPrint("StackTrace -->$stacktrace");
    }
    return addWishListModel;
  }

  @override
  Future<AddToCartModel?> removeItemFromWishlist(
      String wishListProductId) async {
    AddToCartModel? removeFromWishlist;
    try {
      removeFromWishlist =
          await ApiClient().removeFromWishlist(wishListProductId);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->$stacktrace");
    }
    return removeFromWishlist;
  }

  @override
  Future<DownloadSampleModel?> downloadSample(String type, String id) async {
    DownloadSampleModel? model;
    try {
      model = await ApiClient().downloadSample(type, id);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->$stacktrace");
    }
    return model;
  }

  @override
  Future<BookingSlotsData?> getSlots(bookingId, date) async {
    BookingSlotsData? slotModel;
    try {
      slotModel = await ApiClient().getSlots(id: bookingId, date: date);
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->$stacktrace");
    }
    return slotModel;
  }
}
