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

abstract class ReviewsBaseEvent extends Equatable{}

class FetchReviewsEvent extends ReviewsBaseEvent {

  FetchReviewsEvent();
  @override
  List<Object> get props => [];
}


class RemoveReviewEvent extends ReviewsBaseEvent {
  final dynamic productId;

  final String? message;

  RemoveReviewEvent(this.productId, this.message);

  List<Object> get props => [productId ?? "", message ?? ""];

}
class RemoveAllReviewsEvent extends ReviewsBaseEvent {

  RemoveAllReviewsEvent();

  List<Object> get props => [];

}