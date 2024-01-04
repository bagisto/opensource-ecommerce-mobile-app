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
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_model/app_route_arguments.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/route_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../bloc/address_bloc.dart';
import '../../bloc/fetch_address_event.dart';
import '../../data_model/address_model.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class SavedAddressList extends StatelessWidget {
  AddressData? addressModel;
  VoidCallback? reload;
  SavedAddressList({Key? key, this.addressModel, this.reload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddressBloc addressBloc = context.read<AddressBloc>();
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppSizes.spacingNormal,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
            child: Text(
              "${addressModel?.firstName ?? ""} ${addressModel?.lastName ?? ""}",
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.spacingLarge),
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingLarge,
          ),
          _getFormattedAddress(addressModel),
          const SizedBox(
            height: AppSizes.spacingLarge,
          ),
          Padding(
              padding:
                  const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
              child: Row(
                children: [
                  Text("Mobile: ",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: AppSizes.spacingLarge)),
                  Text(
                    addressModel?.phone ?? "",
                    style: TextStyle(
                        fontSize: AppSizes.spacingLarge,
                        color: Colors.grey[600]),
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 1,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade300, width: 1)),
                  ),
                  child: MaterialButton(
                    elevation: 0.0,
                    onPressed: () {
                      Navigator.pushNamed(context, addAddressScreen,
                              arguments: AddressNavigationData(
                                  isEdit: true, addressModel: addressModel))
                          .then((value) {
                        if (reload != null) {
                          reload!();
                        }
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_edit_outline_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            StringConstants.edit.localized(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left:
                            BorderSide(color: Colors.grey.shade300, width: 1)),
                  ),
                  child: MaterialButton(
                    elevation: 0.0,
                    onPressed: () {
                      _onPressRemove(context, addressBloc);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          StringConstants.remove.localized(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onPressRemove(BuildContext context, AddressBloc addressBloc) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            StringConstants.deleteAddressWarning.localized(),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                StringConstants.no.localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  addressBloc.add(
                      RemoveAddressEvent(addressModel?.id ?? ""));
                },
                child: Text(StringConstants.yes.localized(),
                    style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }

  ///this method is used to format address
  _getFormattedAddress(AddressData? addressModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
      child: Text(
        ("${addressModel?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}") +
            "," +
            (" ${addressModel?.city ?? ""}") +
            "," +
            (" ${addressModel?.stateName ?? (addressModel?.state ?? "")}") +
            "," +
            (" ${addressModel?.countryName ?? ""}") +
            "," +
            (" ${addressModel?.postcode ?? ""}"),
        style: TextStyle(
            fontSize: AppSizes.spacingLarge, color: Colors.grey[600]),
      ),
    );
  }
}
