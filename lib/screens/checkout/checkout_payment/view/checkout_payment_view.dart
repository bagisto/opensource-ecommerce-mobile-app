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

import 'package:bagisto_app_demo/configuration/server_configuration.dart';
import 'package:bagisto_app_demo/common_widget/common_error_msg.dart';
import 'package:bagisto_app_demo/common_widget/radio_button_group.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/bloc/checkout_payment_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_fetch_payment_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_payment_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_payment/state/checkout_payment_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../configuration/app_global_data.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/checkout_models/checkout_save_shipping_model.dart';
import '../event/checkout_fetch_payment_event.dart';

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
      child:   _paymentBloc(context)
    );

  }

  ///ADDRESS BLOC CONTAINER///
  _paymentBloc(BuildContext context) {
    CheckOutPaymentBloc checkOutPaymnetBloc =
        context.read<CheckOutPaymentBloc>();
    checkOutPaymnetBloc
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
        return ErrorMessage.errorMsg("SomethingWrong".localized());
      }
    }
    if (state is CheckOutPaymentInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
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
      padding: const EdgeInsets.symmetric(vertical: NormalPadding),
      child: Column(
        children: [
          const Divider(
            thickness: 1,
          ),
          Card(
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(NormalPadding),
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
