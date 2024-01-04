/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import '../../../data_model/graphql_base_model.dart';
import '../../../services/api_client.dart';
import '../../address_list/data_model/country_model.dart';
import '../../address_list/data_model/update_address_model.dart';
import 'package:flutter/material.dart';

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
      bool isDefault);

  Future<GraphQlBaseModel?> callCreateAddress(
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
      bool isDefault);

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
      bool isDefault
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
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
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
      String vatId,
      bool isDefault) async {
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
        isDefault
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
