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
import 'package:bagisto_app_demo/utils/server_configuration.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';



class DownloadFile {
  var tag = "DownloadInvoice ";
  String savePath = "";
  String _localPath = "";
  AndroidDeviceInfo? android;
  TargetPlatform? platform = TargetPlatform.android;

  Future downloadPersonalData(String url,
      String fileNames,
      String fileType,
      BuildContext context,
      GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey) async {
    try {
      Dio dio = Dio();
      var status = await Permission.storage.status;
      if (status.isGranted) {
        debugPrint("${tag}permission is granted");
        String fileName = fileNames ?? "product";
        savePath = await getFilePath(fileName);

        ShowMessage.successNotification(StringConstants.downloading.localized(), context);

        await dio.download(url, savePath,
            onReceiveProgress: (received, total) {
              debugPrint("$tag Download started received$received total $total");
            });
        const platform = MethodChannel(defaultChannelName);
        try {
          if (Platform.isAndroid) {
            await platform.invokeMethod('fileviewer', savePath);
          } else {
            await platform.invokeMethod('fileviewer', fileName);
          }
        } on PlatformException catch (e) {
          debugPrint("Failed ${e.toString()}");
        }

        ShowMessage.successNotification(StringConstants.downloadCompleted.localized(), context);

      } else if (status.isDenied) {
        Permission.storage.request();
        debugPrint("${tag}permission is denied ->requesting");
      }
    } catch (e) {
      debugPrint("${tag}exception while downloading $e");
    }
  }


  Future<String> getFilePath(fileName) async {
    String path = '';
    Directory? dir =  Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory();
    path = '${dir?.path}/$fileName';
    return path;
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
    _localPath = await getFilePath(fileName);
    String url = stringUrl.substring(23);
    Uint8List bytes = base64.decode(url);
    String dir = _localPath;
    File file = File("$dir/$fileName");
    await file.writeAsBytes(bytes);
  }

}
