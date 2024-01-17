import 'dart:async';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/mobikul_theme.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/show_message.dart';
import '../../cart_screen/bloc/cart_screen_bloc.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../checkout_addres/bloc/checkout_bloc.dart';
import '../checkout_addres/bloc/checkout_repository.dart';
import '../checkout_addres/view/checkout_address_view.dart';
import '../checkout_payment/bloc/checkout_payment_bloc.dart';
import '../checkout_payment/bloc/checkout_payment_repository.dart';
import '../checkout_payment/view/checkout_payment_view.dart';
import '../checkout_review/bloc/checkout_review_bloc.dart';
import '../checkout_review/bloc/checkout_review_repository.dart';
import '../checkout_review/view/checkout_order_review_view.dart';
import '../checkout_shipping/bloc/checkout_shipping_bloc.dart';
import '../checkout_shipping/bloc/checkout_shipping_repository.dart';
import '../checkout_shipping/view/checkout_shipping_view.dart';
import '../guest_add_address/bloc/guest_address_bloc.dart';
import '../guest_add_address/bloc/guest_address_repository.dart';
import '../guest_add_address/view/guest_add_address_form.dart';
import 'checkout_header_view.dart';

// ignore: must_be_immutable
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
  int? billingAddressId;
  int? shippingAddressId;
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
  void dispose() {
    super.dispose();
    _myStreamCtrl.close();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              currentIndex == 1
                  ? StringConstants.addressTitle.localized()
                  : currentIndex == 2
                  ? StringConstants.shippingMethods.localized()
                  : currentIndex == 3
                  ? StringConstants.paymentMethods.localized()
                  : StringConstants.reviewAndCheckout.localized(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          body: _buildUI(context),
        ),
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
          create: (context) => CheckOutBloc(CheckOutRepositoryImp()),
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
                shippingPhone, billingAddressId, shippingAddressId) {
              if(billingCompanyName != null) {
                this.billingCompanyName = billingCompanyName;
              }
              if(billingFirstName != null) {
                this.billingFirstName = billingFirstName;
              }
              if(billingLastName != null) {
                this.billingLastName = billingLastName;
              }
              if(billingAddress != null) {
                this.billingAddress = billingAddress;
              }
              if(billingAddress2 != null) {
                this.billingAddress2 = billingAddress2;
              }
              if(email != null) {
                billingEmail = email;
              }
              if(billingCountry != null) {
                this.billingCountry = billingCountry;
              }
              if(billingState != null) {
                this.billingState = billingState;
              }
              if(billingCity != null) {
                this.billingCity = billingCity;
              }
              if(billingPostCode != null) {
                this.billingPostCode = billingPostCode;
              }
              if(billingPhone != null) {
                this.billingPhone = billingPhone;
              }
              if(shippingCompanyName != null) {
                this.shippingCompanyName = shippingCompanyName;
              }
              if(shippingFirstName != null) {
                this.shippingFirstName = shippingFirstName;
              }
              if(shippingLastName != null) {
                this.shippingLastName = shippingLastName;
              }
              if(shippingAddress != null) {
                this.shippingAddress = shippingAddress;
              }
              if(email != null) {
                shippingEmail = email;
              }
              if(shippingAddress2 != null) {
                this.shippingAddress2 = shippingAddress2;
              }
              if(shippingCountry != null) {
                this.shippingCountry = shippingCountry;
              }
              if(shippingState != null) {
                this.shippingState = shippingState;
              }
              if(shippingCity != null) {
                this.shippingCity = shippingCity;
              }
              if(shippingPostCode != null) {
                this.shippingPostCode = shippingPostCode;
              }
              if(shippingPhone != null) {
                this.shippingPhone = shippingPhone;
              }
              if(billingAddressId != 0) {
                this.billingAddressId = billingAddressId;
              }
              if(shippingAddressId != 0) {
                this.shippingAddressId = shippingAddressId;
              }
            }
          ),
        )
            : BlocProvider(
          create: (context) =>
              GuestAddressBloc(GuestAddressRepositoryImp()),
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
              CheckOutShippingBloc(CheckOutShippingRepositoryImp()),
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
            billingId: billingAddressId ?? 0,
            shippingId: shippingAddressId ?? 0,
            callBack: (
                id,
                ) {
              shippingId = id;
            },
              isDownloadable : widget.isDownloadable ?? false,
            callbackNavigate: (){
              setState(() {
                currentIndex = currentIndex+1;
              });
            }
          ),
        );
      case 3:
        return BlocProvider(
          create: (context) =>
              CheckOutPaymentBloc(CheckOutPaymentRepositoryImp()),
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
              CheckOutReviewBloc(CheckOutReviewRepositoryImp()),
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
        return const SizedBox();
    }
  }

  _buildUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spacingLarge, 0.0, AppSizes.spacingLarge, 0),
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
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spacingNormal, horizontal: AppSizes.spacingWide),
                    margin: const EdgeInsets.fromLTRB(
                        0, AppSizes.spacingSmall, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringConstants.cartPageAmountToBePaidLabel.localized(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600
                                ),
                              ),
                              Text(
                                widget.total ?? "",
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.onBackground,
                            elevation: 0.0,
                            textColor: MobikulTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () {
                              debugPrint(
                                  "billingAddress -> $currentIndex * $billingAddress");
                              if (currentIndex < 5) {
                                if (currentIndex == 2 && shippingId == '') {
                                  ShowMessage.warningNotification(
                                      StringConstants.pleaseSelectShipping.localized(),context);
                                } else if (currentIndex == 3 &&
                                    paymentId == '') {
                                  ShowMessage.warningNotification(
                                      StringConstants.pleaseSelectPayment.localized(),context);
                                } else if ((currentIndex == 1 &&
                                        billingAddress == null ||
                                    shippingAddress ==
                                        null) /*||(billing?['address1']==null)*/) {
                                  if (currentIndex == 1 &&
                                      billingAddress == null &&
                                      shippingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants.pleaseFillAddress.localized(),context);
                                  } else if (billingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants.pleaseFillBillingAddress.localized(),context);
                                  } else if (shippingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants.pleaseFillShippingAddress.localized(),context);
                                  }
                                } else {
                                  setState(() {
                                    currentIndex = currentIndex + 1;
                                  });
                                }
                              }
                              if (currentIndex == 5) {
                                Navigator.pushReplacementNamed(
                                    context, orderPlacedScreen);
                              }
                            },
                            child: Text(
                              currentIndex == 4
                                  ? StringConstants.placeOrder.localized()
                                  : StringConstants.proceed.localized().toUpperCase(),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.background
                              ),
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
                margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spacingNormal, horizontal: 18.0),
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
                              StringConstants.cartPageAmountToBePaidLabel.localized(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade600
                              ),
                            ),
                            Text(
                              snapshot.data.toString(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          color: Theme.of(context).colorScheme.onBackground,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          onPressed: () {
                            if (currentIndex < 5) {
                              if (currentIndex == 2 && shippingId == '') {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseSelectShipping.localized(),context);
                              } else if (currentIndex == 3 && paymentId == '') {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseSelectPayment.localized(),context);
                              } else if ((currentIndex == 1 &&
                                  billingAddress ==
                                      null) /*||(billing?['address1']==null)*/) {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseFillAddress.localized(),context);
                              } else {
                                setState(() {
                                  currentIndex = currentIndex + 1;
                                });
                              }
                            }
                            if (currentIndex == 5) {
                              Navigator.pushReplacementNamed(
                                  context, orderPlacedScreen);
                            }
                          },
                          child: Text(
                            currentIndex == 4
                                ? StringConstants.placeOrder.localized()
                                : StringConstants.proceed.localized().toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.background
                            ),
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
