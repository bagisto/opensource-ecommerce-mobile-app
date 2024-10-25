/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/home_page/data_model/theme_customization.dart';
import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

class HomePageView extends StatefulWidget {
  final ThemeCustomDataModel? customHomeData;
  final bool isLoading;
  final bool isLogin;
  final GetDrawerCategoriesData? getCategoriesData;
  final HomePageBloc? homePageBloc;
  final bool callPreCache;

  const HomePageView(
    this.customHomeData,
    this.isLoading,
    this.getCategoriesData,
    this.isLogin,
    this.homePageBloc,
    this.callPreCache, {
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _scrollController = ScrollController();
  List<double> htmlHeight = [];

  @override
  void initState() {
    htmlHeight = List.generate(
        widget.customHomeData?.themeCustomization?.length ?? 0, (index) => 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...getHomepageView(
                    widget.customHomeData, MediaQuery.of(context).size),
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
        return Future.delayed(const Duration(seconds: 4), () {});
      },
    );
  }

  Widget buildCategories(Size size) {


    return (widget.getCategoriesData?.data ?? []).isNotEmpty
        ? Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: AppSizes.screenWidth,
            height: AppSizes.screenHeight / 4,
            margin:
                const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.getCategoriesData?.data?.length ?? 0,
                itemBuilder: (context, index) {
                   HomeCategories? item = widget.getCategoriesData?.data?[index];

                  return GestureDetector(
                    onTap: () {
                      if((item?.children ?? []).isNotEmpty){
                        Navigator.pushNamed(context, drawerSubCategoryScreen, arguments:
                        CategoriesArguments(categorySlug: item?.slug,
                            title: item?.name, id: item?.id.toString(),
                            image: item?.bannerUrl ?? "", parentId: "1"));
                      }
                      else{
                        Navigator.pushNamed(context, categoryScreen,
                            arguments: CategoriesArguments(
                                categorySlug: item?.slug,
                                title: item?.name,
                                id: item?.id,
                                image: item?.bannerUrl));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: AppSizes.spacingWide),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingNormal),
                      child: item?.id != "1"? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: AppSizes.spacingWide * 5,
                            width: AppSizes.spacingWide * 5,
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
                      ):Container(),
                    ),
                  );
                }),
          )
        : const SizedBox();
  }

  Widget staticContentView(int index, {required String heading, String? css}) {
    return Container();

    // String html = getHtmlView(heading, css ?? "");
    //
    // return SizedBox(
    //     height: htmlHeight[index],
    //     width: MediaQuery.of(context).size.width,
    //     child: InAppWebView(
    //       initialData: InAppWebViewInitialData(data: html),
    //       onLoadStop: (controller, url){
    //         controller.evaluateJavascript(source: '''(() => { return document.body.scrollHeight;})()''').then((value) {
    //           if(value == null || value == '') {
    //             return;
    //           }
    //           setState(() {
    //             htmlHeight[index] = (double.parse('$value')/MediaQuery.of(context).devicePixelRatio);
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
              productIndex < (GlobalData.allProducts ?? []).length) {
            homeWidgets.add(SizedBox(
                height:
                    (GlobalData.allProducts?[productIndex]?.data?.isNotEmpty ??
                            false)
                        ? (MediaQuery.of(context).size.width / 1.5) + 220
                        : 0,
                child: GlobalData
                            .allProducts?[productIndex]?.data?.isNotEmpty ??
                        false
                    ? NewProductView(
                        title:
                            element.translations?.firstOrNull?.options?.title ??
                                "",
                        isLogin: widget.isLogin,
                        model: GlobalData.allProducts?[productIndex]?.data,
                        callPreCache: widget.callPreCache,
                      )
                    : Container()));
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
    css = """${css}div {
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
