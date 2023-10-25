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
import '../../../../models/order_model/order_invoices_model.dart';
import '../../../configuration/app_global_data.dart';
import '../../order_detail/widgets/shiping_payment_info.dart';
import '../bloc/invoices_bloc.dart';
import '../bloc/invoices_event.dart';
import '../bloc/invoices_state.dart';

class OrderInvoiceListScreen extends StatefulWidget {
  final int orderId;
  final OrderDetail? orderDetailModel;
  const OrderInvoiceListScreen({Key? key, this.orderDetailModel, required this.orderId}) : super(key: key);

  @override
  State<OrderInvoiceListScreen> createState() => _OrderInvoiceListScreenState();
}

class _OrderInvoiceListScreenState extends State<OrderInvoiceListScreen> {
  InvoiceListBloc? invoiceBloc;
  InvoicesModel? invoiceModel;
  int page = 1;

  @override
  void initState() {
    invoiceBloc = context.read<InvoiceListBloc>();
    invoiceBloc?.add(InvoiceListFetchDataEvent(page: page, orderId: widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonWidgets.getHeadingText("Invoices".localized(),
            context),
      ),
      body:  Directionality(
        textDirection: GlobalData.contentDirection(),
        child: _orderDetail(context) ,
      ),
    );
  }

  _orderDetail(BuildContext context) {
    return BlocConsumer<InvoiceListBloc, InvoiceListBaseState>(
      listener: (BuildContext context, InvoiceListBaseState state) {},
      builder: (BuildContext context, InvoiceListBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, InvoiceListBaseState state) {
    if (state is InvoiceListInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is InvoiceListFetchDataState) {
      if (state.status == InvoiceListStatus.success) {
        invoiceModel = state.invoiceModel;
      }
      if (state.status == InvoiceListStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...getInvoiceInfo(),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: Text(
              "PriceDetails".localized().toUpperCase(),
              style:  const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.normalFontSize,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: CommonWidgets().divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: Column(
                children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spacingTiny),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().getDrawerTileText(
                        "Subtotal".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.orderDetailModel?.formattedPrice?.subTotal ?? "",
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
                        widget.orderDetailModel?.formattedPrice?.shippingAmount ??
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
                    CommonWidgets()
                        .getDrawerTileText("Tax".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.orderDetailModel?.formattedPrice?.taxAmount ??
                            "",
                        context)
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
                        "GrandTotal".localized(), context, isBold: true),
                    CommonWidgets().getDrawerTileText(
                        widget.orderDetailModel?.formattedPrice?.grandTotal??
                            "",
                        context, isBold: true),
                  ],
                ),
              )
            ]),
          ),
          CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
          shippingPaymentInfo(context, widget.orderDetailModel),
        ],
      ),
    );
  }

  List<Widget> getInvoiceInfo() {
    List<Widget> widget = [];

    invoiceModel?.viewInvoices?.forEach((ViewInvoices? element) {
      widget.add(invoiceItem(element));
    });

    return widget;
  }

  Widget invoiceItem(ViewInvoices? element) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          InvoicesItems? item = element?.items?[idx];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invoice".localized() + " #${item?.invoiceId}", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey
                ),),
                CommonWidgets().getTextFieldHeight(NormalPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ImageView(
                        url: item?.product?.images?[0]. url??
                            "",
                        width: MediaQuery.of(context).size.width,
                        height:
                        MediaQuery.of(context).size.height / 5,
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
                              item?.sku ??
                                  "",
                              style: const TextStyle(fontSize: 18),
                            ),
                            CommonWidgets().getTextFieldHeight(NormalPadding),
                            Text(
                              item?.name ?? "", style: const TextStyle(fontSize: 15),
                            ),
                            CommonWidgets().getTextFieldHeight(NormalPadding),
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
                                      fontWeight:
                                      FontWeight.bold,
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
                                            item!.qty.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            CommonWidgets()
                                .getTextFieldHeight(NormalPadding),
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
}
