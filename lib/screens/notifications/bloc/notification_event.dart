/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable


abstract class NotificationScreenEvent /*extends Equatable*/ {
  const NotificationScreenEvent();

  List<Object> get props => [];
}
class NotificationFetchEvent extends NotificationScreenEvent {
  NotificationFetchEvent();

  @override
  List<Object> get props => [];
}
