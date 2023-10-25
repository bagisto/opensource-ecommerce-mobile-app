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

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/models/product_model/product_screen_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/quantity_view.dart';
import 'package:flutter/material.dart';

class GroupProduct extends StatefulWidget {
  List<GroupedProducts>? groupedProducts;
  Function(List)? callBack;

  GroupProduct({Key? key, this.groupedProducts, this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupProductState();
  }
}

class _GroupProductState extends State<GroupProduct> {
  List newData = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getGroupData();
    });
    super.initState();
  }

  getGroupData() {
    List<Data> qtyArray = [];
    for (int i = 0; i < (widget.groupedProducts?.length ?? 0); i++) {
      qtyArray.add(Data(id: widget.groupedProducts?[i].id.toString(), qty: 1));
      newData.add(qtyArray[i].toJson());
    }
    if (widget.callBack != null) {
      widget.callBack!(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.groupedProducts?.length ?? 0) > 0
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (widget.groupedProducts?.length ?? 0) + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return _title();
              } else {
                var product = widget.groupedProducts?[i - 1];
                var price = const Row(
                  children: [
                    SizedBox(
                      width: NormalHeight,
                    ),
                  ],
                );
                return QuantityView(
                  title: product?.associatedProduct?.sku ?? '',
                  qty:
                      "1" /*qtyArray[product?.id.toString() ?? ''].toString()*/,
                  minimum: 0,
                  subTitle: price,
                  callBack: (qty) {
                    setState(() {
                      newData.add(product?.id.toString() ?? '');
                    });
                    if (widget.callBack != null) {
                      widget.callBack!(newData);
                    }
                  },
                );
              }
            })
        : Container();
  }

  Widget _title() {
    return Row(
      children: [
        Text('Name'.localized()),
        const Spacer(),
        Text('Quantity'.localized()),
      ],
    );
  }
}

class Data {
  String? id;
  int? qty;

  Data({this.id, this.qty});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["productId"],
        qty: json["qty"] == null ? null : json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productId": id,
        "quantity": qty,
      };
}