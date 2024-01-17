/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/product_screen/view/quantity_view.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import '../../../utils/check_box_group.dart';
import '../../../utils/radio_button_group.dart';
import '../../home_page/data_model/new_product_data.dart';
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class BundleOptionsView extends StatefulWidget {
  Function(List)? callBack;
  List<BundleOptions>? options = [];

  BundleOptionsView({Key? key, this.options, this.callBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BundleOptionsViewState();
  }
}

class _BundleOptionsViewState extends State<BundleOptionsView> {
  List newData = [];
  String? currentId;
  var bundleData = <dynamic, dynamic>{};
  List<BundleData> qtyArray = [];
  double totalAmount = 0.0;
  double radioTotal = 0.0;
  double dropDownTotal = 0.0;


  @override
  Widget build(BuildContext context) {

    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.customizeOptions.localized(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.options?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = widget.options?[index];
                  switch (item?.type ?? '') {
                    case StringConstants.select:
                      return _getTextField(item);
                    case StringConstants.radioText:
                      return _getRadioButtonType(item);
                    case StringConstants.checkBoxText:
                      return _getCheckBoxType(item);
                    case StringConstants.multiSelect:
                      return _getCheckBoxType(item);
                    default:
                      break;
                  }
                  return const SizedBox();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(StringConstants.totalAmount.localized(), style: Theme.of(context).textTheme.bodyMedium),
                Text("${GlobalData.currencySymbol}$totalAmount", style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            ...getWidgets(),
          ],
        ));
  }

  Widget _getRadioButtonType(BundleOptions? option) {
    return Container(
        // color: Colors.white,
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingLarge,
            AppSizes.spacingNormal,
            AppSizes.spacingLarge,
            AppSizes.spacingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option?.translations?.map((e) => e.label ?? '').toString() ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: AppSizes.spacingSmall,
            ),
            RadioButtonGroup(
              key: Key(option?.id?.toString() ?? ''),
              labels: option?.bundleOptionProducts
                  ?.map((e) => "${e.product?.sku} + ${e.product?.priceHtml?.formattedFinalPrice}")
                  .toList(),
              onChange: (label, index) {
                if ((option?.bundleOptionProducts?.length ?? 0) > index) {
                  totalAmount = totalAmount - radioTotal;

                  var product = option?.bundleOptionProducts?[index];
                  double selectedAmount = ((product?.qty ?? 1)*double.parse(product?.product?.priceHtml?.finalPrice ?? "0"));
                  radioTotal = selectedAmount;

                  totalAmount = totalAmount + selectedAmount;

                  _updateQtyValue(int.parse(option?.id ?? ''),
                      option?.bundleOptionProducts?[index].qty ?? 0);
                  _updateOptions(
                      int.parse(option?.id ?? ''),
                      int.parse(option?.bundleOptionProducts?[index].id ?? ''),
                      -1,
                      true);
                }
              },
            ),
            QuantityView(
                qty: (bundleData['bundleOptionQuantity']
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        ?.toString() ??
                    '0',
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ''), qty);
                })
          ],
        ));
  }

  Widget _getCheckBoxType(BundleOptions? option) {
    var val = option?.bundleOptionProducts
        ?.map((e) =>
            "${e.product?.sku} + ${e.product?.priceHtml?.formattedFinalPrice}")
        .toList();
    return (widget.options?.length ?? 0) > 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  ApplicationLocalizations.of(context)?.translate(option
                              ?.translations
                              ?.map((e) => e.label)
                              .toString() ??
                          '') ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxGroup(
                  activeColor: Theme.of(context).colorScheme.onBackground,
                  checkColor: Theme.of(context).colorScheme.background,
                  labels: val?.toList(),
                  onChange: (isChecked, label, index, key) {

                    var product = option?.bundleOptionProducts?[index];

                    setState(() {
                      if (isChecked) {
                        _updateQtyValue(int.parse(option?.id ?? '0'),
                            product?.qty?.toString() ?? '1');
                        _updateOptions(int.parse(option?.id ?? '0'),
                            int.parse(product?.id ?? '1'), -1, false);
                        totalAmount = totalAmount + ((product?.qty ?? 1)*double.parse(product?.product?.priceHtml?.finalPrice ?? "0"));
                      } else {
                        _updateOptions(int.parse(option?.id ?? ''), -1,
                            int.parse(product?.id ?? '1'), false);
                        totalAmount = totalAmount - ((product?.qty ?? 1)*double.parse(product?.product?.priceHtml?.finalPrice ?? "0"));
                      }
                    });
                  },
                ),
              ])
        : const SizedBox.shrink();
  }

  Widget _getTextField(BundleOptions? option) {
    return Container(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingNormal,
            AppSizes.spacingNormal,
            AppSizes.spacingNormal,
            AppSizes.spacingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CommonWidgets().getDropdown(
                  Key(option?.id?.toString() ?? ''),
                  context,
                  option?.bundleOptionProducts
                          ?.map((e) => "${e.product?.sku} + ${e.product?.priceHtml?.formattedFinalPrice}")
                          .toList() ??
                      [],
                  option?.translations?.map((e) => e.label).toString(),
                  null,
                  null,
                  option?.translations?.map((e) => e.label).toString(),
                  (label, key) {

                    totalAmount = totalAmount - dropDownTotal;

                    var product = option?.bundleOptionProducts?.firstWhereOrNull((element) => label.contains(element.product?.sku ?? ""));
                    double selectedAmount = ((product?.qty ?? 1)*double.parse(product?.product?.priceHtml?.finalPrice ?? "0"));
                    dropDownTotal = selectedAmount;

                    totalAmount = totalAmount + selectedAmount;

                _updateQtyValue(int.parse(option?.id ?? ''),
                    product?.qty?.toString() ?? '1');
                _updateOptions(int.parse(option?.id ?? ''),
                    int.parse(product?.id ?? '1'), -1, true);
              }, false),
            ),
            QuantityView(
                qty: (bundleData['bundleOptionQuantity']
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        .toString() ??
                    '1',
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ''), qty);
                })
          ],
        ));
  }

  _updateOptions(int id, int productId, int removeId, bool isReplace) {

    if (bundleData['bundleOptions'] != null) {
      if (bundleData['bundleOptions'][id.toString()] != null) {
        if (removeId != -1) {}
        (bundleData['bundleOptions']?[id.toString()] as List<dynamic>)
            .remove(removeId);

        if (productId != -1) {
          if (isReplace) {
            bundleData['bundleOptions'][id.toString()] = [productId];
          } else {
            (bundleData['bundleOptions'][id.toString()] as List<dynamic>)
                .add(productId);
          }
        }
      } else {
        bundleData['bundleOptions'][id.toString()] = [productId];
      }
    } else {
      bundleData['bundleOptions'] = {
        id.toString(): [productId]
      };
    }

    Map<String, List<int>>? map = bundleData["bundleOptions"];

    int i = 0;
    qtyArray.clear();
    newData.clear();

    map?.forEach((key, value) {
      if(value.isNotEmpty){
        qtyArray.add(BundleData(
            bundleOptionId: key,
            bundleOptionProductId: [...value.map((el) => el.toString())]));

        newData.add(qtyArray[i].toJson());
        i++;
      }
    });

    if (widget.callBack != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.callBack!(newData);
      });
    }
  }

  _updateQtyValue(int id, dynamic qty) {
    if (bundleData['bundleOptionQuantity'] != null) {
      (bundleData['bundleOptionQuantity']
          as Map<String, dynamic>?)?[id.toString()] = qty;
    } else {
      bundleData['bundleOptionQuantity'] = {id.toString(): qty};
    }
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = [];

    widget.options?.forEach((e) {
      widgets.add(Text(
        ApplicationLocalizations.of(context)?.translate(e
            .translations
            ?.map((e) => e.label)
            .toString() ??
            '') ??
            '',
        style: Theme.of(context).textTheme.bodyMedium,
      ));

      BundleOptions? val = widget.options?.firstWhereOrNull((option) => option.id == e.id);
      List<int>? list = bundleData["bundleOptions"]?[e.id.toString()];
      list?.forEach((element) {
        BundleOptionProducts? temp = val?.bundleOptionProducts?.firstWhereOrNull((product) => product.id == element.toString());
        widgets.add(Text("${temp?.qty ?? 1} x ${temp?.product?.name}"));
      });
    });

    return widgets;
  }
}

class BundleData {
  String? bundleOptionId;
  List<String>? bundleOptionProductId;

  BundleData({this.bundleOptionId, this.bundleOptionProductId});

  factory BundleData.fromJson(Map<String, dynamic> json) => BundleData(
        bundleOptionId: json['bundleOptionId'],
        bundleOptionProductId: json['bundleOptionProductId'].toList(),
      );

  Map<String, dynamic> toJson() => {
        'bundleOptionId': bundleOptionId,
        'bundleOptionProductId': bundleOptionProductId
      };
}
