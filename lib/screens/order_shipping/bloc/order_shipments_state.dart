/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/order_model/shipment_model.dart';
import 'package:equatable/equatable.dart';

//ignore_for_file: must_be_immutable

abstract class OrderShipmentsBaseState extends Equatable {}

enum OrderShipmentsStatus { success, fail }


class OrderShipmentsInitialState extends OrderShipmentsBaseState {
  @override
  List<Object> get props => [];
}

class OrderShipmentsListDataState extends OrderShipmentsBaseState {

  OrderShipmentsStatus? status;
  String? error;
  ShipmentModel? shipmentData;

  OrderShipmentsListDataState.success({this.shipmentData}) : status = OrderShipmentsStatus.success;
  OrderShipmentsListDataState.fail({this.error}) : status = OrderShipmentsStatus.fail;

  @override
  List<Object> get props => [if (shipmentData !=null) shipmentData! else ""];
}

