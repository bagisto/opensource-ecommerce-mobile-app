/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../utils/app_constants.dart';

class PriceWidgetHtml extends StatelessWidget {
  final String priceHtml;
  const PriceWidgetHtml({Key? key, required this.priceHtml}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("PriceWidgetHtml: $priceHtml");
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingNormal),
      child: HtmlWidget(
        priceHtml,
        customStylesBuilder: (element) {
          if (element.classes.contains('line-through')) {
            return {'text-decoration': 'line-through'};
          } else if (element.classes.contains('font-semibold')) {
            return {'font-weight': '600'};
          } else if (element.classes.contains('font-medium')) {
            return {'font-weight': '500'};
          } else if (element.classes.contains('text-[#')) {
            return {
              'text-decoration-color':
                  element.className.split('text-[').last.replaceAll(']', '')
            };
          } else if (element.classes.contains('grid-gap')) {
            return {'grid-column-gap': '0px', 'grid-row-gap': '0px'};
          } else if (element.classes.contains('flex-gap')) {
            return {'flex': '1'};
          } else if (element.classes.contains('max-md:[&>*]:leading-6') ||
              element.classes.contains('max-sm:[&>*]:leading-4') ||
              element.classes.contains('grid') ||
              element.classes.contains('gap-1.5') ||
              element.classes.contains('max-md:flex')) {
            return {'line-height': 'normal', 'gap': '0'};
          }

          return null;
        },
      ),
    );
  }
}
