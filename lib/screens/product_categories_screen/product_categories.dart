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

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/models/homepage_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/screens/homepage/view/homepage.dart';
import 'package:flutter/material.dart';

import '../../configuration/app_global_data.dart';
import '../../configuration/app_sizes.dart';
import '../../routes/route_constants.dart';

class ProductCategoriesList extends StatefulWidget {
  String? title;
  HomeCategories? category;

  ProductCategoriesList({Key? key, this.title, this.category})
      : super(key: key);

  @override
  State<ProductCategoriesList> createState() => _ProductCategoriesListState();
}

class _ProductCategoriesListState extends State<ProductCategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
      appBar: AppBar(
        title: CommonWidgets.getHeadingText(widget.title ?? "", context),
        centerTitle: false,
      ),
      body: _subCategoriesList(widget.category!),
      ),
    );
  }

  ///sub categories product list
  _subCategoriesList(HomeCategories category) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: category.children!.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.normalHeight),
                child: Text(
                  category.children![index].name ?? "",
                  style: const TextStyle(
                    fontSize: AppSizes.normalFontSize,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, SubCategory,
                    arguments: CategoryProductData(
                        metaDescription: category.children![index].description,
                        categorySlug: category.children![index].slug,
                        title: category.children![index].name,
                        image: ""));
              },
            );
          }),
    );
  }
}
