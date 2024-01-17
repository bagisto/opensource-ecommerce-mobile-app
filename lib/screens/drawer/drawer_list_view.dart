import 'package:bagisto_app_demo/screens/drawer/widget/drawer_add_item_view.dart';
import 'package:bagisto_app_demo/screens/drawer/widget/drawer_category_item.dart';
import 'package:bagisto_app_demo/screens/drawer/widget/log_out_button.dart';
import 'package:bagisto_app_demo/screens/sign_up/utils/index.dart';
import 'package:flutter/material.dart';
import '../../data_model/account_models/account_info_details.dart';
import '../../data_model/currency_language_model.dart';
import '../../main.dart';
import '../../utils/assets_constants.dart';
import '../../utils/check_internet_connection.dart';
import '../cms_screen/data_model/cms_model.dart';
import '../cms_screen/widgets/cms_item_list.dart';
import '../home_page/data_model/get_categories_drawer_data_model.dart';
import '../home_page/utils/fetch_shared_pref_helper.dart';
import 'package:bagisto_app_demo/utils/index.dart';
import 'package:collection/collection.dart';
import '../recent_product/utils/database.dart';

class DrawerListView extends StatefulWidget {
  final GetDrawerCategoriesData getDrawerCategoriesData;
  bool isLoggedIn;
  final CmsData? cmsData;
  final AccountInfoDetails? customerDetails;
  String? customerUserName;
  String? image;
  final String? customerLanguage;
  final CurrencyLanguageList? currencyLanguageList;
  final String? customerCurrency;
  final dynamic setupQuickActions;
  final Function? loginCallback;

  DrawerListView({
    Key? key,
    required this.getDrawerCategoriesData,
    required this.isLoggedIn,
    this.cmsData,
    required this.customerUserName,
    required this.image,
    this.customerLanguage,
    this.currencyLanguageList,
    required this.customerCurrency,
    this.customerDetails,
    this.setupQuickActions,
    this.loginCallback
  }) : super(key: key);

  @override
  State<DrawerListView> createState() => _DrawerListViewState();
}

class _DrawerListViewState extends State<DrawerListView> {

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerList = [];

    drawerList.add(const SizedBox(height: AppSizes.spacingWide));

    drawerList.add(
      GestureDetector(
        onTap: () {
          widget.isLoggedIn
              ? Navigator.of(context).pushNamed(accountInfo)
              : Navigator.of(context).pushNamed(signIn);
        },
        child: Container(
          margin: const EdgeInsets.all(AppSizes.spacingLarge),
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingNormal / 2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(AppSizes.spacingLarge)),
          child: Row(
            children: [
              widget.isLoggedIn != true
                  ? const Padding(
                      padding: EdgeInsets.all(AppSizes.spacingNormal),
                      child: ClipOval(
                        child: Image(
                            width: AppSizes.buttonHeight,
                            height: AppSizes.buttonHeight,
                            fit: BoxFit.cover,
                            image: AssetImage(AssetConstants.userPlaceHolder)),
                      ))
                  :
              Padding(
                      padding: const EdgeInsets.all(AppSizes.spacingNormal),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(widget.image ?? ""),
                        backgroundImage: const AssetImage(AssetConstants.userPlaceHolder),
                      )
                    ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      !widget.isLoggedIn
                          ? StringConstants.signUpOrLogin.localized()
                          : "${StringConstants.helloLabel.localized()} ${widget.customerDetails?.data?.firstName ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(
                                40, 0, 0, 0),
                          ),
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 5,
                            color: Color.fromARGB(
                                40, 0, 0, 255),
                          ),
                        ],
                      ),
                    ),
                    if(widget.isLoggedIn) Text(
                        widget.customerDetails?.data?.email ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 3.0,
                            color:
                            Color.fromARGB(40, 0, 0, 0),
                          ),
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 5,
                            color: Color.fromARGB(
                                40, 0, 0, 255),
                          ),
                        ],
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              if(!widget.isLoggedIn) const Padding(
                padding: EdgeInsets.only(right: AppSizes.spacingNormal),
                child: Icon(Icons.keyboard_double_arrow_right),
              )
            ],
          ),
        ),
      ),
    );

    widget.getDrawerCategoriesData.data?.forEach((element) {
      drawerList.add(DrawerCategoryItem(element));
    });

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        checkInternetConnection().then((value) {
          if (value) {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(dashboardScreen);
          } else {
            ShowMessage.showNotification(StringConstants.failed.localized(),StringConstants.internetIssue.localized(),
                Colors.red, const Icon(Icons.cancel_outlined));
          }
        });
      },
      icon: Icons.dashboard,
      subTitle: StringConstants.dashboard,
    ));
    }

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        checkInternetConnection().then((value) {
          if (value) {
            Navigator.pushNamed(context, downloadableProductScreen);
          } else {
            ShowMessage.showNotification(StringConstants.failed.localized(),
                StringConstants.internetIssue.localized(),
                Colors.red, const Icon(Icons.cancel_outlined));
          }
        });
      },
      icon: Icons.download_outlined,
      subTitle: StringConstants.downloadableProductsList,
    ));
    }

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(addressListScreen);
      },
      icon: Icons.gps_fixed_outlined,
      subTitle: StringConstants.addressTitle,
    ));
    }

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        Navigator.of(context).pushNamed(reviewList);
      },
      icon: Icons.reviews,
      subTitle: StringConstants.reviewsTitle,
    ));
    }

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        Navigator.of(context)
            .pushNamed(wishlistScreen)
            .then((value) {
          Navigator.pop(context);
        });
      },
      icon: Icons.favorite_outline_rounded,
      subTitle: StringConstants.wishListTitle,
    ));
    }

    if(widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
      onTap: () {
        Navigator.of(context).pushNamed(orderListScreen);
      },
      icon: Icons.reorder,
      subTitle: StringConstants.orderTitle,
    ));
    }

    if (widget.cmsData != null) {
      drawerList.add(CmsItemsList(
        cmsData: widget.cmsData,
      ));
    }

    widget.isLoggedIn
        ? drawerList.add(LogoutButton(
            customerDetails: widget.customerDetails,
            fetchSharedPreferenceData: _fetchSharedPreferenceData,
          ))
        : const SizedBox();

    return Drawer(
        elevation: AppSizes.spacingMedium,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: drawerList,
              ),
              currencyLanguageWidget()
            ],
          ),
        ));
  }

  Widget currencyLanguageWidget() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: widget.currencyLanguageList?.currencies
                  ?.map((Currencies? value) {
                return DropdownMenuItem<String>(
                  value: value?.name,
                  child: Text(value?.name ?? ""),
                );
              }).toList(),
              elevation: 0,
              onChanged: (val) async {
                Currencies? currency = widget.currencyLanguageList?.currencies?.firstWhereOrNull((element) => element.name == val);

                if (currency?.name == widget.customerCurrency) {
                  SharedPreferenceHelper.setCurrencyCode(currency?.code ?? "USD");
                  Navigator.pop(context, currency?.code);
                } else {
                  SharedPreferenceHelper.setCurrencyCode(currency?.code ?? "USD");
                  GlobalData.currency = await SharedPreferenceHelper.getCurrencyCode();
                  SharedPreferenceHelper.setCurrencyLabel(currency?.name ?? "US Dollar");
                  AppDatabase.getDatabase().then(
                          (value) => value.recentProductDao
                          .deleteRecentProducts());

                  if(context.mounted){
                    RestartWidget.restartApp(context);
                    Navigator.pushNamedAndRemoveUntil(context, splash, (route) => false);
                  }
                }
              },
              value: widget.customerCurrency ??
                  widget.currencyLanguageList?.baseCurrency?.name ??
                  "US Dollar",
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: GlobalData.languageData?.map((Locales? value) {
                return DropdownMenuItem<String>(
                  value: value?.name,
                  child: Text(value?.name ?? ""),
                );
              }).toList(),
              elevation: 0,
              onChanged: (val) async{
                Locales? local = GlobalData.languageData?.firstWhereOrNull((element) => element.name == val);

                GlobalData.selectedLanguage = local?.code?? "";
                SharedPreferenceHelper.setCustomerLanguage(local?.code ?? "");
                GlobalData.locale =
                    await SharedPreferenceHelper.getCustomerLanguage();
                SharedPreferenceHelper.setLanguageName(local?.name ?? "");

                AppDatabase.getDatabase().then(
                        (value) => value.recentProductDao.deleteRecentProducts());

                if(context.mounted){
                  RestartWidget.restartApp(context);

                  Navigator.pushNamedAndRemoveUntil(
                      context, splash, (route) => false);
                }
              },
              value: widget.customerLanguage ??
                  widget.currencyLanguageList?.locales?.first.name,
            ),
          ),
        ],
      ),
    );
  }

  _fetchSharedPreferenceData() async {
    getCustomerLoggedInPrefValue().then((isLogged) {
      if(widget.loginCallback != null){
        widget.loginCallback!(isLogged);
      }
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            widget.customerUserName = value;
            widget.isLoggedIn = isLogged;
          });
        });
        SharedPreferenceHelper.getCustomerImage().then((value) {
          setState(() {
            widget.image = value;
            widget.isLoggedIn = isLogged;
          });
        });
      } else {
        setState(() {
          widget.customerUserName = StringConstants.signUpOrLogin.localized();
          widget.isLoggedIn = isLogged;
        });
      }
    });
  }
}
