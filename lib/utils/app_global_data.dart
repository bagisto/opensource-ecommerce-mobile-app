
import 'package:flutter/material.dart';
import '../data_model/currency_language_model.dart';

class GlobalData {
  static List<Locales>? languageData = [];
  static String? cookie;
  static String? locale ="en";
  static String? currency;
  static String? selectedLanguage = "";

  static TextDirection contentDirection() {
    return selectedLanguage == "ar" ? TextDirection.rtl : TextDirection.ltr;
  }
}