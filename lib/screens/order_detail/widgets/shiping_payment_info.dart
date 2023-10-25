import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/order_model/order_detail_model.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/common_widgets.dart';
import '../../../configuration/app_sizes.dart';

Widget shippingPaymentInfo(
    BuildContext context, OrderDetail? orderDetailModel) {
  return Container(
    padding: const EdgeInsets.all(AppSizes.normalPadding),
    margin: const EdgeInsets.all(AppSizes.normalPadding),
    child: Column(
      children: [
        CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
        Row(
          children: [
            Text(
              "ShippingAndPaymentInfo".localized().toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.normalFontSize,
              ),
            ),
          ],
        ),
        CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
        CommonWidgets().divider(),
        CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.normalPadding),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "ShippingAddress".localized().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.normalFontSize,
                ),
              ),
              const SizedBox(
                height: AppSizes.genericPadding,
              ),
              CommonWidgets().getDrawerTileText(
                  "${orderDetailModel?.shippingAddress?.firstName ?? ""} ${orderDetailModel?.shippingAddress?.lastName ?? ""}",
                  context,
                  isBold: true),
              CommonWidgets().getTextFieldHeight(8),
              _getFormattedAddress(orderDetailModel!),
              CommonWidgets().getTextFieldHeight(8),
              Text(
             "Contact".localized() +
                    (orderDetailModel.shippingAddress?.phone ?? ""),
                style: const TextStyle(fontSize: 18),
              ),
              CommonWidgets().getTextFieldHeight(12),
              Text(
                "BillingAddress".localized().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppSizes.normalFontSize,
                ),
              ),
              const SizedBox(
                height: AppSizes.genericPadding,
              ),
              CommonWidgets().getDrawerTileText(
                  "${orderDetailModel.billingAddress?.firstName ?? ""} ${orderDetailModel.billingAddress?.lastName ?? ""}",
                  context,
                  isBold: true),
              CommonWidgets().getTextFieldHeight(8),
              _getFormattedBillingAddress(orderDetailModel),
              CommonWidgets().getTextFieldHeight(8),
              Text(
                "Contact".localized() +
                    (orderDetailModel.billingAddress?.phone ?? ""),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.normalPadding),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "ShippingMethod".localized().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.normalFontSize,
                ),
              ),
              CommonWidgets().getTextFieldHeight(4),
              Text(orderDetailModel.shippingTitle ?? ""),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.normalPadding),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "PaymentMethod".localized().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.normalFontSize,
                ),
              ),
              CommonWidgets().getTextFieldHeight(4),
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
