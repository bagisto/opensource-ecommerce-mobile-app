import 'package:flutter/cupertino.dart';

import '../../../../api/api_client.dart';
import '../../../../models/order_model/order_invoices_model.dart';

abstract class InvoiceListRepository{
  Future<InvoicesModel> getInvoiceList(int page, int orderId);
}
class InvoiceListRepositoryImp implements InvoiceListRepository {
  @override
  Future<InvoicesModel> getInvoiceList(int page, int orderId) async {
    InvoicesModel? invoicesModel;
    try{
      invoicesModel = await ApiClient().getInvoiceList(page, orderId);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return invoicesModel!;
  }

}