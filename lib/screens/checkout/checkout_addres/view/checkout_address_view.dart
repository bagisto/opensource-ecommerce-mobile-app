/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/checkout/checkout_addres/view/widget/billing_shipping_address_view.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_addres/view/widget/checkout_address_loader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utils/app_global_data.dart';
import '../../../../../utils/shared_preference_helper.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../widgets/common_error_msg.dart';
import '../../../address_list/data_model/address_model.dart';
import '../../../categories_screen/categories_screen.dart';
import '../../guest_add_address/view/checkout_guest_address_loader_view.dart';
import '../bloc/checkout_address_state.dart';
import '../bloc/checkout_base_event.dart';
import '../bloc/checkout_bloc.dart';
import 'package:collection/collection.dart';

//ignore: must_be_immutable
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
      String? shippingPhone, int billingAddressId, int shippingAddressId)? callBack;

  CheckoutAddressView({Key? key, this.callBack}) : super(key: key);

  @override
  State<CheckoutAddressView> createState() => _CheckoutAddressViewState();
}

class _CheckoutAddressViewState extends State<CheckoutAddressView> {
  AddressModel? _addressModel;
  AddressData? billingAddress;
  AddressData? shippingAddress;
  String? email;
  bool? isUser;
  CheckOutBloc? checkOutBloc;

  @override
  void initState() {
    checkOutBloc = context.read<CheckOutBloc>();
    if (_addressModel == null) {
      checkOutBloc?.add(CheckOutAddressEvent());
    }
    getSharePreferenceEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    getCustomerLoggedInPrefValue().then((value) {
      setState(() {
        isUser = value;
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
      child: _addressBloc(context),
    );
  }

  ///ADDRESS BLOC CONTAINER///
  _addressBloc(BuildContext context) {
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
        billingAddress ??= _addressModel?.addressData?.firstWhereOrNull((element) => element.isDefault ?? false);
        shippingAddress ??= _addressModel?.addressData?.firstWhereOrNull((element) => element.isDefault ?? false);
        if (billingAddress == null &&
            (_addressModel?.addressData?.isNotEmpty ?? false)) {
          billingAddress = _addressModel?.addressData?.first;
        }
        if (shippingAddress == null &&
            (_addressModel?.addressData?.isNotEmpty ?? false)) {
          shippingAddress = _addressModel?.addressData?.first;
        }
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
            int.parse(billingAddress?.id ?? "0"),
            int.parse(shippingAddress?.id ?? "0")
          );
        }

        return _addressList();
      }

      if (state.status == CheckOutStatus.fail) {
        return ErrorMessage.errorMsg(StringConstants.somethingWrong);
      }
    }
    if (state is CheckOutLoaderState) {
      return isUser ?? false
          ? const CheckoutAddressLoaderView()
          : const CheckoutGuestAddressLoaderView();
    }

    return const SizedBox();
  }

  _addressList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          BillingAndShippingAddressView(
              title: StringConstants.billingAddress,
              address: billingAddress,
              billingAddress: billingAddress,
              shippingAddress: shippingAddress,
              addressModel: _addressModel,
              callBack: widget.callBack),
          const SizedBox(height: 8),

          ///shipping address
          BillingAndShippingAddressView(
              title: StringConstants.shippingAddress,
              address: shippingAddress,
              shippingAddress: shippingAddress,
              billingAddress: billingAddress,
              addressModel: _addressModel,
              callBack: widget.callBack),
        ],
      ),
    );
  }
}
