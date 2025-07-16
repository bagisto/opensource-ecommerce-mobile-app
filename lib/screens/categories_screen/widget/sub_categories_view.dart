/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';
import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';

//ignore: must_be_immutable
class SubCategoriesView extends StatefulWidget {
  bool? isLoading = false;
  int? page;
  CategoryBloc? subCategoryBloc;
  ScrollController? scrollController;
  String? title;
  String? image;
  String? categorySlug;
  String? metaDescription;
  NewProductsModel? categoriesData;
  bool? isLoggedIn;
  GetFilterAttribute? data;
  List<Map<String, dynamic>> filters;
  bool isPreCatching;

  SubCategoriesView(
      this.isLoading,
      this.page,
      this.subCategoryBloc,
      this.scrollController,
      this.title,
      this.image,
      this.categorySlug,
      this.metaDescription,
      this.categoriesData,
      this.isLoggedIn,
      this.data,
      this.filters,
      this.isPreCatching,
      {Key? key})
      : super(key: key);

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  bool? isGrid = true;
  List? superAttributes = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          widget.subCategoryBloc
              ?.add(FetchSubCategoryEvent(widget.filters, widget.page));
        });
      },
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.image != "" && widget.image != null)
                        const SizedBox(height: AppSizes.spacingMedium),
                      widget.image != "" && widget.image != null
                          ? ImageView(
                              url: widget.image ?? "",
                              height: MediaQuery.of(context).size.height / 3.5,
                              width: MediaQuery.of(context).size.width)
                          : const SizedBox(
                              height: 0,
                            ),
                      if (widget.categoriesData?.data?.isNotEmpty ?? false)
                        Column(
                          children: [
                            (isGrid ?? false)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.spacingNormal),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          widget.categoriesData?.data?.length ??
                                              0,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3) +
                                            100,
                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (widget.isPreCatching) {
                                          // preCacheProductDetails(widget.categoriesData?.data?[index].urlKey ?? "");
                                        }
                                        if (index ==
                                            widget
                                                .categoriesData?.data?.length) {
                                          if (widget
                                                  .categoriesData?.data?.length
                                                  .toString() ==
                                              widget.categoriesData
                                                  ?.paginatorInfo?.total
                                                  .toString()) {
                                            return const SizedBox(
                                              height: AppSizes.spacingNormal,
                                            );
                                          } else {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      AppSizes.spacingMedium /
                                                          2),
                                              child: Center(
                                                child: SizedBox(
                                                  width:
                                                      AppSizes.spacingLarge * 2,
                                                  height:
                                                      AppSizes.spacingLarge * 2,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: MobiKulTheme
                                                        .accentColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return SubCategoriesGridView(
                                            isLogin: widget.isLoggedIn,
                                            data: widget
                                                .categoriesData?.data?[index],
                                            subCategoryBloc:
                                                widget.subCategoryBloc);
                                      },
                                    ),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        (widget.categoriesData?.data!.length ??
                                            0),
                                    itemBuilder: (context, index) {
                                      if (widget.isPreCatching) {
                                        // preCacheProductDetails(widget.categoriesData?.data?[index].urlKey ?? "");
                                      }
                                      if (index ==
                                          widget.categoriesData?.data?.length) {
                                        if (widget.categoriesData?.data?.length
                                                .toString() ==
                                            widget.categoriesData?.paginatorInfo
                                                ?.total
                                                .toString()) {
                                          return const SizedBox(
                                            height: AppSizes.spacingNormal,
                                          );
                                        } else {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    AppSizes.spacingMedium / 2),
                                            child: Center(
                                              child: SizedBox(
                                                width:
                                                    AppSizes.spacingLarge * 2,
                                                height:
                                                    AppSizes.spacingLarge * 2,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      MobiKulTheme.accentColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      return SubCategoriesList(
                                          isLogin: widget.isLoggedIn,
                                          data: widget
                                              .categoriesData?.data?[index],
                                          subCategoryBloc:
                                              widget.subCategoryBloc);
                                    }),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: (superAttributes ?? []).isNotEmpty ||
                    (widget.categoriesData?.data ?? []).isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spacingMedium,
                      horizontal: AppSizes.spacingLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Theme.of(context).cardColor,
                              context: context,
                              builder: (ctx) => BlocProvider(
                                    create: (context) =>
                                        FilterBloc(FilterRepositoryImp()),
                                    child: SortBottomSheet(
                                      categorySlug: widget.categorySlug ?? "",
                                      page: widget.page,
                                      filters: widget.filters,
                                      subCategoryBloc: widget.subCategoryBloc,
                                    ),
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.sort),
                            const SizedBox(
                              width: AppSizes.spacingSmall,
                            ),
                            Text(
                              StringConstants.sort.localized().toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGrid = !isGrid!;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isGrid ?? false
                                ? const Icon(Icons.grid_view_outlined)
                                : const Icon(Icons.list),
                            const SizedBox(
                              width: AppSizes.spacingSmall,
                            ),
                            Text(
                              isGrid ?? false
                                  ? StringConstants.grid
                                      .localized()
                                      .toUpperCase()
                                  : StringConstants.list
                                      .localized()
                                      .toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => SubCategoriesFilterScreen(
                                categorySlug: widget.categorySlug ?? "",
                                subCategoryBloc: widget.subCategoryBloc,
                                page: widget.page,
                                data: widget.data,
                                superAttributes: superAttributes,
                                filters: widget.filters,
                              ),
                            ),
                          )
                              .then((value) {
                            superAttributes = value;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.filter_alt),
                            const SizedBox(
                              width: AppSizes.spacingSmall,
                            ),
                            Text(
                              StringConstants.filter.localized().toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (widget.categoriesData?.data?.isEmpty ?? false)
            const Center(
              child: EmptyDataView(
                assetPath: AssetConstants.emptyCatalog,
                message: StringConstants.emptyPageGenericLabel,
              ),
            ),
          if (widget.isLoading ?? false)
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Loader(),
              ),
            )
        ],
      ),
    );
  }
}
