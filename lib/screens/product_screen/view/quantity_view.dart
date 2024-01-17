/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class QuantityView extends StatefulWidget {
  String title;
  bool showTitle ;
  String qty;
  Widget? subTitle;
  int minimum;
  bool setQuantity;
  ValueChanged<int>? callBack;

  QuantityView(
      {Key? key,
      this.minimum = 1,
      this.callBack,
      this.showTitle= false,
      this.title = StringConstants.quantity,
      this.subTitle,
      this.qty = "1", this.setQuantity = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuantityViewState();
  }
}

class _QuantityViewState extends State<QuantityView> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.qty;
    super.initState();
  }
  // _updateQty() {
  //   setState(() {
  //     controller.text = widget.qty;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // _updateQty();
    if(widget.setQuantity){
      controller.text = widget.qty;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(widget.showTitle == false)
        Text(
          widget.title.localized(),
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        widget.subTitle ?? const SizedBox.shrink(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  int counter = int.tryParse(controller.text) ?? 1;
                  if (counter > widget.minimum) {
                    setState(() {
                      counter--;
                      controller.text = counter.toString();
                      if (widget.callBack != null) {
                        widget.callBack!(counter);
                      }
                    });
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1.5, color: Colors.grey),
                    ),
                    child:
                        Icon(Icons.remove, size: 16, color: Colors.grey[500]))),
            SizedBox(
                width: 30,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(border: InputBorder.none),
                )),
            GestureDetector(
                onTap: () {
                  int counter = int.tryParse(controller.text) ?? 1;
                  setState(() {
                    counter++;
                    controller.text = counter.toString();
                    if (widget.callBack != null) {
                      widget.callBack!(counter);
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1.5, color: Colors.grey),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                    ))),
          ],
        ),
      ],
    );
  }
}
