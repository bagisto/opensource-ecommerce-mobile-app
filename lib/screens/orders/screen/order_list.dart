/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_list_bloc.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:bagisto_app_demo/utils/no_data_found_widget.dart';
import 'package:bagisto_app_demo/utils/status_color_helper.dart';
import 'package:bagisto_app_demo/widgets/common_date_picker.dart';
import 'package:bagisto_app_demo/screens/orders/utils/index.dart';

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
  OrdersListModel? ordersListModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    orderListBloc = context.read<OrderListBloc>();
    orderListBloc?.add(FetchOrderListEvent(id: "", status: "", startDate: "", endDate: "", total: 0, page: 1));
    _scrollController.addListener(() {
      paginationFunction();
    });
    status = [
      StringConstants.all.localized(),
      StringConstants.pending.localized(),
      StringConstants.closed.localized(),
      StringConstants.canceled.localized(),
      StringConstants.processing.localized(),
      StringConstants.completed.localized(),
      StringConstants.pendingPayment.localized(),
      StringConstants.fraud.localized()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
          appBar: (widget.isFromDashboard ?? false)
              ? null
              : AppBar(
                  centerTitle: false,
                  title: Text(StringConstants.orders.localized()),
                  actions: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => _getOrderFilter());
                        },
                        icon: const Icon(
                          Icons.filter_alt,
                          size: AppSizes.size24,
                        ))
                  ],
                ),
          body: _orderList(context)),
    );
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
      return const OrderLoader();
    }
    if (state is FetchOrderListState) {
      if (state.status == OrderStatus.success) {
        if (page > 1) {
          ordersListModel?.data?.addAll(state.ordersListModel?.data ?? []);
          ordersListModel?.paginatorInfo = state.ordersListModel?.paginatorInfo;
        } else {
          ordersListModel = state.ordersListModel;
        }
        return _getOrdersList(ordersListModel);
      }
      if (state.status == OrderStatus.fail) {
        return ErrorMessage.errorMsg(
            StringConstants.somethingWrong.localized());
      }
    }
    return const SizedBox();
  }

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        (ordersListModel?.paginatorInfo?.currentPage ?? 0) <
            (ordersListModel?.paginatorInfo?.lastPage ?? 0)) {
      page++;
      orderListBloc?.add(FetchOrderListEvent(page: page));
    }
  }

  ///to get order list
  _getOrdersList(OrdersListModel? ordersListModel) {
    if (ordersListModel == null) {
      return const NoDataFound();
    } else if ((ordersListModel.data ?? []).isEmpty) {
      return const EmptyDataView();
    } else {
      return RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            orderListBloc?.add(FetchOrderListEvent(id: "", status: "", startDate: "", endDate: "", total: 0, page: 1));
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingLarge),
          child: ListView.separated(
            shrinkWrap: true,
            controller: _scrollController,
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
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child:  Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Card(
            margin: EdgeInsets.zero,
            child: SingleChildScrollView(
              child:Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstants.filterBy.localized(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        elevation: 0.0,
                        minWidth: AppSizes.itemHeight,
                        color: Theme.of(context).colorScheme.onBackground,
                        textColor: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          orderId.clear();
                          total.clear();
                          endDateController.clear();
                          startDateController.clear();
                          _currentStatus = 0;
                          orderListBloc?.add(FetchOrderListEvent(id: "", status: "", startDate: "", endDate: "", total: 0, page: 1));
                          Navigator.pop(context);
                        },
                        child: Text(
                          StringConstants.clear.localized().toUpperCase(),
                          style: const TextStyle(
                              fontSize: AppSizes.spacingMedium),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: Colors.grey,
                  title: Text(
                    StringConstants.searchOrder.localized(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingNormal, vertical: 6),
                      child: Column(
                        children: [
                          CommonWidgets().getTextField(
                              context,
                              orderId,
                              StringConstants.enterOrderId.localized(),
                              label: StringConstants.orderId.localized(),
                              validLabel: ""),
                          const SizedBox(height: AppSizes.spacingWide),
                          CommonWidgets().getTextField(
                              context,
                              total,
                              StringConstants.enterTotal.localized(),
                              label: StringConstants.total.localized(),
                              validLabel: ""),
                          const SizedBox(height: AppSizes.spacingWide),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: AppSizes.spacingWide),
                ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: Colors.grey,
                  title: Text(
                    StringConstants.orderDate.localized(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingNormal, vertical: 6),
                      child: Column(
                        children: [
                          CommonDatePicker(
                            controller: startDateController,
                            hintText: "YYYY-MM-DD",
                            labelText: StringConstants.fromDate.localized(),
                            isRequired: true,
                            save: 0,
                          ),
                          const SizedBox(height: AppSizes.spacingWide),
                          CommonDatePicker(
                            controller: endDateController,
                            hintText: "YYYY-MM-DD",
                            labelText: StringConstants.toDate.localized(),
                            isRequired: true,
                            save: 1,
                          ),
                          const SizedBox(height: AppSizes.spacingWide),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: AppSizes.spacingWide),
                ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: Colors.grey,
                  title: Text(
                    StringConstants.orderStatus.localized(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingNormal, vertical: 6),
                      child: DropdownButtonFormField(
                          iconEnabledColor: Colors.grey[600],
                          style: Theme.of(context).textTheme.bodyMedium,
                          items: status?.map<DropdownMenuItem<String>>((String value) {
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                            ),
                            labelStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            fillColor: Colors.black,
                            labelText:
                                StringConstants.orderStatus.localized(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.zero),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500)),
                          )),
                    )
                  ],
                ),
                const SizedBox(height: AppSizes.spacingWide),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                        elevation: 2.0,
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
                              StringConstants.cancel.localized().toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        )),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        elevation: 2.0,
                        height: AppSizes.buttonHeight,
                        minWidth: MediaQuery.of(context).size.width / 2.2,
                        color: Theme.of(context).colorScheme.onBackground,
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
                            status: status?[_currentStatus] == StringConstants.all.localized()
                                ? ""
                                : status?[_currentStatus],
                            total: double.tryParse(total.text),
                            page: page
                          ));
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                StringConstants.submit
                                    .localized()
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary
                                )),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spacingWide,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchOrder() async {
    orderListBloc?.add(FetchOrderListEvent(id: "", status: "", startDate: "", endDate: "", total: 0, page: 1));
  }
}
