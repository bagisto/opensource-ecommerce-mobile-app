/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: constant_identifier_names, file_names, unnecessary_new, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:bagisto_app_demo/api/graph_ql.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/configuration/app_global_data.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/badge_helper.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:bagisto_app_demo/models/homepage_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';
import 'package:bagisto_app_demo/screens/drawer/bloc/drawer_bloc.dart';
import 'package:bagisto_app_demo/screens/drawer/events/fetch_drawer_event.dart';
import 'package:bagisto_app_demo/screens/drawer/state/drawer_base_state.dart';
import 'package:bagisto_app_demo/screens/drawer/state/fetch_drawer_state.dart';
import 'package:bagisto_app_demo/screens/homepage/bloc/homepage_bloc.dart';
import 'package:bagisto_app_demo/screens/homepage/events/fetch_homepage_event.dart';
import 'package:bagisto_app_demo/screens/homepage/events/homepage_loading_event.dart';
import 'package:bagisto_app_demo/screens/homepage/state/ShowLoaderState.dart';
import 'package:bagisto_app_demo/screens/homepage/state/add_wishlist_homepage_state.dart';
import 'package:bagisto_app_demo/screens/homepage/state/addtocart_homepage_state.dart';
import 'package:bagisto_app_demo/screens/homepage/state/addtocomapre_homepage_state.dart';
import 'package:bagisto_app_demo/screens/homepage/state/fetch_homepage_data_state.dart';
import 'package:bagisto_app_demo/screens/homepage/state/hoempage_base_state.dart';
import 'package:bagisto_app_demo/screens/homepage/state/loader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:upgrader/upgrader.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../configuration/app_sizes.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../helper/theme_provider.dart';
import '../../../main.dart';
import '../../../models/cms_model/cms_model.dart';
import '../../../models/currency_language_model.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../../../routes/route_constants.dart';
import '../../drawer/drawer_list_view.dart';
import 'homepage_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  ///use to check that user is login or not?
  final StreamController _myStreamCtrl = StreamController.broadcast();

  Stream get onVariableChanged => _myStreamCtrl.stream;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLastIndex = false;
  String? customerUserName;
  String? image;
  HomePageBloc? homePageBloc;
  AddToCartModel? addToCartModel;
  bool isLoading = false;
  QuickActions quickActions = const QuickActions();
  String? customerLanguage;
  String? customerCurrency;
  GraphQLClient? client;
  HomeSlidersData? homeSlidersData;
  Advertisements? advertisementData;
  Advertisements? cartData;
  NewProductsModel? newProductsModel;
  NewProductsModel? featuredProduct;
  CurrencyLanguageList? currencyLanguageList;
  GetDrawerCategoriesData? getCategoriesDrawerData;
  CmsData? cmsData;
  ThemeProvider? themeProvider;
  Box? newProductDb;
  Box? featureProductDb;

  @override
  void initState() {
    _fetchSharedPreferenceData();
    DrawerBloc drawerBloc = context.read<DrawerBloc>();
    drawerBloc.add(FetchDrawerPageEvent());
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    fetchHomepageData();
    _handleQuickActions();
    getCustomerLanguageName().then((value) {
      customerLanguage = value;
    });
    getCurrencyName().then((value) {
      customerCurrency = value;
    });
    getLanguageCode().then((value) =>  GlobalData.locale=value);
    super.initState();
  }

  fetchHomepageData() async {
    homePageBloc = context.read<HomePageBloc>();
    homePageBloc?.add(FetchSliderEvent());
  }

  fetchOfflineProductData() async {
    newProductDb = await Hive.openBox("newProductData");
    newProductsModel = newProductDb?.getAt(0);
    featureProductDb = await Hive.openBox("featureProductData");
    featuredProduct = featureProductDb?.getAt(0);
  }

  void _setupQuickActions() {
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'cart_screen', localizedTitle: 'Cart Screen', icon: "cart"),
      if (isLoggedIn)
        const ShortcutItem(
            type: 'order_list', localizedTitle: 'Orders', icon: "reorder"),
      const ShortcutItem(
          type: 'login', localizedTitle: 'Login', icon: "person"),
      const ShortcutItem(
          type: 'search', localizedTitle: 'Search', icon: "search"),
    ]);
  }

  void _handleQuickActions() {
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'cart_screen') {
        Navigator.pushNamed(context, CartPage);
      } else if (shortcutType == 'order_list') {
        Navigator.pushNamed(context, OrderListData);
      } else if (shortcutType == 'login') {
        Navigator.of(context).pushNamed(SignIn);
      } else if (shortcutType == 'search') {
        Navigator.pushNamed(context, Search);
      } else if (shortcutType == 'sign_up') {
        Navigator.pushNamed(context, SignUp);
      }
    });
  }

  Widget createClient() {
    return GraphQLProvider(
      client: ValueNotifier(GraphQlApiCalling().clientToQuery()),
      child: CacheProvider(
        child: buildUI(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return createClient();
  }

  Widget buildUI() {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: UpgradeAlert(
        upgrader: Upgrader(
          dialogStyle: Platform.isAndroid
              ? UpgradeDialogStyle.material
              : UpgradeDialogStyle.cupertino,
        ),
        child: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "AppName".localized(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.normalFontSize),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      checkInternetConnection().then((value) {
                        if (value) {
                          Navigator.pushNamed(context, Notifications);
                        } else {
                          ShowMessage.showNotification(
                              "InternetIssue".localized(),
                              "",
                              Colors.red,
                              const Icon(Icons.cancel_outlined));
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.notifications,
                      // color: Colors.white,
                    )),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    checkInternetConnection().then((value) {
                      if (value) {
                        Navigator.pushNamed(context, Search).then((value) {
                          homePageBloc?.add(CartCountEvent());
                        });
                      } else {
                        ShowMessage.showNotification("InternetIssue".localized(),
                            "", Colors.red, const Icon(Icons.cancel_outlined));
                      }
                    });
                  },
                ),
                StreamBuilder(
                  stream: onVariableChanged,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _cartButtonValue(0);
                    }
                    return _cartButtonValue(
                        int.tryParse(snapshot.data.toString()) ?? 0);
                  },
                )
              ],
            ),
            drawer: _drawerData(context),
            body: _setHomePageData(context),
          ),
        ),
      ),
    );
  }

  ///method to set value on cart badge
  _cartButtonValue(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BadgeIcon(
          icon: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 22,
            ),
            // color: Colors.red,
            onPressed: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.pushNamed(context, CartPage).then((value) {
                    homePageBloc?.add(CartCountEvent());
                  });
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
          ),
          badgeCount: count),
    );
  }

  ///Drawer Bloc container
  _drawerData(BuildContext context) {
    return BlocConsumer<DrawerBloc, DrawerPageBaseState>(
      listener: (BuildContext context, DrawerPageBaseState state) {},
      buildWhen: (DrawerPageBaseState prev, DrawerPageBaseState current) {
        if (current is FetchDrawerPageDataState) {
          return true;
        }
        return false;
      },
      builder: (BuildContext context, DrawerPageBaseState state) {
        return buildDrawer(context, state);
      },
    );
  }

  ///Drawer UI methods
  Widget buildDrawer(BuildContext context, DrawerPageBaseState state) {
    if (state is FetchDrawerPageDataState) {
      if (state.status == DrawerStatus.success) {
        getCategoriesDrawerData = state.getCategoriesDrawerData;
        homePageBloc?.add(CurrencyLanguageEvent());
      }
      if (state.status == DrawerStatus.fail) {
        return CommonWidgets().getTextFieldHeight(0);
      }
    }
    return getCategoriesDrawerData != null
        ? DrawerListView(
            getDrawerCategoriesData: getCategoriesDrawerData!,
            isLoggedIn: isLoggedIn,
            customerUserName: customerUserName,
            image: image,
            customerCurrency: customerCurrency,
            cmsData: cmsData,
            currencyLanguageList: currencyLanguageList,
            customerLanguage: customerLanguage,
            setupQuickActions: _setupQuickActions,
          )
        : Container();
  }

  ///Home Bloc Container
  _setHomePageData(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageBaseState>(
      listener: (BuildContext context, HomePageBaseState state) {
        if (state is AddToCartState) {
          homePageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
          if (state.status == Status.fail) {
            ShowMessage.showNotification(
                "Failed",
                state.graphQlBaseModel?.message,
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == Status.success) {
            addToCartModel = state.graphQlBaseModel;
            ShowMessage.showNotification(
                state.graphQlBaseModel?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
            SharedPreferenceHelper.setCartCount(
                addToCartModel?.cart?.itemsCount ?? 0);
            _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount ?? 0);
          }
        } else if (state is FetchAddWishlistHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.showNotification(
                "Failed",
                state.error,
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.cancel_outlined));
          } else if (state.status == Status.success) {
            ShowMessage.showNotification(
                state.response?.success ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveWishlistState) {
          if (state.status == Status.fail) {
            ShowMessage.showNotification("Failed", state.successMsg ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == Status.success) {
            ShowMessage.showNotification(
                state.response?.success ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is AddToCompareHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == Status.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
      },
      builder: (BuildContext context, HomePageBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///Home Ui methods
  Widget buildContainer(BuildContext context, HomePageBaseState state) {
    if (state is ShowLoaderState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    if (state is FetchAddWishlistHomepageState) {
      isLoading = false;
      if (state.status == Status.success) {
        isLoading = false;
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is RemoveWishlistState) {
      isLoading = false;
      if (state.status == Status.success) {
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
        isLoading = false;
      }
    }

    if (state is AddToCompareHomepageState) {
      isLoading = false;
      isLoading = false;
      if (state.status == Status.success) {
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }

    if (state is AddToCartState) {
      if (state.status == Status.success) {
        isLoading = false;

        SharedPreferenceHelper.setCartCount(
            addToCartModel?.cart?.itemsCount ?? 0);
        _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount ?? 0);
      }
    }

    if (state is OnClickLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }

    /// new advertisements
    if (state is FetchAdvertisementState) {
      fetchOfflineProductData();
      if (state.status == Status.success) {
        advertisementData = state.advertisementData;
      }
      homePageBloc?.add(CartCountEvent());
    }

    /// new advertisements
    if (state is FetchCartCountState) {
      if (state.status == Status.success) {
        cartData = state.advertisementData;
        if (cartData != null) {
          SharedPreferenceHelper.setCartCount(cartData?.cart?.itemsCount ?? 0);
          _myStreamCtrl.sink.add(cartData?.cart?.itemsCount ?? 0);
        }
        homePageBloc?.add(FetchNewProductEvent());
      }
    }

    /// new sliders
    if (state is FetchHomepageSlidersState) {
      if (state.status == Status.success) {
        homeSlidersData = state.homepageSliders;

      } else if (state.status == Status.fail) {
        Future.delayed(Duration.zero)
            .then((value) => _homePageError("InternetIssue".localized()));

        return CommonWidgets().getTextFieldHeight(0);
      }
      homePageBloc?.add(FetchCMSDataEvent());
    }
    if (state is FetchCMSDataState) {
      cmsData = state.cmsData;
      homePageBloc?.add(FetchAdvertisementEvent());
    }

    /// new products
    if (state is NewProductDataState) {
      if (state.status == Status.success) {
        if (newProductDb != null &&
            newProductDb!.length > 0 &&
            newProductDb?.getAt(0) != null) {
          newProductDb?.deleteAt(0);
        }
        newProductsModel = state.newProductsModel!;
        newProductDb?.add(newProductsModel);
      } else if (state.status == Status.fail) {
        Future.delayed(Duration.zero)
            .then((value) => _homePageError("InternetIssue".localized()));

        return CommonWidgets().getTextFieldHeight(0);
      }

      homePageBloc?.add(FetchFeaturedProduct());
    }

    /// featured product
    if (state is FeaturedProductDataState) {
      if (state.status == Status.success) {
        if (featureProductDb != null &&
            featureProductDb!.length > 0 &&
            featureProductDb?.getAt(0) != null) {
          featureProductDb?.deleteAt(0);
        }
        featuredProduct = state.newProductsModel!;
        featureProductDb?.add(featuredProduct);
      } else if (state.status == Status.fail) {
        Future.delayed(Duration.zero).then((value) => _homePageError("InternetIssue".localized()));

        return CommonWidgets().getTextFieldHeight(0);
      }
    }

    if (state is FetchLanguageCurrencyState) {
      if (state.status == Status.success) {
        currencyLanguageList = state.currencyLanguageList!;
        GlobalData.languageData = state.currencyLanguageList?.locales;
      }
    }

    return buildHomePageUI(
      homeSlidersData?.data,
      advertisementData,
      newProductsModel?.data,
      featuredProduct?.data,
    );
  }

  Widget buildHomePageUI(
    List<HomeSliders>? homeSliders,
    Advertisements? advertisements,
    List<NewProducts>? newProducts,
    List<NewProducts>? featuredProduct,
  ) {
    return HomePagView(
      homeSliders,
      advertisements,
      newProducts,
      featuredProduct,
      scaffoldMessengerKey,
      isLoading,
      isLoggedIn,
    );
  }

  ///method will call when there is error on homepage
  _homePageError(String error) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: const Text(
                "Your Internet seems to be not working.Please check your Internet Connection"),
            actions: <Widget>[
              new MaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    ShowMessage.showNotification("closeApp".localized(), "",
                        Colors.yellow, const Icon(Icons.warning_amber));
                    Future.delayed(const Duration(seconds: 2), () {
                      exit(0);
                    });
                    // exit(0);
                  },
                  child: Text("ButtonLabelOk".localized())),
            ],
          );
        });
  }

  ///fetch data from shared pref
  _fetchSharedPreferenceData() {
    getCustomerLoggedInPrefValue().then((isLogged) async {
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            customerUserName = value;
            isLoggedIn = isLogged;
            _setupQuickActions();
          });
        });
        SharedPreferenceHelper.getCustomerImage().then((value) {
          setState(() {
            image = value;
            isLoggedIn = isLogged;
            _setupQuickActions();
          });
        });
      } else {
        setState(() {
          customerUserName = /*WelcomeGuest*/
              "SignInLabel".localized();
          isLoggedIn = isLogged;
          _setupQuickActions();
        });
      }
    });
  }
}

///fetch that the user is login or not?
Future getCustomerLoggedInPrefValue() async {
  return await SharedPreferenceHelper.getCustomerLoggedIn();
}

///fetch cart count saved in shared pref
Future getSharePreferenceCartCount() async {
  return await SharedPreferenceHelper.getCartCount();
}

///fetch customer's language saved in shared pref
Future getCustomerLanguageName() async {
  return await SharedPreferenceHelper.getLanguageName();
}
Future getLanguageCode() async {
  return await SharedPreferenceHelper.getCustomerLanguage();
}

///fetch customer's currency saved in shared pref
Future getCurrencyName() async {
  return await SharedPreferenceHelper.getCurrencyLabel();
}

///class used to pass data on subcategories screen
class DrawerSubCategories {
  DrawerSubCategories({this.category, this.title});

  String? title;
  HomeCategories? category;
}

///class use to pass data on categories screen
class CategoryProductData {
  CategoryProductData(
      {this.image, this.title, this.categorySlug, this.metaDescription});

  String? categorySlug;
  String? title;
  String? image;
  String? metaDescription;
}
