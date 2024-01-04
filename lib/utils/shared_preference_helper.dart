/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/utils/shared_preference_keys.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appStoragePref = SharedPreferenceHelper();

class SharedPreferenceHelper {
  var configurationStorage = GetStorage(
      "configurationStorage"); //-----Use only for user app configuration data

  static Future<String> getDate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? dateNew = sharedPreferences.getString(date);

    return dateNew ?? "";
  }

  static setDate(String setDate) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(date, setDate);
  }

  static setLanguageName(String customerLanguage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Language", customerLanguage);
  }

  static getLanguageName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerLanguage = sharedPreferences.getString("Language");
    return customerLanguage ?? "English";
  }

  static setSortName(String sort) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("sort", sort);
  }

  static getSortName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? sort = sharedPreferences.getString("sort");
    return sort ?? "";
  }

  static setCurrencyCode(String currencyCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(configCurrencyCode, currencyCode);
  }

  static getCurrencyCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String ?  currencyCode = sharedPreferences.getString(configCurrencyCode);
    return currencyCode ?? "USD" ;
  }

  static setCurrencyLabel(String currencyLabel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(configCurrencyLabel, currencyLabel);
  }

  static getCurrencyLabel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currencyLabel = sharedPreferences.getString(configCurrencyLabel);
    return currencyLabel;
  }

  static setCustomerLoggedIn(bool isLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(customerLoggedIn, isLoggedIn);
  }

  static onUserLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(customerLoggedIn, false);
    sharedPreferences.setInt(customerCartCount, 0);
    sharedPreferences.setString(customerName, 'Welcome Guest');
    sharedPreferences.setString(customerEmail, '');
    sharedPreferences.setString(customerProfilePicUrl, '');
    sharedPreferences.setString(customerBannerPicUrl, '');
    sharedPreferences.setString(customerToken, '0');
    sharedPreferences.setBool(isApproved, false);
    await sharedPreferences.clear();
  }

  static getCustomerLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = sharedPreferences.getBool(customerLoggedIn);
    return isLoggedIn ?? false;
  }

  static setAddressData(bool isAddressData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(addressData, isAddressData);
  }

  static getAddressData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isAddressData = sharedPreferences.getBool(addressData);
    return isAddressData ?? false;
  }

  static setQuoteId(int quoteId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(customerQuoteId, quoteId);
  }

  static getQuoteId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? quoteId = sharedPreferences.getInt(customerQuoteId);
    return quoteId ?? 0;
  }

  static setCartCount(int cartCount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(customerCartCount, cartCount);
  }

  static getCartCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? quoteId = sharedPreferences.getInt(customerCartCount);
    return quoteId ?? 0;
  }

  static setCustomerToken(String customerTokenValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(customerToken, customerTokenValue);
  }

  static Future<String> getCustomerToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerTokenNew = sharedPreferences.getString(customerToken);

    return customerTokenNew ?? "0";
  }

  static setCustomerName(String customerNameValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(customerName, customerNameValue);
  }

  static getCustomerName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerNameNew = sharedPreferences.getString(customerName);
    return customerNameNew ?? "";
  }

  static setCustomerImage(String customerImageValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(customerImage, customerImageValue);
  }

  static getCustomerImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerImageNew = sharedPreferences.getString(customerImage);
    return customerImageNew ?? "";
  }

  static setCustomerEmail(String customerEmailNew) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(customerEmail, customerEmailNew);
  }

  static getCustomerEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerEmailNew = sharedPreferences.getString(customerEmail);
    return customerEmailNew ?? "";
  }

  static setCustomerId(int customerIdNew) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(customerId, customerIdNew);
  }

  static getCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? customerIdNew = sharedPreferences.getInt(customerId);
    return customerIdNew ?? 0;
  }

  static setCookie(String cookieData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(cookie, cookieData);
  }

  static getCookie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? cookieNew = sharedPreferences.getString(cookie);
    return cookieNew ?? "";
  }

  static setCustomerLanguage(String languageCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(customerLanguage, languageCode);
  }

  static getCustomerLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(customerLanguage) ?? 'en';
  }

  setFingerPrintUser(String savedKey) {
    configurationStorage.write(fingerPrintUSer, savedKey);
  }

  String? getFingerPrintUser() {
    return configurationStorage.read(fingerPrintUSer) ?? "";
  }

  setFingerPrintPassword(String savedKey) {
    configurationStorage.write(fingerPrintPassword, savedKey);
  }

  String? getFingerPrintPassword() {
    return configurationStorage.read(fingerPrintPassword) ?? "";
  }

  setTheme(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(themeKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(themeKey) ?? "";
  }
}
