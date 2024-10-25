
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:equatable/equatable.dart';

abstract class FilterBaseEvent extends Equatable {}

class FilterSortFetchEvent extends FilterBaseEvent {
  final String ? categorySlug;
  FilterSortFetchEvent(this.categorySlug);

  @override
  List<Object> get props => [];
}
