/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, unnecessary_new

import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon(
      {Key? key,
        this.icon,
        this.height=15,
        this.width=15,
        this.badgeCount = 0,
        this.showIfZero = false,
        this.badgeColor = Colors.red,
        TextStyle? badgeTextStyle})
      : badgeTextStyle = badgeTextStyle ??
      const TextStyle(
        color: Colors.white,
        fontSize: 8,
      ),
        super(key: key);
  final Widget? icon;
  final int badgeCount;
  final double  height;
  final double  width;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon!,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
    right: 10,
    top: 6,
    child: new Container(
      padding: const EdgeInsets.all(1),
      decoration: new BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8.5),
      ),
      constraints:  BoxConstraints(
        minWidth: width,
        minHeight: height,
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
