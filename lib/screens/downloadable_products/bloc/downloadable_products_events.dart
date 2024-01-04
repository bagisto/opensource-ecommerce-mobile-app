
import 'package:equatable/equatable.dart';

abstract class DownloadableProductsBaseEvent extends Equatable {}


class DownloadableProductsCustomerEvent extends DownloadableProductsBaseEvent {
  final int page;
  final  int limit;
  DownloadableProductsCustomerEvent(this.page, this.limit);

  @override
  List<Object> get props => [];
}

class DownloadProductEvent extends DownloadableProductsBaseEvent {
  final int id;
  DownloadProductEvent(this.id);

  @override
  List<Object> get props => [];
}