
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/string_constants.dart';

Widget viewAllButton(BuildContext context,
    {double height = AppSizes.spacingWide*2, Function? callback,
      Color? backGroundColor, Color? foregroundColor}) {
  return OutlinedButton(
      onPressed: () {
        if (callback != null) {
          callback();
        }
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color?>(
              backGroundColor
          ),
          foregroundColor: WidgetStateProperty.all<Color?>(
              foregroundColor
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingNormal,
                  horizontal: AppSizes.spacingNormal*2)),
          side: WidgetStateProperty.all(const BorderSide(
            color: MobiKulTheme.accentColor,
          )),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.spacingNormal),
          ))),
      child: Text(StringConstants.viewAllLabel.localized(),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w500, color: foregroundColor)));
}
