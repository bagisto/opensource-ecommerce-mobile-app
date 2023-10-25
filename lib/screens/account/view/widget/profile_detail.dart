import 'package:bagisto_app_demo/screens/account/view/widget/account_index.dart';

import 'profile_image_view.dart';
import '../account_screen.dart';
import 'change_email_pass_view.dart';

class ProfileDetailView extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ProfileDetailView({Key? key, required this.formKey}) : super(key: key);

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView>   with EmailValidator, PhoneNumberValidator {
  bool autoValidate = false;
  @override
  void initState() {
    genderValues = [
      "Male".localized(),
      "Female".localized(),
      "Other".localized(),
    ];    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          autovalidateMode: autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.normalPadding,
                          horizontal: AppSizes.mediumPadding),
                      // color: Colors.white,
                      child: Column(
                        children: [
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          ProfileImageView(callback: (avatar){
                            base64string=avatar;
                          },),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          CommonWidgets().getTextField(
                            context,
                            firstNameController,
                            "FirstNameLabel".localized(),
                            "FirstNameHint".localized(),
                            "PleaseFillLabel".localized() +
                                "FirstNameLabel".localized(),
                            validator: (firstName) {
                              if (firstName!.isEmpty) {
                                return "PleaseFillLabel".localized() +
                                    "FirstNameLabel".localized();
                              }
                              return null;
                            },
                          ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          CommonWidgets().getTextField(
                            context,
                            lastNameController,
                            "LastNameLabel".localized(),
                            "LastNameHint".localized(),
                            "PleaseFillLabel".localized() +
                                "LastNameLabel".localized(),
                            validator: (lastName) {
                              if (lastName!.isEmpty) {
                                return "PleaseFillLabel".localized() +
                                    "LastNameLabel".localized();
                              }
                              return null;
                            },
                          ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor:
                              Theme.of(context).colorScheme.onBackground,
                            ),
                            child: DropdownButtonFormField(
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
                                    return "GenderRequired".localized();
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
                                  labelText: "GenderLabel".localized(),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade500)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      borderSide:
                                      BorderSide(color: Colors.red.shade500)),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                                  ),
                                )),
                          ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          CommonDatePicker(
                            controller: dobController,
                            hintText: "DobHint".localized(),
                            labelText: "date".localized(),
                            isRequired: true,
                          ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                          CommonWidgets().getTextField(
                              context,
                              phoneController,
                              "ContactUsPhoneLabel".localized(),
                              "ContactUsPhoneHint".localized(),
                              "PleaseFillLabel".localized() +
                                  "ContactUsPhoneLabel".localized(),
                              validator: (phone) {
                                if (phone!.isEmpty) {
                                  return "PleaseFillLabel".localized() +
                                      "ContactUsPhoneLabel".localized();
                                } else if (!isValidPhone(phone)) {
                                  return "EnterPhone".localized();
                                }
                                return null;
                              }, keyboardType: TextInputType.number
                          ),
                          CommonWidgets()
                              .getTextFieldHeight(AppSizes.widgetHeight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ChangeEmailAndPassword(),
                  CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
