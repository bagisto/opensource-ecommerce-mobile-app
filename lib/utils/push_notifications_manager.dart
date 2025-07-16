/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';
import 'package:bagisto_app_demo/utils/server_configuration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsManager {
  static PushNotificationsManager instance = PushNotificationsManager();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  static const initializationSettingsIOS = DarwinInitializationSettings(
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
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      final String? payload = response.payload;
      if ((payload ?? "").isNotEmpty) {
        Map<String, dynamic> payloadData = jsonDecode(payload ?? "");
        if (payloadData["type"] == "openFile") {
          openFile(payloadData["path"].toString());
        }
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

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
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
    String token = await _firebaseMessaging.getToken() ?? "";
    GlobalData.fcmToken = token;
    return token;
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
      String title = notification?.title ?? "";
      String body = notification?.body ?? "";

      RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
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
    });
  }

  void createDownloadNotification(
      int total, int progress, String name, String path) async {
    await Future<void>.delayed(const Duration(milliseconds: 0), () async {
      var androidPlatformChannel = AndroidNotificationDetails(
          'progress channel', 'Bagisto Notification',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: progress < total ? true : false,
          maxProgress: total,
          progress: progress);

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannel);
      await flutterLocalNotificationsPlugin.show(
          1,
          name,
          total == progress
              ? StringConstants.completed.localized()
              : StringConstants.started.localized(),
          platformChannelSpecifics,
          payload: jsonEncode({"type": "openFile", "path": path}));
    });
  }

  Future<void> openFile(String fileName) async {
    const platform = MethodChannel(defaultChannelName);
    try {
      if (Platform.isAndroid) {
        await platform.invokeMethod('fileviewer', fileName);
      } else {
        await platform.invokeMethod('fileviewer', fileName);
      }
    } on PlatformException catch (e) {
      debugPrint("Failed ${e.toString()}");
    }
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

    });
  }
}
