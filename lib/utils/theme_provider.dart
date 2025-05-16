/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/shared_preference_helper.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late String _isDark;
  late final SharedPreferenceHelper appStoragePref;

  String get isDark => _isDark;

  ThemeProvider() {
    _isDark = "false";
    appStoragePref = SharedPreferenceHelper();
    getPreferences();
  }

  set isDark(String value) {
    _isDark = value;
    appStoragePref.setTheme(value);
    notifyListeners();
  }

  /// Getting the theme from shared preferences and setting the theme to the theme provider.
  /// If the theme is not set in the shared preferences, Function to toggle theme between light and dark
  getPreferences() async {
    _isDark = appStoragePref.getTheme();
    notifyListeners();
    if (_isDark == "") {
      ///Getting the system theme brightness (dark or light) from the MediaQuery object using the platformDispatcher property.
      /// The platformBrightness property returns a Brightness enum value that indicates whether the system theme is dark or light.
      /// The WidgetsBinding.instance.platformDispatcher.views.single property returns the single view that is associated with the
      /// current widget tree. The MediaQueryData.fromView method creates a MediaQueryData object from the given view. The
      /// MediaQueryData object contains information about the display, such as the size, pixel density, and brightness.
      /// The platformBrightness property of the MediaQueryData object returns the brightness of the display.
      if (MediaQueryData.fromView(
                  WidgetsBinding.instance.platformDispatcher.views.single)
              .platformBrightness ==
          Brightness.dark) {
        _isDark = "true";
        appStoragePref.setTheme("true");
      } else {
        _isDark = "false";
        appStoragePref.setTheme("false");
      }
    } else {
      _isDark = appStoragePref.getTheme();
      notifyListeners();
    }
  }
}
