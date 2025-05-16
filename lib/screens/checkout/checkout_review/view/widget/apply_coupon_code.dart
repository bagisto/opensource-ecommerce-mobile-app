

/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import '../../../data_model/save_payment_model.dart';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';


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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: AppSizes.buttonHeight+5,
                        color: Theme.of(context).colorScheme.onBackground,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.spacingSmall),
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
                          style:  TextStyle(
                              fontSize: AppSizes.spacingLarge,
                              fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondaryContainer),
                        )
                            : Text(StringConstants.remove.localized(),  style:  TextStyle(
                            fontSize: AppSizes.spacingLarge,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondaryContainer),),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingNormal),
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
                  padding: const EdgeInsets.all(AppSizes.spacingSmall),
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
                  padding: const EdgeInsets.all(AppSizes.spacingSmall),
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
                  padding: const EdgeInsets.all(AppSizes.spacingSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.discount.localized(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500),
                      ),

                      Text( widget.savePaymentModel.cart?.formattedPrice?.discountAmount !=null?
                      widget.savePaymentModel.cart?.formattedPrice?.discountAmount
                          .toString() ??
                          "":"${GlobalData.currencySymbol }0.0",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingMedium,
                ),
                Container(
                 // margin:const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium, vertical: 0),
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1), // Left border
                      bottom: BorderSide(color:  Colors.grey.shade300, width: 1), // Right border
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: Colors.grey,
                    tilePadding: const EdgeInsets.symmetric(horizontal:AppSizes.spacingSmall, vertical: 0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringConstants.tax.localized(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${widget.savePaymentModel.cart?.formattedPrice?.taxTotal?.toString() ?? ""}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                         padding: const EdgeInsets.fromLTRB(AppSizes.spacingSmall, 0, AppSizes.spacingSmall, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...?widget.savePaymentModel.cart?.appliedTaxRates?.map((taxRate) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${taxRate.taxName.trim()}",
                                        style: const TextStyle(fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "${taxRate.totalAmount}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingMedium,
                ),
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacingSmall),
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
