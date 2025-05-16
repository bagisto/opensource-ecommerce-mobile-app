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
import 'package:bagisto_app_demo/screens/order_detail/widgets/shipping_payment_info.dart';

import '../../../utils/extension.dart';

class OrderDetailTile extends StatelessWidget with OrderStatusBGColorHelper {
  final OrderDetail? orderDetailModel;
  final int? orderId;
  final OrderDetailBloc? orderDetailBloc;
  final bool? isLoading;

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
          color: Theme.of(context).colorScheme.onPrimary,
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
                        topLeft: Radius.circular(AppSizes.spacingMedium),
                        topRight: Radius.circular(AppSizes.spacingMedium)),
                  ),
                  padding: const EdgeInsets.all(AppSizes.spacingNormal),
                  margin: const EdgeInsets.all(AppSizes.spacingNormal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.spacingNormal),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              StringConstants.orderWithHash.localized() +
                                  (orderDetailModel?.incrementId ?? ""),
                              style: Theme.of(context).textTheme.headlineSmall),
                          orderDetailModel?.status?.toLowerCase() ==
                                  StringConstants.pending
                                      .localized()
                                      .toLowerCase()
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 30)),
                                    maximumSize: MaterialStateProperty.all(
                                        const Size(140, 100)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            MobiKulTheme.primaryColor),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: Text(StringConstants
                                                .pleaseConfirm
                                                .localized()),
                                            content: Text(
                                              StringConstants.confirmOrder
                                                  .localized(),
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
                                                    StringConstants.cancelLbl
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
                                                          MobiKulTheme
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
                                                      StringConstants.ok
                                                          .localized(),
                                                      style: const TextStyle(
                                                          color: MobiKulTheme
                                                              .primaryColor))),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    StringConstants.cancel.localized(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingNormal),
                      const Divider(),
                      const SizedBox(height: AppSizes.spacingNormal),
                      const SizedBox(height: AppSizes.spacingNormal),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orderDetailModel?.createdAt ?? ""),
                          Container(
                            padding:
                                const EdgeInsets.all(AppSizes.spacingNormal),
                            color:
                                getOrderBgColor(orderDetailModel?.status ?? ""),
                            child: Text(
                              orderDetailModel?.status ?? "".toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingNormal),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0,
                      AppSizes.spacingNormal, AppSizes.spacingNormal),
                  margin: const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0,
                      AppSizes.spacingNormal, AppSizes.spacingNormal),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(orderDetailModel?.items?.length.toString() ?? "",
                              style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: AppSizes.spacingSmall),
                          Text(
                              StringConstants.itemOrdered
                                  .localized()
                                  .toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge),
                          const Spacer(),
                          if (orderDetailModel?.items
                                  ?.any((item) => item.type == 'bundle') !=
                              true)
                            GestureDetector(
                              onTap: () {
                                orderDetailBloc?.add(ReOrderEvent(
                                    orderDetailModel?.id.toString()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                                padding: const EdgeInsets.all(
                                    AppSizes.spacingWide / 2),
                                child: Text(
                                  StringConstants.reOrder.localized(),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingNormal),
                      const Divider(),
                      const SizedBox(height: AppSizes.spacingNormal),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                                          horizontal: AppSizes.spacingNormal),
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
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                              height: AppSizes.spacingNormal),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  StringConstants.qty
                                                      .localized(),
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
                                                        "${StringConstants.ordered.localized()}     ${orderDetailModel?.items?[itemIndex].qtyOrdered.toString() ?? ""}",
                                                        style: const TextStyle(
                                                            letterSpacing:
                                                                0.2)),
                                                    const SizedBox(
                                                        height: AppSizes
                                                            .spacingNormal),
                                                    Text(
                                                      "${StringConstants.shipped.localized()}      ${orderDetailModel?.items![itemIndex].qtyShipped.toString() ?? ""}",
                                                    ),
                                                    const SizedBox(
                                                        height: AppSizes
                                                            .spacingNormal),
                                                    Text(
                                                      "${StringConstants.cancelled.localized()}  ${orderDetailModel?.items![itemIndex].qtyCanceled.toString() ?? ""}",
                                                      style: const TextStyle(
                                                          letterSpacing: 0.2),
                                                    ),
                                                    const SizedBox(
                                                        height: AppSizes
                                                            .spacingNormal),
                                                    Text(
                                                        "${StringConstants.refunded.localized()}   ${orderDetailModel?.items![itemIndex].qtyRefunded.toString() ?? ""}",
                                                        style: const TextStyle(
                                                            letterSpacing:
                                                                0.1)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: AppSizes.spacingMedium),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  StringConstants.price
                                                      .localized(),
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
                                          const SizedBox(
                                              height: AppSizes.spacingMedium),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  StringConstants.subTotal
                                                      .localized(),
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
                                          const SizedBox(
                                              height: AppSizes.spacingMedium),
                                          ...?getAttributesValueFromAdditional(
                                                  orderDetailModel
                                                      ?.items![itemIndex]
                                                      .additional)
                                              ?.map((item) => Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              item['attribute_name'] ??
                                                                  "",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              item["option_label"] ??
                                                                  "",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: AppSizes
                                                              .spacingMedium),
                                                    ],
                                                  ))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: orderDetailModel?.items!.length ?? 0)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0,
                      AppSizes.spacingNormal, AppSizes.spacingNormal),
                  margin: const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0,
                      AppSizes.spacingNormal, AppSizes.spacingNormal),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              StringConstants.priceDetails
                                  .localized()
                                  .toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge)
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingNormal),
                      const Divider(),
                      const SizedBox(height: AppSizes.spacingNormal),
                      Column(children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingSmall),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  StringConstants.subTotal.localized(),
                                  context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel?.formattedPrice?.subTotal ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingSmall),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  StringConstants.shippingHandling.localized(),
                                  context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel
                                          ?.formattedPrice?.shippingAmount ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  StringConstants.tax.localized(), context),
                              CommonWidgets().getDrawerTileText(
                                  orderDetailModel?.formattedPrice?.taxAmount ??
                                      "",
                                  context),
                            ],
                          ),
                        ),
                        orderDetailModel?.formattedPrice?.discountAmount !=
                                "\$0.00"
                            ? Container(
                                padding:
                                    const EdgeInsets.all(AppSizes.spacingSmall),
                                // color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWidgets().getDrawerTileText(
                                        StringConstants.discount.localized(),
                                        context),
                                    CommonWidgets().getDrawerTileText(
                                        orderDetailModel?.formattedPrice
                                                ?.discountAmount ??
                                            "",
                                        context),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spacingSmall),
                          // color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets().getDrawerTileText(
                                  StringConstants.grandTotal.localized(),
                                  context),
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
                const SizedBox(height: AppSizes.spacingNormal),
                if ((orderDetailModel?.items ?? []).isNotEmpty &&
                    orderDetailModel?.items?[0].qtyInvoiced != 0)
                  shipmentInvoiceDetails(StringConstants.invoiceDetails,
                      invoiceDetails, orderDetailModel, context),
                if ((orderDetailModel?.items ?? []).isNotEmpty &&
                    orderDetailModel?.items?[0].qtyShipped != 0)
                  const SizedBox(height: AppSizes.spacingNormal),
                if ((orderDetailModel?.items ?? []).isNotEmpty &&
                    orderDetailModel?.items?[0].qtyShipped != 0)
                  shipmentInvoiceDetails(StringConstants.shipmentDetails,
                      shipmentDetails, orderDetailModel, context),
                if ((orderDetailModel?.items ?? []).isNotEmpty &&
                    orderDetailModel?.items?[0].qtyRefunded != 0)
                  const SizedBox(height: AppSizes.spacingNormal),
                if ((orderDetailModel?.items ?? []).isNotEmpty &&
                    orderDetailModel?.items?[0].qtyRefunded != 0)
                  shipmentInvoiceDetails(StringConstants.refundDetails,
                      refundDetails, orderDetailModel, context),
                const SizedBox(height: AppSizes.spacingNormal),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.spacingNormal),
                  child: ShippingAndPaymentInfo(
                    orderDetailModel: orderDetailModel,
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

  shipmentInvoiceDetails(
      String title, String route, OrderDetail? argument, BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingNormal, vertical: 5.0),
        alignment: Alignment.center,
        height: AppSizes.buttonHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingNormal,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title.localized().toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.background),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route, arguments: argument);
      },
    );
  }
}
