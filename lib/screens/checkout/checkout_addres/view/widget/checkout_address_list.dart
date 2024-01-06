/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_global_data.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../address_list/data_model/address_model.dart';
import '../../bloc/checkout_address_state.dart';
import '../../bloc/checkout_base_event.dart';
import '../../bloc/checkout_bloc.dart';

//ignore: must_be_immutable
class CheckoutAddressList extends StatefulWidget {
  AddressModel addressModel;

  CheckoutAddressList({Key? key, required this.addressModel}) : super(key: key);

  @override
  State<CheckoutAddressList> createState() => _CheckoutAddressListState();
}

class _CheckoutAddressListState extends State<CheckoutAddressList> {
  CheckOutBloc? bloc;
  bool loading = false;
  late AddressModel address;

  @override
  void initState() {
    address = widget.addressModel;
    bloc = context.read<CheckOutBloc>();
    bloc?.add(CheckOutAddressEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton,
          centerTitle: false,
          title: Text(StringConstants.address.localized()),
        ),
        body: _getAddressList(),
      ),
    );
  }

  _getAddressList() {
    return BlocBuilder<CheckOutBloc, CheckOutBaseState>(builder: (context, state){
      if(state is CheckOutLoaderState){
        loading = true;
      }

      if(state is CheckOutAddressState){
        loading = false;
        if(state.addressModel != null){
          address = state.addressModel!;
        }
      }
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: address.addressData!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop(address.addressData?[index]);
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: AppSizes.spacingNormal,
                              ),
                              const SizedBox(
                                height: AppSizes.spacingLarge,
                              ),
                              _getFormattedAddress(address, index),
                              const SizedBox(
                                height: AppSizes.spacingLarge,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    AppSizes.spacingMedium, 0, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "",
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ("Mobile: "),
                                          style: TextStyle(color: Colors.grey[600])),
                                      TextSpan(
                                          text: (address
                                              .addressData![index].phone ??
                                              ""),
                                          style:
                                          const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Visibility(visible: loading, child: const Loader())
        ],
      );
    });
  }

  _getFormattedAddress(AddressModel addressModel, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
      child: Text(
        "${addressModel.addressData?[index].firstName} ${addressModel.addressData?[index].lastName}\n\n${addressModel.addressData![index].address1!.replaceAll("[", "").replaceAll("]", "")},${addressModel.addressData![index].city!},${addressModel.addressData![index].stateName ?? ""}${addressModel.addressData![index].countryName!},${addressModel.addressData![index].postcode!}",
        style: const TextStyle(fontSize: AppSizes.spacingLarge),
      ),
    );
  }
}
