/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/mobikul_theme.dart';
import '../../../../utils/radio_button_group.dart';
import '../../../../utils/server_configuration.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_error_msg.dart';
import '../../data_model/checkout_save_shipping_model.dart';
import '../bloc/checkout_fetch_payment_state.dart';
import '../bloc/checkout_payment_base_event.dart';
import '../bloc/checkout_payment_bloc.dart';

//ignore: must_be_immutable
class CheckoutPaymentView extends StatefulWidget {
  String? shippingId;
  Function(String)? callBack;
  ValueChanged<String>? priceCallback;

  String? total;

  CheckoutPaymentView(
      {Key? key,
      this.total,
      this.shippingId,
      this.callBack,
      this.priceCallback})
      : super(key: key);

  @override
  State<CheckoutPaymentView> createState() => _CheckoutPaymentViewState();
}

class _CheckoutPaymentViewState extends State<CheckoutPaymentView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child: _paymentBloc(context));
  }

  ///ADDRESS BLOC CONTAINER///
  _paymentBloc(BuildContext context) {
    CheckOutPaymentBloc checkOutPaymentBloc =
        context.read<CheckOutPaymentBloc>();
    checkOutPaymentBloc
        .add(CheckOutPaymentEvent(shippingMethod: widget.shippingId));
    return BlocConsumer<CheckOutPaymentBloc, CheckOutPaymentBaseState>(
      listener: (BuildContext context, CheckOutPaymentBaseState state) {},
      builder: (BuildContext context, CheckOutPaymentBaseState state) {
        return buildUI(context, state);
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
          baseColor: Theme.of(context).appBarTheme.backgroundColor ??
              MobikulTheme.primaryColor,
          builder: Container(
              height: 130,
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: const Card(
                margin: EdgeInsets.zero,
                color: Colors.grey,
              )));
    }
    return Container();
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
          const SizedBox(height: 8),
          Text(
            StringConstants.paymentMethods.localized(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 4),
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
