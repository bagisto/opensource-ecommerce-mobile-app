/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, deprecated_member_use
import 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/email_validator.dart';
import 'package:bagisto_app_demo/helper/phone_number_validator.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/bloc/guest_address_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/event/guest_address_country_event.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_address_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_address_country_state.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/state/guest_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../../common_widget/show_message.dart';
import '../../../../configuration/app_global_data.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../common_widget/common_drop_down_field.dart';
import '../../../../common_widget/common_error_msg.dart';
import '../../../../models/address_model/country_model.dart';
import '../../../locationSearch/view/location_screen.dart';

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
  String? state;

  States? selectedState;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: Directionality(
          textDirection: GlobalData.contentDirection(),
          child: _guestAddressBloc( context),
        )
      ),
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
        return ErrorMessage.errorMsg("SomethingWrong".localized());
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
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        firstNameController,
                        "FirstNameLabel".localized(),
                        "FirstNameHint".localized(),
                        "PleaseFillLabel".localized() +
                            "FirstNameLabel".localized(), validator: (name) {
                      if (name!.isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "FirstNameLabel".localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.firstName),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        lastNameController,
                        "LastNameLabel".localized(),
                        "LastNameLabel".localized(),
                        "PleaseFillLabel".localized() +
                            "LastNameLabel".localized(), validator: (lastName) {
                      if (lastName!.isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "LastNameLabel".localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.lastName),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                      context,
                      emailController,
                      "SignInEmailLabel".localized(),
                      "SignInEmailHint".localized(),
                      "PleaseFillLabel".localized() +
                          "SignInEmailLabel".localized(),
                      validator: (email) {
                        if (email!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "SignInEmailLabel".localized();
                        } else if (!isValidEmail(email)) {
                          return "ValidEmailLabel".localized();
                        }
                        return null;
                      },
                      validLabel: "ValidEmailLabel".localized(),
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        companyController,
                        "CompanyNameLabel".localized(),
                        "CompanyNameHint".localized(),
                        "PleaseFillLabel".localized() +
                            "CompanyNameLabel".localized(),
                        validator: (companyName) {
                      if (companyName!.isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "CompanyNameLabel".localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.companyName),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        phoneController,
                        "ContactUsPhoneLabel".localized(),
                        "ContactUsPhoneHint".localized(),
                        "PleaseFillLabel".localized() +
                            "ContactUsPhoneLabel".localized(),
                        keyboardType: TextInputType.phone, validator: (phone) {
                      if (phone!.isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "ContactUsPhoneLabel".localized();
                      } else if (!isValidPhone(phone)) {
                        return "PhoneWarning".localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.phone),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                      context,
                      street1Controller,
                      "StreetLabel".localized(),
                      "StreetHint".localized(),
                      "PleaseFillLabel".localized() + "StreetLabel".localized(),
                      validator: (street1) {
                        if (street1!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "StreetLabel".localized();
                        }
                        return null;
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
                    CommonWidgets().getTextField(
                        context,
                        zipCodeController,
                        "ZipLabel".localized(),
                        "ZipHint".localized(),
                        "PleaseFillLabel".localized() + "ZipLabel".localized(),
                        keyboardType: TextInputType.number,
                        validator: (zipCode) {
                      if (zipCode!.isEmpty) {
                        return "PleaseFillLabel".localized() +
                            "ZipLabel".localized();
                      }
                      return null;
                    }, emailValue: billingAddress?.address1.toString()),
                    CommonWidgets().getTextFieldHeight(20.0),
                    /*   widget.addressModel?.country == null
                        ? countryData?.data != null*/
                    CommonDropDownField(
                      value: countryName,
                      itemList: getCountryStrings(),
                      hintText: "CountryHint".localized(),
                      labelText: "CountryLabel".localized(),
                      key: const Key('country'),
                      callBack: dropdownUpdate,
                    ),
                    CommonWidgets().getTextFieldHeight(20.0),
                    (selectedCountry != null &&
                            (selectedCountry!.states?.length ?? 0) > 0)
                        ? CommonDropDownField(
                            value: selectedState?.defaultName ?? '',
                            itemList: selectedCountry?.states
                                    ?.map((e) => e.defaultName ?? '')
                                    .toList() ??
                                [],
                            hintText: "StateHint".localized(),
                            labelText: "StateLabel".localized(),
                            key: const Key('States'),
                            callBack: dropdownUpdate,
                          )
                        : CommonWidgets().getTextField(
                            context,
                            stateNameController,
                            "StateLabel".localized(),
                            "StateHint".localized(),
                            "PleaseFillLabel".localized() +
                                "StateLabel".localized(),
                            validator: (cityName) {
                              if (cityName!.isEmpty) {
                                return "PleaseFillLabel".localized() +
                                    "StateLabel".localized();
                              }
                              return null;
                            },
                          ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    CommonWidgets().getTextField(
                      context,
                      cityController,
                      "CityLabel".localized(),
                      "CityHint".localized(),
                      "PleaseFillLabel".localized() + "CityLabel".localized(),
                      validator: (cityName) {
                        if (cityName!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "CityLabel".localized();
                        }
                        return null;
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 2)),
                      elevation: 0.0,
                      height: AppSizes.buttonHeight,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.background,
                      textColor: MobikulTheme.primaryColor,
                      onPressed: () {
                        _onPressSaveButton();
                      },
                      child: Text(
                        "SaveAddress".localized().toUpperCase(),
                        style:
                            const TextStyle(fontSize: AppSizes.normalFontSize),
                      ),
                    ),
                    CommonWidgets().getTextFieldHeight(NormalHeight)
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LocationScreen()))
                      .then((value) {
                    if (value is Map) {
                      street1Controller.text = value['street1'];
                      cityController.text = value['city'];
                      zipCodeController.text = value['zip'];
                      stateNameController.text = value['state'];
                      setState(() {
                        countryName = value['country'];
                        state = value['state'];
                      });
                    }
                  });
                },
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100))),
                  child: Icon(
                    Icons.my_location,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ),
            )
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
          country.add(
            "Select Country...",
          );
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
      countryName,
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
      countryName,
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
                padding: const EdgeInsets.all(AppSizes.widgetHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.normalHeight,
                    ),
                    CircularProgressIndicatorClass.circularProgressIndicator(
                        context),
                    const SizedBox(height: AppSizes.widgetHeight),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          "PleaseWaitProcessingRequest".localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.normalPadding),
                  ],
                ),
              ),
            );
          });

      _saveAddress();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pop(context, true);
        ShowMessage.showNotification(
            "Address added successfully",
            "",
            const Color.fromRGBO(140, 194, 74, 5),
            const Icon(Icons.check_circle_outline));
      });
    }
  }
}
