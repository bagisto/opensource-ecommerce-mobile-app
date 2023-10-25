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


import 'cms_base_event.dart';

class FetchCmsDataEvent extends CmsBaseEvent {

String? id;
FetchCmsDataEvent(this.id);
  // int? carouselIndex;
  @override
  // TODO: implement props
  List<Object> get props => [];
}
