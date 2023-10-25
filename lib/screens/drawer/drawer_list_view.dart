import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/drawer/widget/drawer_add_item_view.dart';
import 'package:bagisto_app_demo/screens/drawer/widget/log_out_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widget/common_widgets.dart';
import '../../common_widget/image_view.dart';
import '../../common_widget/show_message.dart';
import '../../configuration/app_sizes.dart';
import '../../helper/check_internet_connection.dart';
import '../../helper/shared_preference_helper.dart';
import '../../helper/theme_provider.dart';
import '../../models/cms_model/cms_model.dart';
import '../../models/currency_language_model.dart';
import '../../models/homepage_model/get_categories_drawer_data_model.dart';
import '../../routes/route_constants.dart';
import '../cms_data/view/cms_item_list.dart';
import '../homepage/view/homepage.dart';

// ignore: must_be_immutable
class DrawerListView extends StatefulWidget {
  final GetDrawerCategoriesData getDrawerCategoriesData;
  bool isLoggedIn;
  final CmsData? cmsData;
  String? customerUserName;
  String? image;
  final String? customerLanguage;
  final CurrencyLanguageList? currencyLanguageList;
  final String? customerCurrency;
  final dynamic setupQuickActions;

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
    this.setupQuickActions,
  }) : super(key: key);

  @override
  State<DrawerListView> createState() => _DrawerListViewState();
}

class _DrawerListViewState extends State<DrawerListView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> drawerList = <Widget>[];
    ThemeProvider? themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    drawerList.add(
      SizedBox(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: Colors.black,
          child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/images/customer_banner_placeholder.png'),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        checkInternetConnection().then((value) {
                          if (value) {
                            widget.isLoggedIn
                                ? Navigator.of(context).pushNamed(AccountInfo)
                                : Navigator.of(context).pushNamed(SignIn);
                          } else {
                            ShowMessage.showNotification(
                                "InternetIssue".localized(),
                                "",
                                Colors.red,
                                const Icon(Icons.cancel_outlined));
                          }
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                widget.isLoggedIn != true
                                    ? const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 8.0),
                                        child: ClipOval(
                                          child: Image(
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/customer_profile_placeholder.png')),
                                        ))
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 8.0, 8.0, 8.0),
                                        child: ClipOval(
                                            child: ImageView(
                                          url: widget.image ?? "",
                                          height: 50,
                                          width: 50,
                                        )),
                                      ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 2, 4),
                                        child: Text(
                                          !widget.isLoggedIn
                                              ? widget.customerUserName ?? ""
                                              : "Hello !",
                                          overflow: TextOverflow.ellipsis,
                                          //softWrap: true,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.5, 0.5),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      40, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(0.5, 0.5),
                                                  blurRadius: 5,
                                                  color: Color.fromARGB(
                                                      40, 0, 0, 255),
                                                ),
                                              ],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        !widget.isLoggedIn
                                            ? "toYourAccount".localized()
                                            : widget.customerUserName ?? "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(0.5, 0.5),
                                                blurRadius: 3.0,
                                                color:
                                                    Color.fromARGB(40, 0, 0, 0),
                                              ),
                                              Shadow(
                                                offset: Offset(0.5, 0.5),
                                                blurRadius: 5,
                                                color: Color.fromARGB(
                                                    40, 0, 0, 255),
                                              ),
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 20.0),
                            child: const IconTheme(
                                data: IconThemeData(color: Colors.white),
                                child: Icon(Icons.chevron_right)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
    widget.isLoggedIn
        ? CommonWidgets().getTextFieldHeight(0)
        : drawerList.add(DrawerAddItemList(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SignUp, arguments: false);
            },
            icon: Icons.person,
            subTitle: "SignUpTitle",
          ));

    drawerList.add(const DrawerAddItemList(
      headingTitle: "Categories",
    ));
    widget.getDrawerCategoriesData.data?.forEach((element) {
      drawerList.add(GestureDetector(
          child: SizedBox(
            height: 50,
            child: ListTile(
              leading: SizedBox(
                  width: AppSizes.iconSize,
                  height: AppSizes.iconSize,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover, placeholder: const AssetImage("assets/images/category_placeholder.png"), image: NetworkImage(element.categoryIconUrl ?? ""),
                    ),
                  )),
              title: CommonWidgets()
                  .getDrawerTileText(element.name ?? "", context),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          onDoubleTap: () {
            checkInternetConnection().then((value) {
              if (value) {
                Navigator.pushNamed(context, SubCategory,
                    arguments: CategoryProductData(
                        metaDescription: element.description,
                        categorySlug: element.slug ?? "",
                        title: element.name,
                        image: element.imageUrl));
              } else {
                ShowMessage.showNotification("InternetIssue".localized(), "",
                    Colors.red, const Icon(Icons.cancel_outlined));
              }
            });
          },
          onTap: () {
            checkInternetConnection().then((value) {
              if (value) {
                element.children!.isNotEmpty
                    ? Navigator.pushNamed(context, CategoryProduct,
                        arguments: DrawerSubCategories(
                            title: element.name, category: element))
                    : Navigator.pushNamed(context, SubCategory,
                        arguments: CategoryProductData(
                            metaDescription: element.description,
                            categorySlug: element.slug ?? "",
                            title: element.name,
                            image: element.imageUrl ?? ""));
              } else {
                ShowMessage.showNotification("InternetIssue".localized(), "",
                    Colors.red, const Icon(Icons.cancel_outlined));
              }
            });
          }));
    });

    widget.isLoggedIn
        ? drawerList.add(CommonWidgets().divider())
        : CommonWidgets().getTextFieldHeight(0);

    widget.isLoggedIn
        ? drawerList.add(const DrawerAddItemList(
            headingTitle: "AccountInformation",
          ))
        : CommonWidgets().getTextFieldHeight(0);

    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Dashboard);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.dashboard,
            subTitle: "Dashboard",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AddressList);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.gps_fixed_outlined,
            subTitle: "AddressTitle",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.of(context).pushNamed(ReviewList);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.reviews,
            subTitle: "ReviewsTitle",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.of(context)
                      .pushNamed(WishListDataScreen)
                      .then((value) {
                    Navigator.pop(context);
                  });
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.favorite_outline_rounded,
            subTitle: "WishListTitle",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.of(context).pushNamed(CompareProduct);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.compare_arrows,
            subTitle: "CompareTitle",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.of(context).pushNamed(OrderListData);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.reorder,
            subTitle: "OrderTitle",
          ))
        : CommonWidgets().getTextFieldHeight(0);
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              checkInternetConnection().then((value) {
                if (value) {
                  Navigator.pushNamed(context, DownloadableProducts);
                } else {
                  ShowMessage.showNotification("InternetIssue".localized(), "",
                      Colors.red, const Icon(Icons.cancel_outlined));
                }
              });
            },
            icon: Icons.account_box_rounded,
            subTitle: "DownloadableProductsList",
          ))
        : CommonWidgets().getTextFieldHeight(0);

    drawerList.add(const DrawerAddItemList(
      headingTitle: "LanguageAndCurrency",
    ));
    drawerList.add(DrawerAddItemList(
      onTap: () {
        Navigator.pushNamed(context, Languages,
            arguments: widget.currencyLanguageList);
      },
      icon: Icons.language_sharp,
      subTitle: widget.customerLanguage ?? widget.currencyLanguageList?.locales?.first.name,
    ));
    drawerList.add(DrawerAddItemList(
      onTap: () {
        checkInternetConnection().then((value) {
          if (value) {
            Navigator.pushNamed(context, CurrenciesPage,
                arguments: widget.currencyLanguageList);
          } else {
            ShowMessage.showNotification("InternetIssue".localized(), "",
                Colors.red, const Icon(Icons.cancel_outlined));
          }
        });
      },
      icon: Icons.currency_exchange_rounded,
      subTitle: widget.customerCurrency ??
          widget.currencyLanguageList?.baseCurrency?.name ??
          "US Dollar",
    ));
    drawerList.add(DrawerAddItemList(
      onTap: () {
        themeProvider.isDark == "true"
            ? themeProvider.isDark = "false"
            : themeProvider.isDark = "true";
      },
      icon: themeProvider.isDark == "true"
          ? Icons.nightlight_round
          : Icons.wb_sunny,
      subTitle: "ChangeTheme",
    ));

    if (widget.cmsData != null) {
      drawerList.add(const DrawerAddItemList(
        headingTitle: "CmsData",
      ));

      drawerList.add(CmsItemsList(
        cmsData: widget.cmsData,
      ));
    }


    widget.isLoggedIn
        ? drawerList.add(LogoutButton(
            fetchSharedPreferenceData: _fetchSharedPreferenceData(),
          ))
        : Container();

    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 200.0,
        child: ListView(
          shrinkWrap: true,
          children: drawerList,
        ));
  }

  _fetchSharedPreferenceData() async {
    getCustomerLoggedInPrefValue().then((isLogged) {
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            widget.customerUserName = value;
            widget.isLoggedIn = isLogged;
            widget.setupQuickActions();
          });
        });
        SharedPreferenceHelper.getCustomerImage().then((value) {
          setState(() {
            widget.image = value;
            widget.isLoggedIn = isLogged;
            widget.setupQuickActions();
          });
        });
      } else {
        setState(() {
          widget.customerUserName = "SignInLabel".localized();
          widget.isLoggedIn = isLogged;
          widget.setupQuickActions();
        });
      }
    });
  }
}
