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


import '../../../models/add_review_model/add_review_model.dart';
import 'add_review_base_state.dart';


class AddReviewFetchState extends AddReviewBaseState {

  AddReviewStatus? status;
  String? error;
  String? successMsg;
  AddReviewModel? addReviewModel;


  AddReviewFetchState.success({this.addReviewModel,this.successMsg}) : status = AddReviewStatus.success;

  AddReviewFetchState.fail({this.error}) : status = AddReviewStatus.fail;

  // TODO: implement props
  List<Object> get props => [if (addReviewModel !=null) addReviewModel! else ""];
}
