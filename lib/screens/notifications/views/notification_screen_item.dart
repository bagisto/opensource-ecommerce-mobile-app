
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/models/notification_model/notification_model.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/image_view.dart';
import '../../../configuration/app_global_data.dart';
import 'package:collection/collection.dart';

class NotificationScreenItem extends StatelessWidget {
   const NotificationScreenItem({Key? key, required this.notification,}) : super(key: key);

  final Data? notification;

  @override
  Widget build(BuildContext context) {
    var translations=  notification?.translations?.firstWhereOrNull((e) => e.locale==GlobalData.locale);

    return Column(
    children: [
      SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ImageView(url: notification?.imageUrl,width: 100,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(translations?.title ?? notification?.translations?[0].title ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                      // style: Theme.of(context).textTheme.headline3,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    Text(translations?.content.toString() ?? notification?.translations?[0].content ?? "",
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
     const Divider()
    ],
    );
  }
}