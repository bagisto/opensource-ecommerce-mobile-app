
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables


import 'address_base_event.dart';

class RemoveAddressEvent extends AddressBaseEvent{
  var id;
  RemoveAddressEvent(this.id);
  // TODO: implement props
  List<Object> get props => [];

}