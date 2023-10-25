/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class EmptyReviews extends StatelessWidget {
  const EmptyReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter:  ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
            child: LottieBuilder.asset(
              "assets/lottie/empty_review_list.json",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
          "noReview".localized(),
            softWrap: true,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
