// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../../models/order_model/order_refund_model.dart';

abstract class RefundListBaseState extends Equatable {}

enum RefundListStatus { success, fail }

class RefundListInitialState extends RefundListBaseState {
  @override
  List<Object> get props => [];
}

class RefundListFetchDataState extends RefundListBaseState {
  RefundListStatus? status;
  String? error;
  OrderRefundModel? refundModel;

  RefundListFetchDataState.success({this.refundModel}) : status = RefundListStatus.success;
  RefundListFetchDataState.fail({this.error}) : status = RefundListStatus.fail;

  @override
  List<Object> get props => [if (refundModel !=null) refundModel! else ""];
}