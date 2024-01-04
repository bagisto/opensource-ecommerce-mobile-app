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
import '../../../utils/app_constants.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/string_constants.dart';

//ignore: must_be_immutable
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
  late List<String>? titles = [
    StringConstants.addressCheckout.localized(),
    StringConstants.shipping.localized(),
    StringConstants.payment.localized(),
    StringConstants.checkout.localized(),
  ];
  List<IconData> stepIcons = [
    Icons.person,
    Icons.local_shipping,
    Icons.payment,
    Icons.add_shopping_cart_sharp
  ];
  final Color _activeColor = MobikulTheme.accentColor;
  final Color _inactiveColor = MobikulTheme.checkOutInActiveColor;
  final double lineWidth = AppSizes.spacingSmall;

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.curStep.toString());
    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
              const SizedBox(height: AppSizes.spacingWide),
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
      var circleColor =
          (i == 0 || widget.curStep > i) ? _activeColor : Colors.grey[400];

      var lineColor = widget.curStep > i + 1
          ? Theme.of(context).colorScheme.onPrimary
          : _inactiveColor;

      var iconColor =
          (i == 0 || widget.curStep > i) ? Colors.white : Colors.white;

      list.add(InkWell(
        child: Container(
          width: AppSizes.spacingLarge*2,
          height: AppSizes.spacingLarge*2,
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
    titles?.asMap().forEach((i, text) {
      list.add(Text(text, style: Theme.of(context).textTheme.bodyLarge));
    });
    return list;
  }
}
