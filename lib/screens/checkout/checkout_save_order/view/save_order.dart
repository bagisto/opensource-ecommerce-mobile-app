/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'dart:developer';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import '../../../home_page/utils/index.dart';
import '../../data_model/save_order_model.dart';

class CheckOutSaveOrder extends StatefulWidget {
  final CartModel? cartModel;
  const CheckOutSaveOrder({super.key, this.cartModel});

  @override
  State<CheckOutSaveOrder> createState() => _CheckOutSaveOrderState();
}

class _CheckOutSaveOrderState extends State<CheckOutSaveOrder> {
  bool isLoggedIn = false;
  SaveOrderBloc? saveOrderBloc;
  List<Map<String, dynamic>>? items;
  Map<String, dynamic>? shippingAddress;
  bool isSandbox = true;
  String? paypalClientId;
  String? paypalClientSecret;
  var platform = MethodChannel(defaultChannelName);

  @override
  void initState() {
    super.initState();
    saveOrderBloc = context.read<SaveOrderBloc>();
    isLoggedIn = appStoragePref.getCustomerLoggedIn();
    setCartData();
    final paymentMethod = widget.cartModel?.payment?.method;

    if (_isPaypalMethod(paymentMethod)) {
      _loadPaypalConfig(paymentMethod);
    } else {
      saveOrderBloc?.add(SaveOrderFetchDataEvent());
    }

    if(paymentMethod == "paypal_smart_button"){
      launchPaypalNative();
    }

    platform.setMethodCallHandler((call) async {
      if (call.method == "paypalPaymentResult") {
        Map<String, dynamic> result = Map<String, dynamic>.from(call.arguments);

        String? orderId = result["orderID"];

        if(orderId != null){
          var serverPayload = {
            "isPaymentCompleted": true,
            "error": false,
            "message": "Success",
            "paymentMethod": "paypal_smart_button",
            "orderID": orderId ?? '',
          };

          saveOrderBloc?.add(
              SaveOrderFetchDataEvent(serverPayload: serverPayload));
        }
      }
    });
  }

  bool _isPaypalMethod(String? method) {
    return method == "paypal_standard" || method == "paypal_smart_button";
  }

  void _loadPaypalConfig(String? method) {
    try {
      isSandbox = _getConfigValue(_getSandboxKeyForMethod(method)) == "1";
      paypalClientId = _getConfigValue(_getClientIdKeyForMethod(method));
      paypalClientSecret =
          _getConfigValue(_getClientSecretKeyForMethod(method));
      ApiClient().getCoreConfigs().then((config) {
        GlobalData.configData = config;
      });
    } catch (e) {
      debugPrint("Error in config --> $e");
    }
  }

  setCartData(){
    var shipping = widget.cartModel?.shippingAddress;

    shippingAddress = {
          "line1": "${shipping?.address1}",
          "line2": "",
          "city": "${shipping?.city}",
          "country_code": "${shipping?.country}",
          "postal_code": "${shipping?.postcode}",
          "phone": "${shipping?.phone}",
          "state": "${shipping?.state}"
       };

    items = widget.cartModel?.items?.map((item) => {
      "name": item.name,
      "quantity": item.quantity,
      "price": item.price,
      "currency": GlobalData.currencyCode
    }).toList();
  }

  String _getSandboxKeyForMethod(String? method) {
    switch (method) {
      case "paypal_standard":
        return "sales.payment_methods.paypal_standard.sandbox";
      case "paypal_smart_button":
        return "sales.payment_methods.paypal_smart_button.sandbox";
      default:
        return "";
    }
  }

  String _getClientIdKeyForMethod(String? method) {
    switch (method) {
      case "paypal_standard":
        return "sales.payment_methods.paypal_standard.client_id";
      case "paypal_smart_button":
        return "sales.payment_methods.paypal_smart_button.client_id";
      default:
        return "";
    }
  }

  String _getClientSecretKeyForMethod(String? method) {
    switch (method) {
      case "paypal_standard":
        return "sales.payment_methods.paypal_standard.client_secret";
      case "paypal_smart_button":
        return "sales.payment_methods.paypal_smart_button.client_secret";
      default:
        return "";
    }
  }

  String? _getConfigValue(String key) {
    return GlobalData.configData?.data
        ?.firstWhereOrNull((item) => item.code == key)
        ?.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _saveOrderBloc(context));
  }

  ///SaverOrder BLOC CONTAINER///
  _saveOrderBloc(BuildContext context) {
    return BlocConsumer<SaveOrderBloc, SaveOrderBaseState>(
      listener: (BuildContext context, SaveOrderBaseState state) {},
      builder: (BuildContext context, SaveOrderBaseState state) {
        if ((state is! SaveOrderFetchDataState) &&
            (widget.cartModel?.payment?.method == "paypal_standard" ||
                widget.cartModel?.payment?.method == "paypal_smart_button")) {
          return paypalView();
        }
        return buildUI(context, state);
      },
    );
  }

  ///SaverOrder UI METHODS///
  Widget buildUI(BuildContext context, SaveOrderBaseState state) {
    if (state is SaveOrderFetchDataState) {
      if (state.status == SaveOrderStatus.success) {
        String redirectUrl = state.saveOrderModel?.redirectUrl ?? "";
        if (redirectUrl.isEmpty) {
          return _orderPlacedView(state.saveOrderModel!);
        } else {
          return CircularProgressIndicatorClass.circularProgressIndicator(
              context);
        }
      }
      if (state.status == SaveOrderStatus.fail) {
        return ErrorMessage.errorMsg(
            "${state.error ?? ""} ${StringConstants.addMoreProductsMsg}"
                .localized());
      }
    }
    if (state is SaveOrderInitialState) {
      return const Loader();
    }

    return const SizedBox();
  }

  _orderPlacedView(SaveOrderModel saveOrderModel) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingNormal),
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Card(
            elevation: 0,
            shape: const ContinuousRectangleBorder(),
            // color: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    children: [
                      Text(
                        StringConstants.orderReceivedMsg
                            .localized()
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    children: [
                      Text(
                        StringConstants.thankYouMsg.localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  InkWell(
                    onTap: isLoggedIn
                        ? () async {
                            Navigator.pushNamed(context, orderDetailPage,
                                arguments: saveOrderModel.order?.id);
                          }
                        : null,
                    child: Wrap(
                      children: [
                        Text(
                            "${StringConstants.yourOrderIdMsg.localized()} ${saveOrderModel.order?.id ?? ""}",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color:
                                        isLoggedIn ? Colors.blueAccent : null))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        StringConstants.orderConfirmationMsg.localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.onBackground,
                    elevation: 0.0,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, home);
                    },
                    child: Text(
                      StringConstants.continueShopping
                          .localized()
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paypalView() {
    return (paypalClientId ?? "").isEmpty || (paypalClientSecret ?? "").isEmpty
        ? Loader()
        : widget.cartModel?.payment?.method == "paypal_smart_button" ?
        paypalSmartButton()
    : PaypalCheckoutView(
                sandboxMode: isSandbox,
                clientId: paypalClientId,
                secretKey: paypalClientSecret,
                note: StringConstants.orderNote.localized(),
                loadingIndicator: Loader(),
                onSuccess: (params) async {
                  final serverPayload = _parsePaypalSuccessData(params);

                  saveOrderBloc?.add(
                      SaveOrderFetchDataEvent(serverPayload: serverPayload));
                },
                onError: (error) {
                  debugPrint("onError: $error");
                  ShowMessage.errorNotification(
                      error.toString(), context);
                  Navigator.of(context).pop();
                },
                onCancel: (params) {
                  Navigator.of(context).pop();
                },
                transactions: [
                  {
                    "amount": {
                      "total": widget.cartModel?.grandTotal,
                      "currency": GlobalData.currencyCode
                    },
                    "item_list": {
                      "items": items,
                      "shipping_address": shippingAddress,
                    }
                  }
                ],
              );
  }

  Map<String, dynamic> prepareCompleteOrderPayload() {
    return {
      "paymentMethod": widget.cartModel?.payment?.method ?? "",
      "sandboxMode": isSandbox,
      "clientId": paypalClientId,
      "secretKey": paypalClientSecret,
      "transactions": [
        {
          "amount": {
            "total": widget.cartModel?.grandTotal ?? "0",
            "currency": GlobalData.currencyCode,
          },
          "item_list": {
            "items": items,
            "shipping_address": shippingAddress,
          },
        }
      ],
    };
  }

  void launchPaypalNative(){
    final payload = prepareCompleteOrderPayload();
    platform.invokeMethod("paypalPay", payload);
  }

  Map<String, dynamic>? _parsePaypalSuccessData(Map<dynamic, dynamic> params) {
    try {
      final data = params['data'] as Map<String, dynamic>?;

      if (data == null) return null;

      String? orderID;
      final transactions = data['transactions'] as List?;
      final firstTransaction = (transactions?.isNotEmpty ?? false)
          ? transactions!.first as Map<String, dynamic>?
          : null;
      final relatedResources = firstTransaction?['related_resources'] as List?;
      final sale = (relatedResources?.isNotEmpty ?? false)
          ? relatedResources!.first['sale'] as Map<String, dynamic>?
          : null;

      if (transactions is List && transactions.isNotEmpty) {
        final relatedResources = transactions.first['related_resources'];
        if (relatedResources is List && relatedResources.isNotEmpty) {
          final sale = relatedResources.first['sale'];
          if (sale != null && sale['id'] != null) {
            orderID = sale['id'];
          }
        }
      }

      final method = widget.cartModel?.payment?.method;

      if (method == "paypal_smart_button") {
        return {
          "isPaymentCompleted": true,
          "paymentMethod": method,
          "orderID": data['cart'] ?? '',
        };
      }

      return {
        "isPaymentCompleted": true,
        "error": params['error'] ?? false,
        "message": params['message'] ?? "Success",
        "transactionId": data['id'] ?? '',
        "paymentStatus": sale?['state'] ?? 'unknown',
        "paymentType": sale?['payment_mode'] ?? 'unknown',
        "paymentMethod": method
      };

    } catch (e, stackTrace) {
      debugPrint("❌ Error parsing PayPal success data: $e");
      debugPrint("📄 StackTrace: $stackTrace");
      return null;
    }
  }

  Widget paypalSmartButton() {
    return Center(
      child: Loader()
    );
  }

}
