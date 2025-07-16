/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/account_models/account_info_details.dart';
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';
import '../../utils/server_configuration.dart';
import '../../utils/shared_preference_keys.dart';

//ignore: must_be_immutable
class DrawerListView extends StatefulWidget {
  bool isLoggedIn;
  AccountInfoModel? customerDetails;
  String? customerUserName;
  String? image;
  final String? customerLanguage;
  final CurrencyLanguageList? currencyLanguageList;
  final String? customerCurrency;
  final Function? loginCallback;

  DrawerListView(
      {Key? key,
      required this.isLoggedIn,
      required this.customerUserName,
      required this.image,
      this.customerLanguage,
      this.currencyLanguageList,
      required this.customerCurrency,
      this.customerDetails,
      this.loginCallback})
      : super(key: key);

  @override
  State<DrawerListView> createState() => _DrawerListViewState();
}

class _DrawerListViewState extends State<DrawerListView> {
  @override
  void initState() {
    appStoragePref.configurationStorage.listenKey(customerDetails, (value) {
      AccountInfoModel? data = value as AccountInfoModel?;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            widget.customerDetails = data;
          });
        }
      });
    });
    super.initState();
  }

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
          padding:
              const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal / 2),
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
                  : Padding(
                      padding: const EdgeInsets.all(AppSizes.spacingNormal),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(widget.image ?? ""),
                        backgroundImage:
                            const AssetImage(AssetConstants.userPlaceHolder),
                      )),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !widget.isLoggedIn
                          ? StringConstants.signUpOrLogin.localized()
                          : "${StringConstants.helloLabel.localized()} ${widget.customerDetails?.firstName ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(40, 0, 0, 0),
                          ),
                          const Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 5,
                            color: Color.fromARGB(40, 0, 0, 255),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isLoggedIn)
                      Text(widget.customerDetails?.email ?? "",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                            shadows: <Shadow>[
                              const Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 3.0,
                                color: Color.fromARGB(40, 0, 0, 0),
                              ),
                              const Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 5,
                                color: Color.fromARGB(40, 0, 0, 255),
                              ),
                            ],
                            color: Colors.grey,
                          )),
                  ],
                ),
              ),
              if (!widget.isLoggedIn)
                Padding(
                  padding: const EdgeInsets.only(right: AppSizes.spacingNormal),
                  child: Icon(GlobalData.locale == "ar"
                      ? Icons.keyboard_double_arrow_left
                      : Icons.keyboard_double_arrow_right),
                )
            ],
          ),
        ),
      ),
    );

    GlobalData.categoriesDrawerData?.data?.forEach((element) {
      drawerList.add(DrawerCategoryItem(element));
    });

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          checkInternetConnection().then((value) {
            if (value) {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(dashboardScreen);
            } else {
              ShowMessage.showNotification(
                  StringConstants.failed.localized(),
                  StringConstants.internetIssue.localized(),
                  Colors.red,
                  const Icon(Icons.cancel_outlined));
            }
          });
        },
        icon: Icons.dashboard,
        subTitle: StringConstants.dashboard,
      ));
    }

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          checkInternetConnection().then((value) {
            if (value) {
              Navigator.pushNamed(context, downloadableProductScreen);
            } else {
              ShowMessage.showNotification(
                  StringConstants.failed.localized(),
                  StringConstants.internetIssue.localized(),
                  Colors.red,
                  const Icon(Icons.cancel_outlined));
            }
          });
        },
        icon: Icons.download_outlined,
        subTitle: StringConstants.downloadableProductsList,
      ));
    }

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(addressListScreen);
        },
        icon: Icons.gps_fixed_outlined,
        subTitle: StringConstants.addressTitle,
      ));
    }

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.of(context).pushNamed(reviewList);
        },
        icon: Icons.reviews,
        subTitle: StringConstants.reviewsTitle,
      ));
    }

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.of(context).pushNamed(wishlistScreen).then((value) {
            Navigator.pop(context);
          });
        },
        icon: Icons.favorite_outline_rounded,
        subTitle: StringConstants.wishListTitle,
      ));
    }

    if (widget.isLoggedIn) {
      drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.of(context).pushNamed(orderListScreen);
        },
        icon: Icons.reorder,
        subTitle: StringConstants.orderTitle,
      ));
    }

    if (GlobalData.cmsData != null) {
      drawerList.add(CmsItemsList(
        cmsData: GlobalData.cmsData,
      ));
    }

    drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.pushNamed(context, languageScreen);
        },
        icon: Icons.language_sharp,
        subTitle: widget.customerLanguage ??
            widget.currencyLanguageList?.locales?.first.name));

    drawerList.add(DrawerAddItemList(
        onTap: () {
          Navigator.pushNamed(context, currencyScreen);
        },
        icon: Icons.currency_exchange_rounded,
        subTitle: (widget.customerCurrency ?? "").isEmpty
            ? (widget.currencyLanguageList?.baseCurrency?.name ??
                defaultCurrencyName)
            : widget.customerCurrency));
    widget.isLoggedIn
        ? drawerList.add(DrawerAddItemList(
            onTap: () {
              Navigator.pushNamed(context, gdpr);
            },
            icon: Icons.privacy_tip_outlined,
            subTitle: StringConstants.gdprComplianceTitle.localized(),
          ))
        : const SizedBox();

    widget.isLoggedIn
        ? drawerList.add(LogoutButton(
            customerDetails: widget.customerDetails,
            fetchSharedPreferenceData: _fetchSharedPreferenceData,
          ))
        : const SizedBox();

    drawerList.add(const SizedBox(height: AppSizes.spacingNormal));

    return Drawer(
        elevation: AppSizes.spacingMedium,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: AppSizes.safeAreaPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: drawerList,
                ),
              ],
            ),
          ),
        ));
  }

  _fetchSharedPreferenceData() async {
    bool isLogged = appStoragePref.getCustomerLoggedIn();
    if (widget.loginCallback != null) {
      widget.loginCallback!(isLogged);
    }
    if (isLogged) {
      String value = appStoragePref.getCustomerName();
      setState(() {
        widget.customerUserName = value;
        widget.isLoggedIn = isLogged;
      });
      String imageValue = appStoragePref.getCustomerImage();
      setState(() {
        widget.image = imageValue;
        widget.isLoggedIn = isLogged;
      });
    } else {
      setState(() {
        widget.customerUserName = StringConstants.signUpOrLogin.localized();
        widget.isLoggedIn = isLogged;
      });
    }
  }
}
