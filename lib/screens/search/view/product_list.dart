import 'package:flutter/material.dart';

import '../../../common_widget/common_widgets.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../routes/route_constants.dart';
import '../../homepage/view/homepage_view.dart';
import 'package:collection/collection.dart';
class ProductList extends StatelessWidget {
  final CategoriesProductModel model;

  const ProductList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.data?.length,
        itemBuilder: (BuildContext context, int index) {
          Data product = model.data![index];
          var productFlats = product.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProductPage,
                  arguments: PassProductData(
                      title: productFlats?.name ?? "",
                      productId: int.parse(product.id ?? "")));
            },
            child: Card(
              margin: const EdgeInsets.only(top: 6),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.normalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.images!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(80.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image:
                                NetworkImage(product.images?.first.url ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.normalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productFlats?.name ?? ""),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  productFlats?.maxPrice ==
                                      productFlats?.minPrice
                                      ? CommonWidgets().priceText(
                                          product.priceHtml?.regular ?? "")
                                      :
                                      CommonWidgets().priceText(
                                          product.priceHtml?.special ?? ""),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  productFlats?.maxPrice ==
                                      productFlats?.minPrice
                                      ? const Text("")
                                      : Text(product.priceHtml?.regular ?? "",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
