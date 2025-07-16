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


import 'package:bagisto_app_demo/screens/order_shipping/utils/index.dart';

abstract class OrderShipmentsRepository{
  Future<ShipmentModel> getShipmentsList(int orderId);
}
class OrderShipmentsRepositoryImp implements OrderShipmentsRepository {
  @override
  Future<ShipmentModel> getShipmentsList(int orderId) async {
    ShipmentModel? shipmentData;
    try{
      shipmentData=await ApiClient().getShipmentsList(orderId);
    }
    catch(error,stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return shipmentData!;
  }



}
