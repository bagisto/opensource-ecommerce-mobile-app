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

import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_order_base_state.dart';

import '../../../../models/checkout_models/save_order_model.dart';




class SaveOrderFetchDataState extends SaveOrderBaseState {

  SaveOrderStatus? status;
  String? error;
  SaveOrderModel? saveOrderModel;

  SaveOrderFetchDataState.success({this.saveOrderModel,}) : status = SaveOrderStatus.success;
  SaveOrderFetchDataState.fail({this.error}) : status = SaveOrderStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (saveOrderModel !=null) saveOrderModel! else ""];
}
