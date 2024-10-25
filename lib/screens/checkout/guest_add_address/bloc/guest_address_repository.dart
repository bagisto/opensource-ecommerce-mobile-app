/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

abstract class GuestAddressRepository{
  Future<CountriesData?> callCountriesData();

}

class GuestAddressRepositoryImp implements GuestAddressRepository {

  @override
  Future<CountriesData?> callCountriesData() async {
    CountriesData? countryData;
    try{
      countryData = await ApiClient().getCountryStateList();
    }catch(error, stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return countryData;
  }


}