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
import '../../data_model/checkout_save_shipping_model.dart';
export 'package:bagisto_app_demo/screens/checkout/data_model/checkout_save_shipping_model.dart';

class CheckoutPaymentView extends StatefulWidget {
  final String? shippingId;
  final Function(String)? callBack;
  final ValueChanged<String>? priceCallback;
  final String? total;
  PaymentMethods? paymentMethods;

   CheckoutPaymentView(
      {Key? key,
      this.total,
      this.shippingId,
      this.callBack,
      this.priceCallback, this.paymentMethods})
      : super(key: key);

  @override
  State<CheckoutPaymentView> createState() => _CheckoutPaymentViewState();
}

class _CheckoutPaymentViewState extends State<CheckoutPaymentView> {
  @override
  Widget build(BuildContext context) {
    return _paymentBloc(context);
  }

  ///ADDRESS BLOC CONTAINER///
  _paymentBloc(BuildContext context) {
    CheckOutPaymentBloc checkOutPaymentBloc =
        context.read<CheckOutPaymentBloc>();
    if((widget.paymentMethods?.paymentMethods ?? []).isEmpty){
      checkOutPaymentBloc
          .add(CheckOutPaymentEvent(shippingMethod: widget.shippingId));
    }
    return BlocConsumer<CheckOutPaymentBloc, CheckOutPaymentBaseState>(
      listener: (BuildContext context, CheckOutPaymentBaseState state) {},
      builder: (BuildContext context, CheckOutPaymentBaseState state) {
        return (widget.paymentMethods?.paymentMethods ?? []).isNotEmpty ? _paymentMethods(widget.paymentMethods!)
            : buildUI(context, state);
      },
    );
  }

  ///ADDRESS UI METHODS///
  Widget buildUI(BuildContext context, CheckOutPaymentBaseState state) {
    if (state is CheckOutFetchPaymentState) {
      if (state.status == CheckOutPaymentStatus.success) {
        return _paymentMethods(state.checkOutShipping!);
      }
      if (state.status == CheckOutPaymentStatus.fail) {
        return ErrorMessage.errorMsg(StringConstants.somethingWrong.localized());
      }
    }
    if (state is CheckOutPaymentInitialState) {
      return SkeletonLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          builder: Container(
              height: 130,
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: const Card(
                margin: EdgeInsets.zero,
                color: Colors.grey,
              )));
    }
    return const SizedBox();
  }

  _paymentMethods(PaymentMethods checkOutShipping) {
    if (widget.priceCallback != null) {
      widget.priceCallback!(
          checkOutShipping.cart?.formattedPrice?.grandTotal ?? "");
    }
    var paymentMethods = checkOutShipping.paymentMethods
        ?.where((element) => availablePaymentMethods.contains(element.method));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spacingNormal),
          Text(
            StringConstants.paymentMethods.localized(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.fromLTRB(0, AppSizes.spacingNormal, 0, AppSizes.spacingSmall),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacingNormal),
              child: RadioButtonGroup(
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  key: const Key('Payment'),
                  labels: paymentMethods
                          ?.map((e) => e.methodTitle ?? '')
                          .toList() ??
                      [],
                  onChange: (value, id) {
                    var payment = checkOutShipping.paymentMethods
                        ?.firstWhere((element) => element.methodTitle == value);
                    if (widget.callBack != null) {
                      widget.callBack!(
                        payment?.method ?? '',
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
