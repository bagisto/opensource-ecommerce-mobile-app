// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

abstract class DownloadableProductsBaseEvent extends Equatable {}

class DownloadableProductsEvent extends DownloadableProductsBaseEvent {
  DownloadableProductsEvent();

  // int? carouselIndex;
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DownloadableProductsCustomerEvent extends DownloadableProductsBaseEvent {
  int page;
  int limit;
  DownloadableProductsCustomerEvent(this.page, this.limit);

  @override
  List<Object> get props => [];
}

class DownloadProductEvent extends DownloadableProductsBaseEvent {
  int id;
  DownloadProductEvent(this.id);

  @override
  List<Object> get props => [];
}