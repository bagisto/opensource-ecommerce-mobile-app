/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/orders/utils/index.dart';

abstract class OrderListEvent extends Equatable {}

class FetchOrderListEvent extends OrderListEvent {
  final String? id;
  final String? startDate;
  final String? endDate;
  final String? status;
  final double? total;
  final int? page;
  final bool? isFilterApply ;


  FetchOrderListEvent({this.id, this.status, this.page, this.endDate, this.startDate, this.total,this.isFilterApply});

  @override
  List<Object> get props => [];
}
