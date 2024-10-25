/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/add_review/utils/index.dart';

abstract class AddReviewBaseEvent {}

class AddReviewFetchEvent extends AddReviewBaseEvent {
  String? name;
  String? title;
  int? rating;
  String? comment;
  int? productId;
  List<Map<String, String>> attachments;
  AddReviewFetchEvent({this.name,this.productId,this.rating,this.title,this.comment, required this.attachments});
}

class ImagePickerEvent extends AddReviewBaseEvent {
  XFile? pickedFile;
  String? image;
  ImagePickerEvent({this.pickedFile, this.image});
  List<Object> get props => [];
}