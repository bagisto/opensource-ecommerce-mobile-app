/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/order_model/order_invoices_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrderInvoiceBaseState extends Equatable {}

enum OrderInvoiceStatus { success, fail }


class OrderInvoiceInitialState extends OrderInvoiceBaseState {
  @override
  List<Object> get props => [];
}

class OrderInvoiceListDataState extends OrderInvoiceBaseState {

  final OrderInvoiceStatus? status;
  final String? error;
  final InvoicesModel? invoicesList;

  OrderInvoiceListDataState.success( {this.invoicesList,this.error}) : status = OrderInvoiceStatus.success;
  OrderInvoiceListDataState.fail( {this.error,this.invoicesList,}) : status = OrderInvoiceStatus.fail;

  @override
  List<Object> get props => [if (invoicesList !=null) invoicesList! else ""];
}

