/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_global_data.dart';
import '../utils/badge_helper.dart';
import '../utils/shared_preference_helper.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final int? index;
  const CommonAppBar(this.title, {Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.spacingLarge),
      ),
      actions: [
        IconButton(
            onPressed: () {
              if(index != 0){
                Navigator.pushNamed(context, searchScreen);
              }
            },
            icon: const Icon(
              Icons.search,
            )),
        IconButton(
            onPressed: () {
              if(index != 1){
                Navigator.pushNamed(context, compareScreen);
              }
            },
            icon: const Icon(
              Icons.compare_arrows,
            )),
        StreamBuilder(
          stream: GlobalData.cartCountController.stream,
          builder: (BuildContext context, snapshot) {
            int count = snapshot.data ?? 0;

            appStoragePref.setCartCount(count);
            return BadgeIcon(
              badgeCount: count,
              icon: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  if(index != 2){
                    Navigator.pushNamed(context, cartScreen);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
