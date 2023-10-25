

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

import 'order_detail_base_event.dart';

class OrderDetailFetchDataEvent extends OrderDetailBaseEvent{
  int? orderId;
  OrderDetailFetchDataEvent(this.orderId);
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class CancelOrderEvent extends OrderDetailBaseEvent {
int? id;
  final String? message;
  CancelOrderEvent( this.id,this.message);

  // TODO: implement props
  @override
  List<Object> get props => [ message ?? ""];

}





class OnClickOrderLoadingEvent extends OrderDetailBaseEvent{
  final bool? isReqToShowLoader;
  OnClickOrderLoadingEvent({this.isReqToShowLoader});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}