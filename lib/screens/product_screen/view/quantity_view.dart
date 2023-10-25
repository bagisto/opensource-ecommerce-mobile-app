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

import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/product_screen_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityView extends StatefulWidget {
  String title;
  String qty;
  Widget? subTitle;
  int minimum;
  ValueChanged<int>? callBack;
  QuantityView({Key? key,this.minimum = 1, this.callBack,this.title = "Quantity",this.subTitle,this.qty = "1"}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _QuantityViewState();
  }
}
class _QuantityViewState extends State<QuantityView> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
_updateqty(){
  controller.text = widget.qty /*?? "0"*/;
}
  @override
  Widget build(BuildContext context) {
    _updateqty();
    return Container(
        padding: const EdgeInsets.all(NormalPadding),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // width: 200,
                    child: Text(widget.title.localized(),maxLines: 2,style: const TextStyle(fontWeight: FontWeight.bold),)),
               if(widget.subTitle != null)
                 widget.subTitle!,
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      int counter = int.tryParse(controller.text) ?? 1;
                      if (counter > widget.minimum) {
                        setState(() {
                          counter--;
                          controller.text = counter.toString();
                          if (widget.callBack != null){
                            widget.callBack!(counter);
                          }
                        });
                      }
                    },
                    child:  Container(
                      padding: const EdgeInsets.all(4),
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 1.5, color: Colors.grey),
                      ),
                        child:Icon(Icons.remove,size:16, color:Colors.grey[500]))),
                SizedBox(
                    width: 30,child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  readOnly:true,
                  style:   TextStyle(fontSize: 17,color:Theme.of(context).colorScheme.onPrimary,),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      border: InputBorder.none
                  ),
                )),
                // Text(
                //   "$_counter",
                //   style: TextStyle(fontSize: 16.0, color: Colors.black),
                // ),
                InkWell(
                    onTap: () {
                      int counter = int.tryParse(controller.text) ?? 1;
                      setState(() {
                        counter++;
                        debugPrint("counter----${counter.toString()}");

                        controller.text = counter.toString();
                        if (widget.callBack != null){
                          widget.callBack!(counter);
                        }

                      });

                    },
                    child:   Container(
                        padding: const EdgeInsets.all(4),
                        // height: MediaQuery.of(context).size.height/22,
                        // width: MediaQuery.of(context).size.width/14,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1.5, color: Colors.grey),
                    ),
                    child:const Icon(Icons.add,size:16,))),

              ],
            ),

          ],)

    );
  }

}