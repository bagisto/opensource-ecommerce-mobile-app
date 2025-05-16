/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/screens/review/utils/index.dart';
import 'package:equatable/equatable.dart';

abstract class ReviewsBaseState extends Equatable {}

enum ReviewStatus { success, fail }

class ReviewInitialState extends ReviewsBaseState {
  @override
  List<Object> get props => [];
}

//ignore: must_be_immutable
class FetchReviewState extends ReviewsBaseState {
  ReviewStatus? status;
  String? error;
  String? successMsg;
  ReviewModel? reviewModel;

  FetchReviewState.success({this.reviewModel, this.successMsg})
      : status = ReviewStatus.success;

  FetchReviewState.fail({this.error}) : status = ReviewStatus.fail;

  @override
  List<Object> get props => [if (reviewModel != null) reviewModel! else ""];
}

//ignore: must_be_immutable
