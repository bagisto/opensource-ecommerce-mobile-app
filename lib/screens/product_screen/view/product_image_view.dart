/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/product_screen/view/image_zoom_view.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/assets_constants.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/image_view.dart';
import '../../../widgets/show_message.dart';
import '../../home_page/data_model/new_product_data.dart';

//ignore: must_be_immutable
class ProductImageView extends StatefulWidget {
  final List<String>? imgList;
  ValueChanged<String>? callBack;
  NewProducts? productData;
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
            child: (widget.imgList ?? []).isNotEmpty ? CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.width/2,
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
                    fit: BoxFit.cover,
                  ))).toList(),
            ) : ImageView(
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
          top:  20.0,
          child: InkWell(
            onTap: () {
              if (widget.callBack != null) {
                checkInternetConnection().then((value) {
                  if (value) {
                    widget.callBack!(StringConstants.wishlist);
                  } else {
                    ShowMessage.showNotification(StringConstants.failed.localized(),StringConstants.internetIssue.localized(),
                         Colors.red, const Icon(Icons.cancel_outlined));
                  }
                });

              }
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.onBackground,
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
        top: 70.0,
        child: InkWell(
          onTap: () {
            if (widget.callBack != null) {
              checkInternetConnection().then((value) {
                if (value) {
                  widget.callBack!(StringConstants.compare);
                } else {
                  ShowMessage.showNotification(StringConstants.failed.localized(), StringConstants.internetIssue.localized(),
                       Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            }
          },
          child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
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
              child: Image.asset(AssetConstants.compareIcon,
                height: AppSizes.spacingWide,
                width: AppSizes.spacingWide,
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
          : (widget.productData?.productFlats?[0].isNew ?? false) ?
         Positioned(
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
                    top: AppSizes.spacingSmall/2,
                    bottom: AppSizes.spacingSmall),
                child: Text(
                  StringConstants.statusNew.localized(),
                  style: const TextStyle(color: Colors.white),
                )
            ),
          )) :
      Container(color: Colors.transparent,),
    ]);
  }
}

