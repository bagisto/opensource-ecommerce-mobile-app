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


abstract class ContactUsScreenRepository{
  Future<BaseModel> contactUsRepoScreen(String name,
   String?  email,
   String?  phone,
   String? describe);


}
class ContactUsScreenRepositoryImp implements ContactUsScreenRepository {

  @override
  Future<BaseModel> contactUsRepoScreen(String name,
      String?  email,
      String?  phone,
      String? describe)async {
    BaseModel? baseModel;
    baseModel = await ApiClient().contactUsApiClient(name,email,phone,describe);
    return baseModel!;
  }
}
