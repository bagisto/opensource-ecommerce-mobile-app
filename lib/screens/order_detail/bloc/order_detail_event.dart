/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:equatable/equatable.dart';

abstract class OrderDetailBaseEvent extends Equatable {}

class OrderDetailFetchDataEvent extends OrderDetailBaseEvent {
  final int? orderId;

  OrderDetailFetchDataEvent(this.orderId);

  @override
  List<Object> get props => [];
}

class CancelOrderEvent extends OrderDetailBaseEvent {
  final int? id;
  final String? message;

  CancelOrderEvent(this.id, this.message);

  List<Object> get props => [message ?? ""];
}

class OnClickOrderLoadingEvent extends OrderDetailBaseEvent {
  final bool? isReqToShowLoader;

  OnClickOrderLoadingEvent({this.isReqToShowLoader});

  @override
  List<Object> get props => [];
}
