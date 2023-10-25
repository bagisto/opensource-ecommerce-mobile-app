

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names


import 'dart:ui';

import 'package:bagisto_app_demo/models/currency_language_model.dart';

import '../screens/account/view/widget/account_index.dart';


class GlobalData{
  static List<Locales>? languageData = [];
  static String? cookie;
  static String? locale ="en";
  static String? currency;
  static String? selectedLanguage="";
  static TextDirection contentDirection(){
    debugPrint("TextDirection------$selectedLanguage");
    return selectedLanguage == "ar" ? TextDirection.rtl:TextDirection.ltr;
  }
}
