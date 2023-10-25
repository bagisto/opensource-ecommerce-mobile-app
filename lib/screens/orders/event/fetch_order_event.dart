

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable


import 'fetch_order_list_event.dart';

class FetchOrderListEvent extends OrderListBaseEvent{
  String ? id;
  String ? startDate;
  String ? endDate;
  String ? status;
  double ? total;
  int ?page;
  FetchOrderListEvent({this.id,this.endDate,this.startDate,this.status,this.total,this.page});
  @override
  // TODO: implement props
  List<Object> get props => [];

}