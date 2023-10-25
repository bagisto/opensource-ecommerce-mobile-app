/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables


import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_base_state.dart';





class AddToCartCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? error;
  String? successMsg;
  AddToCartModel? response;
var cartProductId;
  AddToCartCompareState.success({this.response, this.successMsg,this.cartProductId}):status=CompareStatusStatus.success;
  AddToCartCompareState.fail({this.error}):status=CompareStatusStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [status!,successMsg!,error??"",response!];

}