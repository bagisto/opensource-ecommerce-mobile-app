
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import '../../../api/api_client.dart';
import '../../../models/notification_model/notification_model.dart';



abstract class NotificationRepository {
  Future<NotificationListModel?> getNotificationData();
}

class NotificationRepositoryImp implements NotificationRepository {
  @override
  Future<NotificationListModel?> getNotificationData() async {
    NotificationListModel? model = await ApiClient().getNotificationList();
    return model;
  }
}