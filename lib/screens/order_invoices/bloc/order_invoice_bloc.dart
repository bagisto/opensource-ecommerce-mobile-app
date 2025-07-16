/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/order_invoices/utils/index.dart';

class OrderInvoiceBloc
    extends Bloc<OrderInvoiceBaseEvent, OrderInvoiceBaseState> {
  OrderInvoiceRepository? repository;
  BuildContext? context;

  OrderInvoiceBloc({@required this.repository})
      : super(OrderInvoiceInitialState()) {
    on<OrderInvoiceBaseEvent>(mapEventToState);
  }

  void mapEventToState(
      OrderInvoiceBaseEvent event, Emitter<OrderInvoiceBaseState> emit) async {
    if (event is OrderInvoiceFetchDataEvent) {
      try {
        InvoicesModel invoicesList =
            await repository!.getInvoicesList(event.orderId);
        emit(OrderInvoiceListDataState.success(invoicesList: invoicesList));
      } catch (e) {
        emit(OrderInvoiceListDataState.fail(error: e.toString()));
      }
    }
  }
}
