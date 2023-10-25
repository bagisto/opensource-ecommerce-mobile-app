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

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/bloc/checkout_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/events/checkout_address_event.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_address_state.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/state/checkout_loader_state.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/view/widget/billing_shipping_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../../../common_widget/circular_progress_indicator.dart';
import '../../../../../common_widget/common_error_msg.dart';
import '../../../../../configuration/app_global_data.dart';

class CheckoutAddressView extends StatefulWidget {
  Function(
      String? billingCompanyName,
      String? billingFirstName,
      String? billingLastName,
      String? billingAddress,
      String? billingAddress2,
      String? billingCountry,
      String? billingState,
      String? billingCity,
      String? billingPostCode,
      String? billingPhone,
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone)? callBack;

  CheckoutAddressView({Key? key, this.callBack}) : super(key: key);

  @override
  State<CheckoutAddressView> createState() => _CheckoutAddressViewState();
}

class _CheckoutAddressViewState extends State<CheckoutAddressView> {
  AddressModel? _addressModel;
  AddressData? billingAddress;
  AddressData? shippingAddress;
  String? email;

  @override
  void initState() {
    getSharePreferenceEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    super.initState();
  }

  Future getSharePreferenceEmail() async {
    return await SharedPreferenceHelper.getCustomerEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: _addressBloc( context),
    );
  }

  ///ADDRESS BLOC CONTAINER///
  _addressBloc(BuildContext context) {
    CheckOutBloc checkOutBloc = context.read<CheckOutBloc>();
    if (_addressModel == null) {
      checkOutBloc.add(CheckOutAddressEvent());
    }
    return BlocConsumer<CheckOutBloc, CheckOutBaseState>(
      listener: (BuildContext context, CheckOutBaseState state) {},
      builder: (BuildContext context, CheckOutBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///ADDRESS UI METHODS///
  Widget buildUI(BuildContext context, CheckOutBaseState state) {
    if (state is CheckOutAddressState) {
      if (state.status == CheckOutStatus.success) {
        _addressModel = state.addressModel;
        billingAddress ??= _addressModel?.addressData
            ?.firstWhereOrNull((element) => element.isDefault ?? true);
        shippingAddress ??= _addressModel?.addressData
            ?.firstWhereOrNull((element) => element.isDefault ?? true);
        if (widget.callBack != null) {
          widget.callBack!(
            billingAddress?.companyName,
            billingAddress?.firstName,
            billingAddress?.lastName,
            billingAddress?.address1,
            billingAddress?.address1,
            billingAddress?.country,
            billingAddress?.state,
            billingAddress?.city,
            billingAddress?.postcode,
            billingAddress?.phone,
            shippingAddress?.companyName,
            shippingAddress?.firstName,
            shippingAddress?.lastName,
            shippingAddress?.address1,
            shippingAddress?.address1,
            shippingAddress?.country,
            shippingAddress?.state,
            shippingAddress?.city,
            shippingAddress?.postcode,
            shippingAddress?.phone,
          );
        }
        return _addressList();
      }

      if (state.status == CheckOutStatus.fail) {
        return ErrorMessage.errorMsg(
            ApplicationLocalizations.of(context)!.translate("SomethingWrong"));
      }
    }
    if (state is CheckOutLoaderState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    return Container();
  }

  _addressList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().getTextFieldHeight(12),
          BillingAndShippingAddressView(title: "BillingAddress",address: billingAddress,addressModel: _addressModel,callBack:widget.callBack),
          const SizedBox(height: 16),
          ///shipping address
          BillingAndShippingAddressView(title: "ShippingAddress",address: shippingAddress,addressModel: _addressModel,callBack:widget.callBack),
        ],
      ),
    );
  }

  fetchAddressData() async {
    CheckOutBloc checkOutBloc = context.read<CheckOutBloc>();
    checkOutBloc.add(CheckOutAddressEvent());
  }
}
