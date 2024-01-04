/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class DownloadFile {
  var tag = "DownloadFile";
  String savePath = "";
  TargetPlatform? platform = TargetPlatform.android;
  String _localPath = "";
  AndroidDeviceInfo? android;

  Future downloadPersonalData(
      String url,
      String fileName,
      String fileType,
      BuildContext context,
      GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey) async {
    if (fileType.isNotEmpty) {
      try {
        Dio dio = Dio();
        if (Platform.isAndroid) {
          platform = TargetPlatform.android;
        } else {
          platform = TargetPlatform.iOS;
        }
        var status = await Permission.storage.status;
        DeviceInfoPlugin plugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          android = await plugin.androidInfo;
        }
        if (((android?.version.sdkInt ?? 30) < 33) || Platform.isIOS) {
          if (status.isGranted) {
            getDownload(dio, url, fileName, fileType, context);
          } else if (status.isDenied) {
            Permission.storage.request();
          }
        } else {
          getDownload(dio, url, fileName, fileType, context);
        }
      } catch (e) {
        debugPrint("${tag}exception while downloading invoice $e");
      }
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  void getDownload(
      Dio dio, String url, String fileName, String fileType, BuildContext context) async {
    await _prepareSaveDir();

    if(context.mounted) {
      ShowMessage.successNotification(StringConstants.downloading.localized(), context);
    }

    await dio.download(url, "$_localPath/$fileName",
        onReceiveProgress: (received, total) {
      if (total != -1) {
        double progress = (received / total) * 100;
        debugPrint('Rec: $received , Total: $total, $progress%');
      }
    });

    if(context.mounted) {
      ShowMessage.successNotification(StringConstants.downloadCompleted.localized(), context);
    }
  }

  Future saveBase64String(
    String stringUrl,
    String fileName,
  ) async {
    if (stringUrl.isNotEmpty) {
      try {
        if (Platform.isAndroid) {
          platform = TargetPlatform.android;
        } else {
          platform = TargetPlatform.iOS;
        }
        var status = await Permission.storage.status;
        DeviceInfoPlugin plugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          android = await plugin.androidInfo;
        }

        if (((android?.version.sdkInt ?? 30) < 33) || Platform.isIOS) {
          if (status.isGranted) {
            _createFileFromString(stringUrl, fileName);
          } else if (status.isDenied) {
            Permission.storage.request();
            debugPrint("$tag permission is denied ->requesting");
          }
        } else {
          _createFileFromString(stringUrl, fileName);
        }
      } catch (e) {
        debugPrint("$tag exception while downloading invoice $e");
      }
    }
  }

  Future<void> _createFileFromString(String stringUrl, String fileName) async {
    await _prepareSaveDir();
    String url = stringUrl.substring(22);
    Uint8List bytes = base64.decode(url);
    String dir = _localPath;
    File file = File("$dir/" + fileName);
    await file.writeAsBytes(bytes);
  }
}
