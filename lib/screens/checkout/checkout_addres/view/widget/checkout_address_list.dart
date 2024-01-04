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
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/app_global_data.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../address_list/data_model/address_model.dart';

//ignore: must_be_immutable
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
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton,
          centerTitle: false,
          title: Text(StringConstants.address.localized()),
        ),
        body: _getAddressList(widget.addressModel),
      ),
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
                          height: AppSizes.spacingLarge,
                        ),
                        _getFormattedAddress(addressModel, index),
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
                                    text: (addressModel
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
    );
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
