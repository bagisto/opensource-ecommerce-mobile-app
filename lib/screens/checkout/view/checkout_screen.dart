/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';
import '../checkout_payment/view/checkout_payment_view.dart';

class CheckoutScreen extends StatefulWidget {
  final CartScreenBloc? cartScreenBloc;
  final String? total;
  final bool? isDownloadable;
  final CartModel? cartDetailsModel;
  const CheckoutScreen(
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
  CartModel? cartModel;
  PaymentMethods? paymentMethods;
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
  bool useForShipping = true;
  String? email;
  String? updatedPrice;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final StreamController _myStreamCtrl = StreamController.broadcast();
  Stream get onVariableChanged => _myStreamCtrl.stream;
  @override
  void initState() {
    isUser = appStoragePref.getCustomerLoggedIn();
    email = appStoragePref.getCustomerEmail();
    super.initState();
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
          ),
        ),
        body: _buildUI(context),
      ),
    );
  }

  _getBody() {
    switch (currentIndex) {
      case 1:
        return isUser
            ? BlocProvider(
                create: (context) => CheckOutBloc(CheckOutRepositoryImp()),
                child: CheckoutAddressView(callBack: (billingCompanyName,
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
                    shippingPhone,
                    billingAddressId,
                    shippingAddressId,
                    AddressType addressType,
                    bool isShippingSame) {
                  if (addressType == AddressType.both || isShippingSame) {
                    useForShipping = true;
                  } else {
                    useForShipping = false;
                  }

                  if (addressType == AddressType.billing ||
                      addressType == AddressType.both) {
                    if (billingCompanyName != null) {
                      this.billingCompanyName = billingCompanyName;
                    }
                    if (billingFirstName != null) {
                      this.billingFirstName = billingFirstName;
                    }
                    if (billingLastName != null) {
                      this.billingLastName = billingLastName;
                    }
                    if (billingAddress != null) {
                      this.billingAddress = billingAddress;
                    }
                    if (billingAddress2 != null) {
                      this.billingAddress2 = billingAddress2;
                    }
                    if (email != null) {
                      billingEmail = email;
                    }
                    if (billingCountry != null) {
                      this.billingCountry = billingCountry;
                    }
                    if (billingState != null) {
                      this.billingState = billingState;
                    }
                    if (billingCity != null) {
                      this.billingCity = billingCity;
                    }
                    if (billingPostCode != null) {
                      this.billingPostCode = billingPostCode;
                    }
                    if (billingPhone != null) {
                      this.billingPhone = billingPhone;
                    }
                    if (billingAddressId != 0) {
                      this.billingAddressId = billingAddressId;
                    }
                  }
                  if (addressType == AddressType.shipping ||
                      addressType == AddressType.both) {
                    if (shippingCompanyName != null) {
                      this.shippingCompanyName = shippingCompanyName;
                    }
                    if (shippingFirstName != null) {
                      this.shippingFirstName = shippingFirstName;
                    }
                    if (shippingLastName != null) {
                      this.shippingLastName = shippingLastName;
                    }
                    if (shippingAddress != null) {
                      this.shippingAddress = shippingAddress;
                    }
                    if (email != null) {
                      shippingEmail = email;
                    }
                    if (shippingAddress2 != null) {
                      this.shippingAddress2 = shippingAddress2;
                    }
                    if (shippingCountry != null) {
                      this.shippingCountry = shippingCountry;
                    }
                    if (shippingState != null) {
                      this.shippingState = shippingState;
                    }
                    if (shippingCity != null) {
                      this.shippingCity = shippingCity;
                    }
                    if (shippingPostCode != null) {
                      this.shippingPostCode = shippingPostCode;
                    }
                    if (shippingPhone != null) {
                      this.shippingPhone = shippingPhone;
                    }
                    if (shippingAddressId != 0) {
                      this.shippingAddressId = shippingAddressId;
                    }
                  }
                }),
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
            useForShipping: useForShipping,
            callBack: (
              id,
            ) {
              shippingId = id;
            },
            isDownloadable: widget.isDownloadable ?? false,
            callbackNavigate: () {
              setState(() {
                currentIndex = currentIndex + 1;
              });
            },
            paymentCallback: (PaymentMethods? paymentMethods) {
              this.paymentMethods = paymentMethods;
              setState(() {
                currentIndex = currentIndex + 1;
              });
            },
          ),
        );
      case 3:
        return BlocProvider(
          create: (context) =>
              CheckOutPaymentBloc(CheckOutPaymentRepositoryImp()),
          child: CheckoutPaymentView(
            total: widget.total,
            shippingId: shippingId,
            paymentMethods: paymentMethods,
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
            callBack: (price, CartModel? model) {
              cartModel = model;
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
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spacingLarge, 0.0, AppSizes.spacingLarge, 0),
      child: Column(
        children: [
          CheckoutHeaderView(
            curStep: currentIndex,
            total: widget.total,
            context: context,
            isDownloadable: widget.isDownloadable ?? false,
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
                  margin: const EdgeInsets.fromLTRB(
                      0, AppSizes.spacingSmall, 0, AppSizes.spacingSmall),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spacingNormal,
                        horizontal: AppSizes.spacingWide),
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
                                StringConstants.cartPageAmountToBePaidLabel
                                    .localized(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                              Text(
                                widget.total ?? "",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.onBackground,
                            elevation: 0.0,
                            textColor: MobiKulTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.spacingNormal),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spacingMedium),
                            onPressed: () {
                              if (currentIndex < 5) {
                                if (currentIndex == 2 && shippingId == '') {
                                  ShowMessage.warningNotification(
                                      StringConstants.pleaseSelectShipping
                                          .localized(),
                                      context);
                                } else if (currentIndex == 3 &&
                                    paymentId == '') {
                                  ShowMessage.warningNotification(
                                      StringConstants.pleaseSelectPayment
                                          .localized(),
                                      context);
                                } else if ((currentIndex == 1 &&
                                        billingAddress == null ||
                                    shippingAddress ==
                                        null) /*||(billing?['address1']==null)*/) {
                                  if (currentIndex == 1 &&
                                      billingAddress == null &&
                                      shippingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants.pleaseFillAddress
                                            .localized(),
                                        context);
                                  } else if (billingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants.pleaseFillBillingAddress
                                            .localized(),
                                        context);
                                  } else if (shippingAddress == null) {
                                    ShowMessage.warningNotification(
                                        StringConstants
                                            .pleaseFillShippingAddress
                                            .localized(),
                                        context);
                                  }
                                } else {
                                  setState(() {
                                    currentIndex = currentIndex + 1;
                                  });
                                }
                              }
                              if (currentIndex == 5) {
                                Navigator.pushReplacementNamed(
                                    context, orderPlacedScreen,
                                    arguments: cartModel);
                              }
                            },
                            child: Text(
                              currentIndex == 4
                                  ? StringConstants.placeOrder.localized()
                                  : StringConstants.proceed
                                      .localized()
                                      .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
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
                margin: const EdgeInsets.fromLTRB(
                    0, AppSizes.spacingSmall, 0, AppSizes.spacingSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spacingNormal,
                      horizontal: AppSizes.spacingLarge),
                  margin:
                      const EdgeInsets.fromLTRB(0, AppSizes.spacingSmall, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringConstants.cartPageAmountToBePaidLabel
                                  .localized(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
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
                            borderRadius:
                                BorderRadius.circular(AppSizes.spacingNormal),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spacingMedium),
                          onPressed: () {
                            if (currentIndex < 5) {
                              if (currentIndex == 2 && shippingId == '') {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseSelectShipping
                                        .localized(),
                                    context);
                              } else if (currentIndex == 3 && paymentId == '') {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseSelectPayment
                                        .localized(),
                                    context);
                              } else if ((currentIndex == 1 &&
                                  billingAddress ==
                                      null) /*||(billing?['address1']==null)*/) {
                                ShowMessage.warningNotification(
                                    StringConstants.pleaseFillAddress
                                        .localized(),
                                    context);
                              } else {
                                setState(() {
                                  currentIndex = currentIndex + 1;
                                });
                              }
                            }
                            if (currentIndex == 5) {
                              Navigator.pushReplacementNamed(
                                  context, orderPlacedScreen,
                                  arguments: cartModel);
                            }
                          },
                          child: Text(
                            currentIndex == 4
                                ? StringConstants.placeOrder.localized()
                                : StringConstants.proceed
                                    .localized()
                                    .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
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
