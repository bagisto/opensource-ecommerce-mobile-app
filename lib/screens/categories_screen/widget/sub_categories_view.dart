
import 'package:bagisto_app_demo/screens/categories_screen/widget/sub_categories_grid_view.dart';
import 'package:bagisto_app_demo/screens/categories_screen/widget/sub_categories_list.dart';
import 'package:bagisto_app_demo/screens/home_page/data_model/new_product_data.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/mobikul_theme.dart';
import '../../../../widgets/image_view.dart';
import '../../../utils/string_constants.dart';
import '../../filter_screen/bloc/filter_bloc.dart';
import '../../filter_screen/bloc/filter_repository.dart';
import '../../filter_screen/filter_screen.dart';
import '../../filter_screen/sort_screen.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_event.dart';

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
  List<FilterAttribute>? data;
  List<Map<String, dynamic>> filters;

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
      this.data, this.filters,
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
          widget.subCategoryBloc?.add(FetchSubCategoryEvent(
              widget.filters, widget.page));
        });
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height:AppSizes.spacingMedium),
                    widget.image != "" && widget.image != null
                        ? ImageView(
                        url: widget.image ?? "",
                        width: MediaQuery.of(context).size.width)
                        : const SizedBox(
                      height: 0,
                    ),
                    (isGrid ?? false) ?
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingNormal),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.categoriesData?.data?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: (MediaQuery.of(context).size.height / 3) + 165,
                          crossAxisCount: 2,),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == widget.categoriesData?.data?.length) {
                            if (widget.categoriesData?.data?.length.toString() ==
                                widget.categoriesData?.paginatorInfo?.total
                                    .toString()) {
                              return const SizedBox(
                                height: AppSizes.spacingNormal,
                              );
                            } else {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium/2),
                                child: Center(
                                  child: SizedBox(
                                    width: AppSizes.spacingLarge*2,
                                    height: AppSizes.spacingLarge*2,
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
                      ),
                    )
                  : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (widget.categoriesData?.data!.length ?? 0),
                  itemBuilder: (context, index) {
                    if (index == widget.categoriesData?.data?.length) {
                      if (widget.categoriesData?.data?.length.toString() ==
                          widget.categoriesData?.paginatorInfo?.total
                              .toString()) {
                        return const SizedBox(
                          height: AppSizes.spacingNormal,
                        );
                      } else {
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium/2),
                          child: Center(
                            child: SizedBox(
                              width: AppSizes.spacingLarge*2,
                              height: AppSizes.spacingLarge*2,
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
                  }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingMedium, horizontal: AppSizes.spacingLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Theme.of(context).cardColor,
                            context: context,
                            builder: (ctx) => BlocProvider(
                                create: (context) => FilterBloc(
                                    FilterRepositoryImp()),
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
                                ? StringConstants.grid.localized().toUpperCase()
                                : StringConstants.list.localized().toUpperCase(),
                            style:
                            const TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                            SubCategoriesFilterScreen(
                              categorySlug: widget.categorySlug ?? "",
                              subCategoryBloc: widget.subCategoryBloc,
                              page: widget.page,
                              data: widget.data,
                              superAttributes: superAttributes,
                              filters: widget.filters,

                            ),
                        ),
                        ).then((value) {
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
              )
            ],
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
