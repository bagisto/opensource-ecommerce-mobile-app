/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/add_edit_address/utils/index.dart';

// ignore: must_be_immutable
class SaveAddressButton extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController companyController;
  final TextEditingController street1Controller;
  final TextEditingController zipCodeController;
  final TextEditingController phoneController;
  final TextEditingController vatIdController;
  final TextEditingController cityController;
  final TextEditingController stateNameController;
  final TextEditingController emailController;
  final bool? isEdit;
  final GlobalKey<FormState> formKey;
  final Data? selectedCountry;
  final States? selectedState;
  final String? countryCode;
  final String? stateCode;
  final String? addressId;
  final AddEditAddressBloc? addEditAddressBloc;
  bool isDefault;
  SaveAddressButton(
      {Key? key,
      required this.firstNameController,
      required this.lastNameController,
      required this.companyController,
      required this.street1Controller,
      required this.zipCodeController,
      required this.phoneController,
      required this.vatIdController,
      this.isEdit,
      required this.formKey,
      this.selectedCountry,
      this.selectedState,
      this.countryCode,
      this.stateCode,
      this.addressId,
      this.addEditAddressBloc,
      required this.isDefault,
      required this.cityController,
      required this.stateNameController,
        required this.emailController})
      : super(key: key);

  @override
  State<SaveAddressButton> createState() => _SaveAddressButtonState();
}

class _SaveAddressButtonState extends State<SaveAddressButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSizes.spacingWide),
        Row(
          children: [
            Checkbox(
                value: widget.isDefault,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isDefault = value ?? false;
                  });
                }),
            Text(StringConstants.defaultAddress.localized()),
          ],
        ),
        const SizedBox(height: AppSizes.spacingWide),
        MaterialButton(
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppSizes.spacingSmall)),
          ),
          elevation: 0.0,
          height: AppSizes.buttonHeight,
          minWidth: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.onBackground,
          textColor: Theme.of(context).colorScheme.secondaryContainer,
          onPressed: () {
            _onPressSaveButton();
          },
          child: Text(
            StringConstants.saveAddress.localized().toUpperCase(),
            style: const TextStyle(fontSize: AppSizes.spacingLarge),
          ),
        ),
        const SizedBox(height: AppSizes.spacingWide),
      ],
    );
  }

  ///action performed on press save button
  _onPressSaveButton() {
    if (widget.formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                padding: const EdgeInsets.all(AppSizes.spacingWide),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.spacingMedium,
                    ),
                    const Loader(),
                    const SizedBox(
                      height: AppSizes.spacingWide,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          StringConstants.processWaitingMsg.localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.spacingMedium,
                    ),
                  ],
                ),
              ),
            );
          });

      widget.isEdit ?? false
          ? widget.addEditAddressBloc?.add(FetchEditAddressEvent(
              addressId: int.parse(widget.addressId ?? "0"),
              address: widget.street1Controller.text,
              city: widget.cityController.text,
              country: ((widget.isEdit ?? false) &&
                      widget.selectedCountry?.code == null)
                  ? widget.countryCode
                  : widget.selectedCountry?.code ?? widget.countryCode,
              // countryName: selectedCountry?.name ?? countryController.text,
              phone: widget.phoneController.text,
              postCode: widget.zipCodeController.text,
              state: widget.stateNameController.text.isNotEmpty
                  ? widget.stateNameController.text
                  : ((widget.stateCode ?? "").isNotEmpty
                      ? widget.stateCode!
                      : widget.selectedState?.code ??
                          widget.stateNameController.text),
              companyName: widget.companyController.text,
              firstName: widget.firstNameController.text,
              lastName: widget.lastNameController.text,
              vatId: widget.vatIdController.text,
              email: widget.emailController.text
            ))
          : widget.addEditAddressBloc?.add(FetchAddAddressEvent(
              address: widget.street1Controller.text,
              city: widget.cityController.text,
              country: widget.selectedCountry?.code ?? widget.countryCode,
              phone: widget.phoneController.text,
              postCode: widget.zipCodeController.text,
              state:
                  widget.selectedState?.code ?? widget.stateNameController.text,
              companyName: widget.companyController.text,
              firstName: widget.firstNameController.text,
              lastName: widget.lastNameController.text,
              isDefault: widget.isDefault,
              vatId: widget.vatIdController.text,
              email: widget.emailController.text
            ));
    }
  }
}
