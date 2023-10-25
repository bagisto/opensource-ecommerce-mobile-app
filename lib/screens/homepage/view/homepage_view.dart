/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, unnecessary_new, implementation_imports, unrelated_type_equality_checks, must_be_immutable

import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';
import 'package:bagisto_app_demo/routes/route_constants.dart';
import 'package:bagisto_app_demo/screens/homepage/view/carousal_slider.dart';
import 'package:bagisto_app_demo/screens/homepage/view/reach_top.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../../recent_product/recent_product_view.dart';
import '../bloc/homepage_bloc.dart';
import '../events/fetch_homepage_event.dart';
import 'advertisement_data.dart';
import 'new_product_view.dart';

class HomePagView extends StatefulWidget {
  final List<HomeSliders>? homeSliders;
  final Advertisements? advertisments;
  final List<NewProducts>? newProducts;
  final List<NewProducts>? featuredProduct;
  bool isLoading;
  bool isLogin;
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  HomePagView(
    this.homeSliders,
    this.advertisments,
    this.newProducts,
    this.featuredProduct,
    this.scaffoldMessengerKey,
    this.isLoading,
    this.isLogin, {
    Key? key,
  }) : super(key: key);

  @override
  State<HomePagView> createState() => _HomePagViewState();
}

class _HomePagViewState extends State<HomePagView> {
  final _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    debugPrint("product Data-------${widget.newProducts}");
    debugPrint("product Data-------${widget.featuredProduct}");
    return RefreshIndicator(
      color: MobikulTheme.accentColor,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                CarousalSlider(
                  sliders: widget.homeSliders,
                ),

                /// [four advertisements]
                if (widget.advertisments != null)
                  AdvertisementDataItem(
                    model: widget.advertisments?.advertisementFour,
                  ),

                /// [new products ]
                if (widget.newProducts != null)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight:
                              (MediaQuery.of(context).size.width / 2.5) +
                                  220),
                      child: NewProductView(
                        title: "newProducts".localized(),
                        isLogin: widget.isLogin,
                        model: widget.newProducts,
                      )),

                /// [three advertisements]
                if (widget.advertisments != null)
                  AdvertisementDataItem(
                    model: widget.advertisments?.advertisementThree,
                  ),

                /// [new products ]
                if (widget.featuredProduct !=null)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight:
                              (MediaQuery.of(context).size.width / 2.5) +
                                  220),
                      child: NewProductView(
                        title: "featuredProducts".localized(),
                        isLogin: widget.isLogin,
                        model: widget.featuredProduct,
                      )),

                /// [two advertisements]
                if (widget.advertisments != null)
                  AdvertisementDataItem(
                    model: widget.advertisments?.advertisementTwo,
                  ),

                ///[recent products]
                RecentView(
                  islogin: widget.isLogin,
                ),
                if (widget.newProducts?.isNotEmpty == true)
                  buildReachBottomView(context, _scrollController),
              ],
            ),
          ),
          if (widget.isLoading)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  child: CircularProgressIndicatorClass
                      .circularProgressIndicator(context)),
            )
        ],
      ),
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          HomePageBloc homePageBloc = context.read<HomePageBloc>();
          homePageBloc.add(FetchAdvertisementEvent());
        });
      },
    );
  }
}

enum HomePageAction { addToCart, fetchDeleteAdd, addCompare }

///class use to pass data on product screen
class PassProductData {
  PassProductData({this.title, this.productId});

  int? productId;
  String? title;
}
