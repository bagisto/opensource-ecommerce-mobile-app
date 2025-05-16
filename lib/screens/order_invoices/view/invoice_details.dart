/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/order_invoices/utils/index.dart';

class InvoiceScreen extends StatefulWidget {
  final OrderDetail? orderDetailsModel;
  const InvoiceScreen({this.orderDetailsModel, Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  OrderInvoiceBloc? orderInvoiceBloc;
  InvoicesModel? invoicesList;
  @override
  void initState() {
    orderInvoiceBloc = context.read<OrderInvoiceBloc>();
    orderInvoiceBloc
        ?.add(OrderInvoiceFetchDataEvent(widget.orderDetailsModel?.id ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(StringConstants.invoice.localized()),
        ),
        body: buildContainer(context),
      ),
    );
  }

  buildContainer(BuildContext context) {
    return BlocConsumer<OrderInvoiceBloc, OrderInvoiceBaseState>(
      listener: (BuildContext context, OrderInvoiceBaseState state) {},
      builder: (BuildContext context, OrderInvoiceBaseState state) {
        if (state is OrderInvoiceInitialState) {
          return const Loader();
        }
        if (state is OrderInvoiceListDataState) {
          invoicesList = state.invoicesList;
          return invoiceDetails();
        }
        return invoiceDetails();
      },
    );
  }

  Widget invoiceDetails() {
    return invoicesList != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: AppSizes.spacingNormal),
                    padding: const EdgeInsets.all(AppSizes.spacingNormal),
                    color: Theme.of(context).cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...getInvoices(context, invoicesList?.viewInvoices),
                        const Divider(),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          StringConstants.priceDetails.localized(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        getOrdersRow(
                            StringConstants.subTotal,
                            invoicesList?.viewInvoices?[0].formattedPrice
                                    ?.subTotal ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.shippingHandling,
                            invoicesList?.viewInvoices?[0].formattedPrice
                                    ?.shippingAmount ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.tax,
                            invoicesList?.viewInvoices?[0].formattedPrice
                                    ?.taxAmount ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.grandTotal,
                            invoicesList?.viewInvoices?[0].formattedPrice
                                    ?.grandTotal ??
                                "",
                            context),
                        const Divider(),
                        const SizedBox(
                          height: 8,
                        ),
                        ShippingAndPaymentInfo(
                          orderDetailModel: widget.orderDetailsModel,
                        ),
                      ],
                    )),
                // getBillingShipping(widget.orderDetailsModel, context)
              ],
            ),
          )
        : EmptyDataView();
  }

  childData(String title, String val, BuildContext context) {
    return Row(
      children: [
        Text("${title.localized()} - ",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.normal, color: Colors.grey)),
        Expanded(
          child: Text(val,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
        ),
      ],
    );
  }

  getOrdersRow(String title, String val, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.localized(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.normal, color: Colors.grey)),
          Text(
            val,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }

  getInvoices(BuildContext context, List<ViewInvoices>? invoicesItems) {
    return invoicesItems?.map((ViewInvoices? invoices) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            Text("${StringConstants.invoice.localized()} #${invoices?.id}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.normal)),
            const Divider(),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    childData(StringConstants.sku,
                        invoices?.items?[index].sku ?? "", context),
                    childData(StringConstants.name,
                        invoices?.items?[index].name ?? "", context),
                    childData(
                        StringConstants.price,
                        invoices?.items?[index].formattedPrice?.price
                                .toString() ??
                            "",
                        context),
                    childData(StringConstants.qty,
                        invoices?.items?[index].qty.toString() ?? "", context),
                    childData(
                        StringConstants.subTotal,
                        invoices?.items?[index].formattedPrice?.baseTotal
                                .toString() ??
                            "",
                        context),
                    childData(
                        StringConstants.taxAmount,
                        invoices?.items?[index].formattedPrice?.taxAmount
                                .toString() ??
                            "",
                        context),
                    childData(
                        StringConstants.grandTotal,
                        invoices?.items?[index].formattedPrice?.total
                                .toString() ??
                            "",
                        context),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: invoices?.items?.length ?? 0,
              shrinkWrap: true,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    });
  }
}
