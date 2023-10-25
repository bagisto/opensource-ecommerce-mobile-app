import 'package:bagisto_app_demo/screens/cart_screen/view/cart_index.dart';
class ApplyCouponView extends StatefulWidget {
  final CartModel? cartDetailsModel;
  final CartScreenBloc? cartScreenBloc;
  final TextEditingController  discountController;



  ApplyCouponView({Key? key, this.cartDetailsModel, this.cartScreenBloc,required this.discountController}) : super(key: key);

  @override
  State<ApplyCouponView> createState() => _ApplyCouponViewState();
}

class _ApplyCouponViewState extends State<ApplyCouponView> {
  bool  showButton=false;
  final _discountCouponFormKey = GlobalKey<FormState>();
  final bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                horizontal: NormalPadding,
                vertical: 6
            ),
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
                      widget.discountController,
                      "CartPageEnterDiscountCodeLabel"
                          .localized(),
                      "CartPageEnterDiscountCodeLabel"
                          .localized(),
                      "",
                      contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 12),
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
                    padding: EdgeInsets.only(left: AppSizes.genericPaddingMin,bottom: showButton? AppSizes.widgetHeight:AppSizes.zero,right: 3),
                    child: MaterialButton(
                      height: 47,
                      color: Theme.of(context)
                          .colorScheme
                          .background,
                      textColor:MobikulTheme.primaryColor,
                      elevation: 0.0,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),

                      onPressed: () {
                        if (_discountCouponFormKey.currentState!.validate()) {
                          setState(() {
                            showButton=false;
                          });
                          if (widget.cartDetailsModel?.couponCode ==
                              null) {
                            widget.cartScreenBloc?.add(
                                AddCouponCartEvent(
                                    widget.discountController.text));
                          } else {
                            widget.cartScreenBloc?.add(
                                RemoveCouponCartEvent(
                                    widget.cartDetailsModel));
                            widget.discountController.text = "";
                          }
                        }
                      },
                      child: widget.cartDetailsModel?.couponCode ==
                          null ||
                          widget.cartDetailsModel?.couponCode ==
                              ''
                          ? Text(
                        "Apply".localized().toUpperCase(),
                        style: const TextStyle(
                            fontSize:
                            AppSizes.normalFontSize,
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
    );
  }
}
