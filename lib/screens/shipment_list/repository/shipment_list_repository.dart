/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print

import '../../../../api/api_client.dart';
import '../../../../models/order_model/shipment_model.dart';

abstract class ShipmentListRepository {
  Future<ShipmentModel> getShipmentList(int page, int orderId);
}

class ShipmentListRepositoryImp implements ShipmentListRepository {
  @override
  Future<ShipmentModel> getShipmentList(int page, int orderId) async {
    ShipmentModel? shipmentModel;
    try {
      shipmentModel = await ApiClient().getShipmentList(page, orderId);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return shipmentModel!;
  }
}
