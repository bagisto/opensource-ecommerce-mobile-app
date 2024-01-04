/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:flutter/material.dart';
import '../../../cart_screen/cart_model/cart_data_model.dart';

//ignore: must_be_immutable
class CollectionListType extends StatefulWidget {
  Attributes? variation;

  final Function(int, int)? callback;
  List<Options>? options;
  dynamic seletedId;
  List? optionArray;

  CollectionListType(
      {Key? key,
      this.variation,
      this.callback,
      this.options,
      this.seletedId,
      this.optionArray})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionListTypeState();
}

class _CollectionListTypeState extends State<CollectionListType> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.options?.map((item) {
            bool set = getSet(item.id, widget.optionArray);
            return GestureDetector(
                onTap: () {
                  if (widget.callback != null) {
                    widget.callback!(int.parse(widget.variation?.id ?? ""),
                        int.parse(item.id ?? ""));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: set ? Colors.black : Colors.grey.withAlpha(0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                        color: set
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.grey,
                        width: set ? 2.0 : 2.0, //
                      )),
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
                  child: Text(item.label ?? '',
                      style: TextStyle(
                        color: set
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                      )),
                ));
          }).toList() ??
          [],
    );
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


