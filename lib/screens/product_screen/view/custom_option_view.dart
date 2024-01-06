/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */
// ignore_for_file: file_names, must_be_immutable, must_call_super

import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter/material.dart';
import '../../../data_model/categories_data_model/categories_product_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';


class CustomOptionsView extends StatefulWidget {
  Function(List, String)? callback;
  List<Attributes>? customOptions = [];
  List<Variants>? variants = [];
  NewProducts? productData;

  CustomOptionsView(
      {Key? key,
      this.productData,
      this.customOptions,
      this.variants,
      this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomOptionsViewState();
  }
}

class _CustomOptionsViewState extends State<CustomOptionsView> {
  List optionArray = [];
  List tempList = [];
  String? currentId;
  String? variationId;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.customOptions?.length ?? 0,
            itemBuilder: (context, index) {
              var item = widget.customOptions?[index];
              switch (widget.productData?.superAttributes?[index].type ?? '') {
                case StringConstants.select:
                  switch (item?.swatchType ?? '') {
                    case StringConstants.color:
                      return _getColorCollectionType(item, index);
                    case StringConstants.text:
                      return _getCollectionListType(item, index);
                    case StringConstants.image:
                      return _getImageType(item, index);
                    default:
                      return GetTextField(
                        index: index,
                        optionArray: optionArray,
                        variation: item,
                        productData: widget.productData,
                        customOptions: widget.customOptions,
                        callback: widget.callback,
                      );
                  }
              }
              return Container();
            }));
  }

  Widget _getImageType(Attributes? variation, int index) {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(variation?.label ?? 'test'),
            const SizedBox(
              height: 12.0,
            ),
            ImageType(
                seletedId: variationId,
                optionArray: optionArray,
                variation: variation,
                options: _getOptions(index),
                callback: (id, item) {
                  setState(() {
                    variationId = item.toString();
                    var firstAdd = true;
                    Map<String, dynamic> optionData = {};
                    optionData["attributeId"] = variation?.id?.toString() ?? '';
                    optionData["attributeOptionId"] = item;
                    if (optionArray.isNotEmpty) {
                      for (var optionArrayKey = 0;
                          optionArrayKey < optionArray.length;
                          optionArrayKey++) {
                        if (optionArray[optionArrayKey]["attributeId"]
                                .toString() ==
                            optionData["attributeId"].toString()) {
                          if (optionArray[optionArrayKey]["attributeOptionId"]
                                  .toString() !=
                              item.toString()) {
                            optionArray[optionArrayKey]["attributeOptionId"] =
                                item;
                            firstAdd = false;
                            break;
                          } else {
                            firstAdd = false;
                            break;
                          }
                        } else {
                          firstAdd = true;
                        }
                      }
                      if (firstAdd) {
                        optionArray.add(optionData);
                      }
                    } else {
                      optionArray.add(optionData);
                    }
                  });
                  _updateCallBack();
                })
          ],
        ));
  }

  Widget _getColorCollectionType(Attributes? variation, int index) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(variation?.label ?? '',
              style:TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
            ),
            const SizedBox(
              height: 12.0,
            ),
            ColorCollectionType(
                seletedId: variationId,
                optionArray: optionArray,
                variation: variation,
                options: _getOptions(index),
                callback: (id, item) {
                  setState(() {
                    variationId = item.toString();
                    var firstAdd = true;
                    Map<String, dynamic> optionData = {};
                    optionData["attributeId"] = variation?.id?.toString() ?? '';
                    optionData["attributeOptionId"] = item;
                    if (optionArray.isNotEmpty) {
                      for (var optionArrayKey = 0;
                          optionArrayKey < optionArray.length;
                          optionArrayKey++) {
                        if (optionArray[optionArrayKey]["attributeId"]
                                .toString() ==
                            optionData["attributeId"].toString()) {
                          if (optionArray[optionArrayKey]["attributeOptionId"]
                                  .toString() !=
                              item.toString()) {
                            optionArray[optionArrayKey]["attributeOptionId"] =
                                item;
                            firstAdd = false;
                            break;
                          } else {
                            firstAdd = false;
                            break;
                          }
                        } else {
                          firstAdd = true;
                        }
                      }
                      if (firstAdd) {
                        optionArray.add(optionData);
                      }
                    } else {
                      optionArray.add(optionData);
                    }
                  });
                  _updateCallBack();
                })
          ],
        ));
  }

  Widget _getCollectionListType(Attributes? variation, int index) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(variation?.label ?? '', style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
            ),
            const SizedBox(
              height: 12.0,
            ),
            CollectionListType(
                optionArray: optionArray,
                seletedId: variationId,
                variation: variation,
                options: _getOptions(index),
                callback: (id, item) {
                  if (tempList.contains(item)) {}
                  setState(() {
                    variationId = item.toString();
                    var firstAdd = true;
                    Map<String, dynamic> optionData = {};
                    optionData["attributeId"] = variation?.id?.toString() ?? '';
                    optionData["attributeOptionId"] = item;

                    if (optionArray.isNotEmpty) {
                      for (var optionArrayKey = 0;
                          optionArrayKey < optionArray.length;
                          optionArrayKey++) {
                        if (optionArray[optionArrayKey]["attributeId"]
                                .toString() ==
                            optionData["attributeId"].toString()) {
                          if (optionArray[optionArrayKey]["attributeOptionId"]
                                  .toString() !=
                              item.toString()) {
                            optionArray[optionArrayKey]["attributeOptionId"] =
                                item;
                            firstAdd = false;
                            break;
                          } else {
                            firstAdd = false;
                            break;
                          }
                        } else {
                          firstAdd = true;
                        }
                      }
                      if (firstAdd) {
                        optionArray.add(optionData);
                      }
                    } else {
                      optionArray.add(optionData);
                    }
                  });
                  _updateCallBack();
                })
          ],
        ));
  }

  _getOptions(int index) {
    if ((widget.customOptions?.length ?? 0) > index) {
      if (index == 0) {
        var codeList = widget.customOptions?[0].options
            ?.map((element) => element.id)
            .toList();
        var options = widget.customOptions?[0].options
            ?.where((element) => codeList?.contains(element.id) ?? false);
        return options?.toList() ?? [];
      } else {
        var codeList =
            widget.customOptions?[index].options?.map((e) => e.id).toList();
        var options = widget.customOptions?[index].options
            ?.where((element) => codeList?.contains(element.id) ?? false);
        return options?.toList() ?? [];
      }
    }
    return [];
  }

  _getId() {
    String selectedProductAttributeId = "";
    var mappedKey = true;
    for (var optionArrayKey = 0;
        optionArrayKey < optionArray.length;
        optionArrayKey++) {
      if (mappedKey) {
        loopIndexes:
        for (var index1 = 0;
            index1 < (widget.productData?.configurableData?.index?.length ?? 0);
            index1++) {
          for (var indexData = optionArrayKey;
              indexData <
                  (widget.productData?.configurableData?.index?[index1]
                          .attributeOptionIds?.length ??
                      0);
              indexData++) {
            if (optionArray[optionArrayKey]['attributeId'].toString() ==
                    widget.productData?.configurableData?.index?[index1]
                        .attributeOptionIds?[indexData].attributeId
                        .toString() &&
                optionArray[optionArrayKey]['attributeOptionId'].toString() ==
                    widget.productData?.configurableData?.index?[index1]
                        .attributeOptionIds?[indexData].attributeOptionId
                        .toString()) {
              mappedKey = true;
              selectedProductAttributeId =
                  widget.productData?.configurableData?.index?[index1].id ?? "";
              break loopIndexes;
            } else {
              mappedKey = false;
            }
          }
        }
      }
    }
    return selectedProductAttributeId;
  }

  _updateCallBack() {
    if (widget.callback != null) {
      Map<String, dynamic> dict = {};
      dict["superAttribute"] = optionArray;
      widget.callback!(optionArray, _getId());
    }
  }
}
