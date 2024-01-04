import 'package:bagisto_app_demo/screens/address_list/bloc/address_bloc.dart';
import 'package:bagisto_app_demo/screens/address_list/bloc/address_repository.dart';
import 'package:bagisto_app_demo/screens/address_list/view/address_screen.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_list_bloc.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_list_repo.dart';
import 'package:bagisto_app_demo/screens/orders/screen/order_list.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_bloc.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_repo.dart';
import 'package:bagisto_app_demo/screens/review/screen/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/index.dart';
import 'dashboard_header_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool addressIsEmpty = false;
  Widget orderScreen = BlocProvider(
      create: (context) =>
          OrderListBloc(repository: OrderListRepositoryImp()),
      child: const OrdersList(
        isFromDashboard: true,
      ));

  Widget reviewsScreen = BlocProvider(
      create: (context) =>
          ReviewsBloc(repository: ReviewsRepositoryImp(), context: context),
      child: ReviewsScreen(
        isFromDashboard: true,
      ));

  Widget addressScreen = BlocProvider(
      create: (context) => AddressBloc(AddressRepositoryImp()),
      child: const AddressScreen(
        isFromDashboard: true,
      ));

  getAddressData() async {
    addressIsEmpty = await SharedPreferenceHelper.getAddressData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getAddressData();
    return DefaultTabController(
      length: 3,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(StringConstants.dashboard.localized()),
          ),
          body: dashboardView(),
        ),
      ),
    );
  }

  Widget dashboardView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              const DashboardHeaderView(),
              TabBar(
                unselectedLabelColor: Colors.grey[600],
                labelColor: Theme.of(context).colorScheme.onPrimary,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12
                ),
                indicatorColor: MobikulTheme.accentColor,
                tabs: <Widget>[
                  Tab(
                    text: StringConstants.recentOrders.localized(),
                  ),
                  Tab(
                    text: StringConstants.addressTitle.localized(),
                  ),
                  Tab(
                    text: StringConstants.reviewsTitle.localized(),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colors.grey.shade400,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.15,
                color: Theme.of(context).colorScheme.background,
                child: TabBarView(children: [
                  ///orderScreen
                  Column(
                    children: [
                      Expanded(child: orderScreen),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 2.0),
                        child: SizedBox(
                          height: 40,
                          child: MaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onBackground,
                            textColor:
                                Theme.of(context).colorScheme.background,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, home);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  StringConstants.continueShopping.localized().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.background
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///address
                  Column(
                    children: [
                      Expanded(child: addressScreen),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 2.0),
                        child: SizedBox(
                          height: 40,
                          child: MaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onBackground,
                            textColor:
                                Theme.of(context).colorScheme.background,
                            onPressed: () {
                              addressIsEmpty
                                  ? Navigator.pushNamed(context, addAddressScreen,
                                      arguments: AddressNavigationData(
                                          isEdit: false, addressModel: null))
                                  : Navigator.of(context)
                                      .pushNamed(addressList);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  addressIsEmpty
                                      ? Icons.add
                                      : Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  addressIsEmpty
                                      ? StringConstants.addNewAddress
                                          .localized()
                                          .toUpperCase()
                                      : StringConstants.manageAddress
                                          .localized()
                                          .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context).colorScheme.background),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///reviewScreen
                  Column(
                    children: [
                      Expanded(child: reviewsScreen),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 2.0),
                        child: SizedBox(
                          height: 40,
                          child: MaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onBackground,
                            textColor:
                                Theme.of(context).colorScheme.background,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, home);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  StringConstants.continueShopping.localized().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.background
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
