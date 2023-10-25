/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'dart:async';
import 'dart:io';
import 'package:bagisto_app_demo/configuration/server_configuration.dart';
import 'package:bagisto_app_demo/screens/account/view/widget/account_index.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../api/graph_ql.dart';
import '../configuration/app_global_data.dart';
import '../helper/prefetching_helper.dart';
import '../routes/route_constants.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
  preCacheAdvertisements();
  preCacheBannerData();
  _navigateHomepage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LottieBuilder.asset("assets/lottie/splash_screen.json"),
      ),
    );
  }

  _navigateHomepage() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    Timer(const Duration(seconds: defaultSplashDelay), () {
      Navigator.pushReplacementNamed(context, Home);
    });
  }
}
