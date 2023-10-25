/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';


class ShowMessage{

 static getMessage( String? message,
     final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey){
  return scaffoldMessengerKey?.currentState?.showSnackBar(SnackBar(
    content: Text(message??""),
    duration: const Duration(seconds: 2),
  ));
}

static showNotification( String? title,String? message,Color? color,Icon icon){
   return  showSimpleNotification(Text(title!,style: const TextStyle(fontSize: 16.0,
       fontWeight: FontWeight.bold,color: Colors.white),),
       background: color,
       leading: icon,
       slideDismissDirection: DismissDirection.up,
       subtitle: Text(message??"",style: const TextStyle(color: Colors.white),));
}
  }

