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
import '../../../../data_model/app_route_arguments.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/assets_constants.dart';
import '../../../../utils/route_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/empty_data_view.dart';

//ignore: must_be_immutable
class AddNewAddressButton extends StatelessWidget {
  VoidCallback? reload;
  final bool? isFromDashboard;
  AddNewAddressButton({Key? key, this.reload,this.isFromDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          (isFromDashboard ?? false)
              ? Container()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
            color: Theme.of(context).colorScheme.onBackground,
            padding: const EdgeInsets.all(AppSizes.spacingMedium),
            onPressed: () {
                Navigator.pushNamed(context, addAddressScreen,
                        arguments: AddressNavigationData(
                            isEdit: false, addressModel: null))
                    .then((value) {
                  if (reload != null) {
                    reload!();
                  }
                });
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    StringConstants.addNewAddress.localized().toUpperCase(),
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                  )
                ],
            ),
          ),
              ),
          const EmptyDataView(assetPath: AssetConstants.emptyAddress,
          message: StringConstants.noAddress),
        ],
      ),
    );
  }
}
