/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widget/circular_progress_indicator.dart';
import '../../../configuration/app_sizes.dart';
import '../../../common_widget/common_widgets.dart';
import '../../../common_widget/image_view.dart';
import '../../../helper/no_data_class.dart';
import '../../../helper/order_status_Bg_color_helper.dart';
import '../../../helper/string_constants.dart';
import '../../../models/order_model/order_detail_model.dart';
import '../bloc/order_detail_bloc.dart';
import '../event/order_detail_fetch_event.dart';

class OrderDetailTile extends StatelessWidget with OrderStatusBGColorHelper {
  OrderDetail? orderDetailModel;
  int? orderId;
  OrderDetailBloc? orderDetailBloc;
  bool? isLoading;

  OrderDetailTile(
      {this.orderDetailModel,
      this.orderId,
      this.orderDetailBloc,
      this.isLoading,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getOrderDetail(context),
    );
  }

  _getOrderDetail(BuildContext context) {
    if (orderDetailModel == null) {
      return const NoDataFound();
    } else {
      return Stack(children: [
        RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              OrderDetailBloc orderDetailBloc = context.read<OrderDetailBloc>();
              orderDetailBloc.add(OrderDetailFetchDataEvent(orderId));
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.normalHeight),
                        topRight: Radius.circular(AppSizes.normalHeight)),
                  ),
                  padding: const EdgeInsets.all(NormalPadding),
                  margin: const EdgeInsets.all(NormalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order#".localized() +
                                (orderDetailModel?.incrementId ?? ""),
                          ),
                          orderDetailModel?.status == "pending"
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 30)),
                                    maximumSize: MaterialStateProperty.all(
                                        const Size(140, 100)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            MobikulTheme.primaryColor),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Theme.of(context).colorScheme.background,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                        // side: BorderSide(color: Colors.red)
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: Text(
                                                'PleaseConfirm'.localized()),
                                            content: Text(
                                              'ConfirmOrder'.localized(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            actions: [
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4))),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'ButtonLabelCancel'
                                                        .localized(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary),
                                                  )),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                      backgroundColor:
                                                          MobikulTheme
                                                              .accentColor),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    orderDetailBloc?.add(
                                                        OnClickOrderLoadingEvent(
                                                            isReqToShowLoader:
                                                                true));
                                                    orderDetailBloc?.add(
                                                        CancelOrderEvent(
                                                            orderDetailModel
                                                                    ?.id ??
                                                                0,
                                                            ""));
                                                  },
                                                  child: Text(
                                                      'ButtonLabelOk'
                                                          .localized(),
                                                      style: TextStyle(
                                                          color: MobikulTheme
                                                              .primaryColor))),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "cancel".localized(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: MobikulTheme.primaryColor),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      CommonWidgets().divider(),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orderDetailModel?.createdAt ?? ""),
                          // const Text("1234566"),
                          Container(
                            padding: const EdgeInsets.all(NormalPadding),
                            color:
                                getOrderBgColor(orderDetailModel?.status ?? ""),
                            child: Text(
                              orderDetailModel?.status ?? "".toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  margin: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            orderDetailModel?.items!.length.toString() ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.normalFontSize,
                            ),
                          ),
                          CommonWidgets().getTextFieldWidth(MinWidth),
                          Text(
                            "Item(s)Ordered".localized().toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.normalFontSize,
                            ),
                          )
                        ],
                      ),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      CommonWidgets().divider(),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: (orderDetailModel?.items![itemIndex]
                                                    .product?.images ??
                                                [])
                                            .isNotEmpty
                                        ? ImageView(
                                            url: orderDetailModel
                                                    ?.items![itemIndex]
                                                    .product
                                                    ?.images?[0]
                                                    .url ??
                                                "",
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                      height: 210,
                                      fit: BoxFit.cover,
                                          )
                                        : ImageView(
                                            url: "",
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.3,
                                          ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: NormalPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            orderDetailModel
                                                    ?.items![itemIndex].name ??
                                                "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          CommonWidgets().getTextFieldHeight(
                                              NormalPadding),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Qty".localized(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Ordered".localized() +
                                                            "     " +
                                                            (orderDetailModel
                                                                    ?.items?[
                                                                        itemIndex]
                                                                    .qtyOrdered
                                                                    .toString() ??
                                                                ""),
                                                        style: const TextStyle(
                                                            letterSpacing:
                                                                0.2)),
                                                    CommonWidgets()
                                                        .getTextFieldHeight(
                                                            NormalPadding),
                                                    Text(
                                                      "Shipped".localized() +
                                                          "      " +
                                                          (orderDetailModel
                                                                  ?.items![
                                                                      itemIndex]
                                                                  .qtyShipped
                                                                  .toString() ??
                                                              ""),
                                                    ),
                                                    CommonWidgets()
                                                        .getTextFieldHeight(
                                                            NormalPadding),
                                                    Text(
                                                      "Cancelled".localized() +
                                                          "  " +
                                                          (orderDetailModel
                                                                  ?.items![
                                                                      itemIndex]
                                                                  .qtyCanceled
                                                                  .toString() ??
                                                              ""),
                                                      style: const TextStyle(
                                                          letterSpacing: 0.2),
                                                    ),
                                                    CommonWidgets()
                                                        .getTextFieldHeight(
                                                            NormalPadding),
                                                    Text(
                                                        "Refunded".localized() +
                                                            "   " +
                                                            (orderDetailModel
                                                                    ?.items![
                                                                        itemIndex]
                                                                    .qtyRefunded
                                                                    .toString() ??
                                                                ""),
                                                        style: const TextStyle(
                                                            letterSpacing:
                                                                0.1)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          CommonWidgets().getTextFieldHeight(
                                              MediumPadding),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Price".localized(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  orderDetailModel
                                                          ?.items![itemIndex]
                                                          .formattedPrice
                                                          ?.price ??
                                                      "",
                                                ),
                                              ),
                                            ],
                                          ),
                                          CommonWidgets().getTextFieldHeight(
                                              MediumPadding),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Subtotal".localized(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  orderDetailModel
                                                          ?.items![itemIndex]
                                                          .formattedPrice
                                                          ?.total ??
                                                      "",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return CommonWidgets().divider();
                          },
                          itemCount: orderDetailModel?.items!.length ?? 0)
                    ],
                  ),
                ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  margin: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "PriceDetails".localized().toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.normalFontSize,
                            ),
                          )
                        ],
                      ),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      CommonWidgets().divider(),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                      Column(children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingTiny),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  "Subtotal".localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel?.formattedPrice?.subTotal ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingTiny),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  "ShippingHandling".localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel
                                          ?.formattedPrice?.shippingAmount ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingTiny),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  "Tax".localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel?.formattedPrice?.taxAmount ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingTiny),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  "Discount".localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel?.formattedPrice
                                          ?.baseDiscountAmount ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingTiny),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  "GrandTotal".localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel
                                          ?.formattedPrice?.grandTotal ??
                                      "",
                                  context),
                            ],
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
                CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  margin: const EdgeInsets.fromLTRB(
                      NormalPadding, 0, NormalPadding, NormalPadding),
                  child: Column(
                    children: [
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
                      CommonWidgets()
                          .getTextFieldHeight(AppSizes.normalPadding),
                      CommonWidgets().divider(),
                      CommonWidgets()
                          .getTextFieldHeight(AppSizes.normalPadding),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.normalPadding),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (orderDetailModel?.shippingAddress != null)
                              getShippingAddress(orderDetailModel, context),
                            CommonWidgets()
                                .getTextFieldHeight(AppSizes.mediumPadding),
                            Text(
                              "BillingAddress".localized().toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.normalFontSize,
                              ),
                            ),
                            CommonWidgets()
                                .getTextFieldHeight(AppSizes.normalPadding),
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
                            const SizedBox(
                              height: AppSizes.linePadding,
                            ),
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
                            CommonWidgets()
                                .getTextFieldHeight(AppSizes.linePadding),
                            _getFormattedBillingAddress(orderDetailModel!),
                            CommonWidgets()
                                .getTextFieldHeight(AppSizes.linePadding),
                            Text(
                              "Contact".localized() +
                                  " " +
                                  (orderDetailModel?.billingAddress?.phone ??
                                      ""),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      if (orderDetailModel?.shippingTitle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.mediumPadding),
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
                              CommonWidgets().getTextFieldHeight(8),
                              Text(orderDetailModel?.shippingTitle ?? ""),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.normalPadding),
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
                            CommonWidgets().getTextFieldHeight(8),
                            Text(
                              orderDetailModel?.payment?.methodTitle ?? "",
                            ),
                            // Text(orderDetailModel?.data.me),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading ?? false)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicatorClass.circularProgressIndicator(
                  context),
            ),
          )
      ]);
    }
  }

  _getFormattedAddress(OrderDetail orderDetailModel) {
    return Text(
      "${orderDetailModel.billingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${orderDetailModel.shippingAddress?.city ?? ""}, ${orderDetailModel.shippingAddress?.state ?? ""}, ${orderDetailModel.shippingAddress?.country ?? ""}, ${orderDetailModel.shippingAddress?.postcode ?? ""}",
      style: const TextStyle(fontSize: 15),
    );
  }

  _getFormattedBillingAddress(OrderDetail orderDetailModel) {
    return Text(
      "${orderDetailModel.billingAddress?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${orderDetailModel.billingAddress?.city ?? ""}, ${orderDetailModel.billingAddress?.state ?? ""}, ${orderDetailModel.billingAddress?.country ?? ""}, ${orderDetailModel.billingAddress?.postcode ?? ""}",
      style: const TextStyle(fontSize: 15),
    );
  }

  getShippingAddress(OrderDetail? orderDetailModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ShippingAddress".localized().toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.normalFontSize,
          ),
        ),
        CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
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
        const SizedBox(
          height: AppSizes.linePadding,
        ),
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
        CommonWidgets().getTextFieldHeight(AppSizes.linePadding),
        _getFormattedAddress(orderDetailModel!),
        CommonWidgets().getTextFieldHeight(AppSizes.linePadding),
        Text(
          "Contact".localized() +
              " " +
              (orderDetailModel.shippingAddress?.phone ?? ""),
          style: const TextStyle(fontSize: 15),
        ),
        CommonWidgets().getTextFieldHeight(12),
      ],
    );
  }
}
