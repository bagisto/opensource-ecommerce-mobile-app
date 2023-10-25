/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/models/order_model/order_detail_model.dart';
import '../../../base_model/graphql_base_model.dart';
import 'order_detail_base_state.dart';


class OrderDetailFetchDataState extends OrderDetailBaseState {

  OrderDetailStatus? status;
  String? error;
  OrderDetail? orderDetailModel;

  OrderDetailFetchDataState.success({this.orderDetailModel}) : status = OrderDetailStatus.success;
  OrderDetailFetchDataState.fail({this.error}) : status = OrderDetailStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (orderDetailModel !=null) orderDetailModel! else ""];
}


class CancelOrderState extends OrderDetailBaseState{
  OrderDetailStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  CancelOrderState.success({ this.successMsg,this.baseModel}):status=OrderDetailStatus.success;
  CancelOrderState.fail({this.error}):status=OrderDetailStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}


class OnClickLoadingState extends OrderDetailBaseState {
  final bool? isReqToShowLoader;

  OnClickLoadingState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}
