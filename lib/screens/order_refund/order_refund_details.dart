import 'package:bagisto_app_demo/screens/order_refund/utils/index.dart';

class OrderRefundScreen extends StatefulWidget {
  final OrderDetail? orderDetailsModel;
  const OrderRefundScreen({this.orderDetailsModel, Key? key}) : super(key: key);

  @override
  State<OrderRefundScreen> createState() => _OrderRefundScreenState();
}

class _OrderRefundScreenState extends State<OrderRefundScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  OrderRefundBloc? orderRefundBloc;
  OrderRefundModel? refundList;
  @override
  void initState() {
    orderRefundBloc = context.read<OrderRefundBloc>();
    orderRefundBloc
        ?.add(OrderRefundFetchDataEvent(widget.orderDetailsModel?.id ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(StringConstants.refunds.localized()),
        ),
        body: buildContainer(context),
      ),
    );
  }

  buildContainer(BuildContext context) {
    return BlocConsumer<OrderRefundBloc, OrderRefundBaseState>(
      listener: (BuildContext context, OrderRefundBaseState state) {},
      builder: (BuildContext context, OrderRefundBaseState state) {
        if (state is OrderRefundInitialState) {
          return const Loader();
        }
        if (state is OrderRefundListDataState) {
          if (state.status == OrderRefundStatus.success) {
            refundList = state.refundData;
            return refundDetails();
          }
        }
        return refundDetails();
      },
    );
  }

  Widget refundDetails() {
    return refundList != null
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
                        ...getRefunds(context, refundList?.viewRefunds),
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
                            refundList?.viewRefunds?[0].formattedPrice
                                    ?.subTotal ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.shippingHandling,
                            refundList?.viewRefunds?[0].formattedPrice
                                    ?.shippingAmount ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.adjustmentRefund,
                            refundList?.viewRefunds?[0].formattedPrice
                                    ?.adjustmentRefund
                                    .toString() ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.adjustmentFee,
                            refundList?.viewRefunds?[0].formattedPrice
                                    ?.adjustmentFee
                                    .toString() ??
                                "",
                            context),
                        getOrdersRow(
                            StringConstants.grandTotal,
                            refundList?.viewRefunds?[0].formattedPrice
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
        Text(val,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.normal,
                )),
      ],
    );
  }

  getRefunds(BuildContext context, List<ViewRefunds>? refundModel) {
    return refundModel?.map((ViewRefunds? refunds) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${StringConstants.refunds.localized()} #${refunds?.id}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(children: [
                  childData(StringConstants.sku,
                      refunds?.items?[index].sku ?? "", context),
                  childData(StringConstants.name,
                      refunds?.items?[index].name ?? "", context),
                  childData(
                      StringConstants.price,
                      refunds?.items?[index].formattedPrice?.price.toString() ??
                          "",
                      context),
                  childData(StringConstants.qty,
                      refunds?.items?[index].qty.toString() ?? "", context),
                  childData(
                      StringConstants.subTotal,
                      refunds?.items?[index].formattedPrice?.baseTotal
                              .toString() ??
                          "",
                      context),
                  childData(
                      StringConstants.taxAmount,
                      refunds?.items?[index].formattedPrice?.taxAmount
                              .toString() ??
                          "",
                      context),
                  childData(
                      StringConstants.grandTotal,
                      refunds?.items?[index].formattedPrice?.total.toString() ??
                          "",
                      context),
                ]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: refunds?.items?.length ?? 0,
              shrinkWrap: true,
            ),
          ],
        ),
      );
    });
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
}
