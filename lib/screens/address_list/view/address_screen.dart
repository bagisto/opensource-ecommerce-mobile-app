/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/address_list/utils/index.dart';
import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key, this.isFromDashboard}) : super(key: key);
  final bool? isFromDashboard;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

AddressModel? _addressModel;

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  AddressBloc? addressBloc;

  @override
  void initState() {
    addressBloc = context.read<AddressBloc>();
    addressBloc?.add(FetchAddressEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: (widget.isFromDashboard ?? false)
            ? null
            : AppBar(
                centerTitle: false,
                title: Text(StringConstants.address.localized()),
              ),
        body: _addressBloc(context),
      ),
    );
  }

  ///ADDRESS BLOC CONTAINER///
  _addressBloc(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressBaseState>(
      listener: (BuildContext context, AddressBaseState state) {
        if (state is FetchAddressState) {
          if (state.status == AddressStatus.fail) {
          } else if (state.status == AddressStatus.success) {
            _addressModel = state.addressModel;
          }
        }
        if (state is RemoveAddressState) {
          if (state.status == AddressStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == AddressStatus.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        }
        if (state is SetDefaultAddressState) {
          addressBloc?.add(FetchAddressEvent());
          if (state.status == AddressStatus.fail) {
            ShowMessage.errorNotification(state.message ?? "", context);
          } else if (state.status == AddressStatus.success) {
            ShowMessage.successNotification(
                state.addressModel?.message ?? "", context);
          }
        }
      },
      builder: (BuildContext context, AddressBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///ADDRESS UI METHODS///
  Widget buildUI(BuildContext context, AddressBaseState state) {
    if (state is FetchAddressState) {
      isLoading = false;
      if (state.status == AddressStatus.success) {
        _addressModel == null ? _addressModel = state.addressModel : null;
        return _addressList(state.addressModel!);
      }
      if (state.status == AddressStatus.fail) {
        return EmptyDataView();
      }
    }
    if (state is ShowLoaderState) {
      isLoading = true;
    }
    if (state is InitialAddressState) {
      return AddressLoader(
        isFromDashboard: widget.isFromDashboard,
      );
    }
    if (state is RemoveAddressState) {
      if (state.status == AddressStatus.success) {
        var customerId = state.customerDeletedId;
        if (_addressModel?.addressData != null) {
          _addressModel?.addressData!.removeWhere(
              (element) => element.id.toString() == customerId.toString());
          return _addressList(_addressModel);
        } else {}
      }
    }

    return _addressList(_addressModel);
  }

  ///this method will show address list
  _addressList(AddressModel? addressModel) {
    if (addressModel == null) {
      appStoragePref.setAddressData(true);
      return const EmptyDataView(assetPath: AssetConstants.emptyAddress);
    } else if (addressModel.addressData?.isEmpty ?? false) {
      appStoragePref.setAddressData(true);
      return AddNewAddressButton(
        reload: fetchAddressData,
        isFromDashboard: widget.isFromDashboard,
      );
    } else {
      appStoragePref.setAddressData(false);
      return SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: AppSizes.spacingSmall,
            ),
            Card(
              elevation: 2,
              child: (widget.isFromDashboard ?? false)
                  ? null
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spacingNormal),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spacingNormal),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppSizes.spacingSmall)),
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                          padding: const EdgeInsets.all(AppSizes.spacingMedium),
                          onPressed: () {
                            Navigator.pushNamed(context, addAddressScreen,
                                    arguments: AddressNavigationData(
                                        isEdit: false,
                                        addressModel: null,
                                        isCheckout: false))
                                .then((value) {
                              fetchAddressData();
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              Text(
                                StringConstants.addNewAddress
                                    .localized()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: AppSizes.spacingMedium,
            ),
            Flexible(
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1), () {
                    AddressBloc addressBloc = context.read<AddressBloc>();
                    addressBloc.add(FetchAddressEvent());
                  });
                },
                child: Stack(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: (widget.isFromDashboard ?? false)
                            ? ((addressModel.addressData?.length ?? 0) > 5)
                                ? 5
                                : addressModel.addressData?.length ?? 0
                            : addressModel.addressData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SavedAddressList(
                              addressModel: addressModel.addressData?[index],
                              reload: fetchAddressData,
                              isFromDashboard: widget.isFromDashboard ?? false,
                              addressBloc: addressBloc);
                        }),
                    Visibility(visible: isLoading, child: const Loader())
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  fetchAddressData() async {
    AddressBloc addressBloc = context.read<AddressBloc>();
    addressBloc.add(FetchAddressEvent());
  }
}
