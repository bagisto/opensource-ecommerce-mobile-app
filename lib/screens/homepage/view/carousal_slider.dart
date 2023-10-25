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
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';
import 'package:bagisto_app_demo/screens/homepage/view/homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/show_message.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../routes/route_constants.dart';

class CarousalSlider extends StatefulWidget {
  List<HomeSliders>? sliders;

  CarousalSlider({Key? key, this.sliders}) : super(key: key);

  @override
  State<CarousalSlider> createState() => _CarousalSliderState();
}

class _CarousalSliderState extends State<CarousalSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.sliders?.length ?? 0,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) {
            return InkWell(
              onTap: (){
              checkInternetConnection().then((value) {
                  if (value) {
                    Navigator.pushNamed(context, SubCategory,
                        arguments: CategoryProductData(
                            metaDescription: "",
                            categorySlug: widget.sliders?[itemIndex].sliderPath??"",
                            title: widget.sliders?[itemIndex].title??"",
                            image:widget.sliders?[itemIndex].imageUrl??""));
                  } else {
                    ShowMessage.showNotification(
                        "InternetIssue".localized(),
                        "",
                        Colors.red,
                        const Icon(
                            Icons.cancel_outlined));
                  }
                });


              },
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacingTiny),
                child: ImageView(
                  url: widget.sliders?[itemIndex].imageUrl ?? "",
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
            // );
          },
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 3.2,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            viewportFraction: 1.5,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }
          ),
        ),
        widget.sliders?.length  == 1 && widget.sliders !=null
            ? Container()
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  widget.sliders!.asMap()
              .entries
              .map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                 horizontal: 6.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white
                      : Colors.black)
                      .withOpacity(
                      _current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
