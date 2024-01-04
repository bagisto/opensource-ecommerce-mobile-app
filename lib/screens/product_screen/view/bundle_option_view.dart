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
import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:flutter/material.dart';
import '../../../utils/application_localization.dart';
import '../../../utils/check_box_group.dart';
import '../../../utils/radio_button_group.dart';
import '../../../widgets/common_widgets.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBundleData();
    });
    super.initState();
  }

  getBundleData() {
    List<BundleData> qtyArray = [];
    for (int i = 0; i < (widget.options?.length ?? 0); i++) {
      for (int j = 0;
          j < (widget.options?[i].bundleOptionProducts?.length ?? 0);
          j++) {
        List<String> vals = [];
        vals.add(
            (widget.options?[i].bundleOptionProducts?[j].id ?? "").toString());
        qtyArray.add(BundleData(
            bundleOptionId: widget
                .options?[i].bundleOptionProducts?[j].productBundleOptionId
                .toString(),
            bundleOptionProductId: vals.toList()));
        newData.add(qtyArray[i].toJson());
      }
    }
    if (widget.callBack != null) {
      widget.callBack!(newData);
    }
  }

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
                  return Container();
                })
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
              option?.translations?.map((e) => e.label ?? "").toString() ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: AppSizes.spacingSmall,
            ),
            RadioButtonGroup(
              key: Key(option?.id?.toString() ?? ''),
              labels: option?.bundleOptionProducts
                  ?.map((e) => e.product?.productFlats?[0].name ?? "")
                  .toList(),
              onChange: (label, index) {
                if ((option?.bundleOptionProducts?.length ?? 0) > index) {
                  _updateQtyValue(int.parse(option?.id ?? ""),
                      option?.bundleOptionProducts?[index].qty ?? 0);
                  _updateOptions(
                      int.parse(option?.id ?? ""),
                      int.parse(option?.bundleOptionProducts?[index].id ?? ""),
                      -1,
                      true);
                }
              },
            ),
            QuantityView(
                qty: (bundleData["bundleOptionQuantity"]
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        ?.toString() ??
                    "0",
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ""), qty);
                })
          ],
        ));
  }

  Widget _getCheckBoxType(BundleOptions? option) {
    List<ProductFlats> item = [];
    var val = option?.bundleOptionProducts
        ?.map((e) => e.product?.productFlats
            ?.where((element) => element.locale == "en")
            .toList())
        .toList();

    val?.forEach((element) {
      item.addAll(element as Iterable<ProductFlats>);
    });

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
                          "") ??
                      '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxGroup(
                  activeColor: Theme.of(context).colorScheme.onBackground,
                  checkColor: Theme.of(context).colorScheme.background,
                  labels: item.map((e) => e.name ?? "").toList(),
                  onChange: (isChecked, label, index, key) {
                    var product = option?.bundleOptionProducts
                        ?.firstWhereOrNull((element) {
                      return element.product?.productFlats?.firstWhereOrNull(
                              (element) => element.name == label) !=
                          null;
                    });
                    if (isChecked) {
                      _updateQtyValue(int.parse(option?.id ?? "0"),
                          product?.qty?.toString() ?? '0');
                      _updateOptions(int.parse(option?.id ?? "0"),
                          int.parse(product?.id ?? "0"), -1, false);
                    } else {
                      _updateOptions(int.parse(option?.id ?? ""), -1,
                          int.parse(product?.id ?? "0"), false);
                    }
                  },
                ),
                QuantityView(
                  qty: (bundleData["bundleOptionQuantity"]
                              as Map<String, dynamic>?)?[option?.id.toString()]
                          ?.toString() ??
                      "0",
                  callBack: (qty) {
                    _updateQtyValue(int.parse(option?.id ?? ""), qty);
                  },
                ),
              ])
        : Container();
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
                          ?.map((e) => e.product?.productFlats?[0].name ?? "")
                          .toList() ??
                      [],
                  option?.translations?.map((e) => e.label).toString(),
                  null,
                  null,
                  option?.translations?.map((e) => e.label).toString(),
                  (label, key) {
                var product = option?.bundleOptionProducts?.firstWhere(
                    (element) =>
                        element.product?.productFlats?[0].name == label);
                _updateQtyValue(int.parse(option?.id ?? ""),
                    product?.qty?.toString() ?? '0');
                _updateOptions(int.parse(option?.id ?? ""),
                    int.parse(product?.id ?? ""), -1, true);
              }, false),
            ),
            QuantityView(
                qty: (bundleData["bundleOptionQuantity"]
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        .toString() ??
                    "0",
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ""), qty);
                })
          ],
        ));
  }

  _updateOptions(int id, int productId, int removeId, bool isReplace) {
    if (bundleData["bundleOptions"] != null) {
      if (bundleData["bundleOptions"][id.toString()] != null) {
        if (removeId != -1) {}
        (bundleData["bundleOptions"]?[id.toString()] as List<dynamic>)
            .remove(removeId);

        if (productId != -1) {
          if (isReplace) {
            bundleData["bundleOptions"][id.toString()] = [productId];
          } else {
            (bundleData["bundleOptions"][id.toString()] as List<dynamic>)
                .add(productId);
          }
        }
      } else {
        bundleData["bundleOptions"][id.toString()] = [productId];
      }
    } else {
      bundleData["bundleOptions"] = {
        id.toString(): [productId]
      };
    }
  }

  _updateQtyValue(int id, dynamic qty) {
    if (bundleData["bundleOptionQuantity"] != null) {
      setState(() {
        (bundleData["bundleOptionQuantity"]
            as Map<String, dynamic>?)?[id.toString()] = qty;
      });
    } else {
      setState(() {
        bundleData["bundleOptionQuantity"] = {id.toString(): qty};
      });
    }
  }
}

class BundleData {
  String? bundleOptionId;
  List<String>? bundleOptionProductId;

  BundleData({this.bundleOptionId, this.bundleOptionProductId});

  factory BundleData.fromJson(Map<String, dynamic> json) => BundleData(
        bundleOptionId: json["bundleOptionId"],
        bundleOptionProductId: json["bundleOptionProductId"].toList(),
      );

  Map<String, dynamic> toJson() => {
        "bundleOptionId": bundleOptionId,
        "bundleOptionProductId": bundleOptionProductId
      };
}
