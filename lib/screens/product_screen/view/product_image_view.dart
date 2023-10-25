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

import 'package:bagisto_app_demo/common_widget/image_view.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/imaze_zoom_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../models/product_model/product_screen_model.dart';

class ProductImageView extends StatefulWidget {
  final List<String>? imgList;
  ValueChanged<String>? callBack;
  Product? productData;
  ProductFlats? product;

  ProductImageView(
      {Key? key, this.imgList, this.callBack, this.productData, this.product})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductImageViewState();
  }
}

class ProductImageViewState extends State<ProductImageView> {
  final buttonCarouselController = CarouselController();
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
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  height: MediaQuery.of(context).size.width,
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
                          height: MediaQuery.of(context).size.width)))
                  .toList(),
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
      // if ((widget.imgList?.length ?? 0)>1)
      Positioned(
          right: 8.0,
          top:  20.0,
          child: InkWell(
            onTap: () {
              if (widget.callBack != null) {
                checkInternetConnection().then((value) {
                  if (value) {
                    widget.callBack!('wishlist');
                  } else {
                    ShowMessage.showNotification("InternetIssue".localized(),
                        "", Colors.red, const Icon(Icons.cancel_outlined));
                  }
                });

              }
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                   color: Colors.black,
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
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.white,
                      )),
          )),
      Positioned(
        right: 8.0,
        top:70.0,
        child: InkWell(
          onTap: () {
            if (widget.callBack != null) {
              checkInternetConnection().then((value) {
                if (value) {
                  widget.callBack!('compare');
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(),
                      "", Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: ThemeMode.dark == true
                    ? MobikulTheme.accentColor
                    : MobikulTheme.primaryColor,
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
                "assets/images/compare-icon.png",
                height: 20,
                width: 20,
              )),
        ),
      ),
      if (widget.product?.isNew ?? true)
        Positioned(
            left: AppSizes.size8,
            top: AppSizes.size8,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Padding(
                  padding: EdgeInsets.only(
                      left: AppSizes.size8,
                      right: AppSizes.size8,
                      top: AppSizes.size2,
                      bottom: AppSizes.spacingTiny),
                  child: Text(
                    "New",
                    style: TextStyle(color: Colors.white),
                  )),
            )),
    ]);
  }
}
