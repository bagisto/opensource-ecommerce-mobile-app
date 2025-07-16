/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/account/utils/index.dart';

import '../../sign_up/widgets/news_letter_checkbox.dart';

class ProfileDetailView extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final GlobalKey<FormState> formKey;
  final bool? subsNewsLetter;
  final Function(bool) onDelete;
  const ProfileDetailView(
      {super.key, required this.formKey, this.subsNewsLetter, this.onChanged,
      required this.onDelete});

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView>
    with EmailValidator, PhoneNumberValidator {
  bool autoValidate = false;
  late bool isNewsLetterSelected = widget.subsNewsLetter ?? false;

  @override
  void initState() {
    genderValues = [
      StringConstants.male.localized(),
      StringConstants.female.localized(),
      StringConstants.other.localized(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spacingSmall,
                        horizontal: AppSizes.spacingMedium),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSizes.spacingWide),
                        ProfileImageView(
                          callback: (XFile? avatar, {bool isDelete = false}) {
                            imageFile = avatar;
                            widget.onDelete(isDelete);
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingWide),
                        CommonWidgets().getTextField(
                          context,
                          firstNameController,
                          StringConstants.firstNameHint.localized(),
                          label: StringConstants.firstNameLabel.localized(),
                          isRequired: true,
                          validator: (firstName) {
                            if (firstName!.isEmpty) {
                              return StringConstants.pleaseFillLabel
                                      .localized() +
                                  StringConstants.firstNameLabel.localized();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingWide),
                        CommonWidgets().getTextField(
                          context,
                          lastNameController,
                          StringConstants.lastNameHint.localized(),
                          label: StringConstants.lastNameLabel.localized(),
                          isRequired: true,
                          validator: (lastName) {
                            if (lastName!.isEmpty) {
                              return StringConstants.pleaseFillLabel
                                      .localized() +
                                  StringConstants.lastNameLabel.localized();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingWide),
                        DropdownButtonFormField(
                            iconEnabledColor: Colors.grey[600],
                            style: Theme.of(context).textTheme.bodyMedium,
                            items: genderValues!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                currentGenderValue =
                                    genderValues!.indexOf(value!);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return StringConstants.genderRequired
                                    .localized();
                              } else {}
                              return null;
                            },
                            value: genderValues?[currentGenderValue],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  AppSizes.spacingMedium,
                                  AppSizes.spacingLarge,
                                  AppSizes.spacingMedium,
                                  AppSizes.spacingLarge),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSizes.spacingSmall)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              fillColor: Colors.black,
                              labelText: StringConstants.genderLbl.localized(),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.spacingSmall),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade500)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.spacingSmall),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade500)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.spacingSmall),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                            )),
                        const SizedBox(height: AppSizes.spacingWide),
                        CommonDatePicker(
                          controller: dobController,
                          hintText: StringConstants.dobHint.localized(),
                          labelText: StringConstants.date.localized(),
                          isRequired: true,
                        ),
                        const SizedBox(height: AppSizes.spacingWide),
                        CommonWidgets().getTextField(context, phoneController,
                            StringConstants.contactUsPhoneHint.localized(),
                            label:
                                StringConstants.contactUsPhoneLabel.localized(),
                            isRequired: true, validator: (phone) {
                          if (phone!.isEmpty) {
                            return StringConstants.pleaseFillLabel.localized() +
                                StringConstants.contactUsPhoneLabel.localized();
                          } else if (!isValidPhone(phone)) {
                            return StringConstants.enterPhone.localized();
                          }
                          return null;
                        }, keyboardType: TextInputType.number),
                        const SizedBox(height: AppSizes.spacingWide),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingWide,
                ),
                const ChangeEmailAndPassword(),
                //const SizedBox(height:AppSizes.spacingWide),
                NewsLetterCheckbox((value) {
                  setState(() {
                    isNewsLetterSelected = value;
                  });
                  widget.onChanged!(value); // Call the callback
                }, StringConstants.subscribeToNewsletter.localized(), false,
                    widget.subsNewsLetter),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
