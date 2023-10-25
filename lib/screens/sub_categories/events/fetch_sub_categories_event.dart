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

import 'package:bagisto_app_demo/screens/sub_categories/events/sub_categories_base_event.dart';

class FetchSubCategoryEvent extends SubCategoryBaseEvent {
  FetchSubCategoryEvent(
      this.categorySlug,
      this.page,
      this.sort,
      this.order,
      {this.filter});
 String? categorySlug;
 String? order;
 String? sort;
 int? page;
 int ? min;
 int ? max;
 List? filter;

  @override
  // TODO: implement props
  List<Object> get props => [];
}
