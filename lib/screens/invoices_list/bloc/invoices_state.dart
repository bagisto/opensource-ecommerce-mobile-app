// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../../models/order_model/order_invoices_model.dart';

abstract class InvoiceListBaseState extends Equatable {}

enum InvoiceListStatus { success, fail }

class InvoiceListInitialState extends InvoiceListBaseState {
  @override
  List<Object> get props => [];
}

class InvoiceListFetchDataState extends InvoiceListBaseState {

  InvoiceListStatus? status;
  String? error;
  InvoicesModel? invoiceModel;

  InvoiceListFetchDataState.success({this.invoiceModel}) : status = InvoiceListStatus.success;
  InvoiceListFetchDataState.fail({this.error}) : status = InvoiceListStatus.fail;

  @override
  List<Object> get props => [if (invoiceModel !=null) invoiceModel! else ""];
}