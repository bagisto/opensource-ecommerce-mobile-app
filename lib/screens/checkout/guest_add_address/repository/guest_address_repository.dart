/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, avoid_print



import '../../../../api/api_client.dart';
import '../../../../models/address_model/country_model.dart';

abstract class GuestAddressRepository{
  Future<CountriesData> callCountriesData();

}




class GuestAddressRepositoryImp implements GuestAddressRepository {

  @override
  Future<CountriesData> callCountriesData() async {
    CountriesData? countryData;
    try{
      countryData = await ApiClient().getCountryStateList();
    }catch(error, stacktrace){
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return countryData!;
  }


}