/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

class CheckoutHeaderView extends StatefulWidget {
  final String? total;
  final int curStep;
  final ValueChanged<int>? didSelect;
  final BuildContext? context;
  final bool isDownloadable;
  const CheckoutHeaderView(
      {Key? key,
      this.curStep = 1,
      this.didSelect,
      this.total,
      this.context,
      this.isDownloadable = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CheckoutHeaderViewState();
  }
}

class _CheckoutHeaderViewState extends State<CheckoutHeaderView> {
  late List<String>? titles;
  late List<IconData> stepIcons;
  final Color _activeColor = MobiKulTheme.accentColor;
  final Color _inactiveColor = Colors.grey.shade400;
  final double lineWidth = AppSizes.spacingSmall;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stepIcons = widget.isDownloadable
        ? [
            Icons.person,
            // Icons.local_shipping,
            Icons.payment,
            Icons.add_shopping_cart_sharp
          ]
        : [
            Icons.person,
            Icons.local_shipping,
            Icons.payment,
            Icons.add_shopping_cart_sharp
          ];

    titles = widget.isDownloadable
        ? [
            StringConstants.addressCheckout.localized(),
            // StringConstants.shipping.localized(),
            StringConstants.payment.localized(),
            StringConstants.checkout.localized()
          ]
        : [
            StringConstants.addressCheckout.localized(),
            StringConstants.shipping.localized(),
            StringConstants.payment.localized(),
            StringConstants.checkout.localized()
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(
          0, AppSizes.spacingSmall, 0, AppSizes.spacingSmall),
      child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingNormal,
              horizontal: AppSizes.spacingMedium),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingSmall),
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
          ? Theme.of(context).colorScheme.onBackground
          : _inactiveColor;

      var iconColor =
          (i == 0 || widget.curStep > i) ? Colors.white : Colors.white;

      list.add(InkWell(
        child: Container(
          width: AppSizes.spacingLarge * 2,
          height: AppSizes.spacingLarge * 2,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(
                Radius.circular(AppSizes.spacingMedium * 2)),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: AppSizes.spacingLarge,
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
