/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobikulTheme {
  static String? fontFamily = GoogleFonts.montserrat().fontFamily;
  static Color primaryColor = Colors.white;
  static Color accentColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black
        ),
        backgroundColor: primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          )
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color?>(
            primaryColor),
        fillColor: MaterialStateProperty.all<Color?>(
            accentColor)
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: accentColor,
        background: primaryColor,
        onBackground: accentColor
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
      ),
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
      expansionTileTheme: ExpansionTileThemeData(
          iconColor: accentColor,
          textColor: accentColor
      ),
      bottomSheetTheme: BottomSheetThemeData(
          surfaceTintColor: primaryColor,
      ));

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white
        ),
        backgroundColor: accentColor,
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      )
    ),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white
    ),
      drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black
      ),
      colorScheme: ColorScheme.dark(
          primary: accentColor,
          onPrimary: primaryColor,
          background: accentColor,
          onBackground: primaryColor
      ),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color?>(
            accentColor),
        fillColor: MaterialStateProperty.all<Color?>(
            primaryColor)
    ),
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
  );

  // App Colors
  static Color offerBackgroundLightBlue = const Color.fromRGBO(59, 130, 246, 0.2);
  static Color darkBtnBackground = const Color.fromRGBO(6, 12, 59, 1);
  static Color saleRedColor = Colors.red;
  static Color bodyTextDarkColor = const Color(0xFF6e6e6e);
  static Color appBarBackgroundColor = Colors.grey.shade400;
  static Color checkOutInActiveColor = Colors.grey.withAlpha(100);

}
