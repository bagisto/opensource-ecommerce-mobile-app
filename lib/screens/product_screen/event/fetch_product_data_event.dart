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

import 'package:bagisto_app_demo/screens/product_screen/event/product_base_event.dart';

class FetchProductEvent extends ProductScreenBaseEvent {
  FetchProductEvent(this.id,);
  int? id;
  // TODO: implement props
  List<Object> get props => [];
}
