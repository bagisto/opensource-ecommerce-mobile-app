// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class RefundListBaseEvent extends Equatable{}

class RefundListFetchDataEvent extends RefundListBaseEvent{
  int page;
  int orderId;
  RefundListFetchDataEvent({required this.orderId, required this.page});

  @override
  List<Object> get props => [];
}