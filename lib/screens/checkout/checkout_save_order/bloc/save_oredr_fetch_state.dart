/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../data_model/save_order_model.dart';

abstract class SaveOrderBaseState {}

enum SaveOrderStatus { success, fail }

class SaveOrderInitialState extends SaveOrderBaseState {

}


class SaveOrderFetchDataState extends SaveOrderBaseState {

  SaveOrderStatus? status;
  String? error;
  SaveOrderModel? saveOrderModel;

  SaveOrderFetchDataState.success({this.saveOrderModel,}) : status = SaveOrderStatus.success;
  SaveOrderFetchDataState.fail({this.error}) : status = SaveOrderStatus.fail;

}
