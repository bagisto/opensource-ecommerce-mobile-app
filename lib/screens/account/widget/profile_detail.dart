import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/widgets/common_date_picker.dart';
import '../../../../utils/index.dart';
import 'profile_image_view.dart';
import 'change_email_pass_view.dart';

//ignore: must_be_immutable
class ProfileDetailView extends StatefulWidget {
  GlobalKey<FormState> formKey;
  ProfileDetailView({Key? key, required this.formKey}) : super(key: key);

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView>
    with EmailValidator, PhoneNumberValidator {
  bool autoValidate = false;

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
                        const SizedBox(height:AppSizes.spacingWide),
                        ProfileImageView(
                          callback: (avatar) {
                            base64string = avatar;
                          },
                        ),
                        const SizedBox(height:AppSizes.spacingWide),
                        CommonWidgets().getTextField(
                          context,
                          firstNameController,
                          StringConstants.firstNameHint.localized(),
                          label:StringConstants.firstNameLabel.localized(),
                          isRequired: true,
                          validator: (firstName) {
                            if (firstName!.isEmpty) {
                              return StringConstants.pleaseFillLabel.localized() +
                                  StringConstants.firstNameLabel.localized();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height:AppSizes.spacingWide),
                        CommonWidgets().getTextField(
                          context,
                          lastNameController,
                          StringConstants.lastNameHint.localized(),
                          label: StringConstants.lastNameLabel.localized(),
                          isRequired: true,
                          validator: (lastName) {
                            if (lastName!.isEmpty) {
                              return StringConstants.pleaseFillLabel.localized() +
                                  StringConstants.lastNameLabel.localized();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height:AppSizes.spacingWide),
                        DropdownButtonFormField(
                            iconEnabledColor: Colors.grey[600],
                            style: Theme.of(context).textTheme.bodyMedium,
                            items: genderValues!
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
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
                                return StringConstants.genderRequired.localized();
                              } else {}
                              return null;
                            },
                            value: genderValues?[currentGenderValue],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  12.0, 16.0, 12.0, 16.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              fillColor: Colors.black,
                              labelText: StringConstants.genderLbl.localized(),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade500)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade500)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                            )),
                        const SizedBox(height:AppSizes.spacingWide),
                        CommonDatePicker(
                          controller: dobController,
                          hintText: StringConstants.dobHint.localized(),
                          labelText: StringConstants.date.localized(),
                          isRequired: true,
                        ),
                        const SizedBox(height:AppSizes.spacingWide),
                        CommonWidgets().getTextField(
                            context,
                            phoneController,
                            StringConstants.contactUsPhoneHint.localized(),
                            label: StringConstants.contactUsPhoneLabel.localized(),
                            isRequired: true, validator: (phone) {
                          if (phone!.isEmpty) {
                            return StringConstants.pleaseFillLabel.localized() +
                                StringConstants.contactUsPhoneLabel.localized();
                          } else if (!isValidPhone(phone)) {
                            return StringConstants.enterPhone.localized();
                          }
                          return null;
                        }, keyboardType: TextInputType.number),
                        const SizedBox(height:AppSizes.spacingWide),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ChangeEmailAndPassword(),
                const SizedBox(height:AppSizes.spacingWide),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
