import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  late SharedPreferences _prefs;

  ThemeCubit({ThemeMode initialTheme = ThemeMode.light}) : super(initialTheme);

  /// Initialize SharedPreferences — call this before using the cubit
  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    
    // Load saved theme preference
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      if (savedTheme == 'dark') {
        emit(ThemeMode.dark);
      } else if (savedTheme == 'light') {
        emit(ThemeMode.light);
      }
    }
  }

  /// Toggle between light and dark theme, and save to SharedPreferences
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newTheme);
    await _saveTheme(newTheme);
  }

  /// Set light theme and save to SharedPreferences
  Future<void> setLight() async {
    emit(ThemeMode.light);
    await _saveTheme(ThemeMode.light);
  }

  /// Set dark theme and save to SharedPreferences
  Future<void> setDark() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveTheme(ThemeMode theme) async {
    final themeString = theme == ThemeMode.dark ? 'dark' : 'light';
    await _prefs.setString(_themeKey, themeString);
  }

  bool get isDark => state == ThemeMode.dark;
}
