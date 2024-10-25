
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


abstract class DownloadableProductsBaseState {}

enum DownloadableProductsStatus { success, fail }

class DownloadableProductsInitialState extends DownloadableProductsBaseState {}

class ShowLoaderState extends DownloadableProductsBaseState {}

class DownloadableProductsCustomerDataState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  DownloadableProductModel? productsList;

  DownloadableProductsCustomerDataState.success({this.productsList})
      : status = DownloadableProductsStatus.success;

  DownloadableProductsCustomerDataState.fail({this.error}) : status = DownloadableProductsStatus.fail;

}

class DownloadProductState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  Download? downloadLink;

  DownloadProductState.success({this.downloadLink})
      : status = DownloadableProductsStatus.success;

  DownloadProductState.fail({this.error}) : status = DownloadableProductsStatus.fail;

}
class DownloadBase64ProductState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  DownloadLinkDataModel? downloadLinkProduct;

  DownloadBase64ProductState.success({this.downloadLinkProduct})
      : status = DownloadableProductsStatus.success;

  DownloadBase64ProductState.fail({this.error}) : status = DownloadableProductsStatus.fail;

}