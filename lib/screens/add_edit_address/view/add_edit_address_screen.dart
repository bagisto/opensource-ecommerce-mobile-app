// ignore_for_file: unnecessary_statements

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
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/input_field_validators.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_drop_down_field.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/show_message.dart';
import '../../address_list/data_model/address_model.dart';
import '../../address_list/data_model/country_model.dart';
import '../bloc/add_edit_address_bloc.dart';
import '../bloc/address_country_event.dart';
import '../bloc/fetch_add_address_state.dart';

// ignore: must_be_immutable
class AddNewAddress extends StatefulWidget {
  bool isEdit = false;
  AddressData? addressModel;
  bool? isCheckout;

  AddNewAddress(this.isEdit, this.addressModel, {Key? key,this.isCheckout=false}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress>
    with PhoneNumberValidator {
  final _formKey = GlobalKey<FormState>();
  final bool _autoValidate =
      false; //this bool value is used to decide when to validate form
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
  String? editCountryName;
  String? customerUserName;
  String? addCountryName;
  String? stateName;
  String? countryCode;
  String? stateCode;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AddEditAddressBloc? addEditAddressBloc;
  bool isDefault = false;

  @override
  void initState() {
    _fetchSharedPreferenceData();
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
    // widget.isEdit ? countryController.text = widget.addressModel?.country ?? "" : "";
    widget.isEdit
        ? vatIdController.text = widget.addressModel?.vatId ?? ""
        : "";
    widget.isEdit
        ? editCountryName = widget.addressModel?.countryName ?? ""
        : "";
    widget.isEdit ? countryCode = widget.addressModel?.country ?? "" : "";
    widget.isEdit ? stateCode = widget.addressModel?.state ?? "" : "";
    addCountryName = countryData?.data
            ?.firstWhereOrNull((e) => e.code == selectedCountry?.code)
            ?.name ??
        countryData?.data?.first.name;
    addEditAddressBloc = context.read<AddEditAddressBloc>();
    super.initState();
  }

  _fetchSharedPreferenceData() async {
    customerUserName = await SharedPreferenceHelper.getCustomerName();
    widget.isEdit
        ? firstNameController.text = widget.addressModel?.firstName ?? ""
        : firstNameController.text = customerUserName!.split(" ").elementAt(0);
    widget.isEdit
        ? lastNameController.text = widget.addressModel?.lastName ?? ""
        : lastNameController.text =
            customerUserName!.split(" ").elementAt(1); // Lorem
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(widget.isEdit ? StringConstants.editAddressLabel.localized(): StringConstants.addAddressLabel.localized()),
          ),
          body: _addEditAddressBloc(context),
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
            ShowMessage.errorNotification(
                state.error ?? "",context);
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.successNotification(
                state.updateAddressModel?.message ?? "",context);
            Navigator.pop(
                context,
                AddressData(
                    id: widget.addressModel!.id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    companyName: companyController.text,
                    vatId: vatIdController.text,
                    address1: street1Controller.text.toString(),
                    country: selectedCountry?.code ?? countryCode,
                    countryName:
                        selectedCountry?.name ?? countryController.text,
                    state: selectedState?.code ?? stateNameController.text,
                    city: cityController.text,
                    phone: phoneController.text,
                    postcode: zipCodeController.text,
                    billingAddressId: widget.addressModel?.billingAddressId,
                    shippingAddressId: widget.addressModel?.shippingAddressId,
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
                      address1: street1Controller.text.toString(),
                      country: selectedCountry?.code ?? countryCode,
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
            ShowMessage.errorNotification(
                state.error ?? "",context);
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.successNotification(state.baseModel?.message ?? "",context);
            if (countryCode != null) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(
                    context,
                    AddressData(
                      companyName: companyController.text,
                      address1: street1Controller.text.toString(),
                      city: cityController.text,
                      state: selectedState?.code ?? "",
                      country: selectedCountry?.code ?? countryCode,
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
                    address1: street1Controller.text.toString(),
                    city: cityController.text,
                    state: selectedState?.code ?? "",
                    country: selectedCountry?.code ?? countryCode,
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
          if (widget.isEdit) {
            countryController.text = countryList?.firstWhereOrNull((element) => element.code == widget.addressModel?.country)?.name ?? "";
          } else {
            if ((selectedCountry?.states?.length ?? 0) > 0) {
              selectedState = selectedCountry?.states?.first;
            }
          }
        }
      }
      if (state.status == AddEditStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    if (state is InitialAddEditAddressState) {
      if ((countryList?.length ?? 0) == 0) {
        addEditAddressBloc?.add(AddressCountryEvent());
      }
      return const Loader();
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
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          _getAddressForm();
        });
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingNormal,
              horizontal: AppSizes.spacingMedium),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                    context,
                    firstNameController,
                    StringConstants.firstNameHint.localized(),
                    label: StringConstants.firstNameLabel.localized(),
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
                  companyController,
                   StringConstants.companyNameHint.localized(),
                  label: StringConstants.companyNameLabel.localized(),
                  validLabel: StringConstants.pleaseFillLabel.localized() +
                      StringConstants.companyNameLabel.localized(),
                  validator: (companyName) {
                    if (companyName!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.companyNameLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                CommonWidgets().getTextField(
                  context,
                  phoneController,
                   StringConstants.contactUsPhoneHint.localized(),
                  label: StringConstants.contactUsPhoneLabel.localized(),
                  validLabel: StringConstants.pleaseFillLabel.localized() +
                      StringConstants.contactUsPhoneLabel.localized(),
                  keyboardType: TextInputType.phone,
                  validator: (phone) {
                    if (phone!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.contactUsPhoneLabel.localized();
                    } else if (!isValidPhone(phone)) {
                      return StringConstants.phoneWarning.localized();
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
                  validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.streetLabel.localized(),
                  validator: (street1) {
                    if (street1!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.streetLabel.localized();
                    }
                    return null;
                  },
                ),
                if(widget.isCheckout==false)const SizedBox(height: AppSizes.spacingWide),
                if(widget.isCheckout==false)Text(StringConstants.vatIdNote.localized()),
                if(widget.isCheckout==false)const SizedBox(height: 6),
                if(widget.isCheckout==false)CommonWidgets().getTextField(
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
                CommonDropDownField(
                  value: widget.isEdit ? editCountryName : addCountryName,
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
                        value: stateName,
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
                        validator: (cityName) {
                          if (cityName!.isEmpty) {
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
                  label:  StringConstants.cityLabel.localized(),
                  validLabel: StringConstants.pleaseFillLabel.localized() + StringConstants.cityLabel.localized(),
                  validator: (cityName) {
                    if (cityName!.isEmpty) {
                      return StringConstants.pleaseFillLabel.localized() +
                          StringConstants.cityLabel.localized();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingWide),
                Row(
                  children: [
                    Checkbox(
                        value: isDefault,
                        onChanged: (bool? value) {
                          setState(() {
                            isDefault = value ?? false;
                            debugPrint("$isDefault");
                          });
                        }),
                    Text(StringConstants.defaultAddress.localized()),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingWide),
                MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      side: BorderSide(width: 2)),
                  elevation: 0.0,
                  height: 48,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Theme.of(context).colorScheme.background,
                  textColor: Theme.of(context).colorScheme.onBackground,
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
            ),
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
          stateName = selectedState?.defaultName;
        }
      }
      stateNameController.text = selectedState?.code ?? "";
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

      widget.isEdit
          ? addEditAddressBloc?.add(FetchEditAddressEvent(
              addressId: int.parse(widget.addressModel?.id ?? "0"),
              address: street1Controller.text,
              city: cityController.text,
              country: (widget.isEdit && selectedCountry?.code == null)
                  ? countryCode
                  : selectedCountry?.code ?? countryCode,
              // countryName: selectedCountry?.name ?? countryController.text,
              phone: phoneController.text,
              postCode: zipCodeController.text,
              state: stateNameController.text.isNotEmpty
                  ? stateNameController.text
                  : ((stateCode ?? "").isNotEmpty
                      ? stateCode!
                      : selectedState?.code ?? stateNameController.text),
              companyName: companyController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              vatId: vatIdController.text,
            ))
          : addEditAddressBloc?.add(FetchAddAddressEvent(
              address: street1Controller.text,
              city: cityController.text,
              country: selectedCountry?.code ?? countryCode,
              phone: phoneController.text,
              postCode: zipCodeController.text,
              state: selectedState?.code ?? stateNameController.text,
              companyName: companyController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              isDefault: isDefault,
              vatId: vatIdController.text,
            ));
    }
  }
}
