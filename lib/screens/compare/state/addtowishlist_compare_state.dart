
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

import 'package:bagisto_app_demo/models/add_to_wishlist_model/add_wishlist_model.dart';
import 'package:bagisto_app_demo/screens/compare/state/compare_base_state.dart';

import '../../../base_model/graphql_base_model.dart';

class AddtoWishlistCompareState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? successMsg="";
  String? error="";
  AddWishListModel? response;
  var producDeletedId;
  AddtoWishlistCompareState.success({this.response, this.producDeletedId,this.successMsg}):status=CompareStatusStatus.success;
  AddtoWishlistCompareState.fail({this.error}):status=CompareStatusStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}

class RemoveFromWishlistState extends CompareScreenBaseState{
  CompareStatusStatus? status;
  String? successMsg="";
  String? error="";
  GraphQlBaseModel? response;
  var producDeletedId;
  RemoveFromWishlistState.success({this.response, this.producDeletedId,this.successMsg}):status=CompareStatusStatus.success;
  RemoveFromWishlistState.fail({this.error}):status=CompareStatusStatus.fail;

  // TODO: implement props
  @override
  List<Object> get props => [producDeletedId,status!,successMsg!,error!];

}