/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import '../../address_list/data_model/update_address_model.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/utils/index.dart';

abstract class AddEditAddressRepository {
  Future<UpdateAddressModel?> callEditAddressApi(
      int addressId,
      String companyName,
      String firstName,
      String lastName,
      String address,
      String country,
      String state,
      String city,
      String postCode,
      String phone,
      String vatId,
      bool isDefault, String email);

  Future<BaseModel?> callCreateAddress(
      String companyName,
      String firstName,
      String lastName,
      String address,
      String country,
      String state,
      String city,
      String postCode,
      String phone,
      String vatId,
      bool isDefault, String email);

  Future<CountriesData?> callCountriesData();
}

class AddEditAddressRepositoryImp implements AddEditAddressRepository {
  @override
  Future<UpdateAddressModel> callEditAddressApi(
    int addressId,
    String companyName,
    String firstName,
    String lastName,
    String address,
    String country,
    String state,
    String city,
    String postCode,
    String phone,
    String vatId,
      bool isDefault, String email
  ) async {
    UpdateAddressModel? updateAddressModel;
    try {
      updateAddressModel = await ApiClient().updateAddress(
        addressId,
        companyName,
        firstName,
        lastName,
        address,
        "",
        country,
        state,
        city,
        postCode,
        phone,
        vatId,
          email
      );
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return updateAddressModel!;
  }

  @override
  Future<BaseModel> callCreateAddress(
      String companyName,
      String firstName,
      String lastName,
      String address,
      String country,
      String state,
      String city,
      String postCode,
      String phone,
      String vatId,
      bool isDefault, String email) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().createAddress(
        companyName,
        firstName,
        lastName,
        address,
        "",
        country,
        state,
        city,
        postCode,
        phone,
        vatId,
        isDefault, email
      );
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
  @override
  Future<CountriesData> callCountriesData() async {
    CountriesData? countryData;
    try{
      countryData = await ApiClient().getCountryStateList();
    }catch(error, stacktrace){
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return countryData!;
  }
}
