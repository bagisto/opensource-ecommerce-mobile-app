
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

import 'package:bagisto_app_demo/common_widget/image_view.dart';
import 'package:flutter/material.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/product_model/product_screen_model.dart';

class ImageType extends StatefulWidget {
  Attributes? variation ;
  final Function(int,int)? callback;
  List<Options>? options;
  dynamic seletedId;
  List? optionArray;
  ImageType({Key? key, this.variation, this.callback,this.options,this.seletedId, this.optionArray}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageTypeState();
}

class _ImageTypeState extends State<ImageType> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.options?.map((item) {
            bool set = getSet(item.id, widget.optionArray);
            return GestureDetector(
                onTap: () {
                  if (widget.callback != null){
                    widget.callback!(int.parse(widget.variation?.id??"") ,int.parse(item.id??'') );
                  }
                },
                child:  Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: set ? 1.5 : 0.0,
                    ),
                  ),
                  child: ImageView(url:imageUrl + (item.swatchValue ??''),),
                ));
          }).toList() ??
              [],
        ));
  }

  bool getSet(String? id, List? optionArray) {
    bool val = false;

    for(var element in (optionArray ?? [])){
      val = (element["attributeOptionId"].toString() == id.toString());
      if(val){
        break;
      }
    }
    return val;
  }
}
