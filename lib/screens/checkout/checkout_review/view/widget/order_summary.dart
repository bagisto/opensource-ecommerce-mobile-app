/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/checkout/data_model/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

class OrderSummary extends StatelessWidget {
  final SavePayment savePaymentModel;

  const OrderSummary({Key? key, required this.savePaymentModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.fromLTRB(
          0, AppSizes.spacingNormal, 0, AppSizes.spacingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                StringConstants.orderSummary.localized().toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.spacingNormal,
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const SizedBox(
            height: AppSizes.spacingNormal,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int itemIndex) {
                var productFlats = savePaymentModel.cart?.items?[itemIndex];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spacingSmall, horizontal: AppSizes.spacingNormal),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (savePaymentModel.cart?.items?[itemIndex].product
                                            ?.images ??
                                        [])
                                    .isNotEmpty
                                ? ImageView(
                                    url: (savePaymentModel
                                            .cart
                                            ?.items?[itemIndex]
                                            .product
                                            ?.images?[0]
                                            .url ??
                                        ""),
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                  )
                                : ImageView(
                                    url: "",
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.spacingNormal),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  productFlats?.name ?? "",
                                  style: const TextStyle(
                                    fontSize: AppSizes.spacingLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  StringConstants.cartPageQtyLabel.localized(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  productFlats?.quantity.toString() ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "${StringConstants.price.localized()} - ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${savePaymentModel.cart?.items?[itemIndex].formattedPrice?.price ?? ""}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.spacingNormal,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  StringConstants.cartPageSubtotalLabel
                                      .localized(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${savePaymentModel.cart?.items?[itemIndex].formattedPrice?.total ?? "\$10"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int itemIndex) {
                return CommonWidgets().divider();
              },
              itemCount: savePaymentModel.cart?.items?.length ?? 0),
        ],
      ),
    );
  }
}
