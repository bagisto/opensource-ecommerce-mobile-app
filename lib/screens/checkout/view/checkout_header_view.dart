/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, unnecessary_null_comparison

import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../configuration/app_sizes.dart';

class CheckoutHeaderView extends StatefulWidget {
  String? total;
  int curStep;
  ValueChanged<int>? didSelect;
  BuildContext? context;

  CheckoutHeaderView(
      {Key? key, this.curStep = 1, this.didSelect, this.total, this.context})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckoutHeaderViewState();
  }
}

class _CheckoutHeaderViewState extends State<CheckoutHeaderView> {
  late List<String> titles = [
    "AddressCheckout".localized(),
    "Shipping".localized(),
    "Payment".localized(),
    "Checkout".localized(),
  ];
  List<IconData> stepIcons = [
    Icons.person,
    Icons.local_shipping,
    Icons.payment,
    Icons.add_shopping_cart_sharp
  ];
  final Color _activeColor = MobikulTheme.accentColor;
  final Color _inactiveColor = MobikulTheme.checkOutInActiveColor;
  final double lineWidth = NormalWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.curStep.toString());
    return Card(
      elevation: 2,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _iconViews(),
                ),
              ),
              const SizedBox(height: AppSizes.normalHeight),
              if (titles != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _titleViews(),
                ),
            ],
          )),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    stepIcons.asMap().forEach((i, icon) {
      //colors according to state
      var circleColor =
          (i == 0 || widget.curStep > i) ? _activeColor : Colors.grey[400];

      var lineColor = widget.curStep > i + 1
          ? Theme.of(context).colorScheme.onPrimary
          : _inactiveColor;

      var iconColor =
          (i == 0 || widget.curStep > i) ? Colors.white : Colors.white;

      list.add(InkWell(
        child: Container(
          width: 30.0,
          height: 30.0,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 15.0,
          ),
        ),
      ));

      //line between icons
      if (i != stepIcons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(Text(text, style: const TextStyle(fontWeight: FontWeight.w700)));
    });
    return list;
  }
}
