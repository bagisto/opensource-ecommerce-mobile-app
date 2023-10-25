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

import 'package:equatable/equatable.dart';

abstract class ShipmentListBaseEvent extends Equatable {}

class ShipmentListFetchDataEvent extends ShipmentListBaseEvent {
  int page;
  int? orderId;

  ShipmentListFetchDataEvent({this.orderId, required this.page});

  @override
  List<Object> get props => [];
}
