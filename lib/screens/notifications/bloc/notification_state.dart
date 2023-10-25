


/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import '../../../models/notification_model/notification_model.dart';

abstract class NotificationScreenState{
  const NotificationScreenState();

  List<Object> get props => [];
}
class NotificationInitial extends NotificationScreenState {}

class NotificationSuccess extends NotificationScreenState {
  NotificationSuccess(this.data);

  NotificationListModel data;

  @override
  List<Object> get props => [];
}

class NotificationError extends NotificationScreenState {
  NotificationError(this._message);

  String? _message;
  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}