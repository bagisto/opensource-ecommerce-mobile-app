/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, implementation_imports, unnecessary_null_comparison

import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/no_data_class.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_bloc.dart';
import 'package:bagisto_app_demo/screens/orders/event/fetch_order_event.dart';
import 'package:bagisto_app_demo/screens/orders/state/fetch_order_list_state.dart';
import 'package:bagisto_app_demo/screens/orders/state/fetch_order_list_initial_state.dart';
import 'package:bagisto_app_demo/screens/orders/state/order_list_base_state.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/helper/order_status_Bg_color_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widget/common_date_picker.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../helper/string_constants.dart';
import 'empty_order.dart';
import 'order_list_tile.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key, this.isFromDashboard}) : super(key: key);
  final bool? isFromDashboard;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> with OrderStatusBGColorHelper {
  final orderId = TextEditingController();
  final total = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();
  List<String>? status = [];
  int _currentStatus = 0;
  int page = 1;
  OrderListBloc? orderListBloc;
  String date = "";
  ScrollController scrollController = ScrollController();
  OrdersListModel? ordersListModel;

  @override
  void initState() {
    orderListBloc = context.read<OrderListBloc>();
    orderListBloc?.add(FetchOrderListEvent(
        id: "", status: "", startDate: "", endDate: "", total: 0, page: page));
    status = [
      "All".localized(),
      "Pending".localized(),
      "Closed".localized(),
      "Canceled".localized(),
      "Processing".localized(),
      "Completed".localized(),
      "pendingPayment".localized(),
      "fraud".localized()
    ];
    scrollController.addListener(() => _setItemScrollListener());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: GlobalData.contentDirection(),
      child:Scaffold(
        appBar: (widget.isFromDashboard ?? false)
            ? null
            : AppBar(
                centerTitle: false,
                title:
                    CommonWidgets.getHeadingText("Orders".localized(), context),
                actions: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => _getOrderFilter());
                      },
                      icon: const Icon(
                        Icons.filter_alt,
                        size: 30,
                      ))
                ],
              ),
        body: _orderList(context) ,
        ),);
  }

  ///bloc method
  _orderList(BuildContext context) {
    return BlocConsumer<OrderListBloc, OrderListBaseState>(
      listener: (BuildContext context, OrderListBaseState state) {},
      builder: (BuildContext context, OrderListBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, OrderListBaseState state) {
    if (state is OrderInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchOrderListState) {
      if (state.status == OrderStatus.success) {
        if (page > 1) {
          ordersListModel?.data?.addAll(state.ordersListModel?.data ?? []);
        } else {
          ordersListModel = state.ordersListModel;
        }
        return _getOrdersList(ordersListModel!);
      }
      if (state.status == OrderStatus.fail) {
        return ErrorMessage.errorMsg("SomethingWrong".localized());
      }
    }
    return Container();
  }

  ///to get order list
  _getOrdersList(OrdersListModel ordersListModel) {
    if (ordersListModel == null) {
      return const NoDataFound();
    } else if ((ordersListModel.data ?? []).isEmpty) {
      return const EmptyOrderClass();
    } else {
      return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            orderListBloc?.add(FetchOrderListEvent(
                id: "",
                status: "",
                startDate: "",
                endDate: "",
                total: 0,
                page: page));
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.normalHeight),
          child: ListView.separated(
            controller: scrollController,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int itemIndex) {
              return OrdersListTile(
                data: ordersListModel.data?[itemIndex],
                reload: fetchOrder,
              );
            },
            separatorBuilder: (context, index) {
              return Container();
            },
            itemCount: (widget.isFromDashboard ?? false)
                ? ((ordersListModel.data?.length ?? 0) > 5)
                    ? 5
                    : ordersListModel.data?.length ?? 0
                : ordersListModel.data?.length ?? 0,
          ),
        ),
      );
    }
  }

  ///Filter view

  _getOrderFilter() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FilterBy".localized(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      elevation: 0.0,
                      minWidth: AppSizes.buttonSize,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        orderId.clear();
                        total.clear();
                        endDateController.clear();
                        startDateController.clear();
                        _currentStatus = 0;
                        orderListBloc?.add(FetchOrderListEvent(
                            id: "",
                            status: "",
                            startDate: "",
                            endDate: "",
                            total: 0,
                            page: page));
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Clear".localized().toUpperCase(),
                        style: const TextStyle(
                            fontSize: AppSizes.normalHeight,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.grey,
                title: Text(
                  "SearchOrder".localized(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: NormalPadding, vertical: 6),
                    child: Column(
                      children: [
                        CommonWidgets().getTextField(
                            context,
                            orderId,
                            "OrderId".localized(),
                            "EnterOrderId".localized(),
                            ""),
                        CommonWidgets()
                            .getTextFieldHeight(AppSizes.widgetHeight),
                        CommonWidgets().getTextField(context, total,
                            "Total".localized(), "EnterTotal".localized(), ""),
                        CommonWidgets()
                            .getTextFieldHeight(AppSizes.widgetHeight),
                      ],
                    ),
                  )
                ],
              ),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
              ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.grey,
                title: Text(
                  "OrderDate".localized(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: NormalPadding, vertical: 6),
                    child: Column(
                      children: [
                        CommonDatePicker(
                          controller: startDateController,
                          hintText: "YYYY-MM-DD",
                          labelText: "FromDate".localized(),
                          isRequired: true,
                          save: 0,
                        ),
                        CommonWidgets()
                            .getTextFieldHeight(AppSizes.widgetHeight),
                        CommonDatePicker(
                          controller: endDateController,
                          hintText: "YYYY-MM-DD",
                          labelText: "ToDate".localized(),
                          isRequired: true,
                          save: 1,
                        ),
                        CommonWidgets()
                            .getTextFieldHeight(AppSizes.widgetHeight),
                      ],
                    ),
                  )
                ],
              ),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
              ExpansionTile(
                initiallyExpanded: true,
                iconColor: Colors.grey,
                title: Text(
                  "OrderStatus".localized(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: NormalPadding, vertical: 6),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: DropdownButtonFormField(
                          iconEnabledColor: Colors.grey[600],
                          style: Theme.of(context).textTheme.bodyMedium,
                          items: status!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _currentStatus = status!.indexOf(value!);
                            });
                          },
                          value: status?[_currentStatus],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 16.0, 12.0, 16.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                            ),
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            fillColor: Colors.black,
                            labelText: "OrderStatus".localized(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.zero),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500)),
                          )),
                    ),
                  )
                ],
              ),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary)),
                      elevation: AppSizes.elevation,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ButtonLabelCancel".localized().toUpperCase(),
                            style: const TextStyle(
                                fontSize: AppSizes.normalFontSize),
                          ),
                        ],
                      )),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: AppSizes.elevation,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      color: Theme.of(context).colorScheme.background,
                      textColor: MobikulTheme.primaryColor,
                      onPressed: () {
                        String startDate = startDateController.text != ""
                            ? "${startDateController.text} 00:00:01"
                            : startDateController.text;
                        String endDate = endDateController.text != ""
                            ? "${endDateController.text} 23:59:59"
                            : endDateController.text;
                        orderListBloc?.add(FetchOrderListEvent(
                            id: orderId.text,
                            startDate: startDate,
                            endDate: endDate,
                            status: status?[_currentStatus] == "All"
                                ? ""
                                : status?[_currentStatus],
                            total: double.tryParse(total.text),
                            page: page));
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Submit".localized().toUpperCase(),
                            style: const TextStyle(
                                fontSize: AppSizes.normalFontSize),
                          ),
                        ],
                      )),
                ],
              ),
              CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
            ],
          ),
        ),
      ),
    );
  }

  _setItemScrollListener() {
    if (scrollController.hasClients &&
        scrollController.position.maxScrollExtent == scrollController.offset &&
        ((ordersListModel?.paginatorInfo?.total)! >
            (ordersListModel?.data?.length ?? 0))) {
      page += 1;
      orderListBloc?.add(FetchOrderListEvent(
          id: "",
          status: "",
          startDate: "",
          endDate: "",
          total: 0,
          page: page));
    }
  }

  fetchOrder() async {
    orderListBloc?.add(FetchOrderListEvent(
        id: "", status: "", startDate: "", endDate: "", total: 0, page: page));
  }
}
