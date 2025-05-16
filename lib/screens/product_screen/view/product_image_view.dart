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
import 'package:carousel_slider/carousel_slider.dart' as slider;

class ProductImageView extends StatefulWidget {
  final List<String>? imgList;
  final ValueChanged<String>? callBack;
  final NewProducts? productData;
  final ProductFlats? product;

  const ProductImageView(
      {Key? key, this.imgList, this.callBack, this.productData, this.product})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductImageViewState();
  }
}

class ProductImageViewState extends State<ProductImageView> {
  final buttonCarouselController = slider.CarouselSliderController();
  int? _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Stack(children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ZoomImageView(imgList: widget.productData?.images)));
            },
            child: (widget.imgList ?? []).isNotEmpty
                ? slider.CarouselSlider(
                    carouselController: buttonCarouselController,
                    options: slider.CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        height: MediaQuery.of(context).size.width / 1.1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: widget.imgList
                        ?.map((item) => Center(
                                child: ImageView(
                              url: item,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            )))
                        .toList(),
                  )
                : ImageView(
                    url: "",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ),
          ),
        ]),
        if ((widget.imgList?.length ?? 0) > 1)
          const SizedBox(
            height: 8.0,
          ),
        if ((widget.imgList?.length ?? 0) > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (widget.imgList ?? []).map((url) {
                int? index = widget.imgList?.indexOf(url);
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        _current = index;
                        buttonCarouselController.jumpToPage(_current ?? 0);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: (_current == index
                                ? Colors.black
                                : Colors.red[500]?.withAlpha(0))!,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: ImageView(
                            url: widget.imgList?[index ?? 0],
                            width: 50,
                            height: 50)));
              }).toList(),
            ),
          ),
      ]),
      Positioned(
          right: 8.0,
          top: 20.0,
          child: InkWell(
            onTap: () {
              if (widget.callBack != null) {
                checkInternetConnection().then((value) {
                  if (value) {
                    widget.callBack!(StringConstants.wishlist);
                  } else {
                    ShowMessage.showNotification(
                        StringConstants.failed.localized(),
                        StringConstants.internetIssue.localized(),
                        Colors.red,
                        const Icon(Icons.cancel_outlined));
                  }
                });
              }
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: widget.productData?.isInWishlist ?? false
                    ? Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      )
                    : Icon(
                        Icons.favorite_outline_rounded,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      )),
          )),
      Positioned(
        right: 8.0,
        top: 70.0,
        child: InkWell(
          onTap: () {
            if (widget.callBack != null) {
              checkInternetConnection().then((value) {
                if (value) {
                  widget.callBack!(StringConstants.compare);
                } else {
                  ShowMessage.showNotification(
                      StringConstants.failed.localized(),
                      StringConstants.internetIssue.localized(),
                      Colors.red,
                      const Icon(Icons.cancel_outlined));
                }
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                AssetConstants.compareIcon,
                height: AppSizes.spacingWide,
                width: AppSizes.spacingWide,
                color: Theme.of(context).colorScheme.secondaryContainer,
              )),
        ),
      ),
      (widget.productData?.isInSale ?? false)
          ? Positioned(
              left: AppSizes.spacingNormal,
              top: AppSizes.spacingNormal,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.spacingMedium,
                        right: AppSizes.spacingMedium,
                        top: AppSizes.spacingSmall,
                        bottom: AppSizes.spacingSmall),
                    child: Text(
                      StringConstants.sale.localized(),
                      style: const TextStyle(color: Colors.white),
                    )),
              ))
          : (widget.productData?.productFlats?[0].isNew ?? false)
              ? Positioned(
                  left: AppSizes.spacingNormal,
                  top: AppSizes.spacingNormal,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: AppSizes.spacingNormal,
                            right: AppSizes.spacingNormal,
                            top: AppSizes.spacingSmall / 2,
                            bottom: AppSizes.spacingSmall),
                        child: Text(
                          StringConstants.statusNew.localized(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ))
              : Container(
                  color: Colors.transparent,
                ),
    ]);
  }
}
