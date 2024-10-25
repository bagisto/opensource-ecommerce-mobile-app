
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names


import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

abstract class ContactUsBaseEvent{}

class OnClickContactLoaderEvent extends ContactUsBaseEvent{
  final bool? isReqToShowLoader;
  OnClickContactLoaderEvent({this.isReqToShowLoader});

}
class ContactUsEvent extends ContactUsBaseEvent {
  final String?  name;
  final String?  email;
  final String?  phone;
  final String? describe;

  ContactUsEvent(this.name,this.email,this.phone,this.describe);
  List<Object> get props => [];
}