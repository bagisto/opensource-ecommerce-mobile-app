/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/server_configuration.dart';
import 'package:bagisto_app_demo/utils/shared_preference_keys.dart';
import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:get_storage/get_storage.dart';

import '../data_model/account_models/account_info_details.dart';
import '../screens/home_page/data_model/get_categories_drawer_data_model.dart';

///this is file is for shared preference helper class which will help to store and retrieve data
///from flutter shared preference using get_storage package and shared preference keys are defined
/// in shared_preference_keys.dart file

final appStoragePref = SharedPreferenceHelper();

class SharedPreferenceHelper {
  //named storage box for storing user app configuration data
  var configurationStorage = GetStorage(
      "configurationStorage"); //-----Use only for user app configuration data

  String getDate() {
    return configurationStorage.read(date) ?? "";
  }

  setDate(String setDate) {
    configurationStorage.write(date, setDate);
  }

  setLanguageName(String customerLanguage) {
    configurationStorage.write(language, customerLanguage);
  }

  String getLanguageName() {
    return configurationStorage.read(language) ?? defaultLanguageName;
  }

  setSortName(String selectedSort) {
    configurationStorage.write(sort, selectedSort);
  }

  String getSortName() {
    return configurationStorage.read(sort) ?? "";
  }

  setCurrencyLabel(String currencyLabel) {
    configurationStorage.write(configCurrencyLabel, currencyLabel);
  }

  String getCurrencyLabel() {
    return configurationStorage.read(configCurrencyLabel) ??
        defaultCurrencyName;
  }

  onUserLogout() {
    configurationStorage.write(customerLoggedIn, false);
    configurationStorage.write(customerCartCount, 0);
    configurationStorage.write(customerName, StringConstants.welcomeGuest);
    configurationStorage.write(customerEmail, '');
    configurationStorage.write(customerProfilePicUrl, '');
    configurationStorage.write(customerBannerPicUrl, '');
    configurationStorage.write(customerToken, '0');
    configurationStorage.remove(customerDetails);
  }

  setAddressData(bool isAddressData) {
    configurationStorage.write(addressData, isAddressData);
  }

  bool getAddressData() {
    return configurationStorage.read(addressData) ?? false;
  }

  setCartCount(int cartCount) {
    configurationStorage.write(customerCartCount, cartCount);
  }

  int getCartCount() {
    return configurationStorage.read(customerCartCount) ?? 0;
  }

  setCustomerId(int customerIdNew) {
    configurationStorage.write(customerId, customerIdNew);
  }

  int getCustomerId() {
    return configurationStorage.read(customerId) ?? 0;
  }

  setCustomerToken(String customerTokenValue) {
    configurationStorage.write(customerToken, customerTokenValue);
  }

  String getCustomerToken() {
    return configurationStorage.read(customerToken) ?? "0";
  }

  setCustomerEmail(String customerEmailNew) {
    configurationStorage.write(customerEmail, customerEmailNew);
  }

  String getCustomerEmail() {
    return configurationStorage.read(customerEmail) ?? "";
  }

  setCustomerImage(String customerImageValue) {
    configurationStorage.write(customerImage, customerImageValue);
  }

  String getCustomerImage() {
    return configurationStorage.read(customerImage) ?? "";
  }

  setCustomerName(String customerNameValue) {
    configurationStorage.write(customerName, customerNameValue);
  }

  String getCustomerName() {
    return configurationStorage.read(customerName) ?? "";
  }

  bool getCustomerLoggedIn() {
    return configurationStorage.read(customerLoggedIn) ?? false;
  }

  setCustomerLoggedIn(bool isLoggedIn) {
    configurationStorage.write(customerLoggedIn, isLoggedIn);
  }

  setFingerPrintUser(String savedKey) {
    configurationStorage.write(fingerPrintUSer, savedKey);
  }

  String getFingerPrintUser() {
    return configurationStorage.read(fingerPrintUSer) ?? "";
  }

  setFingerPrintPassword(String savedKey) {
    configurationStorage.write(fingerPrintPassword, savedKey);
  }

  String? getFingerPrintPassword() {
    return configurationStorage.read(fingerPrintPassword) ?? "";
  }

  setTheme(String value) {
    configurationStorage.write(themeKey, value);
  }

  String getTheme() {
    return configurationStorage.read(themeKey) ?? "";
  }

  setCurrencySymbol(String currencySymbol) {
    configurationStorage.write(configCurrencySymbol, currencySymbol);
  }

  String getCurrencySymbol() {
    return configurationStorage.read(configCurrencySymbol) ?? "\$";
  }

  setCookieGet(String cookieData) {
    configurationStorage.write(cookie, cookieData);
  }

  String getCookieGet() {
    return configurationStorage.read(cookie) ?? "";
  }

  setCustomerLanguage(String languageCode) {
    configurationStorage.write(customerLanguage, languageCode);
  }

  String getCustomerLanguage() {
    return configurationStorage.read(customerLanguage) ?? defaultStoreCode;
  }

  setCurrencyCode(String currencyCode) {
    configurationStorage.write(configCurrencyCode, currencyCode);
  }

  String getCurrencyCode() {
    return configurationStorage.read(configCurrencyCode) ?? defaultCurrencyCode;
  }

  AccountInfoModel? getCustomerDetails() {
    return configurationStorage.read(customerDetails);
  }

  setCustomerDetails(AccountInfoModel? details) {
    return configurationStorage.write(customerDetails, details);
  }

  setDrawerCategories(GetDrawerCategoriesData? data) {
    return configurationStorage.write(drawerCatData, data);
  }

  GetDrawerCategoriesData? getDrawerCategories() {
    var data = configurationStorage.read(drawerCatData);
    if(data is GetDrawerCategoriesData){
      return data;
    }
    GetDrawerCategoriesData? drawerData =
        GetDrawerCategoriesData.fromJson(data ?? {});
    return drawerData;
  }
}
