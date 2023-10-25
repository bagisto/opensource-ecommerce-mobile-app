// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../configuration/app_sizes.dart';

class EmptyWishlist extends StatelessWidget {
  StreamController streamController = StreamController.broadcast();

  EmptyWishlist({Key? key, required this.streamController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    streamController.add(false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
            child: LottieBuilder.asset(
              "assets/lottie/empty_wish_list.json",
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            "EmptyWishList".localized(),
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.mediumFontSize,
            ),
          ),
          const SizedBox(
            height: AppSizes.widgetHeight,
          ),
          Text(
            "EmptyWishListNoItem".localized(),
            softWrap: true,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
