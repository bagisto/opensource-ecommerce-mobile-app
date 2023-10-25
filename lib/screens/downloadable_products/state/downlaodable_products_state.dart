// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

import '../../../models/downloadable_products/download_product_model.dart';
import '../../../models/downloadable_products/downloadable_product_model.dart';
import '../../../models/homepage_model/new_product_data.dart';

abstract class DownloadableProductsBaseState extends Equatable {}

enum DownloadableProductsStatus { success, fail }

class DownloadableProductsInitialState extends DownloadableProductsBaseState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DownloadableProductsDataState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  NewProductsModel? productsModel;

  DownloadableProductsDataState.success({this.productsModel})
      : status = DownloadableProductsStatus.success;

  DownloadableProductsDataState.fail({this.error}) : status = DownloadableProductsStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (productsModel != null) productsModel! else ""];
}

class DownloadableProductsCustomerDataState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  DownloadableProductModel? productsList;

  DownloadableProductsCustomerDataState.success({this.productsList})
      : status = DownloadableProductsStatus.success;

  DownloadableProductsCustomerDataState.fail({this.error}) : status = DownloadableProductsStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (productsList != null) productsList! else ""];
}

class DownloadProductState extends DownloadableProductsBaseState {
  DownloadableProductsStatus? status;
  String? error;
  DownloadLink? downloadLink;

  DownloadProductState.success({this.downloadLink})
      : status = DownloadableProductsStatus.success;

  DownloadProductState.fail({this.error}) : status = DownloadableProductsStatus.fail;

  @override
  List<Object> get props => [if (downloadLink != null) downloadLink! else ""];
}