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
class GetAddressForm extends StatelessWidget  with PhoneNumberValidator, EmailValidator{
  final bool? isCheckout;
  final TextEditingController firstNameController ;
  final TextEditingController lastNameController ;
  final TextEditingController companyController;
  final TextEditingController street1Controller ;
  final TextEditingController zipCodeController ;
  final TextEditingController phoneController;
  final TextEditingController vatIdController;
  final TextEditingController emailController;

   GetAddressForm({Key? key,required this.firstNameController, required this.lastNameController,
     required this.companyController, required this.street1Controller, required this.zipCodeController,
     required this.phoneController, required this.vatIdController, this.isCheckout,
     required this.emailController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
              context,
              firstNameController,
              StringConstants.firstNameHint.localized(),
              label: StringConstants.firstNameLabel.localized(),
              isRequired: true,
              validLabel: StringConstants.pleaseFillLabel.localized() +
                  StringConstants.firstNameHint.localized(), validator: (name) {
            if ((name ??"").isEmpty) {
              return StringConstants.pleaseFillLabel.localized() +
                  StringConstants.firstNameLabel.localized();
            }
            return null;
          }),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            lastNameController,
            StringConstants.lastNameLabel.localized(),
            label: StringConstants.lastNameLabel.localized(),
            isRequired: true,
            validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.lastNameLabel.localized(),
            validator: (lastName) {
              if (lastName!.isEmpty) {
                return StringConstants.pleaseFillLabel.localized() +
                    StringConstants.lastNameLabel.localized();
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            emailController,
            StringConstants.signInEmailHint.localized(),
            label: StringConstants.signInEmailLabel.localized(),
            isRequired: true,
            validator: (email) {
              if ((email ?? "").isEmpty) {
                return StringConstants.pleaseFillLabel.localized() +
                    StringConstants.signInWithEmail.localized();
              } else if (!isValidEmail(email)) {
                return StringConstants.validEmailLabel.localized();
              }
              return null;
            },
            validLabel: StringConstants.validEmailLabel.localized(),
          ),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            companyController,
            StringConstants.companyNameHint.localized(),
            label: StringConstants.companyNameLabel.localized(),
            validLabel: StringConstants.pleaseFillLabel.localized() +
                StringConstants.companyNameLabel.localized(),
            validator: (companyName) {
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            phoneController,
            StringConstants.contactUsPhoneHint.localized(),
            label: StringConstants.contactUsPhoneLabel.localized(),
            isRequired: true,
            validLabel: StringConstants.pleaseFillLabel.localized() +
                StringConstants.contactUsPhoneLabel.localized(),
            keyboardType: TextInputType.phone,
            validator: (phone) {
              if (phone!.isEmpty) {
                return StringConstants.pleaseFillLabel.localized() +
                    StringConstants.contactUsPhoneLabel.localized();
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            street1Controller,
            StringConstants.streetHint.localized(),
            label: StringConstants.streetLabel.localized(),
            isRequired: true,
            validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.streetLabel.localized(),
            validator: (street1) {
              if (street1!.isEmpty) {
                return StringConstants.pleaseFillLabel.localized() +
                    StringConstants.streetLabel.localized();
              }
              return null;
            },
          ),
          if(isCheckout==false)const SizedBox(height: AppSizes.spacingWide),
          if(isCheckout==false)Text(StringConstants.vatIdNote.localized()),
          if(isCheckout==false)const SizedBox(height: 6),
          if(isCheckout==false)CommonWidgets().getTextField(
            context,
            vatIdController,
            StringConstants.vatIdHint.localized(),
            label:   StringConstants.vatIdLabel.localized(),
            validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.vatIdLabel.localized(),
          ),
          const SizedBox(height: AppSizes.spacingWide),
          CommonWidgets().getTextField(
            context,
            zipCodeController,
            StringConstants.zipHint.localized(),
            label: StringConstants.zipLabel.localized(),
            isRequired: true,
            validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.zipLabel.localized(),
            keyboardType: TextInputType.number,
            validator: (zipCode) {
              if (zipCode!.isEmpty) {
                return StringConstants.pleaseFillLabel.localized() +
                    StringConstants.zipLabel.localized();
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spacingWide),
        ],
      );
  }
}
