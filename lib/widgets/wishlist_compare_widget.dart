/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/assets_constants.dart';

Widget wishlistIcon(BuildContext context, bool? isInWishlist){
  return Container(
    padding: const EdgeInsets.all(AppSizes.spacingNormal),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme.onBackground,
      borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.spacingSmall)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child:
    isInWishlist ??
        false
        ? Icon(
      Icons.favorite,
      color: Theme.of(context)
          .colorScheme
          .secondaryContainer,
      size: 16,
    )
        : Icon(
      Icons.favorite_border,
      size: 16,
      color: Theme.of(context)
          .colorScheme
          .secondaryContainer,
    ),
  );
}

Widget compareIcon(BuildContext context){
  return Container(
    padding: const EdgeInsets.all(AppSizes.spacingNormal),
    margin: const EdgeInsets.only(top: AppSizes.spacingNormal),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .onBackground,
      borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.spacingSmall)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Image.asset(AssetConstants.compareIcon,
      height: 18,
      width: 18,
      color: Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}