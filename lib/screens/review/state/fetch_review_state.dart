// ignore_for_file: prefer_typing_uninitialized_variables

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

import 'package:bagisto_app_demo/models/review_model/review_model.dart';
import 'package:bagisto_app_demo/screens/review/state/review_base_state.dart';

import '../../../base_model/graphql_base_model.dart';


class FetchReviewState extends ReviewsBaseState {

  ReviewStatus? status;
  String? error;
  String? successMsg;
  ReviewModel? reviewModel;


  FetchReviewState.success({this.reviewModel,this.successMsg}) : status = ReviewStatus.success;

  FetchReviewState.fail({this.error}) : status = ReviewStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (reviewModel !=null) reviewModel! else ""];
}

class RemoveReviewState extends ReviewsBaseState{
  ReviewStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  var productDeletedId;
  RemoveReviewState.success({ this.successMsg,this.baseModel,this.productDeletedId}):status=ReviewStatus.success;
  RemoveReviewState.fail({this.error}):status=ReviewStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!,productDeletedId];

}
class RemoveAllReviewState extends ReviewsBaseState{
  ReviewStatus? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;
  RemoveAllReviewState.success({ this.successMsg,this.baseModel}):status=ReviewStatus.success;
  RemoveAllReviewState.fail({this.error}):status=ReviewStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [successMsg??"",error??"",baseModel!];

}