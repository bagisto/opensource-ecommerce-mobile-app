// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class InvoiceListBaseEvent extends Equatable{}

class InvoiceListFetchDataEvent extends InvoiceListBaseEvent{
  int page;
  int orderId;
  InvoiceListFetchDataEvent({required this.orderId, required this.page});

  @override
  List<Object> get props => [];
}