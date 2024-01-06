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
import 'package:bagisto_app_demo/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_global_data.dart';
import '../../../../utils/input_field_validators.dart';
import '../../../../utils/mobikul_theme.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/common_drop_down_field.dart';
import '../../../../widgets/common_error_msg.dart';
import '../../../../widgets/common_widgets.dart';
import '../../../../widgets/show_message.dart';
import '../../../address_list/data_model/address_model.dart';
import '../../../address_list/data_model/country_model.dart';
import '../bloc/guest_address_base_event.dart';
import '../bloc/guest_address_bloc.dart';
import '../bloc/guest_address_country_state.dart';

// ignore: must_be_immutable
class GuestAddAddressForm extends StatefulWidget {
  Function(
      String? billingCompanyName,
      String? billingFirstName,
      String? billingLastName,
      String? billingAddress,
      String? billingAddress2,
      String? billingCountry,
      String? billingState,
      String? billingCity,
      String? billingPostCode,
      String? billingPhone,
      String? billingEmail,
      String? shippingEmail,
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone)? callBack;

  GuestAddAddressForm({this.callBack, Key? key}) : super(key: key);

  @override
  State<GuestAddAddressForm> createState() => _GuestAddAddressFormState();
}

class _GuestAddAddressFormState extends State<GuestAddAddressForm>
    with PhoneNumberValidator, EmailValidator {
  AddressData? billingAddress;
  AddressData? shippingAddress;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool showAlert = false;
  int exceptionCode = 200;
  String exceptionMessage = "";
  final _formKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  Data? selectedCountry;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyController = TextEditingController();
  final street1Controller = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  CountriesData? countryData;
  List<Data>? countryList = [];
  String? countryName;
  String? countryCode;
  String? state;
  States? selectedState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
          body: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: _guestAddressBloc(context),
      )),
    );
  }

  ///BLOC CONTAINER///
  _guestAddressBloc(BuildContext context) {
    return BlocConsumer<GuestAddressBloc, GuestAddressBaseState>(
      listener: (BuildContext context, GuestAddressBaseState state) {},
      builder: (BuildContext context, GuestAddressBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///buildUI UI METHODS///
  Widget buildUI(BuildContext context, GuestAddressBaseState state) {
    if (state is GuestAddressCountryState) {
      if (state.status == GuestStatus.success) {
        countryData = state.countryData;
        countryList = state.countryData!.data;
        if (selectedCountry == null) {
          selectedCountry = countryData?.data?.first;
          if ((selectedCountry?.states?.length ?? 0) > 0) {
            selectedState = selectedCountry?.states?.first;
          }
        }
        return _getAddressForm();
      }
      if (state.status == GuestStatus.fail) {
        return ErrorMessage.errorMsg(
            StringConstants.somethingWrong.localized());
      }
    }
    if (state is GuestAddressInitialState) {
      GuestAddressBloc guestAddressBloc = context.read<GuestAddressBloc>();
      guestAddressBloc.add(GuestAddressCountryEvent());
      return _getAddressForm();
    }
    return Container();
  }

  _getAddressForm() {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          _getAddressForm();
        });
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(context, firstNameController,
                        StringConstants.firstNameHint.localized(),
                        label: StringConstants.firstNameLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() +
                            StringConstants.firstNameLabel.localized(),
                        isRequired: true, validator: (name) {
                      if ((name ?? "").isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.firstNameLabel.localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.firstName),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                        context,
                        lastNameController,
                        StringConstants.lastNameHint.localized(),
                        label: StringConstants.lastNameLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() +
                            StringConstants.lastNameLabel.localized(),
                        isRequired: true, validator: (lastName) {
                      if ((lastName ?? "").isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.lastNameLabel.localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.lastName),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                      context,
                      emailController,
                      StringConstants.signInEmailHint.localized(),
                      label: StringConstants.signInEmailLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() +
                            StringConstants.signInEmailLabel.localized(),
                      isRequired: true,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return StringConstants.pleaseFillLabel.localized() +
                              StringConstants.signInEmailLabel.localized();
                        } else if (!isValidEmail(email)) {
                          return StringConstants.signInEmailLabel.localized();
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                        context,
                        companyController,
                        StringConstants.companyNameHint.localized(),
                        label: StringConstants.companyNameLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() +
                            StringConstants.companyNameLabel.localized(),
                        isRequired: true, validator: (companyName) {
                      if (companyName!.isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.companyNameLabel.localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.companyName),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                        context,
                        phoneController,
                        StringConstants.contactUsPhoneHint.localized(),
                        label: StringConstants.contactUsPhoneLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() +
                            StringConstants.contactUsPhoneLabel.localized(),
                        isRequired: true,
                        keyboardType: TextInputType.phone, validator: (phone) {
                      if ((phone ?? "").isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.contactUsPhoneLabel.localized();
                      } else if (!isValidPhone(phone)) {
                        return StringConstants.phoneWarning.localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.phone),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                      context,
                      street1Controller,
                      StringConstants.streetHint.localized(),
                      label: StringConstants.streetLabel.localized(),
                      isRequired: true,
                      validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.streetLabel.localized(),
                      validator: (street1) {
                        if ((street1 ?? "").isEmpty) {
                          return StringConstants.pleaseFillLabel.localized() +
                              StringConstants.streetLabel.localized();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                        context,
                        zipCodeController,
                        StringConstants.zipHint.localized(),
                        label: StringConstants.zipLabel.localized(),
                        validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.zipLabel.localized(),
                        keyboardType: TextInputType.number,
                        isRequired: true, validator: (zipCode) {
                      if (zipCode!.isEmpty) {
                        return StringConstants.pleaseFillLabel.localized() +
                            StringConstants.zipLabel.localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.address1.toString()),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonDropDownField(
                      value: countryName,
                      itemList: getCountryStrings(),
                      hintText: StringConstants.countryHint.localized(),
                      labelText: StringConstants.countryLabel.localized(),
                      key: const Key('country'),
                      callBack: dropdownUpdate,
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    (selectedCountry != null &&
                            (selectedCountry!.states?.length ?? 0) > 0)
                        ? CommonDropDownField(
                            value: selectedState?.defaultName ?? '',
                            itemList: selectedCountry?.states
                                    ?.map((e) => e.defaultName ?? '')
                                    .toList() ??
                                [],
                            hintText: StringConstants.stateHint.localized(),
                            labelText: StringConstants.stateLabel.localized(),
                            key: const Key('States'),
                            callBack: dropdownUpdate,
                          )
                        : CommonWidgets().getTextField(
                            context,
                            stateNameController,
                            StringConstants.stateHint.localized(),
                            label: StringConstants.stateLabel.localized(),
                            validLabel: StringConstants.pleaseFillLabel.localized() +
                                StringConstants.stateLabel.localized(),
                            isRequired: true,
                            validator: (cityName) {
                              if ((cityName ?? "").isEmpty) {
                                return StringConstants.pleaseFillLabel.localized() +
                                    StringConstants.stateLabel.localized();
                              }
                              return null;
                            },
                          ),
                    const SizedBox(height: AppSizes.spacingWide),
                    CommonWidgets().getTextField(
                      context,
                      cityController,
                      StringConstants.cityHint.localized(),
                      label: StringConstants.cityLabel.localized(),
                      validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.cityLabel.localized(),
                      isRequired: true,
                      validator: (cityName) {
                        if ((cityName ?? "").isEmpty) {
                          return StringConstants.pleaseFillLabel.localized() +
                              StringConstants.cityLabel.localized();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingWide),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 2)),
                      elevation: 0.0,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.onBackground,
                      textColor: MobikulTheme.primaryColor,
                      onPressed: () {
                        _onPressSaveButton();
                      },
                      child: Text(
                        StringConstants.saveAddress.localized().toUpperCase(),
                        style:
                            const TextStyle(fontSize: AppSizes.spacingLarge),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getCountryStrings() {
    List<String> country = [];
    if (countryList != null) {
      for (Data item in countryList ?? []) {
        if (item.name == null) {
          country.add("Select Country...");
        } else {
          country.add(item.name ?? '');
        }
      }
    }
    return country;
  }

  void dropdownUpdate(String item, Key? key) {
    if (key == const Key('country')) {
      var country = countryList?.firstWhereOrNull((e) => e.name == item);
      selectedCountry = country;
      countryCode = selectedCountry?.code;
      countryName = selectedCountry?.name ?? '';
      if ((country?.states?.length ?? 0) > 0) {
        selectedState = country?.states?.first;
      }
      countryController.text = selectedCountry?.name ?? "";
    } else if (key == const Key('States')) {
      if (selectedCountry != null) {
        var state = selectedCountry?.states
            ?.firstWhereOrNull((element) => element.defaultName == item);
        if (state != null) {
          selectedState = state;
        }
      }
      stateNameController.text = selectedState?.code ?? "";
    }
    setState(() {});
  }

  _saveAddress() {
    var address1 = [street1Controller.text];
    Map<String, dynamic> newAddress = <String, dynamic>{}; //keys as String
    address1.asMap().forEach((key, value) {
      newAddress[key.toString()] = value;
    });
    widget.callBack!(
      companyController.text,
      firstNameController.text,
      lastNameController.text,
      street1Controller.text,
      emailController.text,
      countryCode,
      selectedState?.code ?? stateNameController.text,
      cityController.text,
      zipCodeController.text,
      phoneController.text,
      emailController.text,
      emailController.text,
      companyController.text,
      firstNameController.text,
      lastNameController.text,
      street1Controller.text,
      emailController.text,
      countryCode,
      selectedState?.code ?? stateNameController.text,
      cityController.text,
      zipCodeController.text,
      phoneController.text,
    );
  }

  _onPressSaveButton() {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                padding: const EdgeInsets.all(AppSizes.spacingWide),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.spacingNormal,
                    ),
                    const Loader(),
                    const SizedBox(height: AppSizes.spacingWide),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          StringConstants.processWaitingMsg.localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingNormal),
                  ],
                ),
              ),
            );
          });
      _saveAddress();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pop(context, true);
        ShowMessage.showNotification(
            StringConstants.success.localized(),
            StringConstants.addressAdded.localized(),
            const Color.fromRGBO(140, 194, 74, 5),
            const Icon(Icons.check_circle_outline));
      });
    }
  }
}
