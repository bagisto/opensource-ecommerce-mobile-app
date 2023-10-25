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

import 'package:bagisto_app_demo/common_widget/check_box_group.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';

import '../../../models/product_model/product_screen_model.dart';

class DownloadProductOptions extends StatefulWidget {
  List<DownloadableProduct>? options;
  Function(List)? callBack;

  DownloadProductOptions({Key? key, this.options, this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DownloadProductOptionsState();
  }
}

class _DownloadProductOptionsState extends State<DownloadProductOptions> {
  final buttonCarouselController = CarouselController();
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.options?.length ?? 0) > 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  "Links".localized(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxGroup(
                  activeColor: Colors.black,
                  labels: widget.options
                          ?.map(
                              (e) => '${e.title ?? ''} + ${e.price.toString()}')
                          .toList() ??
                      [],
                  checked: selected,
                  onChange: (isChecked, label, index, key) {
                    setState(() {
                      if (isChecked) {
                        selected.add(label);
                      } else {
                        selected.remove(label);
                      }
                    });
                    var list = selected
                        .map((e) =>
                            widget.options
                                ?.firstWhere((element) =>
                                    '${element.title ?? ''} + ${element.price.toString()}' ==
                                    e)
                                .id ??
                            0)
                        .toList();
                    if (widget.callBack != null) {
                      widget.callBack!(list);
                    }
                  },
                )
              ])
        : Container();
  }
}
