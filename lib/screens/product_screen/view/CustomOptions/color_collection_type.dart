/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import '../../../../utils/extension.dart';
import '../../../../utils/mobikul_theme.dart';
import '../../../cart_screen/cart_model/cart_data_model.dart';

class ColorCollectionType extends StatefulWidget {
  Attributes? variation;

  final Function(int, int)? callback;
  List<Options>? options;
  dynamic seletedId;
  List? optionArray;

  ColorCollectionType(
      {Key? key,
      this.variation,
      this.callback,
      this.options,
      this.seletedId,
      this.optionArray})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColorCollectionTypeState();
}

class _ColorCollectionTypeState extends State<ColorCollectionType> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.options?.map((item) {
                bool set = getSet(item.id, widget.optionArray);
                return GestureDetector(
                    onTap: () {
                      item.isSelect = true;
                      if (widget.callback != null) {
                        widget.callback!(int.parse(widget.variation?.id ?? ""),
                            int.parse(item.id ?? ""));
                      }
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                            color: (item.isSelect ?? false)
                                ? MobikulTheme.primaryColor
                                : Colors.white.withAlpha(0),
                            width: set ? 1.5 : 0.0,
                          )),
                      child: Container(
                        height: 32,
                        width: 32,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: ((item.swatchValue ?? "").isNotEmpty &&
                                  item.swatchValue != null)
                              ? HexColor.fromHex(item.swatchValue ?? '')
                              : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0)),
                          border: Border.all(
                            color: Colors.grey,
                            width: (item.isSelect ?? false) ? 1.5 : 0.0,
                          ),
                        ),
                      ),
                    ));
              }).toList() ??
              [],
        ));
  }

  bool getSet(String? id, List? optionArray) {
    bool val = false;

    for (var element in (optionArray ?? [])) {
      val = (element["attributeOptionId"].toString() == id.toString());
      if (val) {
        print(
            "break --> ${id.toString()} * ${(element["attributeOptionId"].toString() == id.toString())} ");
        break;
      }
    }
    return val;
  }
}
