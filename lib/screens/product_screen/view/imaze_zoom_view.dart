// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../common_widget/image_view.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/product_model/product_screen_model.dart';

class ZoomImageView extends StatefulWidget {
  ZoomImageView({Key? key, this.imgList}) : super(key: key);
  List<Images>? imgList;

  @override
  State<ZoomImageView> createState() => _ZoomImageViewState();
}

class _ZoomImageViewState extends State<ZoomImageView> {
  final _pageController = PageController(initialPage: 0);
  double? imageSize;

  @override
  Widget build(BuildContext context) {
    imageSize ??= (AppSizes.width / 4);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                    padding: EdgeInsets.all(AppSizes.mediumPadding),
                    child: Icon(
                      Icons.cancel_sharp,
                      size: 30,
                    ))),
            SizedBox(
                width: AppSizes.width,
                height: AppSizes.height - 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imgList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageView(
                      url: widget.imgList?[index].url,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
