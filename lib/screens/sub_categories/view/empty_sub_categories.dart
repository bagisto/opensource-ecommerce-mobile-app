/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class EmptySubCategories extends StatelessWidget {
  const EmptySubCategories({Key? key}) : super(key: key);

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
              "assets/lottie/empty_catalog.json",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
           "EmptyPageGenericLabel".localized(),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
