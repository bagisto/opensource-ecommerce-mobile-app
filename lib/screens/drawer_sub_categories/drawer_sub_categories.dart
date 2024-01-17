/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/drawer_sub_categories/bloc/drawer_sub_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_model/app_route_arguments.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_global_data.dart';
import '../../utils/route_constants.dart';
import '../../widgets/loader.dart';
import '../home_page/data_model/get_categories_drawer_data_model.dart';
import 'bloc/drawer_sub_categories_bloc.dart';
import 'bloc/drawer_sub_categories_event.dart';

//ignore: must_be_immutable
class DrawerSubCategoryView extends StatefulWidget {
  String? title;
  String? id;

  DrawerSubCategoryView({Key? key, this.title, this.id})
      : super(key: key);

  @override
  State<DrawerSubCategoryView> createState() => _DrawerSubCategoryViewState();
}

class _DrawerSubCategoryViewState extends State<DrawerSubCategoryView> {
  GetDrawerCategoriesData? categoriesData;
  DrawerSubCategoriesBloc? bloc;
  bool isLoading = false;

  @override
  void initState() {
    bloc = context.read<DrawerSubCategoriesBloc>();
    bloc?.add(FetchDrawerSubCategoryEvent(int.parse(widget.id ?? "${GlobalData.rootCategoryId}")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
        appBar: AppBar(
          title:Text(widget.title ?? ""),
          centerTitle: false,
        ),
        body: _subCategoriesList(),
      ),
    );
  }

  _subCategoriesList() {
    return BlocBuilder<DrawerSubCategoriesBloc, DrawerSubCategoriesState>(
      builder: (context, state){
        if(state is DrawerSubCategoryInitialState){
          isLoading = true;
        }

        else if(state is FetchDrawerSubCategoryState){
          isLoading = false;
          if(state.status == Status.success){
            categoriesData = state.getCategoriesData;
          }
          else if(state.status == Status.fail){}
        }

        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {});
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Stack(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: categoriesData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      HomeCategories? item = categoriesData?.data?[index];

                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.spacingMedium),
                          child: Text(
                            item?.name ?? "",
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, categoryScreen, arguments:
                          CategoriesArguments(categorySlug: item?.slug, title: item?.name,
                              id: item?.categoryId.toString()));
                        },
                      );
                    }),
                Visibility(visible: isLoading, child: const Loader())
              ],
            ),
          ),
        );
      },
    );
  }
}
