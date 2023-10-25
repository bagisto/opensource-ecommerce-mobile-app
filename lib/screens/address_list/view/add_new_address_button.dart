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

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../configuration/app_sizes.dart';
import '../../../routes/route_constants.dart';
import 'address_screen.dart';

class AddNewAddressButton extends StatelessWidget {
  VoidCallback? reload;
  final bool? isFromDashboard;

  AddNewAddressButton({Key? key, this.reload, this.isFromDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (isFromDashboard ?? false)
            ? Container()
            : MaterialButton(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.all(AppSizes.mediumPadding),
          onPressed: () {
            Navigator.pushNamed(context, AddAddress,
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
                "AddNewAddress".localized().toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
                child: LottieBuilder.asset(
                  "assets/lottie/empty_address.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: AppSizes.widgetSidePadding,
              ),
              Text(
                "NoAddress".localized(),
                softWrap: true,
                style: const TextStyle(fontSize: AppSizes.normalFontSize),
              ),
            ],
          ),
        )
      ],
    );
  }
}
