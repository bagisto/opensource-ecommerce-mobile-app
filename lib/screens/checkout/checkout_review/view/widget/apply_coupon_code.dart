

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/mobikul_theme.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../widgets/common_widgets.dart';
import '../../../../cart_screen/bloc/cart_screen_base_event.dart';
import '../../../../cart_screen/bloc/cart_screen_bloc.dart';
import '../../../../cart_screen/cart_model/cart_data_model.dart';
import '../../../data_model/save_payment_model.dart';


class ApplyCouponCode extends StatefulWidget {
  final SavePayment savePaymentModel;
  final CartScreenBloc? cartScreenBloc;
  final CartModel? cartDetailsModel;
  final Function? callback;
  const ApplyCouponCode({Key? key, required this.savePaymentModel, this.cartScreenBloc, this.cartDetailsModel,
  this.callback}) : super(key: key);

  @override
  State<ApplyCouponCode> createState() => _ApplyCouponCodeState();
}

class _ApplyCouponCodeState extends State<ApplyCouponCode> {
  final _discountCouponFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final _discountController = TextEditingController();
  bool  showButton = false;

  @override
  void initState() {
    _discountController.text = widget.cartDetailsModel?.couponCode ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Theme(
          data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            initiallyExpanded: true,
            iconColor: Colors.grey,
            title: Text(
              StringConstants.applyCode.localized(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Row(
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
                        StringConstants.cartPageEnterDiscountCodeLabel.localized(),
                        validLabel: "",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        validator: (discountCode) {
                          if ((discountCode?.trim() ?? "").isEmpty) {
                            setState(() {
                              showButton = true;
                            });
                            return StringConstants.couponEmpty.localized();
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
                          left: AppSizes.spacingNormal,
                          bottom: showButton
                              ? AppSizes.spacingWide
                              : 0,
                          right: 3),
                      child: MaterialButton(
                        height: 47,
                        color: Theme.of(context).colorScheme.onBackground,
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

                            Future.delayed(const Duration(seconds: 1)).then((value) {
                              if(widget.callback != null){
                                widget.callback!();
                              }
                            });
                          }

                        },
                        child: widget.cartDetailsModel?.couponCode ==
                            null ||
                            widget.cartDetailsModel?.couponCode == ''
                            ? Text(
                          StringConstants.apply.localized().toUpperCase(),
                          style: const TextStyle(
                              fontSize: AppSizes.spacingLarge,
                              fontWeight: FontWeight.w500),
                        )
                            : Text(StringConstants.remove.localized()),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              iconColor: Colors.grey,
              title: Text(
                StringConstants.priceDetails.localized().toUpperCase(),
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
                        Text(
                          StringConstants.subTotal.localized(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.savePaymentModel.cart?.formattedPrice?.subTotal
                              .toString() ??
                              "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        )
                    ],
                  ),
                ),
                widget.savePaymentModel.cart?.selectedShippingRate!=null?Container(
                  padding: const EdgeInsets.all(4.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.shippingHandling.localized(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.savePaymentModel.cart?.selectedShippingRate
                            ?.formattedPrice?.price ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ): const SizedBox.shrink(),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.tax.localized(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.savePaymentModel.cart?.formattedPrice?.taxTotal
                            .toString() ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.discount.localized(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.savePaymentModel.cart?.formattedPrice?.discount
                            .toString() ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.grandTotal.localized(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.savePaymentModel.cart?.formattedPrice?.grandTotal
                            .toString() ??
                            "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
