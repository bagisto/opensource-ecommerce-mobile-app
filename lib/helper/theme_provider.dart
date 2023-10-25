

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';
import '../screens/cart_screen/view/cart_index.dart';


class ThemeProvider extends ChangeNotifier {
  late String _isDark;
  late final  appStoragePref;
  String get isDark => _isDark;

  ThemeProvider() {
    _isDark = "false";
    appStoragePref = SharedPreferenceHelper();
    getPreferences();
  }
//Switching the themes
  set isDark(String value) {
    _isDark = value;
    appStoragePref.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await appStoragePref.getTheme();
    notifyListeners();
    if (_isDark == "") {
      if (window.platformBrightness == Brightness.dark) {
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
