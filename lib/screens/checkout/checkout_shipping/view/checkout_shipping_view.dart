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
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_error_msg.dart';
import '../../../../widgets/show_message.dart';
import '../../data_model/checkout_save_address_model.dart';
import '../bloc/checkout_fetch_shipping_state.dart';
import '../bloc/checkout_shipping_base_event.dart';
import '../bloc/checkout_shipping_bloc.dart';

//ignore: must_be_immutable
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
  int billingId;
  int shippingId;
  ValueChanged<String>? callBack;
  bool isDownloadable;
  Function? callbackNavigate;
  CheckoutShippingPageView(
      {Key? key,
      this.billingCompanyName,
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
      this.shippingPhone,
      this.callBack, required this.shippingId, required this.billingId, this.isDownloadable = false,
      this.callbackNavigate})
      : super(key: key);

  @override
  State<CheckoutShippingPageView> createState() =>
      _CheckoutShippingPageViewState();
}

class _CheckoutShippingPageViewState extends State<CheckoutShippingPageView> {
  String shippingId = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child: _shippingBloc(context));
  }

  ///ADDRESS BLOC CONTAINER///
  _shippingBloc(BuildContext context) {
    CheckOutShippingBloc checkOutShippingBloc =
        context.read<CheckOutShippingBloc>();
    checkOutShippingBloc.add(CheckOutFetchShippingEvent(
      billingCompanyName: widget.billingCompanyName,
      billingFirstName: widget.billingFirstName,
      billingLastName: widget.billingLastName,
      billingAddress: widget.billingAddress,
      billingEmail: widget.billingEmail,
      billingAddress2: widget.billingAddress2,
      billingCountry: widget.billingCountry,
      billingState: widget.billingState,
      billingCity: widget.billingCity,
      billingPostCode: widget.billingPostCode,
      billingPhone: widget.billingPhone,
      shippingCompanyName: widget.shippingCompanyName,
      shippingFirstName: widget.shippingFirstName,
      shippingLastName: widget.shippingLastName,
      shippingAddress: widget.shippingAddress,
      shippingEmail: widget.shippingEmail,
      shippingAddress2: widget.shippingAddress2,
      shippingCountry: widget.shippingCountry,
      shippingState: widget.shippingState,
      shippingCity: widget.shippingCity,
      shippingPostCode: widget.shippingPostCode,
      shippingPhone: widget.shippingPhone,
      billingId: widget.billingId,
      shippingId: widget.shippingId,
    ));
    return BlocConsumer<CheckOutShippingBloc, CheckOutShippingBaseState>(
      listener: (BuildContext context, CheckOutShippingBaseState state) {
        if(state is CheckOutFetchShippingState){
          if((state.checkOutSaveAddressModel?.shippingMethods ?? []).isEmpty && widget.isDownloadable==false){
            ShowMessage.showNotification(StringConstants.failed.localized(), StringConstants.noShippingMsg.localized(),
                Colors.red, const Icon(Icons.cancel_outlined));
          }
        }
        if(widget.isDownloadable){
          if (widget.callbackNavigate != null) {
              widget.callbackNavigate!();
          }
        }
      },
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
        return ErrorMessage.errorMsg(
          StringConstants.serverError.localized(),
        );
      }
    }
    if (state is CheckOutShippingInitialState) {
      return SkeletonLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).appBarTheme.backgroundColor ??
              MobikulTheme.primaryColor,
          builder: Container(
              height: AppSizes.spacingWide * 5,
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: const Card(
                margin: EdgeInsets.zero,
                color: Colors.red,
              )));
    }

    return const SizedBox();
  }

  _shippingMethods(SaveCheckoutAddresses checkOutSaveAddressModel) {
    return Container(
        height: AppSizes.spacingWide * 5,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacingNormal),
            Text(
              StringConstants.shippingMethods.localized(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 4),
              child: RadioButtonGroup(
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  key: const Key('Shipping'),
                  labels: checkOutSaveAddressModel.shippingMethods
                          ?.map((e) =>
                              (e.title ?? '') +
                              '  ' +
                              (e.methods?.formattedPrice.toString() ?? ''))
                          .toList() ??
                      [],
                  onChange: (value, index) {
                    if ((checkOutSaveAddressModel.shippingMethods?.length ??
                            0) >
                        0) {
                      if (widget.callBack != null) {
                        widget.callBack!(checkOutSaveAddressModel
                                .shippingMethods?[index].methods?.code ??
                            '');
                      }
                    }
                  }),
            ),
          ],
        ));
  }
}
