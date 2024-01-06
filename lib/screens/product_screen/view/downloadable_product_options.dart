/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import '../../../utils/check_box_group.dart';
import '../../../utils/string_constants.dart';
import '../../home_page/data_model/new_product_data.dart';

//ignore: must_be_immutable
class DownloadProductOptions extends StatefulWidget {
  List<DownloadableLinks>? options;
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
        ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    StringConstants.links.localized(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CheckboxGroup(
                    activeColor: Colors.black,
                    data: widget.options,
                    showText: true,
                    labels: widget.options
                            ?.map((e) =>
                                '${e.title ?? ''} + ${e.price}')
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
                                      '${element.title ?? ''} + ${element.price}' ==
                                      e)
                                  .id ??
                              0)
                          .toList();
                      if (widget.callBack != null) {
                        widget.callBack!(list);
                      }
                    },
                  ),
                ]),
        )
        : Container();
  }
}
