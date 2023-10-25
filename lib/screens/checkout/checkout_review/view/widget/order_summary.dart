import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../common_widget/common_widgets.dart';
import '../../../../../common_widget/image_view.dart';
import '../../../../../configuration/app_global_data.dart';
import '../../../../../configuration/app_sizes.dart';
import '../../../../../helper/string_constants.dart';
import '../../../../../models/checkout_models/save_payment_model.dart';
import 'package:collection/collection.dart';

class OrderSummary extends StatelessWidget {
  final SavePayment savePaymentModel;

  const OrderSummary({Key? key, required this.savePaymentModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSizes.spacingNormal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "OrderSummary".localized().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.normalFontSize,
                ),
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
            height: 8,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int itemIndex) {
                var productFlats = savePaymentModel.cart?.items![itemIndex].product?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.linePadding, horizontal: 6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (savePaymentModel.cart?.items?[itemIndex].product
                                            ?.images ??
                                        [])
                                    .isNotEmpty
                                ? ImageView(
                                    url: (imageUrl) +
                                        (savePaymentModel
                                                .cart
                                                ?.items![itemIndex]
                                                .product
                                                ?.images?[0]
                                                .path ??
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
                        padding:
                            const EdgeInsets.all(AppSizes.genericPaddingMin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  productFlats?.name ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: AppSizes.normalFontSize,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: NormalPadding,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "CartPageQtyLabel".localized(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  savePaymentModel
                                          .cart?.items![itemIndex].quantity
                                          .toString() ??
                                      "",
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
                                  "Price -".localized(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  savePaymentModel.cart?.items![itemIndex]
                                          .formattedPrice?.price
                                          .toString() ??
                                      "",
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
                                  "CartPageSubtotalLabel".localized(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  savePaymentModel.cart?.items![itemIndex]
                                          .formattedPrice?.total
                                          .toString() ??
                                      "",
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
