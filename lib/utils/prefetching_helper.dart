
import 'package:flutter/material.dart';
import '../services/api_client.dart';


// pre-cache homepage data
Future preCacheCustomHomeData() async {
  try {
    await ApiClient().getThemeCustomizationData();
  } catch (error, stacktrace) {
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}

Future preCacheCMSData() async {
  try {
    await ApiClient().getCmsPagesData();
  } catch (error, stacktrace) {
    debugPrint("Error --> $error");
    debugPrint("StackTrace --> $stacktrace");
  }
}

