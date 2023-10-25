import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../routes/route_constants.dart';
import '../../address_list/bloc/address_bloc.dart';
import '../../address_list/repository/address_repository.dart';
import '../../address_list/view/address_screen.dart';
import '../../orders/repository/order_repository.dart';
import '../../orders/view/order_list.dart';
import '../../review/bloc/review_bloc.dart';
import '../../review/repository/review_repository.dart';
import '../../review/view/reviews.dart';
import 'dashboard_header_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool addressIsEmpty =false;
  Widget orderScreen = BlocProvider(
      create: (context) =>
          OrderListBloc(repository: OrderListRepositoryImp(), context: context),
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
      create: (context) => AddressBloc(repository: AddressRepositoryImp()),
      child: const AddressScreen(
        isFromDashboard: true,
      ));



  getAddressData() async{
    addressIsEmpty = await SharedPreferenceHelper.getAddressData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getAddressData();
    return DefaultTabController(
      length: 3,
      child:Directionality(
        textDirection: GlobalData.contentDirection(),
        child :Scaffold(
        appBar: AppBar(
          title: Text("Dashboard".localized()),
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
                indicatorColor: MobikulTheme.accentColor,
                tabs: <Widget>[
                  Tab(
                    text: "RecentOrders".localized(),
                  ),
                  Tab(
                    text: "AddressTitle".localized(),
                  ),
                  Tab(
                    text: "ReviewsTitle".localized(),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colors.grey.shade400,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.15,
                color: MobikulTheme.primaryColor,
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onPrimary,
                            textColor: Theme.of(context).colorScheme.onBackground,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Home);
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
                                  "ContinueShopping".localized().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: MobikulTheme.primaryColor),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onPrimary,
                            textColor: Theme.of(context).colorScheme.onBackground,
                            onPressed: () {
                              addressIsEmpty ? Navigator.pushNamed(context, AddAddress,
                                  arguments: AddressNavigationData(
                                      isEdit: false, addressModel: null)) :
                              Navigator.of(context).pushNamed(AddressList);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  addressIsEmpty  ? Icons.add :  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  addressIsEmpty
                                      ? "AddNewAddress".localized().toUpperCase()
                                      : "ManageAddress".localized().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: MobikulTheme.primaryColor),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))),
                            elevation: 0.0,
                            height: AppSizes.buttonHeight,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.onPrimary,
                            textColor: Theme.of(context).colorScheme.onBackground,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Home);
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
                                  "ContinueShopping".localized().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: MobikulTheme.primaryColor),
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
