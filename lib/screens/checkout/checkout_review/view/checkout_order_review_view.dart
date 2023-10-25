/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, implementation_imports, must_be_immutable

import 'package:bagisto_app_demo/common_widget/common_error_msg.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/image_view.dart';
import 'package:bagisto_app_demo/configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/checkout_models/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/event/checkout_review_save_payment_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_initial_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/state/checkout_review_save_payment_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/view/widget/apply_coupon_code.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_review/view/widget/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/app_global_data.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../models/cart_model/cart_data_model.dart';
import '../../../cart_screen/bloc/cart_screen_bloc.dart';
import '../../../cart_screen/events/add_coupon_cart_event.dart';
import '../../../cart_screen/events/remove_cart_coupom_state.dart';
import '../bloc/checkout_review_bloc.dart';
import '../state/checkout_review_base_state.dart';

class CheckoutOrderReviewView extends StatefulWidget {
  String? paymentId;
  Function(String, )? callBack;

  CartScreenBloc? cartScreenBloc;

  CartModel? cartDetailsModel;

  CheckoutOrderReviewView({Key? key,this.paymentId,this.callBack,this.cartDetailsModel,this.cartScreenBloc}) : super(key: key);

  @override
  State<CheckoutOrderReviewView> createState() => _CheckoutOrderReviewViewState();
}

class _CheckoutOrderReviewViewState extends State<CheckoutOrderReviewView> {


  @override
  void initState() {
  CheckOutReviewBloc checkOutReviewBloc = context.read<CheckOutReviewBloc>();
  checkOutReviewBloc.add(CheckOutReviewSavePaymentEvent(paymentMethod:widget.paymentId ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: GlobalData.contentDirection(),
        child:   _checkOutReview(context)
    );
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
          widget.cartDetailsModel=state.savePaymentModel?.cart;
          widget.callBack!(
              state.savePaymentModel?.cart?.formattedPrice?.grandTotal.toString()??"");
        }
        return _reviewOrder(state.savePaymentModel!);
      }
      if (state.status == CheckOutReviewStatus.fail) {
        return ErrorMessage.errorMsg("SomethingWrong".localized());
      }
    }
    if (state is CheckOutReviewInitialState) {
      return  CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    return Container();
  }


  _reviewOrder(SavePayment savePaymentModel){
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top:AppSizes.genericPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.genericPaddingMin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Text(
                              "BillingAddress".localized().toUpperCase(),
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.normalFontSize,
                              ),
                            ),
                      CommonWidgets().getTextFieldHeight(NormalPadding),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                         CommonWidgets().divider(),
                              CommonWidgets().getTextFieldHeight(NormalPadding),

                              _getFormattedBillingAddress(savePaymentModel),
                              CommonWidgets().getTextFieldHeight(NormalWidth),
                              Text(
                              "Contact".localized()+ (savePaymentModel.cart?.billingAddress?.phone ?? ""),
                                style: const TextStyle(fontSize: AppSizes.normalFontSize),
                              ),
                            ],
                          ),
                        ),
                        CommonWidgets().getTextFieldHeight(MediumPadding),
                        Text(
                              "ShippingAddress".localized().toUpperCase(),
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.normalFontSize,
                          ),
                            ),
                        CommonWidgets().getTextFieldHeight(NormalPadding),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              CommonWidgets().divider(),
                              CommonWidgets().getTextFieldHeight(AppSizes.linePadding),
                              _getFormattedShippingAddress(savePaymentModel),
                              CommonWidgets().getTextFieldHeight(NormalWidth),

                              Text(
                  "Contact".localized()+ (savePaymentModel.cart?.shippingAddress?.phone ?? ""),
                                style: const TextStyle(fontSize: AppSizes.normalFontSize),
                              ),
                            ],
                          ),
                        ),
                        CommonWidgets().getTextFieldHeight(MediumPadding),
                        Text(
                          "ShippingMethods".localized().toUpperCase(),
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.normalFontSize,
                          ),
                        ),
                        CommonWidgets().getTextFieldHeight(NormalPadding),
                        const Divider(
                          height: 1,
                          thickness: 1,
                        ),

                        Wrap(
                          children: [
                            Text(
                              savePaymentModel.cart?.selectedShippingRate?.methodTitle??"",
                              style: const TextStyle(
                                fontSize: 16,
                                // color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        CommonWidgets().getTextFieldHeight(MediumPadding),
                        Text(
                          "PaymentMethods".localized().toUpperCase(),
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.normalFontSize,
                          ),
                        ),
                        CommonWidgets().getTextFieldHeight(AppSizes.linePadding),
                        const Divider(
                          height: AppSizes.size1,
                          thickness: AppSizes.size1,
                        ),
                        CommonWidgets().getTextFieldHeight(AppSizes.linePadding),
                        Wrap(
                          children: [
                            Text(
                              savePaymentModel.cart?.payment?.methodTitle ?? savePaymentModel.cart?.payment?.method ??" ",
                              style: const TextStyle(
                                fontSize: AppSizes.normalFontSize,
                                // color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  OrderSummary(savePaymentModel: savePaymentModel),
                  CommonWidgets().getTextFieldHeight(NormalPadding),
                  ApplyCouponCode(savePaymentModel: savePaymentModel,cartScreenBloc: widget.cartScreenBloc,cartDetailsModel: widget.cartDetailsModel,)
                ],
              ),
            )),
      ],
    );
  }

  _getFormattedBillingAddress(SavePayment savePaymentModel){
    return  Text(
        "${savePaymentModel.cart?.billingAddress?.address1?.replaceAll("[", "").replaceAll("]", "")??""}, ${savePaymentModel.cart?.billingAddress?.city ?? ''}, ${savePaymentModel.cart?.billingAddress?.state??""}, ${savePaymentModel.cart?.billingAddress?.country ??""}, ${savePaymentModel.cart?.billingAddress?.postcode.toString()??""}",
      style: const TextStyle(fontSize: AppSizes.normalFontSize),
    );
  }

  _getFormattedShippingAddress(SavePayment savePaymentModel){
    return  Text(
      "${savePaymentModel.cart?.shippingAddress?.address1?.replaceAll("[", "").replaceAll("]", "")??""}, ${savePaymentModel.cart?.shippingAddress?.city ?? ''}, ${savePaymentModel.cart?.shippingAddress?.state??""}, ${savePaymentModel.cart?.shippingAddress?.country ??""}, ${savePaymentModel.cart?.shippingAddress?.postcode.toString()??""}",
      style: const TextStyle(fontSize:AppSizes.normalFontSize),
    );
  }
}
