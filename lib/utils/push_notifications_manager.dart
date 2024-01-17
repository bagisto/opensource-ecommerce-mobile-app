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
  static PushNotificationsManager instance = PushNotificationsManager();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

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

  void setUpFirebase(BuildContext context) {
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload?.isNotEmpty ?? false) {
        debugPrint("payload$payload");
      }
    });
    _firebaseCloudMessagingListeners(context);
  }

  Future<StyleInformation?> getNotificationStyle(String? image) async {
    if ((image ?? "").isNotEmpty) {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(image!)).load("");
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

  subscribeToTopic() {
    if (Platform.isIOS) {
      _firebaseMessaging.subscribeToTopic("Bagisto_mobikul");
    } else {
      _firebaseMessaging.subscribeToTopic("Bagisto_mobikul");
    }
  }

  void _firebaseCloudMessagingListeners(BuildContext context) async {
    if (Platform.isIOS) _iosPermission();

    createFcmToken();
    subscribeToTopic();

    //When app is in Working state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      debugPrint('on message ${message.data}');
      debugPrint("onMessageNotification${message.notification?.body}");
      String title = notification?.title ?? "";
      String body = notification?.body ?? "";

      RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
      String parsedString = body.replaceAll(exp, ' ').trim();

      body = parsedString;

      String? imageUrl = "";
      if (Platform.isAndroid) {
        imageUrl = message.data['attachment'];
      } else {
        imageUrl = message.data['attachment'];
      }
      showNotification(title, body, json.encode(message.data), imageUrl);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("OnAppOpened}");
      debugPrint(message.data.toString());
    });
  }

  void checkInitialMessage(BuildContext context) {
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      debugPrint("open app data");
      debugPrint(message?.data.toString());
      if (message?.data != null) {}
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
