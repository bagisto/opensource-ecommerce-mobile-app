/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:async';

import '../data_model/core_configs_model.dart';
import '../data_model/currency_language_model.dart';
import '../screens/cms_screen/data_model/cms_model.dart';
import '../screens/home_page/data_model/get_categories_drawer_data_model.dart';
import '../screens/home_page/data_model/new_product_data.dart';
import 'server_configuration.dart';

/// Global Data class to store global data throughout the application like currency, language, cookie, etc. and stream controllers.

class GlobalData {
  static CurrencyLanguageList? languageData;
  static String? cookie;
  static String locale = defaultStoreCode;
  static String currencyCode = defaultCurrencyCode;
  static String? currencySymbol = "";
  static int rootCategoryId = 1;
  static CmsData? cmsData;
  static GetDrawerCategoriesData? categoriesDrawerData;

  static final StreamController cartCountController =
      StreamController<int>.broadcast();

  static StreamController<NewProductsModel?> productsStream =
      StreamController<NewProductsModel?>.broadcast();

  static List<NewProductsModel?>? allProducts = [];
  static CoreConfigs? configData;

  static String style = "";
  static String fcmToken = "";
  static String deviceName = "";
}
