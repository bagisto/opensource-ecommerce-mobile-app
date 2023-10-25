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

import 'package:bagisto_app_demo/configuration/server_configuration.dart';
import 'package:bagisto_app_demo/configuration/shared_preference_keys.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
final appStoragePref = SharedPreferenceHelper();

class SharedPreferenceHelper {
  var configurationStorage = GetStorage("configurationStorage"); //-----Use only for user app configuration data

  static setWebSiteId(String websiteId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_WEBSITE_ID, websiteId);
  }

  static getWebSiteId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? websiteId = sharedPreferences.getString(CONFIG_WEBSITE_ID);
    return websiteId ?? defaultWebsiteId;
  }
  static setAddressData(bool isAddressData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(AddressData, isAddressData);
  }

  static getAddressData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isAddressData = sharedPreferences.getBool(AddressData);
    return isAddressData ?? false;
  }
  static setWebSiteLabel(String websiteLabel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_WEBSITE_LABEL, websiteLabel);
  }

  setTheme(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(THEME_KEY, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(THEME_KEY) ?? "";
  }

  static getWebSiteLabel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? websiteLabel = sharedPreferences.getString(CONFIG_WEBSITE_LABEL);
    return websiteLabel ?? "";
  }

  static setChannelId(String channelId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_CHANNEL_ID, channelId);
  }

  static getChannelId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? channelId = sharedPreferences.getString(CONFIG_CHANNEL_ID);
    return channelId ?? defaultChannelId;
  }

  static setStoreCode(String storeCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_STORE_CODE, storeCode);
  }

  static getStoreCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storeCode = sharedPreferences.getString(CONFIG_STORE_CODE);
    return storeCode ?? defaultStoreCode;
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
    sharedPreferences.setString(CONFIG_CURRENCY_CODE, currencyCode);
  }

  static getCurrencyCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currencyCode = sharedPreferences.getString(CONFIG_CURRENCY_CODE);
    return currencyCode;
  }

  static setCurrencyLabel(String currencyLabel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_CURRENCY_LABEL, currencyLabel);
  }

  static getCurrencyLabel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? currencyLabel = sharedPreferences.getString(CONFIG_CURRENCY_LABEL);
    return currencyLabel;
  }

  static setFCMToken(String fcmToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CONFIG_FCM_TOKEN, fcmToken);
  }

  static getFCMToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? fcmToken = sharedPreferences.getString(CONFIG_FCM_TOKEN);
    return fcmToken ?? "";
  }

  static setCustomerLoggedIn(bool isLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(CUSTOMER_LOGGED_IN, isLoggedIn);
  }

  static onUserLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(CUSTOMER_LOGGED_IN, false);
    sharedPreferences.setInt(CUSTOMER_CART_COUNT, 0);
    sharedPreferences.setString(CUSTOMER_NAME, 'Welcome Guest');
    sharedPreferences.setString(CUSTOMER_EMAIL, '');
    sharedPreferences.setString(CUSTOMER_PROFILE_PIC_URL, '');
    sharedPreferences.setString(CUSTOMER_BANNER_PIC_URL, '');
    sharedPreferences.setString(CUSTOMER_TOKEN, '0');
    await sharedPreferences.clear();
  }

  static getCustomerLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = sharedPreferences.getBool(CUSTOMER_LOGGED_IN);
    return isLoggedIn ?? false;
  }

  static setQuoteId(int quoteId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(CUSTOMER_QUOTE_ID, quoteId);
  }

  static getQuoteId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? quoteId = sharedPreferences.getInt(CUSTOMER_QUOTE_ID);
    return quoteId ?? 0;
  }

  static setCartCount(int cartCount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(CUSTOMER_CART_COUNT, cartCount);
  }

  static getCartCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? quoteId = sharedPreferences.getInt(CUSTOMER_CART_COUNT);
    return quoteId ?? 0;
  }

  static setCustomerToken(String customerToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(CUSTOMER_TOKEN, customerToken);
  }

  static Future<String> getCustomerToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerToken = sharedPreferences.getString(CUSTOMER_TOKEN);

    return customerToken ?? "0";
  }

  static setCustomerName(String customerName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CUSTOMER_NAME, customerName);
  }

  static setDate(String date) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("date", date);
  }

  static Future<String> getDate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? date = sharedPreferences.getString("date");

    return date ?? "";
  }

  static getCustomerName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerName = sharedPreferences.getString(CUSTOMER_NAME);
    return customerName ?? "";
  }
  static setCustomerImage(String customerImage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CUSTOMER_IMAGE, customerImage);
  }

  static getCustomerImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerImage = sharedPreferences.getString(CUSTOMER_IMAGE);
    return customerImage ?? "";
  }

  static setCustomerEmail(String customerEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(CUSTOMER_EMAIL, customerEmail);
  }

  static getCustomerEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? customerEmail = sharedPreferences.getString(CUSTOMER_EMAIL);
    return customerEmail ?? "";
  }

  // static setCustomerProfilePicUrl(String customerProfileUrl) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setString(CUSTOMER_PROFILE_PIC_URL, customerProfileUrl);
  // }
  //
  // static getCustomerProfilePicUrl() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? customerProfilePicUrl =
  //       sharedPreferences.getString(CUSTOMER_PROFILE_PIC_URL);
  //   return customerProfilePicUrl ?? "";
  // }
  //
  // static setCustomerBannerPicUrl(String customerBannerPicUrl) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setString(CUSTOMER_BANNER_PIC_URL, customerBannerPicUrl);
  // }
  //
  // static getCustomerBannerPicUrl() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? customerBannerPicUrl =
  //       sharedPreferences.getString(CUSTOMER_BANNER_PIC_URL);
  //   return customerBannerPicUrl ?? "";
  // }

  static setCustomerId(int customerId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(CUSTOMER_ID, customerId);
  }

  static getCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? customerId = sharedPreferences.getInt(CUSTOMER_ID);
    return customerId ?? 0;
  }

  static setCookie(String cookie) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(COOKIE, cookie);
  }

  static getCookie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? cookie = sharedPreferences.getString(COOKIE);
    return cookie ?? "";
  }

  static setCustomerLanguage(String languageCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(CUSTOMER_LANGUAGE, languageCode);
  }

  static getCustomerLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(CUSTOMER_LANGUAGE) ?? 'en';
  }

  setFingerPrintUser(String savedKey) {
    configurationStorage.write(FINGER_PRINT_USER, savedKey);
  }

  String? getFingerPrintUser() {
    return configurationStorage.read(FINGER_PRINT_USER) ?? "";
  }

  setFingerPrintPassword(String savedKey) {
    configurationStorage.write(FINGER_PRINT_PASSWORD, savedKey);
  }

  String? getFingerPrintPassword() {
    return configurationStorage.read(FINGER_PRINT_PASSWORD) ?? "";
  }

}