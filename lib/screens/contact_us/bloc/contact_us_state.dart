/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/compare/utils/index.dart';


abstract class ContactUsBaseState {}

enum ContactUsStatus { success, fail }

class ContactUsState extends ContactUsBaseState{
  ContactUsStatus? status;
  String? error;
  String? successMsg;
  BaseModel? response;
  ContactUsState.success({this.response, this.successMsg}):status=ContactUsStatus.success;
  ContactUsState.fail({this.error}):status=ContactUsStatus.fail;

}
class ContactUsScreenInitialState extends ContactUsBaseState {
}

