// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

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

import 'package:bagisto_app_demo/screens/review/events/review_base_event.dart';

class FetchReviewsEvent extends ReviewsBaseEvent {

FetchReviewsEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class RemoveReviewEvent extends ReviewsBaseEvent {
  var productId;

  final String? message;

  RemoveReviewEvent(this.productId, this.message);

  // TODO: implement props
  @override
  List<Object> get props => [productId ?? "", message ?? ""];

}
class RemoveAllReviewsEvent extends ReviewsBaseEvent {

  RemoveAllReviewsEvent();

  // TODO: implement props
  @override
  List<Object> get props => [];

}