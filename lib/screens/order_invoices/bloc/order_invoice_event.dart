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

abstract class OrderInvoiceBaseEvent extends Equatable {}

class OrderInvoiceFetchDataEvent extends OrderInvoiceBaseEvent {
  final int orderId;

  OrderInvoiceFetchDataEvent(this.orderId);

  @override
  List<Object> get props => [];
}
