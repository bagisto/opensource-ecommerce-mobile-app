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
class ShippingAndPaymentInfo extends StatelessWidget {
  final  OrderDetail? orderDetailModel;

  const ShippingAndPaymentInfo({Key? key, this.orderDetailModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                StringConstants.shippingAndPaymentInfo
                    .localized()
                    .toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: AppSizes.spacingNormal),
        const Divider(),
        const SizedBox(height: AppSizes.spacingNormal),
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (orderDetailModel?.shippingAddress != null)
                getShippingAddress(orderDetailModel, context),
              const SizedBox(height: AppSizes.spacingMedium),
              Text(
                  StringConstants.billingAddress
                      .localized()
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(
                (orderDetailModel?.billingAddress?.companyName ??
                    ""),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Text(
                "${orderDetailModel?.billingAddress?.firstName ?? ""} ${orderDetailModel?.billingAddress?.lastName ?? ""}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              _getFormattedBillingAddress(
                  orderDetailModel!, context),
              const SizedBox(height: AppSizes.spacingSmall),
              Text(
                "${StringConstants.contact.localized()} ${orderDetailModel?.billingAddress?.phone ?? ""}",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        if (orderDetailModel?.shippingTitle != null)
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spacingMedium),
            alignment: GlobalData.locale == "ar"
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    StringConstants.shippingMethod
                        .localized()
                        .toUpperCase(),
                    style:
                    Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSizes.spacingNormal),
                Text(orderDetailModel?.shippingTitle ?? ""),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingNormal),
          alignment: GlobalData.locale == "ar"
              ? Alignment.topRight
              : Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                StringConstants.paymentMethod
                    .localized()
                    .toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(
                orderDetailModel?.payment?.methodTitle ?? "",
              ),
            ],
          ),
        ),
      ],
    );
  }
  _getFormattedBillingAddress(
      OrderDetail orderDetailModel, BuildContext context) {
    return Text(
      "${orderDetailModel.billingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${orderDetailModel.billingAddress?.city ?? ""}, ${orderDetailModel.billingAddress?.state ?? ""}, ${orderDetailModel.billingAddress?.country ?? ""}, ${orderDetailModel.billingAddress?.postcode ?? ""}",
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  getShippingAddress(OrderDetail? orderDetailModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(StringConstants.shippingAddress.localized().toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSizes.spacingNormal),
        Text(
          (orderDetailModel?.shippingAddress?.companyName ?? ""),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 15,
          ),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          "${orderDetailModel?.shippingAddress?.firstName ?? ""} ${orderDetailModel?.shippingAddress?.lastName ?? ""}",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 15,
          ),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        _getFormattedAddress(orderDetailModel!, context),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          "${StringConstants.contact.localized()} ${orderDetailModel.shippingAddress?.phone ?? ""}",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: AppSizes.spacingMedium),
      ],
    );
  }
  _getFormattedAddress(OrderDetail orderDetailModel, BuildContext context) {
    return Text(
      "${orderDetailModel.shippingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${orderDetailModel.shippingAddress?.city ?? ""}, ${orderDetailModel.shippingAddress?.state ?? ""}, ${orderDetailModel.shippingAddress?.country ?? ""}, ${orderDetailModel.shippingAddress?.postcode ?? ""}",
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
