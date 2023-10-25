// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/categories_data_model/categories_product_model.dart';
import 'package:bagisto_app_demo/screens/sub_categories/view/sub_categories_grid_view.dart';
import 'package:bagisto_app_demo/screens/sub_categories/view/sub_categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/image_view.dart';
import '../../../configuration/app_sizes.dart';

import '../../../helper/prefetching_helper.dart';
import '../../../models/categories_data_model/filter_product_model.dart';

import '../../filter_screen/bloc/filter_bloc.dart';
import '../../filter_screen/repository/filter_repository.dart';
import '../../filter_screen/view/filter_screen.dart';
import '../../filter_screen/view/sort_screen.dart';
import '../bloc/sub_categories_bloc.dart';
import '../events/fetch_sub_categories_event.dart';

class SubCategoriesView extends StatefulWidget {
  bool? isLoading = false;
  int? page;
  SubCategoryBloc? subCategoryBloc;
  ScrollController? scrollController;
  String? title;
  String? image;
  String? categorySlug;
  String? metaDescription;
  CategoriesProductModel? categoriesData;
  bool? isLoggedIn;
  List<FilterAttribute>? data;



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
      {Key? key})
      : super(key: key);

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  bool? isGrid = true;

  List ? superAttributes = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MobikulTheme.accentColor,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          widget.subCategoryBloc?.add(FetchSubCategoryEvent(
              widget.categorySlug ?? "", widget.page, "", "" /*0,500*/));
        });
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().getTextFieldHeight(AppSizes.normalHeight),
                widget.image != "" && widget.image != null
                    ? ImageView(
                        url: widget.image ?? "",
                        width: MediaQuery.of(context).size.width)
                    : const SizedBox(
                        height: 0,
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Theme.of(context).cardColor,
                              context: context,
                              builder: (ctx) => BlocProvider(
                                    create: (context) => FilterBloc(
                                        repository: FilterRepositoryImp(),
                                        context: context),
                                    child: SortBottomSheet(
                                      categorySlug: widget.categorySlug ?? "",
                                      page: widget.page,
                                      subCategoryBloc: widget.subCategoryBloc,
                                    ),
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.sort),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "sort".localized().toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              isDismissible: false,
                              backgroundColor: Theme.of(context).cardColor,
                              context: context,
                              builder: (ctx) =>FilterBottomSheet(
                                      categorySlug: widget.categorySlug ?? "",
                                      subCategoryBloc: widget.subCategoryBloc,
                                      page: widget.page,
                                       data: widget.data,
                                      superAttributes:superAttributes ,
                                    ),).then((value) {
                            superAttributes=value;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.filter_alt),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "filter".localized().toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      InkWell(
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
                              width: 4,
                            ),
                            Text(
                              isGrid ?? false
                                  ? "grid".localized().toUpperCase()
                                  : "list".localized().toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isGrid ?? false)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: widget.categoriesData?.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: (MediaQuery.of(context).size.height/4) + 160,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      preCacheProductPage( int.parse(widget.categoriesData?.data?[index].id??""));
                      if (index == widget.categoriesData?.data!.length) {
                        if (widget.categoriesData?.data!.length.toString() ==
                            widget.categoriesData?.paginatorInfo?.total
                                .toString()) {
                          return const SizedBox(
                            height: 8.0,
                          );
                        } else {
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 6.0, bottom: 6.0),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: MobikulTheme.accentColor,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      return SubCategoriesGridView(
                          isLogin: widget.isLoggedIn,
                          data: widget.categoriesData?.data?[index],
                          subCategoryBloc: widget.subCategoryBloc);
                    },
                  )
                else
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: (widget.categoriesData?.data!.length ?? 0),
                      itemBuilder: (context, index) {
                        preCacheProductPage( int.parse(widget.categoriesData?.data?[index].id??""));
                        if (index == widget.categoriesData?.data!.length) {
                          if (widget.categoriesData?.data!.length.toString() ==
                              widget.categoriesData?.paginatorInfo?.total
                                  .toString()) {
                            return const SizedBox(
                              height: 8.0,
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 6.0),
                              child: Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: MobikulTheme.accentColor,
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        return SubCategoriesList(
                            isLogin: widget.isLoggedIn,
                            data: widget.categoriesData?.data?[index],
                            subCategoryBloc: widget.subCategoryBloc);
                      })
              ],
            ),
          ),
          if (widget.isLoading ?? false)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: CircularProgressIndicatorClass.circularProgressIndicator(
                    context),
              ),
            )
        ],
      ),
    );
  }
}
