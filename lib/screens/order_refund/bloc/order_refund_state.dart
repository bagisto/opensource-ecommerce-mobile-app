/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:equatable/equatable.dart';
import '../../../data_model/order_model/order_refund_model.dart';

//ignore_for_file: must_be_immutable

abstract class OrderRefundBaseState extends Equatable {}

enum OrderRefundStatus { success, fail }


class OrderRefundInitialState extends OrderRefundBaseState {
  @override
  List<Object> get props => [];
}

class OrderRefundListDataState extends OrderRefundBaseState {

  OrderRefundStatus? status;
  String? error;
  OrderRefundModel? refundData;

  OrderRefundListDataState.success({this.refundData}) : status = OrderRefundStatus.success;
  OrderRefundListDataState.fail({this.error}) : status = OrderRefundStatus.fail;

  @override
  List<Object> get props => [if (refundData !=null) refundData! else ""];
}

