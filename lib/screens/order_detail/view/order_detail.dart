/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, implementation_imports
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/order_status_Bg_color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../common_widget/show_message.dart';
import '../../../configuration/app_global_data.dart';
import '../../../models/order_model/order_detail_model.dart';
import '../bloc/order_detail_bloc.dart';
import '../event/order_detail_fetch_event.dart';
import '../state/order_detail_base_state.dart';
import '../state/order_detail_fetch.dart';
import '../state/order_detail_fetch_state.dart';
import 'order_detail_tile.dart';

class OrderDetailScreen extends StatefulWidget {
  final int? orderId;

  const OrderDetailScreen({
    Key? key,
    this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with OrderStatusBGColorHelper {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  OrderDetailBloc? orderDetailBloc;
  OrderDetail? orderDetail;
  bool isLoading = false;

  @override
  void initState() {
    orderDetailBloc = context.read<OrderDetailBloc>();
    orderDetailBloc?.add(OrderDetailFetchDataEvent(widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:Directionality(
        textDirection: GlobalData.contentDirection(),
        child:  Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title:
              CommonWidgets.getHeadingText("OrderDetails".localized(), context),
        ),
        body: _orderDetail(context) ,
        ),
      ),
    );
  }

  /// Order bloc method
  _orderDetail(BuildContext context) {
    return BlocConsumer<OrderDetailBloc, OrderDetailBaseState>(
      listener: (BuildContext context, OrderDetailBaseState state) {
        if (state is CancelOrderState) {
          if (state.status == OrderDetailStatus.fail) {
            ShowMessage.showNotification("Failed", state.error,
                Colors.redAccent, const Icon(Icons.cancel_outlined));
          } else if (state.status == OrderDetailStatus.success) {
            ShowMessage.showNotification(
                state.baseModel?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
            Future.delayed(const Duration(seconds: 2)).then((value) {
              Navigator.pop(context);
            });
          }
        }
      },
      builder: (BuildContext context, OrderDetailBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, OrderDetailBaseState state) {
    if (state is OrderDetailInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is OrderDetailFetchDataState) {
      if (state.status == OrderDetailStatus.success) {
        orderDetail = state.orderDetailModel;
        return OrderDetailTile(
          orderId: widget.orderId,
          orderDetailModel: state.orderDetailModel,
          orderDetailBloc: orderDetailBloc,
          isLoading: isLoading,
        );
      }
      if (state.status == OrderDetailStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "");
      }
    }

    if (state is CancelOrderState) {
      isLoading = false;
      if (state.status == OrderDetailStatus.success) {}
    }
    if (state is OnClickLoadingState) {
      isLoading = state.isReqToShowLoader ?? false;
    }

    return OrderDetailTile(
      orderId: widget.orderId,
      orderDetailModel: orderDetail,
      orderDetailBloc: orderDetailBloc,
      isLoading: isLoading,
    );
  }
}
