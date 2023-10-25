import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../common_widget/common_error_msg.dart';
import '../../../../common_widget/common_widgets.dart';
import '../../../../common_widget/image_view.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/order_model/order_detail_model.dart';
import '../../../../models/order_model/order_refund_model.dart';
import '../../order_detail/widgets/shiping_payment_info.dart';
import '../refund_bloc/refund_bloc.dart';
import '../refund_bloc/refund_event.dart';
import '../refund_bloc/refund_state.dart';

class OrderRefundListScreen extends StatefulWidget {
  final int orderId;
  final OrderDetail? orderDetailModel;

  const OrderRefundListScreen(
      {Key? key, this.orderDetailModel, required this.orderId})
      : super(key: key);

  @override
  State<OrderRefundListScreen> createState() => _OrderInvoiceListScreenState();
}

class _OrderInvoiceListScreenState extends State<OrderRefundListScreen> {
  RefundListBloc? refundBloc;
  OrderRefundModel? refundModel;
  int page = 1;

  @override
  void initState() {
    refundBloc = context.read<RefundListBloc>();
    refundBloc
        ?.add(RefundListFetchDataEvent(page: page, orderId: widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonWidgets.getHeadingText("Refunds".localized(), context),
      ),
      body: _orderDetail(context),
    );
  }

  _orderDetail(BuildContext context) {
    return BlocConsumer<RefundListBloc, RefundListBaseState>(
      listener: (BuildContext context, RefundListBaseState state) {},
      builder: (BuildContext context, RefundListBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, RefundListBaseState state) {
    if (state is RefundListInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is RefundListFetchDataState) {
      if (state.status == RefundListStatus.success) {
        refundModel = state.refundModel;
      }
      if (state.status == RefundListStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...getRefundInfo(),
          CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
          shippingPaymentInfo(context, widget.orderDetailModel),
        ],
      ),
    );
  }

  List<Widget> getRefundInfo() {
    List<Widget> widget = [];

    refundModel?.viewRefunds?.forEach((ViewRefunds? element) {
      widget.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
        child: Text(
          "Refund".localized() + " #${element?.id}",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.grey),
        ),
      ));
      widget.add(invoiceItem(element));
      widget.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: Text(
              "PriceDetails".localized().toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.normalFontSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: CommonWidgets().divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spacingTiny),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets()
                        .getDrawerTileText("Subtotal".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        (element?.formattedPrice?.subTotal) ?? "", context),
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
                        (element?.formattedPrice?.shippingAmount) ?? "",
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
                        "AdjustmentRefund".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        (element?.formattedPrice?.adjustmentRefund) ?? "",
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
                        "AdjustmentFee".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        (element?.formattedPrice?.adjustmentFee) ?? "",
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
                        "GrandTotal".localized(), context,
                        isBold: true),

                    CommonWidgets().getDrawerTileText(
                        (element?.formattedPrice?.grandTotal) ?? "", context,
                        isBold: true),
                  ],
                ),
              )
            ]),
          ),
        ],
      ));
    });

    return widget;
  }

  Widget invoiceItem(ViewRefunds? element) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          RefundItems? item = element?.items?[idx];
          return Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ImageView(
                        url: item?.product?.images?[0].url ?? "",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: NormalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item?.sku ?? "",
                              style: const TextStyle(fontSize: 18),
                            ),
                            CommonWidgets().getTextFieldHeight(NormalPadding),
                            Text(
                              item?.name ?? "",
                              style: const TextStyle(fontSize: 15),
                            ),
                            CommonWidgets().getTextFieldHeight(NormalPadding),
                            getItemRow(
                                "Qty".localized(), item?.qty.toString() ?? ""),
                            getItemRow("Price".localized(),
                                item?.formattedPrice?.price ?? ""),
                            getItemRow("Subtotal".localized(),
                                item?.formattedPrice?.baseTotal ?? ""),
                            getItemRow("TaxAmount".localized(),
                                item?.formattedPrice?.taxAmount ?? ""),
                            getItemRow("GrandTotal".localized(),
                                item?.formattedPrice?.total ?? ""),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return CommonWidgets().divider();
        },
        itemCount: element?.items?.length ?? 0);
  }

  getItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
          ),
        ],
      ),
    );
  }
}
