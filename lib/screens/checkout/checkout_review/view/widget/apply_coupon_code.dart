import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../Configuration/mobikul_theme.dart';
import '../../../../../common_widget/common_widgets.dart';
import '../../../../../configuration/app_sizes.dart';
import '../../../../../helper/string_constants.dart';
import '../../../../../models/cart_model/cart_data_model.dart';
import '../../../../../models/checkout_models/save_payment_model.dart';
import '../../../../cart_screen/bloc/cart_screen_bloc.dart';
import '../../../../cart_screen/events/add_coupon_cart_event.dart';
import '../../../../cart_screen/events/remove_cart_coupom_state.dart';
class ApplyCouponCode extends StatefulWidget {
  final SavePayment savePaymentModel;
  final CartScreenBloc? cartScreenBloc;
  final CartModel? cartDetailsModel;
  const ApplyCouponCode({Key? key, required this.savePaymentModel, this.cartScreenBloc, this.cartDetailsModel}) : super(key: key);

  @override
  State<ApplyCouponCode> createState() => _ApplyCouponCodeState();
}

class _ApplyCouponCodeState extends State<ApplyCouponCode> {
  final _discountCouponFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final _discountController = TextEditingController();
  bool  showButton = false;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Card(
          child: ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            title: Text(
              "ApplyCode".localized(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: NormalPadding, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Form(
                        key: _discountCouponFormKey,
                        autovalidateMode: _autoValidate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: CommonWidgets().getTextField(
                          context,
                          _discountController,
                          "CartPageEnterDiscountCodeLabel".localized(),
                          "CartPageEnterDiscountCodeLabel".localized(),
                          "",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          validator: (discountCode) {
                            if (discountCode!.isEmpty) {
                              setState(() {
                                showButton = true;
                              });
                              return "CouponEmpty".localized();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: AppSizes.genericPaddingMin,
                            bottom: showButton
                                ? AppSizes.widgetHeight
                                : AppSizes.zero,
                            right: 3),
                        child: MaterialButton(
                          height: 47,
                          color: Theme.of(context).colorScheme.background,
                          textColor: MobikulTheme.primaryColor,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          onPressed: () {
                            if (_discountCouponFormKey.currentState!
                                .validate()) {
                              setState(() {
                                showButton = false;
                              });
                              if (widget.cartDetailsModel?.couponCode ==
                                  null) {
                                widget.cartScreenBloc?.add(AddCouponCartEvent(
                                    _discountController.text));
                              } else {
                                widget.cartScreenBloc?.add(
                                    RemoveCouponCartEvent(
                                        widget.cartDetailsModel));
                                _discountController.text = "";
                              }
                            }
                          },
                          child: widget.cartDetailsModel?.couponCode ==
                              null ||
                              widget.cartDetailsModel?.couponCode == ''
                              ? Text(
                            "Apply".localized().toUpperCase(),
                            style: const TextStyle(
                                fontSize: AppSizes.normalFontSize,
                                fontWeight: FontWeight.w500),
                          )
                              : Text("Remove".localized()),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        CommonWidgets().getTextFieldHeight(NormalPadding),
        ExpansionTile(
            initiallyExpanded: true,
            iconColor: Colors.grey,
            title: Text(
              "PriceDetails".localized().toUpperCase(),
              style: TextStyle(
                  color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets()
                        .getDrawerTileText("Subtotal".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.savePaymentModel.cart?.formattedPrice?.subTotal
                            .toString() ??
                            "",
                        context),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().getDrawerTileText(
                        "ShippingHandling".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.savePaymentModel.cart?.selectedShippingRate
                            ?.formattedPrice?.price ??
                            "",
                        context),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets()
                        .getDrawerTileText("Tax".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.savePaymentModel.cart?.formattedPrice?.taxTotal
                            .toString() ??
                            "",
                        context),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets()
                        .getDrawerTileText("Discount".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.savePaymentModel.cart?.formattedPrice?.discount
                            .toString() ??
                            "",
                        context),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets()
                        .getDrawerTileText("GrandTotal".localized(), context),
                    CommonWidgets().getDrawerTileText(
                        widget.savePaymentModel.cart?.formattedPrice?.grandTotal
                            .toString() ??
                            "",
                        context),
                  ],
                ),
              )
            ]),
      ],
    );
  }
}
