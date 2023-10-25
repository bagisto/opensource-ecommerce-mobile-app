/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'add_edit_address_base_event.dart';

class FetchAddAddressEvent extends AddEditAddressBaseEvent {
 final  String? address ;
 final  String? city;
 final  String? country;
 final  String? firstName;
 final  String? lastName;
 final  String? vatId;
 final String? phone;
 final   String? postCode;
 final String? state;
 final   String? companyName;

  FetchAddAddressEvent({this.address,this.city,this.country,this.firstName,this.phone,this.postCode,this.state,this.companyName,this.lastName,this.vatId});
  // TODO: implement props
  List<Object> get props => [];
}
