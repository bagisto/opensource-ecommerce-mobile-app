/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, implementation_imports, file_names

import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../routes/route_constants.dart';
import '../bloc/address_bloc.dart';
import '../events/remove_address_event.dart';
import 'address_screen.dart';

class SavedAddressList extends StatelessWidget {
  AddressData? addressModel;
  VoidCallback? reload;

  SavedAddressList({Key? key, this.addressModel, this.reload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddressBloc addressBloc = context.read<AddressBloc>();
    return SizedBox(
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppSizes.spacingNormal,
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(AppSizes.normalHeight, 0, 0, 0),
              child: Text(
                "${addressModel?.firstName ?? ""} ${addressModel?.lastName ?? ""}",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.normalFontSize),
              ),
            ),
            const SizedBox(
              height: AppSizes.genericPadding,
            ),
            _getFormattedAddress(addressModel),
            const SizedBox(
              height: AppSizes.genericPadding,
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(AppSizes.normalHeight, 0, 0, 0),
              child: RichText(
                text: TextSpan(
                  text: "".localized(),
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: ("Mobile: "),
                        style: TextStyle(color: Colors.grey[600])),
                    TextSpan(
                        text: (addressModel?.phone ?? ""),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1.5,
            ),
            SizedBox(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddAddress,
                                arguments: AddressNavigationData(
                                    isEdit: true, addressModel: addressModel))
                            .then((value) {
                          if (reload != null) {
                            reload!();
                          }
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.mode_edit_outline_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Edit".localized(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _onPressRemove(context, addressBloc);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.delete,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Remove".localized(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            "deleteAddressWarning".localized(),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "ButtonLabelNO".localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  addressBloc.add(
                      RemoveAddressEvent(int.parse(addressModel?.id ?? "")));
                },
                child: Text(
                  "ButtonLabelYes".localized(),
                ))
          ],
        );
      },
    );
  }

  ///this method is used to format address
  _getFormattedAddress(AddressData? addressModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.normalHeight, 0, 0, 0),
      child: Text(
        "${addressModel?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${addressModel?.city ?? ""}, ${addressModel?.stateName ?? ""}, ${addressModel?.countryName ?? ""}, ${addressModel?.postcode ?? ""}",
        style: TextStyle(
            fontSize: AppSizes.normalFontSize, color: Colors.grey[600]),
      ),
    );
  }
}
