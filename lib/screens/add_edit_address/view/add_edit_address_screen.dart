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

import '../../location/view/location_screen.dart';

class AddNewAddress extends StatefulWidget {
  final bool? isEdit;
  final AddressData? addressModel;
  final bool? isCheckout;

  const AddNewAddress(this.isEdit, this.addressModel,
      {Key? key, this.isCheckout = false})
      : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
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
  final emailController =
      TextEditingController(text: appStoragePref.getCustomerEmail());
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
    widget.isEdit ?? false
        ? companyController.text = widget.addressModel?.companyName ?? ""
        : "";
    widget.isEdit ?? false
        ? emailController.text = widget.addressModel?.email ?? ""
        : "";
    widget.isEdit ?? false
        ? phoneController.text = widget.addressModel?.phone ?? ""
        : "";
    widget.isEdit ?? false
        ? street1Controller.text = widget.addressModel?.address1 ?? ''
        : "";
    widget.isEdit ?? false
        ? cityController.text = widget.addressModel?.city ?? ""
        : "";
    widget.isEdit ?? false
        ? stateNameController.text =
            widget.addressModel?.stateName ?? (widget.addressModel?.state ?? "")
        : "";
    widget.isEdit ?? false
        ? zipCodeController.text = widget.addressModel?.postcode ?? ""
        : "";
    widget.isEdit ?? false
        ? vatIdController.text = widget.addressModel?.vatId ?? ""
        : "";
    widget.isEdit ?? false
        ? editCountryName = widget.addressModel?.countryName ?? ""
        : "";
    widget.isEdit ?? false ? stateName = stateNameController.text : null;
    widget.isEdit ?? false
        ? countryCode = widget.addressModel?.country ?? ""
        : "";
    widget.isEdit ?? false ? stateCode = widget.addressModel?.state ?? "" : "";
    addCountryName = countryData?.data
            ?.firstWhereOrNull((e) => e.code == selectedCountry?.code)
            ?.name ??
        countryData?.data?.first.name;
    addEditAddressBloc = context.read<AddEditAddressBloc>();
    super.initState();
  }

  _fetchSharedPreferenceData() async {
    customerUserName = appStoragePref.getCustomerName();
    widget.isEdit ?? false
        ? firstNameController.text = widget.addressModel?.firstName ?? ""
        : firstNameController.text = customerUserName!.split(" ").elementAt(0);
    widget.isEdit ?? false
        ? lastNameController.text = widget.addressModel?.lastName ?? ""
        : lastNameController.text =
            customerUserName!.split(" ").elementAt(1); // Lorem
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.isEdit ?? false
              ? StringConstants.editAddressLabel.localized()
              : StringConstants.addAddressLabel.localized()),
          actions: [
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LocationScreen())).then((value) {
                  if (value is Map) {
                    street1Controller.text =
                        "${value['street1'] ?? ""} ${value['street2'] ?? ""} ${value['street3'] ?? ""}";
                    cityController.text = value['city'] ?? "";
                    zipCodeController.text = value['zip'];
                    stateNameController.text = value['state'];
                    setState(() {
                      editCountryName = value['country'];
                      addCountryName = value['country'];
                      countryCode = value['countryCode'];
                      stateName = value['state'];
                      if (selectedCountry != null) {
                        selectedCountry?.name = value['country'];
                      } else {
                        selectedCountry = Data(name: value['country']);
                      }
                    });
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: AppSizes.spacingMedium),
                padding: const EdgeInsets.all(AppSizes.spacingNormal),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.my_location,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
        body: _addEditAddressBloc(context),
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
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.successNotification(
                state.updateAddressModel?.message ?? "", context);
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
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == AddEditStatus.success) {
            ShowMessage.successNotification(
                state.baseModel?.message ?? "", context);
            if (countryCode != null) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(
                    context,
                    AddressData(
                      companyName: companyController.text,
                      address1: street1Controller.text.toString(),
                      city: cityController.text,
                      state: selectedState?.code ?? stateNameController.text,
                      country: selectedCountry?.code ?? countryCode,
                      lastName: lastNameController.text,
                      postcode: zipCodeController.text,
                      phone: phoneController.text,
                      isDefault: isDefault,
                      vatId: vatIdController.text,
                      stateName:
                          selectedState?.code ?? stateNameController.text,
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
                    state: selectedState?.code ?? stateNameController.text,
                    country: selectedCountry?.code ?? countryCode,
                    lastName: lastNameController.text,
                    postcode: zipCodeController.text,
                    phone: phoneController.text,
                    stateName: selectedState?.code ?? stateNameController.text,
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
          if (widget.isEdit ?? false) {
            var countryFromEdit = countryList?.firstWhereOrNull(
                (e) => e.name == widget.addressModel?.countryName);
            widget.isEdit ?? false ? selectedCountry = countryFromEdit : "";
            countryCode = selectedCountry?.code;
            if ((countryFromEdit?.states?.length ?? 0) > 0) {
              selectedState = countryFromEdit?.states?.first;
            }

            countryController.text = countryList
                    ?.firstWhereOrNull((element) =>
                        element.code == widget.addressModel?.country)
                    ?.name ??
                "";
            selectedCountry?.name = countryController.text.toString();
          } else {
            if ((selectedCountry?.states?.length ?? 0) > 0) {
              selectedState = selectedCountry?.states?.first;
            }
          }
        } else {}
      }
      if (state.status == AddEditStatus.fail) {
        return EmptyDataView();
      }
    }
    if (state is InitialAddEditAddressState) {
      if ((countryList?.length ?? 0) == 0) {
        addEditAddressBloc?.add(AddressCountryEvent());
      }
      return const AddEditLoaderView();
    }
    if (state is FetchAddAddressState) {
      if (state.status == AddEditStatus.success) {}
      if (state.status == AddEditStatus.fail) {}
    }
    if (state is FetchEditAddressState) {
      if (state.status == AddEditStatus.success) {}
      if (state.status == AddEditStatus.fail) {}
    }

    return SafeArea(
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
            children: [
              GetAddressForm(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                emailController: emailController,
                zipCodeController: zipCodeController,
                companyController: companyController,
                street1Controller: street1Controller,
                phoneController: phoneController,
                vatIdController: vatIdController,
                isCheckout: widget.isCheckout,
              ),
              CommonDropDownField(
                value:
                    widget.isEdit ?? false ? editCountryName : addCountryName,
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
                      hintText: (widget.isEdit ?? false)
                          ? stateNameController.text.toString()
                          : StringConstants.stateHint.localized(),
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
                label: StringConstants.cityLabel.localized(),
                isRequired: true,
                validLabel: StringConstants.pleaseFillLabel.localized() +
                    StringConstants.cityLabel.localized(),
                validator: (cityName) {
                  if (cityName!.isEmpty) {
                    return StringConstants.pleaseFillLabel.localized() +
                        StringConstants.cityLabel.localized();
                  }
                  return null;
                },
              ),
              SaveAddressButton(
                isEdit: widget.isEdit,
                addEditAddressBloc: addEditAddressBloc,
                countryCode: countryCode,
                selectedCountry: selectedCountry,
                selectedState: selectedState,
                stateCode: stateCode,
                addressId: widget.addressModel?.id,
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                companyController: companyController,
                street1Controller: street1Controller,
                zipCodeController: zipCodeController,
                phoneController: phoneController,
                vatIdController: vatIdController,
                formKey: _formKey,
                isDefault: isDefault,
                cityController: cityController,
                stateNameController: stateNameController,
                emailController: emailController,
              )
            ],
          ),
        ),
      )),
    );
  }

  ///address form

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
}
