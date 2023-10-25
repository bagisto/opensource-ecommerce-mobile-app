/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotificationsManager {
  // static final PushNotificationsManager _instance = PushNotificationsManager._internal();

  static PushNotificationsManager instance = PushNotificationsManager();

  // factory PushNotificationsManager() {
  //   return _instance;
  // }

  // PushNotificationsManager._internal() {
  //   tz.initializeTimeZones();
  // }


  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  // static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static const initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  static const initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings =
  const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

 /* setupNotification({required int seconds, required int id, required String title, required String body}) async{
    final String? timeZoneName =  await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add( Duration(seconds: seconds)),
         NotificationDetails(
            android: AndroidNotificationDetails(
                id.toString(), title,
                channelDescription: body)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
*/

  void setUpFirebase(BuildContext context) {
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload?.isNotEmpty ?? false) {
            debugPrint("payload$payload");
            // Map notificationModelMap = json.decode(payload.toString());
            // if (notificationModelMap['type'] ==
            //     AppConstant.productTypeNotification) {
            //   Navigator.pushNamed(navigatorKey.currentContext!, productPage,
            //       arguments: getProductDataMap(
            //           notificationModelMap['name'], notificationModelMap['id']));
            // } else if (notificationModelMap['type'] ==
            //     AppConstant.categoryTypeNotification) {
            //   Navigator.pushNamed(navigatorKey.currentContext!, catalogPage,
            //       arguments: getCatalogMap(
            //         "",
            //         false,
            //         notificationModelMap['name'],
            //         customerId: int.parse(notificationModelMap['id']),
            //       ));
            // } else if (notificationModelMap['type'] ==
            //     AppConstant.customTypeNotification) {
            //   Navigator.pushNamed(navigatorKey.currentContext!, catalogPage,
            //       arguments: getCatalogMap("", false, "Catalog",
            //           fromNotification: true,
            //           domain: notificationModelMap['domain']));
            // }
          }
        });
    _firebaseCloudMessagingListeners(context);
  }

  Future<StyleInformation?> getNotificationStyle(String? image) async {
    if (image != null) {
      final ByteData imageData =
      await NetworkAssetBundle(Uri.parse(image)).load("");
      return BigPictureStyleInformation(
          ByteArrayAndroidBitmap(imageData.buffer.asUint8List()));
    } else {
      return null;
    }
  }

  void showNotification(
      String title, String body, String? payload, String? image) async {
    var notificationStyle = await getNotificationStyle(image);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '${Random().nextDouble()}', 'Bagisto Notification',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        styleInformation: notificationStyle);

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  Future<String?> createFcmToken() async {
    debugPrint("token---->${await _firebaseMessaging.getToken()}");
    return await _firebaseMessaging.getToken();
  }
  subscribeToTopic(){
    if(Platform.isIOS) {
      _firebaseMessaging.subscribeToTopic("Bagisto-iOS");
    }else{
      _firebaseMessaging.subscribeToTopic("Bagisto-Android");
    }
  }

  void _firebaseCloudMessagingListeners(BuildContext context) async {
    if (Platform.isIOS) _iosPermission();

    createFcmToken();
    subscribeToTopic();


      if (Platform.isIOS) {
      //   IosDeviceIn iosInfo = await deviceInfo.iosInfo;
      //   print("deviceId${iosInfo.identifierForVendor}");
      //   AppSharedPref().setDeviceID(iosInfo.identifierForVendor.toString());
      // } else {
      //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //   print("deviceId${androidInfo.androidId}");
      //   AppSharedPref().setDeviceID(androidInfo.androidId.toString());
    }




    //When app is in Working state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      //message.data["orderId"]
      //messagew.data["orderStatus"]
      debugPrint('on message ${message.data}');
      debugPrint("onMessageNotification${message.notification?.body}");
      String? title = notification?.title;
      String? body = notification?.body;
      String? imageUrl = "";
      if (Platform.isAndroid) {
        imageUrl =  message.data['attachment'];
      } else {
        imageUrl = message.data['attachment'];
      }
      showNotification(title!, body!, json.encode(message.data), imageUrl);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("OnAppOpened}");
      debugPrint(message.data.toString());
      // if (message.data['type'] == "product") {
      //   print("product");
      //   Navigator.pushNamed(navigatorKey.currentContext!, productPage,
      //       arguments:
      //           getProductDataMap(message.data['name'], message.data['id']));
      // } else if (message.data['type'] == "category") {
      //   Navigator.pushNamed(navigatorKey.currentContext!, catalogPage,
      //       arguments: getCatalogMap(
      //         "",
      //         false,
      //         message.data['name'],
      //         customerId: int.parse(message.data['id']),
      //       ));
      // } else if (message.data['type'] == AppConstant.customTypeNotification) {
      //   Navigator.pushNamed(navigatorKey.currentContext!, catalogPage,
      //       arguments: getCatalogMap(
      //           "", false, message.notification?.title ?? "",
      //           fromNotification: true, domain: message.data['domain']));
      // }
    });
  }

  void checkInitialMessage(BuildContext context) {
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      debugPrint("open app data");
      debugPrint(message?.data.toString());
      if (message?.data != null) {
        // if (message?.data['type'] == "product") {
        //   Navigator.pushNamed(context, productPage,
        //       arguments: getProductDataMap(
        //           message?.data['name'], message?.data['id']));
        // } else if (message?.data['type'] == "category") {
        //   Navigator.pushNamed(context, catalogPage,
        //       arguments: getCatalogMap(
        //         "",
        //         false,
        //         message?.data['name'],
        //         customerId: int.parse(message?.data['id']),
        //       ));
        // } else if (message?.data['type'] ==
        //     AppConstant.customTypeNotification) {
        //   Navigator.pushNamed(navigatorKey.currentContext!, catalogPage,
        //       arguments: getCatalogMap(
        //           "", false, message?.notification?.title ?? "",
        //           fromNotification: true, domain: message?.data['domain']));
        // }
      }
    });
  }

  void _iosPermission() {
    _firebaseMessaging
        .requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    )
        .then((value) {
      debugPrint("Settings registered: $value");
    });
  }
}
