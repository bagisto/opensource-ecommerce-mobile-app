


/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/common_widget/radio_button_group.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/bloc/checkout_shipping_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/event/checkout_fetch_shipping_event.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_fetch_shipping_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_shipping_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_shipping/state/checkout_shipping_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../common_widget/common_error_msg.dart';
import '../../../../configuration/app_global_data.dart';
import '../../../../models/checkout_models/checkout_save_address_model.dart';


class CheckoutShippingPageView extends StatefulWidget {
  String? billingCompanyName;
  String? billingFirstName;
  String? billingLastName;
  String? billingAddress;
  String? billingEmail;
  String? billingAddress2;
  String? billingCountry;
  String? billingState;
  String? billingCity;
  String? billingPostCode;
  String? billingPhone;
  String? shippingCompanyName;
  String? shippingFirstName;
  String? shippingLastName;
  String? shippingAddress;
  String? shippingEmail;
  String? shippingAddress2;
  String? shippingCountry;
  String? shippingState;
  String? shippingCity;
  String? shippingPostCode;
  String? shippingPhone;
  ValueChanged<String>? callBack;
   CheckoutShippingPageView({Key? key,this.billingCompanyName,
     this.billingFirstName,
     this.billingLastName,
     this.billingAddress,
     this.billingEmail,
     this.billingAddress2,
     this.billingCountry,
     this.billingState,
     this.billingCity,
     this.billingPostCode,
     this.billingPhone,
     this.shippingCompanyName,
     this.shippingFirstName,
     this.shippingLastName,
     this.shippingAddress,
     this.shippingEmail,
     this.shippingAddress2,
     this.shippingCountry,
     this.shippingState,
     this.shippingCity,
     this.shippingPostCode,
     this.shippingPhone,this.callBack}) : super(key: key);

  @override
  State<CheckoutShippingPageView> createState() => _CheckoutShippingPageViewState();
}

class _CheckoutShippingPageViewState extends State<CheckoutShippingPageView> {
String shippingId = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child:   _shippingBloc(context)
    );
  }


  ///ADDRESS BLOC CONTAINER///
  _shippingBloc(BuildContext context) {
    CheckOutShippingBloc checkOutShippingBloc = context.read<CheckOutShippingBloc>();
    checkOutShippingBloc.add(CheckOutFetchShippingEvent(
      billingCompanyName: widget.billingCompanyName,
        billingFirstName:widget.billingFirstName,
       billingLastName:widget.billingLastName,
       billingAddress:widget.billingAddress,
        billingEmail: widget.billingEmail,
        billingAddress2: widget.billingAddress2,
        billingCountry:widget.billingCountry,
        billingState: widget.billingState,
        billingCity: widget.billingCity,
        billingPostCode: widget.billingPostCode,
       billingPhone: widget.billingPhone,
       shippingCompanyName: widget.shippingCompanyName,
       shippingFirstName:widget.shippingFirstName,
        shippingLastName: widget.shippingLastName,
        shippingAddress:widget.shippingAddress,
       shippingEmail:widget.shippingEmail,
       shippingAddress2: widget.shippingAddress2,
       shippingCountry: widget.shippingCountry,
      shippingState: widget.shippingState,
      shippingCity:widget.shippingCity,
     shippingPostCode: widget.shippingPostCode,
      shippingPhone: widget.shippingPhone,

    ));
    return BlocConsumer<CheckOutShippingBloc, CheckOutShippingBaseState>(
      listener: (BuildContext context, CheckOutShippingBaseState state) {},
      builder: (BuildContext context, CheckOutShippingBaseState state) {
        return buildUI(context, state);
      },
    );
  }



  ///ADDRESS UI METHODS///
  Widget buildUI(BuildContext context, CheckOutShippingBaseState state) {

    if (state is CheckOutFetchShippingState) {

      if (state.status == CheckOutShippingStatus.success) {
          return _shippingMethods(state.checkOutSaveAddressModel!);
      }
      if (state.status == CheckOutShippingStatus.fail) {
        return ErrorMessage.errorMsg(  "ServerError".localized(),);
      }
    }
    if (state is CheckOutShippingInitialState) {
      return   CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    return Container();
  }


  _shippingMethods(SaveCheckoutAddresses checkOutSaveAddressModel){
      return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: NormalPadding),
          child: Column(
            children: [
              const Divider(thickness: 1,),
              Card(
                elevation: 2,
                child: RadioButtonGroup(activeColor: Theme.of(context).colorScheme.onPrimary,key: const Key('Shipping'),
                    labels: checkOutSaveAddressModel.shippingMethods?.map((e) => '${e.title ?? ''}  ${e.methods?.formattedPrice.toString() ??''}' ).toList() ?? [],
                    onChange: (value,index) {
                      if ((checkOutSaveAddressModel.shippingMethods?.length ?? 0) > 0) {
                        if (widget.callBack != null) {
                          widget.callBack!(checkOutSaveAddressModel.shippingMethods ?[index].methods?.code ?? '');
                        }
                      }
                    }

                ),
              ),
            ],
          )

      );
    }
}
