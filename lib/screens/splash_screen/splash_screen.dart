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
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/graph_ql.dart';
import '../../utils/assets_constants.dart';
import '../../utils/prefetching_helper.dart';
import '../../utils/route_constants.dart';
import '../../utils/server_configuration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // preCacheCustomHomeData();
    // preCacheCMSData();
    _navigateHomepage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
        LottieBuilder.asset(AssetConstants.splashLottie),
        // Stack(
        //   children: [
        //     SizedBox(
        //       width: AppSizes.screenWidth.toDouble(),
        //       height: AppSizes.screenHeight.toDouble(),
        //       child: Image.asset(AssetConstants.splashImage,
        //         fit: BoxFit.fill,
        //       ),
        //     ),
        //     Positioned(
        //       bottom: AppSizes.screenHeight * 0.1,
        //       left: 0,
        //       right: 0,
        //       child: const Loader(),
        //     )
        //   ],
        // ),
      ),
    );
  }

  _navigateHomepage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    Timer(const Duration(seconds: defaultSplashDelay), () {
      Navigator.pushReplacementNamed(context, home);
    });
  }
}

