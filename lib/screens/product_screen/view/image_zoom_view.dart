import 'package:flutter/material.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/image_view.dart';
import '../../home_page/data_model/new_product_data.dart';


class ZoomImageView extends StatefulWidget {
  const ZoomImageView({Key? key, this.imgList}) : super(key: key);
 final List<Images>? imgList;

  @override
  State<ZoomImageView> createState() => _ZoomImageViewState();
}

class _ZoomImageViewState extends State<ZoomImageView> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                    padding: EdgeInsets.all(AppSizes.spacingMedium),
                    child: Icon(
                      Icons.cancel_sharp,
                      size: 30,
                    ))),
            SizedBox(
                width: AppSizes.screenWidth,
                height: AppSizes.screenHeight - 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imgList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageView(
                      url: widget.imgList?[index].url,
                      fit: BoxFit.cover,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
