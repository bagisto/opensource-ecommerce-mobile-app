/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, constant_identifier_names
import 'package:flutter/material.dart';
class MobikulTheme {

  static Color primaryColor = const Color(0xFFFFFFFF);///this is basic color of app used for filling inside widgets where needed
  // static Color accentColor = const Color(0xFF0041FF);///this color will use for all the buttons,icon colors etc.
  // static Color accentColor = const Color(0xFF12225C);///this color will use for all the buttons,icon colors etc.
  // static Color accentColor = const Color(0xFF1433a3);///this color will use for all the buttons,icon colors etc.
  static Color accentColor =  Colors.black;///this color will use for all the buttons,icon colors etc.
  static Color checkOutInActiveColor =  Colors.grey.withAlpha(100);///this color will use for all the buttons,icon colors etc.

  // static Color appBarItemColor =  const Color(0xFF0041FF);///this is for all appbar icons
  // static Color appBarItemColor =  const Color(0xFF12225C);///this is for all appbar icons
  // static Color appBarItemColor =  const Color(0xFF1433a3);///this is for all appbar icons
  static Color appBarItemColor =   Colors.black;///this is for all appbar icons
  static Color appBarBackgroundColor = Colors.grey.shade400;///this is for app bar background color
  static Color notInStockLabelColor = Colors.red;///this color will use when item is not in stock
  static Color inStockLabelColor = Colors.green;///this color will use when item is  in stock
  static Color borderColor = const Color(0xFFD3D3D3);/// this is use for to give border color of widgets
  static Color quantityViewColor = const Color(0xFFD3D3D3);///this will use for quantity viewer
  static Color forgetPassword = Colors.blueAccent;///this will use for forget password button

  static ThemeData darkTheme = ThemeData(
    unselectedWidgetColor:Colors.grey.shade500 ,
     dividerColor: Colors.white ,
      dialogBackgroundColor: Colors.black ,
      scaffoldBackgroundColor: accentColor,
    fontFamily: 'Montserrat',
    iconTheme: const IconThemeData(color: Colors.white,),
    primaryColor: Colors.grey.shade900 ,
    cardColor: Colors.grey.shade900,
    textTheme:  TextTheme(
      headlineSmall: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white),
      titleLarge: const TextStyle(
          fontSize: 16.0, color: Colors.white, fontFamily: 'Montserrat',fontWeight: FontWeight.w600),
      bodyMedium: const TextStyle(
          fontSize: 14.0, color: Colors.white, fontFamily: 'Montserrat'),
        displayMedium:TextStyle(fontSize: 30,color: Colors.grey.shade500,fontWeight: FontWeight.bold)
    ),
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.grey.shade800,
        iconTheme: const IconThemeData(color: Colors.white,),
        shadowColor:Colors.grey.shade700,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor,onBackground: Colors.black,onPrimary: Colors.white,
        background: Colors.grey.shade800,primaryContainer:Colors.white, )
  );

///this is the basic theme of app. color and view of all the screens are based on this theme.
  static ThemeData mobikulTheme = ThemeData(
      cardColor: Colors.white,
      iconTheme:  IconThemeData(color: MobikulTheme.accentColor,),
    fontFamily: 'Montserrat',
    primaryColor: primaryColor,
    textTheme:  TextTheme(
      headlineSmall:  TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,

          color: accentColor),
      titleLarge:  TextStyle(
          fontSize: 16.0, color: accentColor, fontFamily: 'Montserrat',fontWeight: FontWeight.w600),
      bodyMedium:  TextStyle(
          fontSize: 14.0, color:accentColor, fontFamily: 'Montserrat'),
        displaySmall:TextStyle(fontSize: 30,color:Colors.grey.shade500,fontWeight: FontWeight.bold)
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor,onBackground: Colors.white,
        onPrimary: accentColor,background: accentColor,primaryContainer:Colors.black, ),
    appBarTheme:  AppBarTheme(
      backgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color:appBarItemColor),
      shadowColor:appBarBackgroundColor,
    )
  );

  ///this method will used to set the label color of reviews
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