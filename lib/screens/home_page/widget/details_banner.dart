
import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../widgets/image_view.dart';

class DetailsBannerView extends StatelessWidget {
  final String? title;
  final String? imgUrl;
  const DetailsBannerView({Key? key, this.title, this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.spacingMedium),
          child: ImageView(
            url: imgUrl,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingWide/2),
          child: HtmlWidget(
            title ?? "",
          ),
        ),
        const SizedBox(height: AppSizes.spacingNormal)
      ],
    );
  }
}
