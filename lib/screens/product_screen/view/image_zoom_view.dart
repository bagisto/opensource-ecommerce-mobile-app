/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

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
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 2.0,
              child: SizedBox(
                  width: AppSizes.screenWidth,
                  height: AppSizes.screenHeight - 150,
                  child: (widget.imgList ?? []).isNotEmpty ? PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imgList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return ImageView(
                        url: widget.imgList?[index].url,
                        fit: BoxFit.cover,
                      );
                    },
                  ) : const ImageView(
                    url: "",
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
