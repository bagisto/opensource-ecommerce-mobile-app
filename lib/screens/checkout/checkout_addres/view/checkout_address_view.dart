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

class CheckoutAddressView extends StatefulWidget {
  final Function(
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
      String? shippingPhone, int billingAddressId, int shippingAddressId,
      AddressType addressType, bool isShippingSame
      )? callBack;

  const CheckoutAddressView({Key? key, this.callBack}) : super(key: key);

  @override
  State<CheckoutAddressView> createState() => _CheckoutAddressViewState();
}

class _CheckoutAddressViewState extends State<CheckoutAddressView> {
  AddressModel? _addressModel;
  AddressData? billingAddress;
  AddressData? shippingAddress;
  String? email;
  bool? isUser;
  bool isShippingSame = true;
  CheckOutBloc? checkOutBloc;
  AddressType type = AddressType.both;

  @override
  void initState() {
    checkOutBloc = context.read<CheckOutBloc>();
    if (_addressModel == null) {
      checkOutBloc?.add(CheckOutAddressEvent());
    }
    email = appStoragePref.getCustomerEmail();
    isUser = appStoragePref.getCustomerLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _addressBloc(context);
  }

  ///ADDRESS BLOC CONTAINER///
  _addressBloc(BuildContext context) {
    return BlocConsumer<CheckOutBloc, CheckOutBaseState>(
      listener: (BuildContext context, CheckOutBaseState state) {
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

            callAddressCallback();

          }
        }
      },
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
          const SizedBox(height: AppSizes.spacingNormal),
          BillingAndShippingAddressView(
              title: StringConstants.billingAddress,
              address: billingAddress,
              billingAddress: billingAddress,
              shippingAddress: shippingAddress,
              addressModel: _addressModel,
              callBack: widget.callBack,
              isShippingSame: isShippingSame,
            addressSetCallback: (billing, shipping){
              setState(() {
                if(shipping != null){
                  type = AddressType.shipping;
                  shippingAddress = shipping;
                }
                if(billing != null){
                  type = AddressType.billing;
                  billingAddress = billing;
                }
              });
            },
          ),
          const SizedBox(height: AppSizes.spacingNormal),
          Row(
            children: [
              Checkbox(
                  value: isShippingSame,
                  onChanged: (bool? value) {
                    setState(() {
                      isShippingSame = value ?? false;
                      if(isShippingSame){
                        type = AddressType.both;
                        if(billingAddress != null){
                          shippingAddress = billingAddress;
                        }
                        callAddressCallback();
                      }
                    });
                  }),
              Text(StringConstants.sameAsBilling.localized()),
            ],
          ),
          ///shipping address
          if(!isShippingSame)
          BillingAndShippingAddressView(
              title: StringConstants.shippingAddress,
              address: shippingAddress,
              shippingAddress: shippingAddress,
              billingAddress: billingAddress,
              addressModel: _addressModel,
              callBack: widget.callBack,
            isShippingSame: isShippingSame,
            addressSetCallback: (billing, shipping){
              setState(() {
                if(shipping != null){
                  type = AddressType.shipping;
                  shippingAddress = shipping;
                }
                if(billing != null){
                  type = AddressType.billing;
                  billingAddress = billing;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void callAddressCallback() {
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
          int.parse(shippingAddress?.id ?? "0"),
          type,
          isShippingSame
      );
    }
  }
}
