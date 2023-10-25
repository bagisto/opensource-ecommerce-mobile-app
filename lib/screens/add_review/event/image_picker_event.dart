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

import 'package:image_picker/image_picker.dart';

import 'add_review_base_event.dart';

class ImagePickerEvent extends AddReviewBaseEvent {

  XFile? pickedFile;
  ImagePickerEvent({
    this.pickedFile,
  });
  // TODO: implement props
  List<Object> get props => [];
}
