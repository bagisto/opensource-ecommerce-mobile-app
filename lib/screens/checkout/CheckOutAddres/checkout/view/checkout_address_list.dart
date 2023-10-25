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

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:flutter/material.dart';

import '../../../../../configuration/app_global_data.dart';
import '../../../../../configuration/app_sizes.dart';

class CheckoutAddressList extends StatefulWidget {
  AddressModel addressModel;

  CheckoutAddressList({Key? key, required this.addressModel}) : super(key: key);

  @override
  State<CheckoutAddressList> createState() => _CheckoutAddressListState();
}

class _CheckoutAddressListState extends State<CheckoutAddressList> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: GlobalData.contentDirection(),
        child:Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CommonWidgets.getHeadingText("Address".localized(), context),
      ),
      body:  _getAddressList(widget.addressModel),
      )

    );
  }

  _getAddressList(AddressModel addressModel) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: addressModel.addressData!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(addressModel.addressData?[index]);
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
                          height: AppSizes.genericPadding,
                        ),
                        _getFormattedAddress(addressModel, index),
                        const SizedBox(
                          height: AppSizes.genericPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSizes.normalHeight, 0, 0, 0),
                          child: RichText(
                            text: TextSpan(
                              text: "".localized(),
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: ("Mobile: "),
                                    style: TextStyle(color: Colors.grey[600])),
                                TextSpan(
                                    text: (addressModel
                                            .addressData![index].phone ??
                                        ""),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ), /*Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.normalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getFormattedAddress(addressModel, index),
                          Text(
                           "Contact".localized() +
                                addressModel.addressData![index].phone??"",
                            style: const TextStyle(fontSize:AppSizes.normalFontSize),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),*/
                );
              }),
        ),
      ],
    );
  }

  _getFormattedAddress(AddressModel addressModel, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.normalHeight, 0, 0, 0),
      child: Text(
        "${addressModel.addressData?[index].firstName} ${addressModel.addressData?[index].lastName}\n\n${addressModel.addressData![index].address1!.replaceAll("[", "").replaceAll("]", "")},${addressModel.addressData![index].city!},${addressModel.addressData![index].stateName ?? ""},${addressModel.addressData![index].countryName!},${addressModel.addressData![index].postcode!}",
        style: const TextStyle(fontSize: AppSizes.normalFontSize),
      ),
    );
  }
}
