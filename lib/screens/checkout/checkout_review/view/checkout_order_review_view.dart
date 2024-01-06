/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/checkout/checkout_review/view/widget/apply_coupon_code.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/view/widget/checkout_order_review_loader_view.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/view/widget/order_summary.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_error_msg.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../cart_screen/bloc/cart_screen_bloc.dart';
import '../../../cart_screen/cart_model/cart_data_model.dart';
import '../../data_model/save_payment_model.dart';
import '../bloc/checkout_review_base_event.dart';
import '../bloc/checkout_review_bloc.dart';
import '../bloc/checkout_review_save_payment_state.dart';

//ignore: must_be_immutable
class CheckoutOrderReviewView extends StatefulWidget {
  String? paymentId;
  Function(
    String,
  )? callBack;

  CartScreenBloc? cartScreenBloc;

  CartModel? cartDetailsModel;

  CheckoutOrderReviewView(
      {Key? key,
      this.paymentId,
      this.callBack,
      this.cartDetailsModel,
      this.cartScreenBloc})
      : super(key: key);

  @override
  State<CheckoutOrderReviewView> createState() =>
      _CheckoutOrderReviewViewState();
}

class _CheckoutOrderReviewViewState extends State<CheckoutOrderReviewView> {
  CheckOutReviewBloc? checkOutReviewBloc;

  @override
  void initState() {
    checkOutReviewBloc = context.read<CheckOutReviewBloc>();
    checkOutReviewBloc?.add(CheckOutReviewSavePaymentEvent(paymentMethod: widget.paymentId));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child: _checkOutReview(context));
  }

  ///REVIEW BLOC CONTAINER///
  _checkOutReview(BuildContext context) {
    return BlocConsumer<CheckOutReviewBloc, CheckOutReviewBaseState>(
      listener: (BuildContext context, CheckOutReviewBaseState state) {},
      builder: (BuildContext context, CheckOutReviewBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///REVIEW UI METHODS///
  Widget buildUI(BuildContext context, CheckOutReviewBaseState state) {
    if (state is CheckOutReviewSavePaymentState) {
      if (state.status == CheckOutReviewStatus.success) {
        if (widget.callBack != null) {
          widget.cartDetailsModel = state.savePaymentModel?.cart;
          widget.callBack!(state
                  .savePaymentModel?.cart?.formattedPrice?.grandTotal
                  .toString() ??
              "");
        }

        return _reviewOrder(state.savePaymentModel!);
      }
      if (state.status == CheckOutReviewStatus.fail) {
        return ErrorMessage.errorMsg(StringConstants.somethingWrong.localized());
      }
    }
    if (state is CheckOutReviewInitialState) {
      return  const CheckoutOrderReviewLoaderView();
    }

    return Container();
  }

  _reviewOrder(SavePayment savePaymentModel) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: AppSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0,
                    AppSizes.spacingNormal, 0, AppSizes.spacingNormal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.billingAddress.localized().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.spacingLarge,
                          ),
                        ),
                        CommonWidgets().divider(),
                        savePaymentModel.cart?.billingAddress != null ?_getFormattedBillingAddress(savePaymentModel): const Text('N/A'),
                        savePaymentModel.cart?.billingAddress != null ?const SizedBox(height: 4): const SizedBox.shrink(),
                        savePaymentModel.cart?.billingAddress != null ?Text(
                          StringConstants.contact.localized() +
                              (savePaymentModel.cart?.billingAddress?.phone ??
                                  ""),
                          style: const TextStyle(
                              fontSize: AppSizes.spacingLarge),
                        ): const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    Text(
                      StringConstants.shippingAddress.localized().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.spacingLarge,
                      ),
                    ),
                    CommonWidgets().divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        savePaymentModel.cart?.shippingAddress != null ?_getFormattedShippingAddress(savePaymentModel): const Text('N/A'),
                        savePaymentModel.cart?.shippingAddress != null ?const SizedBox(height: 4): const SizedBox.shrink(),
                        savePaymentModel.cart?.shippingAddress != null ?Text(
                          StringConstants.contact.localized() +
                              (savePaymentModel.cart?.shippingAddress?.phone ??
                                  ""),
                          style: const TextStyle(
                              fontSize: AppSizes.spacingLarge),
                        ): const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingLarge),
                    savePaymentModel
                        .cart?.selectedShippingRate?.methodTitle != ""?Text(
                      StringConstants.shippingMethods.localized().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.spacingLarge,
                      ),
                    ):const SizedBox.shrink(),
                    savePaymentModel
                        .cart?.selectedShippingRate != null?const SizedBox(height: AppSizes.spacingSmall):const SizedBox.shrink(),
                    savePaymentModel
                        .cart?.selectedShippingRate != null?const Divider(
                      height: 1,
                      thickness: 1,
                    ):const SizedBox.shrink(),
                    savePaymentModel
                        .cart?.selectedShippingRate != null?const SizedBox(height: AppSizes.spacingSmall):const SizedBox.shrink(),
                    savePaymentModel
                        .cart?.selectedShippingRate != null?Wrap(
                      children: [
                        Text(
                          savePaymentModel
                                  .cart?.selectedShippingRate?.methodTitle ??
                              "",
                          style: const TextStyle(
                            fontSize: 16,
                            // color: Colors.grey,
                          ),
                        )
                      ],
                    ):const SizedBox.shrink(),
                    const SizedBox(height: AppSizes.spacingLarge),
                    Text(
                      StringConstants.paymentMethods.localized().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.spacingLarge,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    const Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    Wrap(
                      children: [
                        Text(
                          savePaymentModel.cart?.payment?.methodTitle ??
                              savePaymentModel.cart?.payment?.method ??
                              " ",
                          style: const TextStyle(
                            fontSize: AppSizes.spacingLarge,
                            // color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              OrderSummary(savePaymentModel: savePaymentModel),
              const SizedBox(height: AppSizes.spacingNormal),
              ApplyCouponCode(
                savePaymentModel: savePaymentModel,
                cartScreenBloc: widget.cartScreenBloc,
                cartDetailsModel: widget.cartDetailsModel,
                callback: reload,
              )
            ],
          ),
        )),
      ],
    );
  }

  reload(){
    checkOutReviewBloc?.add(CheckOutReviewSavePaymentEvent(paymentMethod: widget.paymentId));
  }

  _getFormattedBillingAddress(SavePayment savePaymentModel) {
    return Text(
      "${savePaymentModel.cart?.billingAddress?.address1?.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${savePaymentModel.cart?.billingAddress?.city ?? ''}, ${savePaymentModel.cart?.billingAddress?.state ?? ""}, ${savePaymentModel.cart?.billingAddress?.country ?? ""}, ${savePaymentModel.cart?.billingAddress?.postcode.toString() ?? ""}",
      style: const TextStyle(fontSize: AppSizes.spacingLarge),
    );
  }

  _getFormattedShippingAddress(SavePayment savePaymentModel) {
    return Text(
      "${savePaymentModel.cart?.shippingAddress?.address1?.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${savePaymentModel.cart?.shippingAddress?.city ?? ''}, ${savePaymentModel.cart?.shippingAddress?.state ?? ""}, ${savePaymentModel.cart?.shippingAddress?.country ?? ""}, ${savePaymentModel.cart?.shippingAddress?.postcode.toString() ?? ""}",
      style: const TextStyle(fontSize: AppSizes.spacingLarge),
    );
  }
}
