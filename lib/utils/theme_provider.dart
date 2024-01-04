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

  getPreferences() async {
    _isDark = await appStoragePref.getTheme();
    notifyListeners();
    if (_isDark == "") {
      if (MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single).platformBrightness == Brightness.dark) {
        _isDark = "true";
        appStoragePref.setTheme("true");
      } else {
        _isDark = "false";
        appStoragePref.setTheme("false");
      }
    } else {
      _isDark = await appStoragePref.getTheme();
      notifyListeners();
    }
  }
}
