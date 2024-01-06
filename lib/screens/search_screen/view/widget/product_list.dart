import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_global_data.dart';
import '../../../home_page/data_model/new_product_data.dart';
import '../../../home_page/utils/route_argument_helper.dart';

class ProductList extends StatelessWidget {
  final NewProductsModel? model;
  const ProductList({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model?.data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          NewProducts? product = model?.data?[index];
          var productFlats = product?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, productScreen,
                  arguments: PassProductData(
                      title: productFlats?.name,
                      urlKey: productFlats?.urlKey,
                      productId: int.parse(product?.id ?? "")));
            },
            child: Card(
              margin: const EdgeInsets.only(top: 6),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacingNormal),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((product?.images ?? []).isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSizes.spacingWide*4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image:
                            NetworkImage(product?.images?.first.url ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding:  const EdgeInsets.all(AppSizes.spacingNormal),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productFlats?.name ?? ""),
                              const SizedBox(
                                height: 12,
                              ),
                             Text(product?.priceHtml?.formattedFinalPrice ?? "")
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
