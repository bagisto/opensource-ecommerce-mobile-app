/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../utils/cart_index.dart';

class PriceDetailView extends StatelessWidget {
  final CartModel cartDetailsModel;

  const PriceDetailView({Key? key, required this.cartDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            title: Text(
              StringConstants.priceDetails.localized(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.spacingMedium, 0, AppSizes.spacingMedium, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.subTotal.localized(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      cartDetailsModel.formattedPrice?.subTotal.toString() ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium,
                    AppSizes.spacingSmall, AppSizes.spacingMedium, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.discount.localized(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      cartDetailsModel.formattedPrice?.discountAmount != null
                          ? cartDetailsModel.formattedPrice?.discountAmount.toString() ?? ""
                          : "${GlobalData.currencySymbol}0.0",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              cartDetailsModel.taxTotal > 0
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingMedium, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1), // Left border
                          bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1), // Right border
                        ),
                      ),
                      child: ExpansionTile(
                        iconColor: Colors.grey,
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConstants.tax.localized(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              cartDetailsModel.formattedPrice?.taxTotal
                                      ?.toString() ??
                                  "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...?cartDetailsModel.appliedTaxRates
                                  ?.map((taxRate) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          taxRate.taxName.trim(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          taxRate.totalAmount,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium,
                          AppSizes.spacingSmall, AppSizes.spacingMedium, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.tax.localized(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            cartDetailsModel.formattedPrice?.taxTotal
                                    ?.toString() ??
                                "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              Container(
                padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium,
                    AppSizes.spacingSmall, AppSizes.spacingMedium, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StringConstants.grandTotal.localized(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      cartDetailsModel.formattedPrice?.grandTotal.toString() ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.spacingMedium,
              ),
            ]),
      ),
    );
  }
}
