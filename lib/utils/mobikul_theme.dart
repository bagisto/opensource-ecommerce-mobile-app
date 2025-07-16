/*
 * *
 *
 *  Webkul Software.
 *
 *  @package Mobikul App
 *
 *  @Category Mobikul
 *
 *  @author Webkul <support@webkul.com>
 *
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *
 *  @license https://store.webkul.com/license.html ASL Licence
 *
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobiKulTheme {
  static String? fontFamily = GoogleFonts.montserrat().fontFamily;
  static const Color primaryColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFF000000);

  // replace with client accent color
  static const Color skeletonLoaderColorLight = Color(0xFFE0E0E0);
  static const Color skeletonLoaderColorDark = Color(0xFF424242);
  static const Color appbarTextColor = Color(0xFF000000);
  static final Color linkColor = Colors.blue[900] as Color;
  static const Color transparentColor = Colors.transparent;
  static const Color errorColor = Color(0xFFE51A1A);
  static final Color warningColor = Colors.orange[700] as Color;
  static const MaterialColor greyColor = Colors.grey;
  static const Color _lightPrimaryColor = Colors.white24;
  static const Color _lightPrimaryVariantColor = Colors.white;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white24;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
      highlightColor: skeletonLoaderColorLight,
      scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBarTheme: AppBarTheme(
        elevation: 2,
        actionsIconTheme: const IconThemeData(
          color: MobiKulTheme.appbarTextColor,
        ),
        backgroundColor: primaryColor,
        shadowColor: const Color(0xFFBDBDBD),
        titleTextStyle: TextStyle(
          color: MobiKulTheme.appbarTextColor,
          fontSize: 16,
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: MobiKulTheme.appbarTextColor,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.black12, cursorColor: Colors.green),
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: primaryColor,
        secondaryContainer: _lightPrimaryVariantColor,
        onBackground: MobiKulTheme.accentColor,
        onPrimary: Colors.black,
      ),
      checkboxTheme: CheckboxThemeData(
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(color: accentColor)),
      ),
      iconTheme: const IconThemeData(
        color: _lightOnPrimaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _lightOnPrimaryColor),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontFamily),
        displayMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: fontFamily),
        displaySmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: fontFamily),
        headlineLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontFamily),
        headlineMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: fontFamily),
        headlineSmall: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: fontFamily),
        titleLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontFamily),
        titleMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: fontFamily),
        titleSmall: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: fontFamily),
        labelLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontFamily),
        labelMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: fontFamily),
        labelSmall: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: fontFamily),
        bodyLarge: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontFamily),
        bodyMedium: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: fontFamily),
        bodySmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: fontFamily),
      ),
      dividerTheme: const DividerThemeData(color: Colors.black12),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xFF2A65B3),
      ));

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryVariantColor,
      highlightColor: skeletonLoaderColorDark,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.bold),
      ),
      checkboxTheme: CheckboxThemeData(
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(color: _darkOnPrimaryColor)),
      ),
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: accentColor,
        secondaryContainer: _darkPrimaryVariantColor,
        onPrimary: Colors.white,
        onBackground: _darkOnPrimaryColor,
        background: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: _darkOnPrimaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _darkOnPrimaryColor),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily),
        displayMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: fontFamily),
        displaySmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: fontFamily),
        headlineLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily),
        headlineMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: fontFamily),
        headlineSmall: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: fontFamily),
        titleLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily),
        titleMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: fontFamily),
        titleSmall: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: fontFamily),
        labelLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily),
        labelMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: fontFamily),
        labelSmall: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: fontFamily),
        bodyLarge: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: fontFamily),
        bodyMedium: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: fontFamily),
        bodySmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: fontFamily),
      ),
      dividerTheme: const DividerThemeData(color: Colors.grey),
      bottomAppBarTheme: const BottomAppBarTheme(color: _darkOnPrimaryColor));

  getColor(double rating) {
    if (rating <= 1.0) {
      return const Color(0xFFE51A1A);
    } else if (rating <= 2) {
      return const Color(0xFFE91E63);
    } else if (rating <= 3) {
      return const Color(0xFFFFA100);
    } else if (rating <= 4) {
      return const Color(0xFFFFCC00);
    } else {
      return const Color(0xFF6BC700);
    }
  }
}
