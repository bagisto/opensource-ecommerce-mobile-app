// ignore_for_file: must_be_immutable

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common_widget/common_widgets.dart';
import '../../../../common_widget/image_view.dart';
import '../../../../common_widget/show_message.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../configuration/mobikul_theme.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/categories_data_model/categories_product_model.dart';
import '../../../../routes/route_constants.dart';
import '../../../configuration/app_global_data.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/sub_categories_bloc.dart';
import '../events/add_delete_wishlist_category_event.dart';
import '../events/addtocart_sub_categories_event.dart';
import '../events/addtocompare_subcategories_event.dart';
import '../events/loader_sub_categories_event.dart';
import 'package:collection/collection.dart';

class SubCategoriesGridView extends StatelessWidget {
  bool? isLogin;
  Data? data;
  SubCategoryBloc? subCategoryBloc;

  SubCategoriesGridView(
      {this.isLogin, this.data, this.subCategoryBloc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productFlats = data?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductPage,
            arguments: PassProductData(
              title: productFlats?.name ?? "",
              productId: int.parse(data?.id ?? ""),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  Stack(
                    children: [
                      (data?.images ?? []).isNotEmpty
                          ? Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: ImageView(
                          url: data?.images![0].url ?? "",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4.5,
                        ),
                      )
                          : ImageView(
                        url: "",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4.5,
                      ),
                      if (productFlats?.isNew ?? true)
                        Positioned(
                            left: AppSizes.normalHeight,
                            top: AppSizes.normalHeight,
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
                  Positioned(
                      right: AppSizes.size14,
                      top: AppSizes.size14,
                      child: InkWell(
                        onTap: () {
                          subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                              isReqToShowLoader: true));
                          if (isLogin ?? false) {
                            if (data?.isInWishlist ?? false) {
                              subCategoryBloc?.add(FetchDeleteItemEvent(
                                  int.parse(data?.id ?? ""), data));
                            } else {
                              subCategoryBloc?.add(
                                  FetchDeleteAddItemCategoryEvent(
                                      data?.id, data));
                            }
                          } else {
                            ShowMessage.showNotification(
                                "pleaseLogin".localized(),
                                "",
                                Colors.yellow,
                                const Icon(Icons.warning_amber));
                            subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                                isReqToShowLoader: false));
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                    right: 14.0,
                    top: 50.0,
                    child: InkWell(
                      onTap: () {
                        if (isLogin == true) {
                          subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                              isReqToShowLoader: true));
                          subCategoryBloc?.add(AddToCompareSubCategoryEvent(
                              productFlats?.id ?? "", ""));
                        } else {
                          ShowMessage.showNotification("pleaseLogin".localized(),
                              "", Colors.yellow, const Icon(Icons.warning_amber));
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
                            color: Colors.grey[500],
                          )),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          productFlats?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10),
                  child: Text(
                    data?.priceHtml?.regular ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                ((data?.reviews ?? []).isNotEmpty && data?.reviews != null)?
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.spacingTiny,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      Row(
                          children: List.generate(
                              5,
                                  (i) => (i >=
                                  num.parse(
                                      data?.reviews?[0].rating.toString() ??
                                          ""))
                                  ? Icon(
                                Icons.star_border,
                                color: MobikulTheme().getColor(
                                    double.parse(data?.reviews?[0].rating
                                        .toString() ??
                                        "")),
                                size: 16.0,
                              )
                                  : Icon(
                                Icons.star,
                                color: MobikulTheme().getColor(
                                    double.parse(data?.reviews?[0].rating
                                        .toString() ??
                                        "")),
                                size: 16.0,
                              ))),
                    ],
                  ),
                ):const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,8,8,0),
                  child: CommonWidgets().appButton(
                      context,
                      "AddToCart".localized(),
                      MediaQuery.of(context).size.width, () {
                    subCategoryBloc?.add(
                        OnClickSubCategoriesLoaderEvent(isReqToShowLoader: true));
                    if (data?.type == simple) {
                      var dict = <String, dynamic>{};
                      dict['product_id'] = data?.id ?? '';
                      dict['quantity'] = 1;
                      subCategoryBloc?.add(AddToCartSubCategoriesEvent((data?.id ?? ""), 1, ""));
                    } else {
                      ShowMessage.showNotification("addOptions".localized(), "",
                          Colors.yellow, const Icon(Icons.warning_amber));
                      subCategoryBloc?.add(OnClickSubCategoriesLoaderEvent(
                          isReqToShowLoader: false));
                    }
                  }),
                )
              ],
            )),
      ),
    );
  }
}
