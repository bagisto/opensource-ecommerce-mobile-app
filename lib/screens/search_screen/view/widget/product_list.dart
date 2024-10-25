/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/order_detail/utils/index.dart';
import 'package:bagisto_app_demo/screens/search_screen/utils/index.dart';

import '../../../../utils/prefetching_helper.dart';

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

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, productScreen,
                  arguments: PassProductData(
                      title: product?.name,
                      urlKey: product?.urlKey,
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
                    ((product?.images ?? []).isNotEmpty) ?
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: ImageView(url: product?.images?.first.url ?? "", fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width / 3,
                          height:
                          MediaQuery.of(context).size.height * 0.2),
                      ) :
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: ImageView(url: "",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width / 3,
                          height:
                          MediaQuery.of(context).size.height * 0.2),
                    ),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding:  const EdgeInsets.all(AppSizes.spacingNormal),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product?.name ?? ""),
                              const SizedBox(
                                height: 12,
                              ),
                             Text(product?.priceHtml?.formattedFinalPrice ?? product?.priceHtml?.formattedRegularPrice ?? "")
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
