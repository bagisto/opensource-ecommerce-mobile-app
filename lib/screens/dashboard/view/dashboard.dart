/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/dashboard/utils/index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool addressIsEmpty = false;
  Widget orderScreen = BlocProvider(
      create: (context) => OrderListBloc(repository: OrderListRepositoryImp()),
      child: const OrdersList(
        isFromDashboard: true,
      ));

  Widget reviewsScreen = BlocProvider(
      create: (context) =>
          ReviewsBloc(repository: ReviewsRepositoryImp(), context: context),
      child: const ReviewsScreen(
        isFromDashboard: true,
      ));

  Widget addressScreen = BlocProvider(
      create: (context) => AddressBloc(AddressRepositoryImp()),
      child: const AddressScreen(
        isFromDashboard: true,
      ));

  @override
  Widget build(BuildContext context) {
    addressIsEmpty = appStoragePref.getAddressData();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.dashboard.localized()),
          centerTitle: false,
        ),
        body: dashboardView(),
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
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: AppSizes.spacingMedium),
                indicatorColor: MobiKulTheme.accentColor,
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.15,
                child: TabBarView(children: [
                  ///orderScreen
                  Column(
                    children: [
                      Expanded(child: orderScreen),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spacingWide, vertical: 2.0),
                        child: SizedBox(
                          height: AppSizes.spacingWide * 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              elevation: 0.0,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  AppSizes.buttonHeight),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              foregroundColor:
                                  Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, home);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_forward_outlined,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  StringConstants.continueShopping
                                      .localized()
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
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
                            horizontal: AppSizes.spacingWide, vertical: 2.0),
                        child: SizedBox(
                          height: AppSizes.spacingWide * 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              elevation: 0.0,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  AppSizes.buttonHeight),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              foregroundColor:
                                  Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              addressIsEmpty
                                  ? Navigator.pushNamed(
                                      context, addAddressScreen,
                                      arguments: AddressNavigationData(
                                          isEdit: false,
                                          addressModel: null,
                                          isCheckout: false))
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
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
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, home);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                elevation: 0.0,
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width,
                                    AppSizes.buttonHeight),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                foregroundColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_forward_outlined),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    StringConstants.continueShopping
                                        .localized()
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                  ),
                                ],
                              ),
                            )),
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
