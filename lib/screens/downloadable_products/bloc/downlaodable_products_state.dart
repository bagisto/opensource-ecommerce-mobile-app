
import '../../home_page/data_model/new_product_data.dart';
import '../data_model/download_product_model.dart';
import '../data_model/downloadable_product_model.dart';


abstract class DownloadableProductsBaseState {}

enum DownloadableProductsStatus { success, fail }

class DownloadableProductsInitialState extends DownloadableProductsBaseState {

}

class DownloadableProductsDataState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  NewProductsModel? productsModel;

  DownloadableProductsDataState.success({this.productsModel})
      : status = DownloadableProductsStatus.success;

  DownloadableProductsDataState.fail({this.error}) : status = DownloadableProductsStatus.fail;

}

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
  DownloadLink? downloadLink;

  DownloadProductState.success({this.downloadLink})
      : status = DownloadableProductsStatus.success;

  DownloadProductState.fail({this.error}) : status = DownloadableProductsStatus.fail;

}