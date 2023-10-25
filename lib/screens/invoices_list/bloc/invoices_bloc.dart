import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/order_model/order_invoices_model.dart';
import 'invoices_event.dart';
import 'invoices_repository.dart';
import 'invoices_state.dart';

class InvoiceListBloc extends Bloc<InvoiceListBaseEvent, InvoiceListBaseState> {
  InvoiceListRepository? repository;

  InvoiceListBloc({@required this.repository}) : super(InvoiceListInitialState()) {on<InvoiceListBaseEvent>(mapEventToState);
  }

  void mapEventToState(InvoiceListBaseEvent event, Emitter<InvoiceListBaseState> emit) async {
    if (event is InvoiceListFetchDataEvent) {
      try {
        InvoicesModel model = await repository!.getInvoiceList(event.page, event.orderId);
        if (model.status == true) {
          emit(InvoiceListFetchDataState.success(invoiceModel : model));
        } else {
          emit(InvoiceListFetchDataState.fail(error: model.success));
        }
      } catch (e) {
        emit(InvoiceListFetchDataState.fail(error: e.toString()));
      }
    }
  }
}