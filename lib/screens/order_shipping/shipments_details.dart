import 'package:bagisto_app_demo/screens/order_shipping/utils/index.dart';

class OrderShipmentsScreen extends StatefulWidget {
  final OrderDetail? orderDetailsModel;
  const OrderShipmentsScreen({this.orderDetailsModel, Key? key})
      : super(key: key);

  @override
  State<OrderShipmentsScreen> createState() => _OrderShipmentsScreenState();
}

class _OrderShipmentsScreenState extends State<OrderShipmentsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  OrderShipmentsBloc? orderShipmentsBloc;
  ShipmentModel? shipmentsList;
  @override
  void initState() {
    orderShipmentsBloc = context.read<OrderShipmentsBloc>();
    orderShipmentsBloc
        ?.add(OrderShipmentsFetchDataEvent(widget.orderDetailsModel?.id ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(StringConstants.shipment.localized()),
        ),
        body: buildContainer(context),
      ),
    );
  }

  buildContainer(BuildContext context) {
    return BlocConsumer<OrderShipmentsBloc, OrderShipmentsBaseState>(
      listener: (BuildContext context, OrderShipmentsBaseState state) {},
      builder: (BuildContext context, OrderShipmentsBaseState state) {
        if (state is OrderShipmentsInitialState) {
          return const Loader();
        }
        if (state is OrderShipmentsListDataState) {
          if (state.status == OrderShipmentsStatus.success) {
            shipmentsList = state.shipmentData;
            return shipmentsDetails();
          }
        }
        return shipmentsDetails();
      },
    );
  }

  Widget shipmentsDetails() {
    return shipmentsList != null
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
                        ...getShipments(context, shipmentsList?.viewShipments),
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

  getShipments(BuildContext context, List<ViewShipments>? shipmentModel) {
    return shipmentModel?.map((ViewShipments? shipments) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${StringConstants.trackingNumber.localized()} ${shipments?.trackNumber}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: AppSizes.spacingSmall,
            ),
            Text("${StringConstants.shipment.localized()} #${shipments?.id}",
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
                      shipments?.items?[index].sku ?? "", context),
                  childData(StringConstants.name,
                      shipments?.items?[index].name ?? "", context),
                  childData(StringConstants.qty,
                      shipments?.items?[index].qty.toString() ?? "", context),
                ]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: shipments?.items?.length ?? 0,
              shrinkWrap: true,
            ),
          ],
        ),
      );
    });
  }
}
