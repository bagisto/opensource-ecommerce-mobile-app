/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print


import 'package:bagisto_app_demo/screens/order_invoices/utils/index.dart';

abstract class OrderInvoiceRepository{
  Future<InvoicesModel> getInvoicesList(int orderId);
}
class OrderInvoiceRepositoryImp implements OrderInvoiceRepository {
  @override
  Future<InvoicesModel> getInvoicesList(int orderId) async {
    InvoicesModel? invoiceList;
    try{
      invoiceList=await ApiClient().getInvoicesList(orderId);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return invoiceList!;
  }



}
