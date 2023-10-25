// ignore_for_file: must_be_immutable

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

import '../../../../models/order_model/shipment_model.dart';

abstract class ShipmentListBaseState extends Equatable {}

enum ShipmentListStatus { success, fail }

class ShipmentListInitialState extends ShipmentListBaseState {
  @override
  List<Object> get props => [];
}

class ShipmentListFetchDataState extends ShipmentListBaseState {
  ShipmentListStatus? status;
  String? error;
  ShipmentModel? shipmentModel;

  ShipmentListFetchDataState.success({this.shipmentModel})
      : status = ShipmentListStatus.success;

  ShipmentListFetchDataState.fail({this.error})
      : status = ShipmentListStatus.fail;

  @override
  List<Object> get props => [if (shipmentModel != null) shipmentModel! else ""];
}
