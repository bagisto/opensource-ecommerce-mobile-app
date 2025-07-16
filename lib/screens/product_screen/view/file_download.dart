/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'dart:io';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:bagisto_app_demo/utils/push_notifications_manager.dart';


class DownloadFile {
  String savePath = "";
  String _localPath = "";
  AndroidDeviceInfo? android;
  TargetPlatform? platform = TargetPlatform.android;

  Future downloadPersonalData(String url,
      String? fileNames,
      String fileType,
      BuildContext context,
      GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey) async {
    try {
      Dio dio = Dio();
      var status = await Permission.storage.status;
      if (status.isGranted) {
        String fileName = fileNames ?? "product";
        savePath = await getFilePath(fileName);

        await dio.download(url, savePath,
            onReceiveProgress: (received, total) async {
              int progress = ((received / total) * 100).toInt();
              if(progress%5 == 0 || progress < 20){
                PushNotificationsManager.instance.createDownloadNotification(100, progress,
                    fileName, Platform.isAndroid ? savePath : fileName);
              }
            });
      } else if (status.isDenied) {
        Permission.storage.request();
      }
    } catch (e) {
      debugPrint("exception while downloading $e");
    }
  }

  Future<String> getFilePath(fileName) async {
    String path = '';
    Directory? dir =  Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory();
    String sanitizedFileName = fileName.replaceAll(RegExp(r'[/\\]'), '_');
    path = '${dir?.path}/$sanitizedFileName';
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
          }
        } else {
          _createFileFromString(stringUrl, fileName);
        }
      } catch (e) {
        debugPrint(" exception while downloading invoice $e");
      }
    }
  }

  Future<void> _createFileFromString(String stringUrl, String fileName) async {
    _localPath = await getFilePath(fileName);
    Uint8List bytes = base64.decode(stringUrl);
    String dir = _localPath;
    File file = File(dir);
    if (!(await file.parent.exists())) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsBytes(bytes);
    PushNotificationsManager.instance.createDownloadNotification(100, 100,
        fileName, Platform.isAndroid ? _localPath : fileName);
  }


}
