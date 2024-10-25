/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import 'package:equatable/equatable.dart';

import '../../cart_screen/cart_model/add_to_cart_model.dart';

//ignore_for_file: must_be_immutable

abstract class OrderDetailBaseState extends Equatable {}

enum OrderDetailStatus { success, fail }


class OrderDetailInitialState extends OrderDetailBaseState {
  @override
  List<Object> get props => [];
}

class OrderDetailFetchDataState extends OrderDetailBaseState {

  OrderDetailStatus? status;
  String? error;
  OrderDetail? orderDetailModel;

  OrderDetailFetchDataState.success({this.orderDetailModel}) : status = OrderDetailStatus.success;
  OrderDetailFetchDataState.fail({this.error}) : status = OrderDetailStatus.fail;

  @override
  List<Object> get props => [if (orderDetailModel !=null) orderDetailModel! else ""];
}


class CancelOrderState extends OrderDetailBaseState{
  OrderDetailStatus? status;
  String? error;
  String? successMsg;
  BaseModel? baseModel;
  CancelOrderState.success({ this.successMsg,this.baseModel}):status=OrderDetailStatus.success;
  CancelOrderState.fail({this.error}):status=OrderDetailStatus.fail;

  @override
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}


class OnClickLoadingState extends OrderDetailBaseState {
  final bool? isReqToShowLoader;

  OnClickLoadingState({this.isReqToShowLoader});

  @override
  List<Object> get props => [isReqToShowLoader!];
}

class ReOrderState extends OrderDetailBaseState {
  OrderDetailStatus? status;
  String? message;
  AddToCartModel? model;

  ReOrderState.success({this.message,this.model}):status=OrderDetailStatus.success;
  ReOrderState.fail({this.message}): status=OrderDetailStatus.fail;

  @override
  List<Object> get props => [message ??"",model!];

}
