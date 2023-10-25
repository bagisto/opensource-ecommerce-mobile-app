/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable



import 'add_review_base_event.dart';

class AddReviewFetchEvent extends AddReviewBaseEvent {
 String? name;
 String? title;
 int? rating;
 String? comment;
 int? productId;
  AddReviewFetchEvent({this.name,this.productId,this.rating,this.title,this.comment});
  // TODO: implement props
  List<Object> get props => [];
}