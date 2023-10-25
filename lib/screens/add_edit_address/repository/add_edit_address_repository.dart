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

import 'package:bagisto_app_demo/api/api_client.dart';
import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/models/address_model/update_address_model.dart';

import '../../../models/address_model/country_model.dart';

abstract class AddEditAddressRepository {
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
      String vatId);

  Future<GraphQlBaseModel> callCreateAddress(
      String companyName,
      String firstName,
      String lastName,
      String address,
      String country,
      String state,
      String city,
      String postCode,
      String phone,
      String vatId);
  Future<CountriesData> callCountriesData();
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
      );
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return updateAddressModel!;
  }

  @override
  Future<GraphQlBaseModel> callCreateAddress(
      String companyName,
      String firstName,
      String lastName,
      String address,
      String country,
      String state,
      String city,
      String postCode,
      String phone,
      String vatId) async {
    GraphQlBaseModel? baseModel;
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
      );
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return baseModel!;
  }
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
