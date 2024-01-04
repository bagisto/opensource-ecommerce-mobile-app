import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';

Widget shippingPaymentInfo(
    BuildContext context, OrderDetail? orderDetailModel) {
  return Container(
    padding: const EdgeInsets.all(AppSizes.spacingNormal),
    margin: const EdgeInsets.all(AppSizes.spacingNormal),
    child: Column(
      children: [
        const SizedBox(height: AppSizes.spacingNormal),
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
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(StringConstants.shippingAddress.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(
                height: AppSizes.spacingMedium,
              ),
              CommonWidgets().getDrawerTileText(
                  "${orderDetailModel?.shippingAddress?.firstName ?? ""} ${orderDetailModel?.shippingAddress?.lastName ?? ""}",
                  context,
                  isBold: true),
              const SizedBox(height: AppSizes.spacingNormal),
              _getFormattedAddress(orderDetailModel!),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(
                StringConstants.contact.localized() +
                    (orderDetailModel.shippingAddress?.phone ?? ""),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Text(StringConstants.billingAddress.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(
                height: AppSizes.spacingNormal,
              ),
              CommonWidgets().getDrawerTileText(
                  "${orderDetailModel.billingAddress?.firstName ?? ""} ${orderDetailModel.billingAddress?.lastName ?? ""}",
                  context,
                  isBold: true),
              const SizedBox(height: AppSizes.spacingNormal),
              _getFormattedBillingAddress(orderDetailModel),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(
                StringConstants.contact.localized() +
                    (orderDetailModel.billingAddress?.phone ?? ""),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(StringConstants.shippingMethod.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(orderDetailModel.shippingTitle ?? ""),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(StringConstants.paymentMethod.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSizes.spacingNormal),
              Text(
                orderDetailModel.payment?.methodTitle ?? "",
              ),
              // Text(orderDetailModel?.data.me),
            ],
          ),
        ),
      ],
    ),
  );
}

_getFormattedAddress(OrderDetail orderDetailModel) {
  return Text(
    "${orderDetailModel.shippingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""},${orderDetailModel.shippingAddress?.city ?? ""},${orderDetailModel.shippingAddress?.state ?? ""},${orderDetailModel.shippingAddress?.country ?? ""},${orderDetailModel.shippingAddress?.postcode ?? ""}",
    style: const TextStyle(fontSize: 18),
  );
}

_getFormattedBillingAddress(OrderDetail orderDetailModel) {
  return Text(
    "${orderDetailModel.billingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""},${orderDetailModel.billingAddress?.city ?? ""},${orderDetailModel.billingAddress?.state ?? ""},${orderDetailModel.billingAddress?.country ?? ""},${orderDetailModel.billingAddress?.postcode ?? ""}",
    style: const TextStyle(fontSize: 18),
  );
}
