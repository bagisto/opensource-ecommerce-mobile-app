/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:async';
import 'dart:io';
import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';
import 'data_model/theme_customization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false, isLoading = false, callPreCache = true;
  String? customerUserName, image, customerLanguage, customerCurrency;
  HomePageBloc? homePageBloc;
  AddToCartModel? addToCartModel;
  ThemeCustomDataModel? customHomeData;
  CurrencyLanguageList? currencyLanguageList;
  GetDrawerCategoriesData? getHomeCategoriesData;
  AccountInfoModel? customerDetails;
  DrawerBloc? drawerBloc;

  @override
  void initState() {
    _registerStreamListener();
    _fetchSharedPreferenceData();
    drawerBloc = context.read<DrawerBloc>();
    getCartCount().then((value) {
      GlobalData.cartCountController.sink.add(value);
    });
    customerLanguage = appStoragePref.getLanguageName();
    customerCurrency = appStoragePref.getCurrencyLabel();
    fetchHomepageData();
    fetchOfflineProductData();
    GlobalData.locale = appStoragePref.getCustomerLanguage();
    super.initState();
  }

  Future<int> getCartCount() async {
    return appStoragePref.getCartCount();
  }

  fetchHomepageData() async {
    homePageBloc = context.read<HomePageBloc>();
    homePageBloc?.add(FetchHomeCustomData());
  }

  fetchOfflineProductData() async {
    GlobalData.categoriesDrawerData = appStoragePref.getDrawerCategories();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: CommonAppBar(StringConstants.builderAppName.localized()),
      drawer: _drawerData(context),
      body: buildView(context),
    );
  }

  ///Drawer Bloc container
  _drawerData(BuildContext context) {
    return BlocConsumer<DrawerBloc, DrawerPageBaseState>(
      listener: (BuildContext context, DrawerPageBaseState state) {},
      builder: (BuildContext context, DrawerPageBaseState state) {
        if (state is FetchDrawerPageDataState) {
          if (state.status == DrawerStatus.success) {
            GlobalData.categoriesDrawerData = state.getCategoriesDrawerData;
            appStoragePref.setDrawerCategories(state.getCategoriesDrawerData);
          }
          drawerBloc?.add(CurrencyLanguageEvent());
        }
        if (state is FetchLanguageCurrencyState) {
          if (state.status == DrawerStatus.success) {
            GlobalData.rootCategoryId =
                state.currencyLanguageList?.rootCategoryId ?? 1;
            currencyLanguageList = state.currencyLanguageList;
            GlobalData.languageData = state.currencyLanguageList;
          }
        }

        return DrawerListView(
          isLoggedIn: isLoggedIn,
          customerUserName: customerUserName,
          image: image,
          customerCurrency: customerCurrency,
          currencyLanguageList: currencyLanguageList,
          customerDetails: customerDetails,
          customerLanguage: customerLanguage,
          loginCallback: (isLogged) {
            setState(() {
              isLoggedIn = isLogged;
              if (isLogged == false) {
                GlobalData.cartCountController.sink
                    .add(appStoragePref.getCartCount());
              }
            });
          },
        );
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
            ShowMessage.errorNotification(
                state.graphQlBaseModel?.graphqlErrors ?? "", context);
          } else if (state.status == Status.success) {
            addToCartModel = state.graphQlBaseModel;
            ShowMessage.successNotification(
                state.graphQlBaseModel?.message ?? "", context);
            appStoragePref.setCartCount(addToCartModel?.cart?.itemsQty ?? 0);
            GlobalData.cartCountController.sink
                .add(addToCartModel?.cart?.itemsQty ?? 0);
          }
        } else if (state is FetchAddWishlistHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        } else if (state is RemoveWishlistState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.successMsg ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        }
        if (state is AddToCompareHomepageState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
        if (state is SubscribeNewsLetterState) {
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(
                state.baseModel?.message ??
                    state.baseModel?.graphqlErrors ??
                    "",
                context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.baseModel?.message ?? "", context);
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
      callPreCache = false;
      isLoading = false;
      if (state.status == Status.success) {
        GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
      }
    }
    if (state is RemoveWishlistState) {
      callPreCache = false;
      isLoading = false;
      if (state.status == Status.success) {
        GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
      }
    }
    if (state is AddToCompareHomepageState) {
      callPreCache = false;
      isLoading = false;
      if (state.status == Status.success) {
        GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
      }
    }

    if (state is AddToCartState) {
      callPreCache = false;
      if (state.status == Status.success) {
        isLoading = false;
        appStoragePref.setCartCount(addToCartModel?.cart?.itemsQty ?? 0);
        GlobalData.cartCountController.sink
            .add(addToCartModel?.cart?.itemsQty ?? 0);
      }
    }
    if (state is OnClickLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }

    /// all products state
    if (state is FetchAllProductsState) {
      callPreCache = true;
      if (state.status == Status.success) {}
      drawerBloc?.add(FetchDrawerPageEvent([
        {"key": '"status"', "value": '"1"'},
        {"key": '"locale"', "value": '"${GlobalData.locale}"'},
        {"key": '"parent_id"', "value": '"1"'}
      ]));
    }

    if (state is FetchCartCountState) {
      callPreCache = false;
      if (state.status == Status.success) {
        if (state.cartDetails != null) {
          appStoragePref.setCartCount(state.cartDetails?.itemsQty ?? 0);
          GlobalData.cartCountController.sink
              .add(state.cartDetails?.itemsQty ?? 0);
        }
      }
    }

    /// new sliders
    if (state is FetchHomeCustomDataState) {
      callPreCache = true;
      if (state.status == Status.success) {
        GlobalData.allProducts?.clear();
        customHomeData = state.homepageSliders;
        getHomePageData(customHomeData);
      } else if (state.status == Status.fail) {}
    }

    if (state is CustomerDetailsState) {
      callPreCache = false;
      if (state.status == Status.success) {
        customerDetails = state.accountInfoDetails;
        image = customerDetails?.imageUrl;
        appStoragePref.setCustomerDetails(customerDetails);
        appStoragePref.setCustomerImage(image ?? "");
      }
      if (state.status == Status.fail) {}
      homePageBloc?.add(CartCountEvent());
    }

    if (state is FetchHomeCategoriesState) {
      callPreCache = false;
      if (state.status == Status.success) {
        getHomeCategoriesData = state.getCategoriesData;
      }
      if (state.status == Status.fail) {}
      homePageBloc?.add(FetchCMSDataEvent());
    }
    if (state is FetchCMSDataState) {
      callPreCache = false;
      GlobalData.cmsData = state.cmsData;
      if (appStoragePref.getCustomerLoggedIn()) {
        homePageBloc?.add(CustomerDetailsEvent());
      } else {
        homePageBloc?.add(CartCountEvent());
      }
    }

    return (GlobalData.allProducts ?? []).isEmpty
        ? const HomePageLoader()
        : SafeArea(
            child: HomePageView(customHomeData, isLoading,
                getHomeCategoriesData, isLoggedIn, homePageBloc, callPreCache),
          );
  }

  ///fetch data from shared pref
  _fetchSharedPreferenceData() async {
    bool isLogged = appStoragePref.getCustomerLoggedIn();
    if (isLogged) {
      String value = appStoragePref.getCustomerName();
      setState(() {
        customerUserName = value;
        isLoggedIn = isLogged;
      });
      String imageValue = appStoragePref.getCustomerImage();
      setState(() {
        image = imageValue;
        isLoggedIn = isLogged;
      });
    } else {
      setState(() {
        customerUserName = StringConstants.signInLabel.localized();
        isLoggedIn = isLogged;
      });
    }
  }

  _registerStreamListener() {
    GlobalData.productsStream.stream.listen((event) {
      if ((event?.data ?? []).isNotEmpty) {
        GlobalData.allProducts?.add(event);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getHomePageData(ThemeCustomDataModel? customHomeData) async {
    customHomeData?.themeCustomization ??= [];
    if (customHomeData?.themeCustomization != null) {
      await Future.wait(
          customHomeData!.themeCustomization!.map((element) async {
        List<Map<String, dynamic>>? filters = [];

        if (element.type == "category_carousel") {
          filters.clear();
          element.translations
              ?.firstWhereOrNull((e) => e.localeCode == GlobalData.locale)
              ?.options
              ?.filters
              ?.forEach((element) {
            filters.add(
                {"key": '"${element.key}"', "value": '"${element.value}"'});
          });
          homePageBloc?.add(FetchHomePageCategoriesEvent(filters: filters));
        } else if (element.type == "product_carousel") {
          filters.clear();
          element.translations
              ?.firstWhereOrNull((e) => e.localeCode == GlobalData.locale)
              ?.options
              ?.filters
              ?.forEach((element) {
            filters.add(
                {"key": '"${element.key}"', "value": '"${element.value}"'});
          });
          homePageBloc?.add(FetchAllProductsEvent(filters));
        }
      }));
    }
  }
}
