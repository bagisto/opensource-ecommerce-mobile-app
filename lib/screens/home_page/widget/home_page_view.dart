/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/home_page/widget/reach_top.dart';
import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/route_constants.dart';
import '../../../widgets/image_view.dart';
import '../../recent_product/recent_product_view.dart';
import '../bloc/home_page_bloc.dart';
import '../bloc/home_page_event.dart';
import '../data_model/get_categories_drawer_data_model.dart';
import '../data_model/new_product_data.dart';
import '../data_model/theme_customization.dart';
import 'carousal_slider.dart';
import 'new_product_view.dart';

class HomePagView extends StatefulWidget {
  final ThemeCustomDataModel? customHomeData;
  final bool isLoading;
  final bool isLogin;
  final GetDrawerCategoriesData? getCategoriesData;
  final HomePageBloc? homePageBloc;

  const HomePagView(
    this.customHomeData,
    this.isLoading,
    this.getCategoriesData,
    this.isLogin,
    this.homePageBloc, {
    Key? key,
  }) : super(key: key);

  @override
  State<HomePagView> createState() => _HomePagViewState();
}

class _HomePagViewState extends State<HomePagView> {
  final _scrollController = ScrollController();
  List<double> _htmlHeight = [];

  @override
  void initState() {
    _registerStreamListener();
    _htmlHeight = List.generate(
        widget.customHomeData?.themeCustomization?.length ?? 0, (index) => 1);
    super.initState();
  }

  _registerStreamListener(){
    if(mounted) {
      GlobalData.productsStream.stream.listen((event) {
        setState(() {});
        GlobalData.allProducts?.add(event);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...getHomepageView(widget.customHomeData, size),
                ],
              ),
            ),
            Visibility(
                visible: widget.isLoading,
                child: const Align(
                  alignment: Alignment.center,
                  child: SizedBox(child: Loader()),
                ))
          ],
        ),
        onRefresh: () {
          HomePageBloc homePageBloc = context.read<HomePageBloc>();
          homePageBloc.add(FetchHomeCustomData());
          return Future.delayed(const Duration(seconds: 4), () {
          });
        },
      ),
    );
  }

  Widget buildCategories(Size size) {
    return (widget.getCategoriesData?.data ?? []).isNotEmpty ?
     Container(
      color: Theme.of(context).colorScheme.primary,
      width: AppSizes.screenWidth,
      height: AppSizes.screenHeight / 4,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.size12),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.getCategoriesData?.data?.length ?? 0,
          itemBuilder: (context, index) {
            HomeCategories? item = widget.getCategoriesData?.data?[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, categoryScreen,
                    arguments: CategoriesArguments(
                        categorySlug: item?.slug, title: item?.name, id: item?.categoryId.toString()));
              },
              child: Container(
                margin: const EdgeInsets.only(top: AppSizes.spacingWide),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingNormal),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: ClipOval(
                        child: ImageView(
                          url: item?.logoUrl ?? "",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.spacingLarge,
                    ),
                    Text(item?.name ?? "",
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
            );
          }),
    ) : const SizedBox();
  }

  Widget staticContentView(int index, {required String heading, String? css}) {
    return Container();

    // String html = getHtmlView(heading, css ?? "");
    //
    // return SizedBox(
    //     height: _htmlHeight[index],
    //     width: MediaQuery.of(context).size.width,
    //     child: InAppWebView(
    //       initialData: InAppWebViewInitialData(data: html),
    //       onLoadStop: (controller, url){
    //         controller.evaluateJavascript(source: '''(() => { return document.body.scrollHeight;})()''').then((value) {
    //           if(value == null || value == '') {
    //             return;
    //           }
    //           setState(() {
    //             _htmlHeight[index] = (double.parse('$value')/MediaQuery.of(context).devicePixelRatio);
    //             print("Loaded height --> $value $index");
    //           });
    //         });
    //       },
    //       initialOptions: InAppWebViewGroupOptions(
    //           crossPlatform: InAppWebViewOptions(
    //               useShouldOverrideUrlLoading: true,
    //               supportZoom: false,
    //               javaScriptEnabled: true,
    //
    //           )),
    //     ));
  }

  List<Widget> getHomepageView(
      ThemeCustomDataModel? customHomeData, Size size) {
    List<Widget> homeWidgets = [];
    int index = 0;
    int productIndex = 0;

    customHomeData?.themeCustomization?.forEach((element) {
      switch (element.type) {
        case "image_carousel":
          homeWidgets.add(CarousalSlider(
            sliders: element,
          ));
          break;

        case "static_content":
          homeWidgets.add(staticContentView(index,
              heading: element.translations?.firstOrNull?.options?.html ?? "",
              css: element.translations?.firstOrNull?.options?.css ?? ""));
          break;

        case "category_carousel":
          homeWidgets.add(buildCategories(size));
          break;

        case "product_carousel":
          if ((GlobalData.allProducts ?? []).isNotEmpty &&
              productIndex < (GlobalData.allProducts ?? []).length && (GlobalData.allProducts?[productIndex]?.data ?? []).isNotEmpty) {
            homeWidgets.add(SizedBox(
                height: (MediaQuery.of(context).size.width / 1.5) + 220,
                child: NewProductView(
                  title:
                      element.translations?.firstOrNull?.options?.title ?? "",
                  isLogin: widget.isLogin,
                  model: GlobalData.allProducts?[productIndex]?.data,
                )));
            productIndex++;
          }
          break;
      }
      index++;
    });

    homeWidgets.add(Column(
      children: [
        RecentView(
          isLogin: widget.isLogin,
        ),
        const SizedBox(
          height: AppSizes.spacingNormal,
        ),
        if (GlobalData.allProducts?.isNotEmpty == true)
          buildReachBottomView(context, _scrollController)
      ],
    ));

    return homeWidgets;
  }

  String getHtmlView(String html, String css) {
    css = css +
        """div {
    flex-direction: column;
    column-count: 1 !important;
    width: 100%;
   gap: 2vw;

  }
  .top-collection-card{
    width: 100vw;
  }
  .top-collection-card img{
    width: 90vw;
    height: 90vw;
  }
  .top-collection-card h3{
    font-size: 7vw;
    font-weight: bold;
  }
  """;

    return """
    <html><head>
        <style>
            $css
        </style>
    </head>
    <body>
    $html
    </body></html>
    """;
  }
}
