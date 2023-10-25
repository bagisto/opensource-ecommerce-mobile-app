/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_call_super, unused_field

import 'package:bagisto_app_demo/common_widget/check_box_group.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/radio_button_group.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/quantity_view.dart';
import 'package:flutter/material.dart';

import '../../../configuration/app_global_data.dart';
import '../../../models/product_model/product_screen_model.dart';
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
  ApplicationLocalizations? _localizations;
  String? currentId;
  var bundleData = <dynamic, dynamic>{};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBundleData();
    });
    // TODO: implement initState
    super.initState();
  }

  getBundleData() {
    List<BundleData> qtyArray = [];
    for (int i = 0; i < (widget.options?.length ?? 0); i++) {
      qtyArray.add(BundleData(
          bundleOptionProductId: widget.options?[i].productId.toString(),
          qty: 1,
          bundleOptionId: widget.options?[i].id.toString()));
      newData.add(qtyArray[i].toJson());
    }
    if (widget.callBack != null) {
      widget.callBack!(newData);
    }
  }



  @override
  Widget build(BuildContext context) {

    return Container(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
             "CustomizeOptions".localized(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.options?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = widget.options?[index];
                  switch (item?.type ?? '') {
                    case Select:
                      return _getTextField(item);
                    case RadioText:
                      return _getRadioButtonType(item);
                    case CheckBoxText:
                      return _getCheckBoxType(item);
                    case MultiSelect:
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
        padding: const EdgeInsets.fromLTRB(
            MediumPadding, NormalPadding, MediumPadding, NormalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option?.translations?.map((e) => e.label ?? "").toString() ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: NormalWidth,
            ),
            RadioButtonGroup(
              key: Key(option?.id?.toString() ?? ''),
              labels: option?.bundleOptionProducts
                  ?.map((e) => e.product?.productFlats?.firstWhereOrNull((element) => element.locale== GlobalData.locale)?.name ?? e.product?.productFlats?[0].name ?? "")
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
                qty: (bundleData["bundle_option_qty"]
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        ?.toString() ??
                    "0",
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ""), qty /*?? 0*/);
                })
          ],
        ));
  }

  Widget _getCheckBoxType(BundleOptions? option) {
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
                  labels: option?.bundleOptionProducts
                      ?.map((e) => e.product?.productFlats?.firstWhereOrNull((element) => element.locale== GlobalData.locale)?.name ?? e.product?.productFlats?[0].name ?? "")
                      .toList(),
                  onChange: (isChecked, label, index, key) {
                    var product = option?.bundleOptionProducts?.firstWhere(
                        (element) => (element.product?.productFlats?.firstWhereOrNull((element) => element.locale== GlobalData.locale)?.name  ?? element.product?.productFlats?[0].name) == label);
                    if (isChecked) {
                      _updateQtyValue(int.parse(option?.id ?? ""),
                          product?.qty?.toString() ?? '0');
                      _updateOptions(int.parse(option?.id ?? ""),
                          int.parse(product?.id ?? ""), -1, false);
                    } else {
                      _updateOptions(int.parse(option?.id ?? ""), -1,
                          int.parse(product?.id ?? ""), false);
                    }
                  },
                ),
                QuantityView(
                  qty: (bundleData["bundle_option_qty"]
                              as Map<String, dynamic>?)?[option?.id.toString()]
                          ?.toString() ??
                      "0",
                  callBack: (qty) {
                    _updateQtyValue(int.parse(option?.id ?? ""), qty /* ?? 0*/);
                  },
                ),
              ])
        : Container();
  }

  Widget _getTextField(BundleOptions? option) {
    return Container(
        // color: Colors.white,
        padding: const EdgeInsets.fromLTRB(
            NormalPadding, NormalPadding, NormalPadding, NormalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CommonWidgets().getDropdown(
                  Key(option?.id?.toString() ?? ''),
                  context,
                  option?.bundleOptionProducts
                          ?.map((e) => e.product?.productFlats?.firstWhereOrNull((element) => element.locale== GlobalData.locale)?.name ?? e.product?.productFlats?[0].name ?? "")
                          .toList() ??
                      [],
                  option?.translations?.map((e) => e.label).toString(),
                  null,
                  null,
                  option?.translations?.map((e) => e.label).toString(),
                  (label, key) {
                var product = option?.bundleOptionProducts?.firstWhere(
                    (element) =>( element.product?.productFlats?.firstWhereOrNull((element) => element.locale == GlobalData.locale)?.name ?? element.product?.productFlats?[0].name  )== label);
                _updateQtyValue(int.parse(option?.id ?? ""),
                    product?.qty?.toString() ?? '0');
                _updateOptions(int.parse(option?.id ?? ""),
                    int.parse(product?.id ?? ""), -1, true);
              }, false),
            ),
            QuantityView(
                qty: (bundleData["bundle_option_qty"]
                            as Map<String, dynamic>?)?[option?.id.toString()]
                        .toString() ??
                    "0",
                callBack: (qty) {
                  _updateQtyValue(int.parse(option?.id ?? ""), qty /*?? 0*/);
                })
          ],
        ));
  }

  _updateOptions(int id, int productId, int removeId, bool isReplace) {
    if (bundleData["bundle_options"] != null) {
      if (bundleData["bundle_options"][id.toString()] != null) {
        if (removeId != -1) {}
        (bundleData["bundle_options"]?[id.toString()] as List<dynamic>)
            .remove(removeId);

        if (productId != -1) {
          if (isReplace) {
            bundleData["bundle_options"][id.toString()] = [productId];
          } else {
            (bundleData["bundle_options"][id.toString()] as List<dynamic>)
                .add(productId);
          }
        }
      } else {
        bundleData["bundle_options"][id.toString()] = [productId];
      }
    } else {
      bundleData["bundle_options"] = {
        id.toString(): [productId]
      };
    }
    // if (widget.callBack != null) widget.callBack!(bundleData);
  }

  _updateQtyValue(int id, dynamic qty) {
    if (bundleData["bundle_option_qty"] != null) {
      setState(() {
        (bundleData["bundle_option_qty"]
                as Map<String, dynamic>?)?[id.toString() /*?? ""*/
            ] = qty;
      });
    } else {
      setState(() {
        bundleData["bundle_option_qty"] = {id.toString(): qty};
      });
    }
  }
}

class BundleData {
  String? bundleOptionId;
  String? bundleOptionProductId;
  int? qty;

  BundleData({this.bundleOptionId, this.bundleOptionProductId, this.qty});

  factory BundleData.fromJson(Map<String, dynamic> json) => BundleData(
        bundleOptionId: json["bundleOptionId"],
        bundleOptionProductId: json["bundleOptionProductId"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "bundleOptionId": bundleOptionId,
        "bundleOptionProductId": bundleOptionProductId,
        "qty": qty,
      };
}
