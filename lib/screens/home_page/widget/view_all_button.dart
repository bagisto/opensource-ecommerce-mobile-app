
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
  return Column(
    children: [
      SizedBox(
        height: height,
      ),
      OutlinedButton(
          onPressed: () {
            if (callback != null) {
              callback();
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color?>(
                  backGroundColor
              ),
              foregroundColor: MaterialStateProperty.all<Color?>(
                  foregroundColor
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                      vertical: AppSizes.spacingLarge,
                      horizontal: AppSizes.spacingLarge*2)),
              side: MaterialStateProperty.all(const BorderSide(
                color: MobiKulTheme.accentColor,
              )),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacingLarge),
              ))),
          child: Text(StringConstants.viewAllLabel.localized(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500, color: foregroundColor))),
    ],
  );
}
