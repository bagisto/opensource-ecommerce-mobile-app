
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


abstract class DownloadableProductsBaseEvent {}


class DownloadableProductsCustomerEvent extends DownloadableProductsBaseEvent {
  final int page;
  final  int limit;
  String? title;
  String? status;
  String? orderId;
  String? orderDateFrom;
  String? orderDateTo;

  DownloadableProductsCustomerEvent(this.page, this.limit, {this.orderId,
  this.orderDateFrom, this.orderDateTo, this.title, this.status});

}

class DownloadProductEvent extends DownloadableProductsBaseEvent {
  final int id;
  DownloadProductEvent(this.id);

}
class DownloadBase64ProductEvent extends DownloadableProductsBaseEvent {
  final int id;
  DownloadBase64ProductEvent(this.id);

}