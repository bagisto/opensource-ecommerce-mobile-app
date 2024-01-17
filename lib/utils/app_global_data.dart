
import 'dart:async';

import 'package:flutter/material.dart';
import '../data_model/currency_language_model.dart';
import '../screens/home_page/data_model/new_product_data.dart';

class GlobalData {
  static List<Locales>? languageData = [];
  static String? cookie;
  static String? locale ="en";
  static String? currency;
  static String? currencySymbol = "";
  static String? selectedLanguage = "";
  static int rootCategoryId = 1;

  static StreamController<NewProductsModel?> productsStream = StreamController<NewProductsModel?>.broadcast();

  static List<NewProductsModel?>? allProducts = [];

  static TextDirection contentDirection() {
    return selectedLanguage == "ar" ? TextDirection.rtl : TextDirection.ltr;
  }
}