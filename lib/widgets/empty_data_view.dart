/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/app_constants.dart';
import '../utils/assets_constants.dart';
import '../utils/string_constants.dart';

class EmptyDataView extends StatelessWidget {
  final String assetPath;
  final String message;
  final double height;
  final double width;
  final bool showDescription;
  final String description;
  const EmptyDataView({Key? key, this.assetPath = AssetConstants.emptyOrders,
  this.message = StringConstants.emptyPageGenericLabel, this.height=200, this.width=200, this.showDescription=false,
  this.description = StringConstants.emptyCartPageMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onBackground,
              BlendMode.srcIn,
            ),
            child: LottieBuilder.asset(assetPath,
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),
          ),
          if(showDescription==false) const SizedBox(
            height: AppSizes.spacingWide,
          ),
          Text(
            message.localized(),
            softWrap: true,
          ),
          if(showDescription) const SizedBox(
            height: 20,
          ),
          if(showDescription) Text(
            description.localized(),
            softWrap: true,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}