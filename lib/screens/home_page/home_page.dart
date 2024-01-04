/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'dart:async';
import 'package:bagisto_app_demo/screens/home_page/utils/fetch_shared_pref_helper.dart';
import 'package:bagisto_app_demo/screens/home_page/widget/home_page_loader_view.dart';
import 'package:bagisto_app_demo/screens/home_page/widget/home_page_view.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import '../../data_model/account_models/account_info_details.dart';
import '../../data_model/currency_language_model.dart';
import '../../services/graph_ql.dart';
import '../../utils/app_global_data.dart';
import '../../utils/shared_preference_helper.dart';
import '../../utils/string_constants.dart';
import '../../utils/theme_provider.dart';
import '../../widgets/show_message.dart';
import '../cart_screen/cart_model/add_to_cart_model.dart';
import '../cms_screen/data_model/cms_model.dart';
import '../drawer/bloc/drawer_bloc.dart';
import '../drawer/bloc/drawer_events.dart';
import '../drawer/bloc/drawer_state.dart';
import '../drawer/drawer_list_view.dart';
import 'bloc/home_page_bloc.dart';
import 'bloc/home_page_event.dart';
import 'bloc/home_page_state.dart';
import 'data_model/advertisement_data.dart';
import 'data_model/get_categories_drawer_data_model.dart';
import 'data_model/new_product_data.dart';
import 'data_model/theme_customization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false, isLoading = false, isLastIndex = false;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  String? customerUserName, image, customerLanguage, customerCurrency;
  HomePageBloc? homePageBloc;
  AddToCartModel? addToCartModel;
  GraphQLClient? client;
  ThemeCustomDataModel? customHomeData;
  List<NewProductsModel?>? allProducts = [];
  CurrencyLanguageList? currencyLanguageList;
  GetDrawerCategoriesData? getCategoriesDrawerData;
  GetDrawerCategoriesData? getHomeCategoriesData;
  AccountInfoDetails? customerDetails;
  CmsData? cmsData;
  Advertisements? cartData;
  ThemeProvider? themeProvider;
  Box? newProductDb, featureProductDb, getCategoriesDrawerDb;
  DrawerBloc? drawerBloc;

  @override
  void initState() {
    _fetchSharedPreferenceData();
    drawerBloc = context.read<DrawerBloc>();
    drawerBloc?.add(FetchDrawerPageEvent([{
      "key": '\"parent_id\"',
      "value": '\"1\"'
    }]));
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    getCustomerLanguageName().then((value) {
      customerLanguage = value;
    });
    getCurrencyName().then((value) {
      customerCurrency = value;
    });
    fetchHomepageData();
    fetchOfflineProductData();
    getLanguageCode().then((value) => GlobalData.locale = value);
    homePageBloc?.add(FetchCMSDataEvent());
    super.initState();
  }

  fetchHomepageData() async {
    homePageBloc = context.read<HomePageBloc>();
    homePageBloc?.add(FetchHomeCustomData());
  }

  fetchOfflineProductData() async {
    getCategoriesDrawerDb = await Hive.openBox("getCategoriesDrawerData");
    if ((getCategoriesDrawerDb?.length ?? 0) > 0) {
      getCategoriesDrawerData = getCategoriesDrawerDb?.getAt(0);
    }
    debugPrint("getCategoriesDrawerData==>${getCategoriesDrawerData?.data}");
  }

  @override
  void dispose() {
    super.dispose();
    _myStreamCtrl.close();
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
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CommonAppBar(StringConstants.builderAppName.localized()),
        drawer: _drawerData(context),
        body: buildView(context),
      ),
    );
  }

  ///Drawer Bloc container
  _drawerData(BuildContext context) {
    return BlocConsumer<DrawerBloc, DrawerPageBaseState>(
      listener: (BuildContext context, DrawerPageBaseState state) {},
      builder: (BuildContext context, DrawerPageBaseState state) {
        if (state is FetchDrawerPageDataState) {
          if (state.status == DrawerStatus.success) {
            if (getCategoriesDrawerDb != null &&
                getCategoriesDrawerDb!.length > 0 &&
                getCategoriesDrawerDb?.getAt(0) != null) {
              getCategoriesDrawerDb?.deleteAt(0);
            }
            getCategoriesDrawerData = state.getCategoriesDrawerData;
            getCategoriesDrawerDb?.add(state.getCategoriesDrawerData);
          }
          drawerBloc?.add(CurrencyLanguageEvent());
        }
        if (state is FetchLanguageCurrencyState) {
          if (state.status == DrawerStatus.success) {
            currencyLanguageList = state.currencyLanguageList!;
            GlobalData.languageData = state.currencyLanguageList?.locales;
          }
          homePageBloc?.add(FetchCMSDataEvent());
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
          customerDetails: customerDetails,
          customerLanguage: customerLanguage,
        )
            : const SizedBox();
      },
    );
  }

  ///Home Bloc Container
  buildView(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageBaseState>(
      listener: (BuildContext context, HomePageBaseState state) {
        if (state is AddToCartState) {
          homePageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.graphQlBaseModel?.message ?? "", context);
          } else if (state.status == Status.success) {
            addToCartModel = state.graphQlBaseModel;
            ShowMessage.successNotification(state.graphQlBaseModel?.message ?? "", context);
            SharedPreferenceHelper.setCartCount(
                addToCartModel?.cart?.itemsCount ?? 0);
            _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount ?? 0);
          }
        } else if (state is FetchAddWishlistHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.error ??"", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(state.response?.success ?? "", context);
          }
        } else if (state is RemoveWishlistState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.successMsg ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(state.response?.success ?? "", context);
          }
        }
        if (state is AddToCompareHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
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
      return const HomePageLoader();
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

    /// all products state
    if (state is FetchAllProductsState) {
      if (state.status == Status.success) {
          allProducts?.add(state.allProducts);
      }
    }

    if (state is FetchCartCountState) {
      if (state.status == Status.success) {
        cartData = state.advertisementData;
        if (cartData != null) {
          SharedPreferenceHelper.setCartCount(cartData?.cart?.itemsCount ?? 0);
          _myStreamCtrl.sink.add(cartData?.cart?.itemsCount ?? 0);
        }
      }
    }

    /// new sliders
    if (state is FetchHomeCustomDataState) {
      if (state.status == Status.success) {
        allProducts?.clear();
        customHomeData = state.homepageSliders;
        (customHomeData?.themeCustomization?.forEach((element) {
          List<Map<String, dynamic>>? filters = [];

          if(element.type == "category_carousel"){
            element.translations?.firstOrNull?.options?.filters?.forEach((element) {
              filters.add({
                "key": '\"${element.key}\"',
                "value": '\"${element.value}\"'
              });
            });
            homePageBloc?.add(FetchHomePageCategoriesEvent(filters: filters));
          }
          else if(element.type == "product_carousel"){
            filters.clear();
            element.translations?.firstOrNull?.options?.filters?.forEach((element) {
              filters.add({
                "key": '\"${element.key}\"',
                "value": '\"${element.value}\"'
              });
            });
            homePageBloc?.add(FetchAllProductsEvent(filters));
          }
        }));
      } else if (state.status == Status.fail) {}
    }
    if (state is FetchCMSDataState) {
      cmsData = state.cmsData;
      if(isLoggedIn){
        homePageBloc?.add(CustomerDetailsEvent());
      }
    }

    if (state is CustomerDetailsState) {
      if (state.status == Status.success) {
        customerDetails = state.accountInfoDetails;
      }
      if (state.status == Status.fail) {}
    }

    if (state is FetchHomeCategoriesState) {
      if (state.status == Status.success) {
        getHomeCategoriesData = state.getCategoriesData;
      }
      if (state.status == Status.fail) {}
    }

    return (customHomeData?.themeCustomization ?? []).isEmpty
        ? const HomePageLoader()
        : HomePagView(
        customHomeData,
        isLoading,
        getHomeCategoriesData,
        isLoggedIn,
        allProducts,
        homePageBloc
    );
  }

  ///fetch data from shared pref
  _fetchSharedPreferenceData() async {
    getCustomerLoggedInPrefValue().then((isLogged) {
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            customerUserName = value;
            isLoggedIn = isLogged;
          });
        });
        SharedPreferenceHelper.getCustomerImage().then((value) {
          setState(() {
            image = value;
            isLoggedIn = isLogged;
          });
        });
      } else {
        setState(() {
          customerUserName = StringConstants.signInLabel.localized();
          isLoggedIn = isLogged;
        });
      }
    });
  }
}

