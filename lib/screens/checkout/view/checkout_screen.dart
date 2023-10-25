/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'dart:async';

import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/bloc/checkout_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/repository/checkout_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/view/checkout_address_view.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/bloc/checkout_payment_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/repository/checkout_payment_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/view/checkout_payment_view.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/bloc/checkout_review_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/repository/checkout_review_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/bloc/checkout_shipping_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/repository/checkout_shipping_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/view/checkout_shipping_view.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/bloc/guest_address_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/repository/guest_address_repository.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/view/guest_add_address_form.dart';
import 'package:bagisto_app_demo/screens/checkout/view/checkout_header_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/cart_model/cart_data_model.dart';
import '../../../routes/route_constants.dart';
import '../../cart_screen/bloc/cart_screen_bloc.dart';
import '../checkout_review/view/checkout_order_review_view.dart';

class CheckoutScreen extends StatefulWidget {
  CartScreenBloc? cartScreenBloc;

  String? total;
  bool? isDownloadable;
  CartModel? cartDetailsModel;

  CheckoutScreen(
      {Key? key,
      this.total,
      this.cartScreenBloc,
      this.cartDetailsModel,
      this.isDownloadable = false})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentIndex = 1;
  Map<String, dynamic>? billing;
  Map<String, dynamic>? shipping;
  String? billingCompanyName;
  String? billingFirstName;
  String? billingLastName;
  String? billingAddress;
  String? billingEmail;
  String? billingAddress2;
  String? billingCountry;
  String? billingState;
  String? billingCity;
  String? billingPostCode;
  String? billingPhone;
  String? shippingCompanyName;
  String? shippingFirstName;
  String? shippingLastName;
  String? shippingAddress;
  String? shippingEmail;
  String? shippingAddress2;
  String? shippingCountry;
  String? shippingState;
  String? shippingCity;
  String? shippingPostCode;
  String? shippingPhone;
  String shippingId = '';
  String paymentId = "";
  bool isUser = false;
  String? email;
  String? updatedPrice;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final StreamController _myStreamCtrl = StreamController.broadcast();

  Stream get onVariableChanged => _myStreamCtrl.stream;

  @override
  void initState() {
    _fetchSharedPrefData();
    getSharePreferenceEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    super.initState();
  }

  Future getSharePreferenceEmail() async {
    return await SharedPreferenceHelper.getCustomerEmail();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:Directionality(
          textDirection: GlobalData.contentDirection(),
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentIndex == 1
                ? "AddressTitle".localized()
                : currentIndex == 2
                    ? "ShippingMethods".localized()
                    : currentIndex == 3
                        ? "PaymentMethod".localized()
                        : "reviewAndCheckout".localized(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body:  _buildUI( context),
        )
      ),
    );
  }

  Future getCustomerLoggedInPrefValue() async {
    return await SharedPreferenceHelper.getCustomerLoggedIn();
  }

  _fetchSharedPrefData() {
    getCustomerLoggedInPrefValue().then((value) {
      setState(() {
        isUser = value;
      });
    });
  }

  _getBody() {
    switch (currentIndex) {
      case 1:
        return isUser
            ? BlocProvider(
                create: (context) =>
                    CheckOutBloc(repository: CheckOutRepositoryImp()),
                child: CheckoutAddressView(
                  callBack: (billingCompanyName,
                      billingFirstName,
                      billingLastName,
                      billingAddress,
                      billingAddress2,
                      billingCountry,
                      billingState,
                      billingCity,
                      billingPostCode,
                      billingPhone,
                      shippingCompanyName,
                      shippingFirstName,
                      shippingLastName,
                      shippingAddress,
                      shippingAddress2,
                      shippingCountry,
                      shippingState,
                      shippingCity,
                      shippingPostCode,
                      shippingPhone) {
                    this.billingCompanyName = billingCompanyName;
                    this.billingFirstName = billingFirstName;
                    this.billingLastName = billingLastName;
                    this.billingAddress = billingAddress;
                    billingEmail = email;
                    this.billingAddress2 = billingAddress2;
                    this.billingCountry = billingCountry;
                    this.billingState = billingState;
                    this.billingCity = billingCity;
                    this.billingPostCode = billingPostCode;
                    this.billingPhone = billingPhone;
                    this.shippingCompanyName = shippingCompanyName;
                    this.shippingFirstName = shippingFirstName;
                    this.shippingLastName = shippingLastName;
                    this.shippingAddress = shippingAddress;
                    shippingEmail = email;
                    this.shippingAddress2 = shippingAddress2;
                    this.shippingCountry = shippingCountry;
                    this.shippingState = shippingState;
                    this.shippingCity = shippingCity;
                    this.shippingPostCode = shippingPostCode;
                    this.shippingPhone = shippingPhone;
                  },
                ),
              )
            : BlocProvider(
                create: (context) =>
                    GuestAddressBloc(repository: GuestAddressRepositoryImp()),
                child: GuestAddAddressForm(callBack: (billingCompanyName,
                    billingFirstName,
                    billingLastName,
                    billingAddress,
                    billingAddress2,
                    billingCountry,
                    billingState,
                    billingCity,
                    billingPostCode,
                    billingPhone,
                    billingEmail,
                    shippingEmail,
                    shippingCompanyName,
                    shippingFirstName,
                    shippingLastName,
                    shippingAddress,
                    shippingAddress2,
                    shippingCountry,
                    shippingState,
                    shippingCity,
                    shippingPostCode,
                    shippingPhone) {
                  this.billingCompanyName = billingCompanyName;
                  this.billingFirstName = billingFirstName;
                  this.billingLastName = billingLastName;
                  this.billingAddress = billingAddress;
                  this.billingEmail = billingEmail;
                  this.billingAddress2 = billingAddress2;
                  this.billingCountry = billingCountry;
                  this.billingState = billingState;
                  this.billingCity = billingCity;
                  this.billingPostCode = billingPostCode;
                  this.billingPhone = billingPhone;
                  this.shippingCompanyName = shippingCompanyName;
                  this.shippingFirstName = shippingFirstName;
                  this.shippingLastName = shippingLastName;
                  this.shippingAddress = shippingAddress;
                  this.shippingEmail = shippingEmail;
                  this.shippingAddress2 = shippingAddress2;
                  this.shippingCountry = shippingCountry;
                  this.shippingState = shippingState;
                  this.shippingCity = shippingCity;
                  this.shippingPostCode = shippingPostCode;
                  this.shippingPhone = shippingPhone;
                }),
              );

      case 2:
        return BlocProvider(
          create: (context) =>
              CheckOutShippingBloc(repository: CheckOutShippingRepositoryImp()),
          child: CheckoutShippingPageView(
            billingCompanyName: billingCompanyName,
            billingFirstName: billingFirstName,
            billingLastName: billingLastName,
            billingAddress: billingAddress,
            billingEmail: billingEmail,
            billingAddress2: billingAddress2,
            billingCountry: billingCountry,
            billingState: billingState,
            billingCity: billingCity,
            billingPostCode: billingPostCode,
            billingPhone: billingPhone,
            shippingCompanyName: shippingCompanyName,
            shippingFirstName: shippingFirstName,
            shippingLastName: shippingLastName,
            shippingAddress: shippingAddress,
            shippingEmail: shippingEmail,
            shippingAddress2: shippingAddress2,
            shippingCountry: shippingCountry,
            shippingState: shippingState,
            shippingCity: shippingCity,
            shippingPostCode: shippingPostCode,
            shippingPhone: shippingPhone,
            callBack: (
              id,
            ) {
              shippingId = id;
            },

          ),
        );
      case 3:
        return BlocProvider(
          create: (context) =>
              CheckOutPaymentBloc(repository: CheckOutPaymentRepositoryImp()),
          child: CheckoutPaymentView(
            total: widget.total,
            shippingId: shippingId,
            callBack: (id) {
              paymentId = id;
            },
            priceCallback: (price) {
              _myStreamCtrl.sink.add(price);
            },
          ),
        );

      case 4:
        return BlocProvider(
          create: (context) =>
              CheckOutReviewBloc(repository: CheckOutReviewRepositoryImp()),
          child: CheckoutOrderReviewView(
            paymentId: paymentId,
            cartDetailsModel: widget.cartDetailsModel,
            cartScreenBloc: widget.cartScreenBloc,
            callBack: (price) {
              _myStreamCtrl.sink.add(price);
            },
          ),
        );
      default:
        return Container();
    }
  }

  _buildUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0.0, 14.0, 0),
      child: Column(
        children: [
          CheckoutHeaderView(
            curStep: currentIndex,
            total: widget.total,
            context: context,
            didSelect: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Expanded(
            child: _getBody(),
          ),
          StreamBuilder(
            stream: onVariableChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Card(
                  elevation: 12,
                  child: Container(
                    // color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: NormalPadding, horizontal: HighPadding),
                    margin: const EdgeInsets.fromLTRB(0, NormalWidth, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CartPageAmountToBePaidLabel".localized(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.total ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.mediumFontSize),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.background,
                            elevation: 0.0,
                            textColor: MobikulTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () {
                              if (currentIndex < 5) {
                                if (currentIndex == 2 && shippingId == '') {
                                  ShowMessage.showNotification(
                                      "pleaseSelectShipping".localized(),
                                      "",
                                      Colors.yellow,
                                      const Icon(Icons.warning_amber));
                                } else if (currentIndex == 3 &&
                                    paymentId == '') {
                                  ShowMessage.showNotification(
                                      "pleaseSelectPayment".localized(),
                                      "",
                                      Colors.yellow,
                                      const Icon(Icons.warning_amber));
                                } else if ((currentIndex == 1 &&
                                        billingAddress == null ||
                                    shippingAddress == null)) {
                                  if (currentIndex == 1 &&
                                      billingAddress == null &&
                                      shippingAddress == null) {
                                    ShowMessage.showNotification(
                                        "unaddressable".localized(),
                                        "",
                                        Colors.yellow,
                                        const Icon(Icons.warning_amber));
                                  } else if (billingAddress == null) {
                                    ShowMessage.showNotification(
                                        "pleasefillbillingaddress".localized(),
                                        "",
                                        Colors.yellow,
                                        const Icon(Icons.warning_amber));
                                  } else if (shippingAddress == null) {
                                    ShowMessage.showNotification(
                                        "pleasefillshippingaddress".localized(),
                                        "",
                                        Colors.yellow,
                                        const Icon(Icons.warning_amber));
                                  }
                                } else {
                                  setState(() {
                                    if ((widget.isDownloadable ?? false) &&
                                        currentIndex == 1) {
                                      currentIndex = currentIndex + 2;
                                    } else {
                                      currentIndex = currentIndex + 1;
                                    }
                                  });
                                }
                              }
                              if (currentIndex == 5) {
                                Navigator.pushReplacementNamed(
                                    context, OrderPlacedScreen);
                              }
                            },
                            child: Text(
                              currentIndex == 4
                                  ? 'PlaceOrder'.localized()
                                  : 'Proceed'.localized().toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: MobikulTheme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Card(
                elevation: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.normalPadding, horizontal: 18.0),
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CartPageAmountToBePaidLabel".localized(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              snapshot.data.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.mediumFontSize),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          color: Theme.of(context).colorScheme.background,
                          elevation: 0.0,
                          textColor: Theme.of(context).colorScheme.onBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          onPressed: () {
                            if (currentIndex < 5) {
                              if(currentIndex == 2 && shippingId == ''){
                                ShowMessage.showNotification("pleaseSelectShipping".localized(),"",Colors.yellow,Icon(Icons.warning_amber));
                              }else if(currentIndex == 3 && paymentId == ''){
                                ShowMessage.showNotification("pleaseSelectPayment".localized(),"",Colors.yellow,Icon(Icons.warning_amber));
                              }
                              else if((currentIndex==1 && billingAddress == null || shippingAddress == null) /*||(billing?['address1']==null)*/){
                                if(currentIndex==1 && billingAddress == null && shippingAddress == null) {
                                  ShowMessage.showNotification("pleasefilladdress".localized(),"",Colors.yellow,Icon(Icons.warning_amber));
                                }
                                else if(billingAddress == null){
                                  ShowMessage.showNotification("pleasefillbillingaddress".localized(),"",Colors.yellow,Icon(Icons.warning_amber));
                                }
                                else if(shippingAddress == null){
                                  ShowMessage.showNotification("pleasefillshippingaddress".localized(),"",Colors.yellow,Icon(Icons.warning_amber));
                                }
                              }
                              else{
                                setState(() {
                                  if((widget.isDownloadable ?? false) && currentIndex==1){
                                    currentIndex = currentIndex + 2;
                                  }
                                  else{
                                    currentIndex = currentIndex + 1;
                                  }
                                });
                              }

                            }
                            if (currentIndex == 5) {
                              Navigator.pushReplacementNamed(
                                context, OrderPlacedScreen,);
                            }
                          },
                          child: Text(
                            currentIndex == 4
                                ? 'PlaceOrder'.localized()
                                : 'Proceed'.localized().toUpperCase(),
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: MobikulTheme.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
