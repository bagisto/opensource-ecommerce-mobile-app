/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: implementation_imports, file_names, must_be_immutable

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/image_view.dart';
import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/add_delete_wishlist_category_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/addtocart_sub_categories_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/addtocompare_subcategories_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../../../Configuration/mobikul_theme.dart';
import '../../../../common_widget/show_message.dart';
import '../../../../models/categories_data_model/categories_product_model.dart';
import '../../../../routes/route_constants.dart';
import '../../../configuration/app_global_data.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/sub_categories_bloc.dart';
import '../events/loader_sub_categories_event.dart';
import 'package:collection/collection.dart';

class SubCategoriesList extends StatelessWidget {
  bool? isLogin;
  Data? data;
  SubCategoryBloc? subCategoryBloc;

  SubCategoriesList(
      {Key? key, this.isLogin, required this.data, this.subCategoryBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productFlats = data?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductPage,
            arguments: PassProductData(
                title: productFlats?.name ?? "",
                productId: int.parse(data?.id ?? "")));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: AppSizes.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 2.08,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Stack(
                      children: [
                        (data?.images ?? []).isNotEmpty
                            ? ImageView(
                          url: data?.images?[0].url ?? "",
                          width: MediaQuery.of(context).size.width / 3,
                        )
                            : ImageView(
                          url: "",
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        if (productFlats?.isNew ?? true)
                          Positioned(
                              left: AppSizes.spacingTiny,
                              top: AppSizes.spacingTiny,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppSizes.size8,
                                        right: AppSizes.size8,
                                        top: AppSizes.size2,
                                        bottom: AppSizes.spacingTiny),
                                    child: Text(
                                      "New".localized(),
                                      style: const TextStyle(color: Colors.white),
                                    )),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.mediumPadding),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 160,
                              child: Text(productFlats?.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16))),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.normalPadding),
                          CommonWidgets()
                              .priceText(data?.priceHtml?.regular ?? ""),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.normalPadding),
                          if ((data?.reviews ?? []).isNotEmpty &&
                              data?.reviews != null)
                            Row(
                              children: [
                                Row(
                                    children: List.generate(
                                        5,
                                            (index) => (index >=
                                            num.parse(data?.reviews?[0].rating
                                                .toString() ??
                                                ""))
                                            ? Icon(
                                          Icons.star_border,
                                          color: MobikulTheme().getColor(
                                              double.parse(data
                                                  ?.reviews?[0].rating
                                                  .toString() ??
                                                  "")),
                                          size: 16.0,
                                        )
                                            : Icon(
                                          Icons.star,
                                          color: MobikulTheme().getColor(
                                              double.parse(data
                                                  ?.reviews?[0].rating
                                                  .toString() ??
                                                  "")),
                                          size: 16.0,
                                        ))),
                              ],
                            ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.extraPadding),
                          CommonWidgets().appButton(
                              context,
                              ApplicationLocalizations.of(context)!
                                  .translate("AddToCart"),
                              SubcategoryScreenButtonWith, () {
                            subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                                isReqToShowLoader: true));
                            if (data?.type == simple) {
                              SubCategoryBloc subCategories =
                              context.read<SubCategoryBloc>();

                              var dict = <String, dynamic>{};
                              dict['product_id'] = data?.id ?? '';
                              dict['quantity'] = 1;
                              subCategories.add(AddToCartSubCategoriesEvent(
                                  (data?.id ?? ""), 1, ""));
                            } else {
                              ShowMessage.showNotification(
                                  "addOptions".localized(),
                                  "",
                                  Colors.yellow,
                                  const Icon(Icons.warning_amber));
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: false));
                            }
                          })
                        ],
                      ),
                      Positioned(
                          right: 0,
                          top: 4.0,
                          child: InkWell(
                            onTap: () {
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: true));
                              if (isLogin ?? false) {
                                if (data?.isInWishlist ?? false) {
                                  subCategoryBloc?.add(FetchDeleteItemEvent(
                                      int.parse(data?.id ?? ""), data));
                                } else {
                                  subCategoryBloc?.add(
                                      FetchDeleteAddItemCategoryEvent(
                                          data?.id, data!));
                                }
                              } else {
                                ShowMessage.showNotification(
                                    "pleaseLogin".localized(),
                                    "",
                                    Colors.yellow,
                                    const Icon(Icons.warning_amber));
                                subCategoryBloc?.add(
                                    OnClickSubCategoriesLoaderEvent(
                                        isReqToShowLoader: false));
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(19)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: data?.isInWishlist ?? false
                                    ? Icon(Icons.favorite,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: 14)
                                    : Icon(Icons.favorite_outline_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: 14)),
                          )),
                      Positioned(
                        right: 0,
                        top: 40,
                        child: InkWell(
                          onTap: () {
                            if (isLogin == true) {
                              subCategoryBloc?.add(
                                  OnClickSubCategoriesLoaderEvent(
                                      isReqToShowLoader: true));
                              subCategoryBloc?.add(AddToCompareSubCategoryEvent(
                                  productFlats?.id ?? "", ""));
                            } else {
                              ShowMessage.showNotification(
                                  "pleaseLogin".localized(),
                                  "",
                                  Colors.yellow,
                                  const Icon(Icons.warning_amber));
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(
                                AppSizes.spacingTiny + AppSizes.size2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onBackground,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/images/compare-icon.png",
                                height: 18,
                                width: 18,
                                color: Colors.grey,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
