import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../common_widget/common_error_msg.dart';
import '../../../../common_widget/common_widgets.dart';
import '../../../../common_widget/image_view.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/order_model/order_detail_model.dart';
import '../../../../models/order_model/shipment_model.dart';
import '../../../configuration/app_global_data.dart';
import '../../order_detail/widgets/shiping_payment_info.dart';
import '../bloc/shipment_list_bloc.dart';
import '../event/shipment_list_event.dart';
import '../state/shipment_list_state.dart';

class ShipmentListScreen extends StatefulWidget {
  final int? orderId;
  final OrderDetail? orderDetailModel;

  const ShipmentListScreen({Key? key, this.orderId, this.orderDetailModel})
      : super(key: key);

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  ShipmentListBloc? shipmentBloc;
  ShipmentModel? shipmentModel;
  int page = 1;

  @override
  void initState() {
    shipmentBloc = context.read<ShipmentListBloc>();
    shipmentBloc
        ?.add(ShipmentListFetchDataEvent(page: page, orderId: widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonWidgets.getHeadingText("Shipments".localized(), context),
      ),
      body:  _orderDetail(context),
      ),
    );
  }

  _orderDetail(BuildContext context) {
    return BlocConsumer<ShipmentListBloc, ShipmentListBaseState>(
      listener: (BuildContext context, ShipmentListBaseState state) {},
      listenWhen: (ShipmentListBaseState prev, ShipmentListBaseState current) {
        if (current is ShipmentListInitialState) {
          return true;
        }
        if (current is ShipmentListFetchDataState) {
          return true;
        }
        return false;
      },
      buildWhen: (ShipmentListBaseState prev, ShipmentListBaseState current) {
        if (current is ShipmentListFetchDataState) {
          return true;
        }
        if (current is ShipmentListInitialState) {
          return true;
        }

        return false;
      },
      builder: (BuildContext context, ShipmentListBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, ShipmentListBaseState state) {
    if (state is ShipmentListInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is ShipmentListFetchDataState) {
      if (state.status == ShipmentListStatus.success) {
        shipmentModel = state.shipmentModel;
      }
      if (state.status == ShipmentListStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...getShippingList(),
          shippingPaymentInfo(context, widget.orderDetailModel),
        ],
      ),
    );
  }

  List<Widget> getShippingList() {
    List<Widget> widgets = [];
    shipmentModel?.viewShipments?.forEach((ViewShipments? element) {
      widgets.add(shipmentsCards(element));
    });

    return widgets;
  }

  Widget shipmentsCards(ViewShipments? element) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int idx) {
          ItemsModel? item = element?.items?[idx];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shipment".localized() + " #${item?.shipmentId}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.grey),
                ),
                CommonWidgets().getTextFieldHeight(NormalPadding),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            CommonWidgets().getTextFieldHeight(NormalPadding),
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
