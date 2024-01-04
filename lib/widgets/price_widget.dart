import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../utils/app_constants.dart';


class PriceWidgetHtml extends StatelessWidget {
  String priceHtml;
  PriceWidgetHtml({Key? key, required this.priceHtml}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: HtmlWidget(
        priceHtml,

        customStylesBuilder: (element) {
          if (element.classes.contains('line-through')) {
            return {'text-decoration': 'line-through'};
          }
          else if (element.classes.contains('font-semibold')) {
            return {'font-weight': '600'};
          }
          else if (element.classes.contains('font-medium')) {
            return {'font-weight': '500'};
          }
          else if (element.classes.contains('text-[#')) {
            return {'text-decoration-color': element.className.split('text-[').last.replaceAll(']', '')};
          }
          else if (element.classes.contains('grid-gap')) {
            return {'grid-column-gap' : '0px','grid-row-gap' : '0px'};
          }
          else if (element.classes.contains('flex-gap')) {
            return {'flex' : '1'};
          }
          return null;
        },
      ),
    );
  }
}
