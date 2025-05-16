
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
import 'package:flutter/material.dart';
import '../data_model/currency_language_model.dart';
import '../services/api_client.dart';
import 'app_global_data.dart';


Future preCacheLanguageData() async {
    try {
      CurrencyLanguageList? currencyLanguageList = await ApiClient().getLanguageCurrency();
      GlobalData.languageData = currencyLanguageList;
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
}

Future preCacheCMSData() async {
    try {
      await ApiClient().getCmsPagesData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
}

Future preCacheOrderDetails(int orderId) async {
    try {
      await ApiClient().getOrderDetail(orderId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
}

Future preCacheProductDetails(String urlKey) async {
    try {
      await ApiClient().getAllProducts(filters: [
        {"key": '"url_key"', "value": '"$urlKey"'}
      ]);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
}

