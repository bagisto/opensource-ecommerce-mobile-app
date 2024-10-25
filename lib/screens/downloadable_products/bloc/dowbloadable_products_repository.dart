
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/downloadable_products/utils/index.dart';

import '../data_model/download_product_Image_model.dart';

// import '../data_model/download_product_base64_model.dart';


abstract class DownloadableProductsRepository {
  Future<DownloadableProductModel> getDownloadableProductCustomerData(int page, int limit, {
    String? title,
    String? status,
    String? orderId,
    String? orderDateFrom,
    String? orderDateTo
  });
  Future<Download?> downloadProductLink(int id);
  Future<DownloadLinkDataModel?> dataBase64ProductModel(int id);
}

class DownloadableProductsRepositoryImp
    implements DownloadableProductsRepository {

  @override
  Future<DownloadableProductModel> getDownloadableProductCustomerData(int page, int limit, {
    String? title,
    String? status,
    String? orderId,
    String? orderDateFrom,
    String? orderDateTo
  }) async{
    DownloadableProductModel? productData;

    try {
      productData = await ApiClient().getCustomerDownloadableProducts(page, limit, title: title, status: status, orderId: orderId,
          orderDateFrom: orderDateFrom, orderDateTo: orderDateTo);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return productData!;

  }

  @override
  Future<Download> downloadProductLink(int id) async{
    Download? downloadLink;

    try {
      downloadLink = await ApiClient().downloadLinksProduct(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return downloadLink!;
  }

  @override
  Future<DownloadLinkDataModel?> dataBase64ProductModel(int id) async{
    DownloadLinkDataModel? downloadLink;
    try {
      downloadLink = await ApiClient().downloadLinksProductAPI(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return downloadLink;
  }
}
