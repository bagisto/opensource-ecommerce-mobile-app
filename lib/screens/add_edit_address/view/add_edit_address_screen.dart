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
import 'package:bagisto_app_demo/common_widget/common_error_msg.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/phone_number_validator.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/bloc/add_edi_address_bloc.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/address_country_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/fetch_add_address_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/events/fetch_edit_address_event.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/state/address_country_state.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/state/fetch_add_address_state.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/state/fetch_edit_address_state.dart';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_drop_down_field.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../models/address_model/country_model.dart';
import '../../locationSearch/view/location_screen.dart';

// ignore: must_be_immutable
class AddNewAddress extends StatefulWidget {
  bool isEdit = false;
  AddressData? addressModel;

  AddNewAddress(this.isEdit, this.addressModel, {Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress>
    with PhoneNumberValidator {
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
  final vatIdController = TextEditingController();
  CountriesData? countryData;
  List<Data>? countryList = [];
  States? selectedState;
  String? countryCode;
  String? stateCode;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AddEditAddressBloc? addEditAddressBloc;
  bool isDefault = false;

  @override
  void initState() {
    widget.isEdit
        ? firstNameController.text = widget.addressModel?.firstName ?? ""
        : "";
    widget.isEdit
        ? lastNameController.text = widget.addressModel?.lastName ?? ""
        : "";
    widget.isEdit
        ? companyController.text = widget.addressModel?.companyName ?? ""
        : "";
    widget.isEdit
        ? phoneController.text = widget.addressModel?.phone ?? ""
        : "";
    widget.isEdit
        ? street1Controller.text = widget.addressModel?.address1 ?? ''
        : "";
    widget.isEdit ? cityController.text = widget.addressModel?.city ?? "" : "";
    widget.isEdit
        ? stateNameController.text = widget.addressModel?.state ?? ""
        : "";
    widget.isEdit
        ? zipCodeController.text = widget.addressModel?.postcode ?? ""
        : "";
    widget.isEdit
        ? countryController.text = widget.addressModel?.country ?? ""
        : "";
    widget.isEdit
        ? vatIdController.text = widget.addressModel?.vatId ?? ""
        : "";
     widget.isEdit ? selectedCountry?.name = widget.addressModel?.countryName ?? "" : "";
    widget.isEdit ? countryCode = widget.addressModel?.country ?? "" : "";
    widget.isEdit ? stateCode = widget.addressModel?.state ?? "" : "";

    addEditAddressBloc = context.read<AddEditAddressBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:Directionality(
        textDirection: GlobalData.contentDirection(),
        child:  Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: widget.isEdit
                ? CommonWidgets.getHeadingText(
                    "EditAddressLabel".localized(), context)
                : CommonWidgets.getHeadingText(
                    "AddAddressLabel".localized(), context),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LocationScreen()))
                        .then((value) {
                      if (value is Map) {
                        street1Controller.text =
                            value['street1'] + " " + value['street3'] ?? "";
                        cityController.text = value['city'];
                        zipCodeController.text = value['zip'];
                        stateNameController.text = value['state'];
                        setState(() {
                          selectedCountry?.name = value['country'];
                          selectedState?.defaultName = value['state'];
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
              ),
            ],
          ),
          body:  _addEditAddressBloc(context),
          ),
      ),
    );
  }

  ///BLOC CONTAINER///
  _addEditAddressBloc(BuildContext context) {
    return BlocConsumer<AddEditAddressBloc, AddEditAddressBaseState>(
      listener: (BuildContext context, AddEditAddressBaseState state) {
        if (state is FetchEditAddressState) {
          if (state.status == AddEditStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.showNotification(
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.showNotification(
                state.updateAddressModel?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle));
            Navigator.pop(
                context,
                AddressData(
                    id: widget.addressModel!.id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    companyName: companyController.text,
                    vatId: vatIdController.text,
                    address1: [street1Controller.text].toString(),
                    country: selectedCountry?.code ?? "",
                    countryName:
                        selectedCountry?.name ?? countryController.text,
                    state: selectedState?.code ?? stateNameController.text,
                    city: cityController.text,
                    phone: phoneController.text,
                    postcode: zipCodeController.text,
                    isDefault: isDefault));
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(
                  context,
                  AddressData(
                      id: widget.addressModel!.id,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      companyName: companyController.text,
                      vatId: vatIdController.text,
                      address1: [street1Controller.text].toString(),
                      country: selectedCountry?.code ?? "",
                      countryName:
                          selectedCountry?.name ?? countryController.text,
                      state: selectedState?.code ?? stateNameController.text,
                      city: cityController.text,
                      phone: phoneController.text,
                      postcode: zipCodeController.text,
                      isDefault: isDefault));
            });
          }
        } else if (state is FetchAddAddressState) {
          if (state.status == AddEditStatus.fail) {
            Navigator.of(context).pop();
            ShowMessage.showNotification(
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.showNotification(
                state.baseModel!.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle));
            if (selectedCountry?.code != null) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(
                    context,
                    AddressData(
                      companyName: companyController.text,
                      address1: [street1Controller.text].toString(),
                      city: cityController.text,
                      state: selectedState?.code ?? "",
                      country: selectedCountry?.code ?? "",
                      lastName: lastNameController.text,
                      postcode: zipCodeController.text,
                      phone: phoneController.text,
                      isDefault: isDefault,
                      vatId: vatIdController.text,
                      firstName: firstNameController.text,
                      countryName:
                          selectedCountry?.name ?? countryController.text,
                    ));
              });
              Navigator.pop(
                  context,
                  AddressData(
                    companyName: companyController.text,
                    address1: [street1Controller.text].toString(),
                    city: cityController.text,
                    state: selectedState?.code ?? "",
                    country: selectedCountry?.code ?? "",
                    lastName: lastNameController.text,
                    postcode: zipCodeController.text,
                    phone: phoneController.text,
                    isDefault: isDefault,
                    vatId: vatIdController.text,
                    firstName: firstNameController.text,
                    countryName:
                        selectedCountry?.name ?? countryController.text,
                  ));
            }
          }
        }
      },
      builder: (BuildContext context, AddEditAddressBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///buildUI Ui METHODS///
  Widget buildUI(BuildContext context, AddEditAddressBaseState state) {
    if (state is AddressCountryState) {
      if (state.status == AddEditStatus.success) {
        countryData = state.countryData;
        countryList = state.countryData!.data;
        if (selectedCountry == null) {
          if ((selectedCountry?.states?.length ?? 0) > 0) {
            selectedState = selectedCountry?.states?.first;
          }
        }
          selectedCountry = countryData?.data?.first;
      }
      if (state.status == AddEditStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    if (state is InitialAddEditAddressState) {
      if ((countryList?.length ?? 0) == 0) {
        addEditAddressBloc?.add(AddressCountryEvent());
      }
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchAddAddressState) {
      if (state.status == AddEditStatus.success) {}
      if (state.status == AddEditStatus.fail) {}
    }
    if (state is FetchEditAddressState) {
      if (state.status == AddEditStatus.success) {}
      if (state.status == AddEditStatus.fail) {}
    }
    return _getAddressForm();
  }

  ///address form
  _getAddressForm() {
    return RefreshIndicator(
      color: MobikulTheme.accentColor,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          _getAddressForm();
        });
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.normalPadding,
              horizontal: AppSizes.mediumPadding),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
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
                    }),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    CommonWidgets().getTextField(
                      context,
                      lastNameController,
                      "LastNameLabel".localized(),
                      "LastNameLabel".localized(),
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
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
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
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    CommonWidgets().getTextField(
                      context,
                      phoneController,
                      "ContactUsPhoneLabel".localized(),
                      "ContactUsPhoneHint".localized(),
                      "PleaseFillLabel".localized() +
                          "ContactUsPhoneLabel".localized(),
                      keyboardType: TextInputType.phone,
                      validator: (phone) {
                        if (phone!.isEmpty) {
                          return "PleaseFillLabel".localized() +
                              "ContactUsPhoneLabel".localized();
                        } else if (!isValidPhone(phone)) {
                          return "PhoneWarning".localized();
                        }
                        return null;
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
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
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    Text("vatIdNote".localized()),
                    CommonWidgets().getTextFieldHeight(6),
                    CommonWidgets().getTextField(
                      context,
                      vatIdController,
                      "VatIdLabel".localized(),
                      "VatIdHint".localized(),
                      "PleaseFillLabel".localized() + "VatIdLabel".localized(),
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
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
                      },
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    CommonDropDownField(
                      value: selectedCountry?.name,
                      itemList: getCountryStrings(),
                      hintText: "CountryHint".localized(),
                      labelText: "CountryLabel".localized(),
                      key: const Key('country'),
                      callBack: dropdownUpdate,
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    (selectedCountry != null &&
                            (selectedCountry!.states?.length ?? 0) > 0)
                        ? CommonDropDownField(
                            value: selectedState?.defaultName,
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
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: isDefault,
                            activeColor: MobikulTheme.accentColor,
                            onChanged: (bool? value) {
                              setState(() {
                                isDefault = value ?? false;
                              });
                            }),
                        Text('DefaultAddress'.localized()),
                      ],
                    ),
                    CommonWidgets().getTextFieldHeight(AppSizes.widgetHeight),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          side: BorderSide(width: 2)),
                      elevation: 0.0,
                      height: 48,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.background,
                      textColor: Colors.white,
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
            ],
          ),
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
          if (!country.contains(selectedCountry?.name)) {
            country.add(item.name ?? '');
          }
        }
      }
    }
    return country;
  }

  void dropdownUpdate(String item, Key? key) {
    if (key == const Key('country')) {
      var country = countryList?.firstWhereOrNull((e) => e.name == item);
      selectedCountry = country;
      if ((country?.states?.length ?? 0) > 0) {
        selectedState = country?.states?.first;
      }
    } else if (key == const Key('States')) {
      if (selectedCountry != null) {
        var state = selectedCountry?.states
            ?.firstWhereOrNull((element) => element.defaultName == item);
        if (state != null) {
          selectedState = state;
        }
      }
    }
    setState(() {});
  }

  ///action performed on press save button
  _onPressSaveButton() {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                padding: const EdgeInsets.all(AppSizes.widgetSidePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: AppSizes.normalHeight,
                    ),
                    CircularProgressIndicatorClass.circularProgressIndicator(
                        context),
                    const SizedBox(
                      height: AppSizes.widgetHeight,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: Text(
                          "PleaseWaitProcessingRequest".localized(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.normalHeight,
                    ),
                  ],
                ),
              ),
            );
          });

      widget.isEdit
          ? addEditAddressBloc?.add(FetchEditAddressEvent(
              addressId: int.parse(widget.addressModel?.id ?? ""),
              address: street1Controller.text,
              city: cityController.text,
              country: (widget.isEdit && selectedCountry?.code == null)
                  ? countryCode
                  : selectedCountry?.code ?? "",
              phone: phoneController.text,
              postCode: zipCodeController.text,
              state: (widget.isEdit && selectedState?.countryCode == null)
                  ? stateCode
                  : selectedState?.code ?? stateNameController.text,
              companyName: companyController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              vatId: vatIdController.text,
            ))
          : addEditAddressBloc?.add(FetchAddAddressEvent(
              address: street1Controller.text,
              city: cityController.text,
              country: selectedCountry?.code ?? "",
              phone: phoneController.text,
              postCode: zipCodeController.text,
              state: selectedState?.code ?? stateNameController.text,
              companyName: companyController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              vatId: vatIdController.text,
            ));
    }
  }
}
