/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


abstract class AddressBaseEvent{}

class FetchAddressEvent extends AddressBaseEvent {

}

class RemoveAddressEvent extends AddressBaseEvent{
  String? id;
  RemoveAddressEvent(this.id);
}