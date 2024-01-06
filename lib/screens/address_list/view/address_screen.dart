/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/address_list/view/widget/add_new_address_button.dart';
import 'package:bagisto_app_demo/screens/address_list/view/widget/address_loader_view.dart';
import 'package:bagisto_app_demo/screens/address_list/view/widget/saved_address_list.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/assets_constants.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/empty_data_view.dart';
import '../../../widgets/show_message.dart';
import '../bloc/address_bloc.dart';
import '../bloc/ferch_address_state.dart';
import '../bloc/fetch_address_event.dart';
import '../data_model/address_model.dart';

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

  @override
  void initState() {
    AddressBloc addressBloc = context.read<AddressBloc>();
    addressBloc.add(FetchAddressEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: (widget.isFromDashboard ?? false)
              ? null
              : AppBar(
                  centerTitle: false,
                  title: Text(StringConstants.address.localized()),
                ),
          body: _addressBloc(context),
        ),
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
      },
      builder: (BuildContext context, AddressBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///ADDRESS UI METHODS///
  Widget buildUI(BuildContext context, AddressBaseState state) {
    if (state is FetchAddressState) {
      if (state.status == AddressStatus.success) {
        _addressModel == null ? _addressModel = state.addressModel : null;
        return _addressList(state.addressModel!);
      }
      if (state.status == AddressStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? StringConstants.error);
      }
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
      SharedPreferenceHelper.setAddressData(true);
      return const EmptyDataView(assetPath: AssetConstants.emptyAddress);
    } else if (addressModel.addressData?.isEmpty ?? false) {
      SharedPreferenceHelper.setAddressData(true);
      return AddNewAddressButton(
        reload: fetchAddressData,
        isFromDashboard: widget.isFromDashboard,
      );
    } else {
      SharedPreferenceHelper.setAddressData(false);
      return Column(
        children: [
          const SizedBox(
            height: AppSizes.spacingSmall,
          ),
          Card(
            elevation: 2,
            child: (widget.isFromDashboard ?? false)
                ? null
                : Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSizes.size8),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.size8),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.size4)),
                            side: BorderSide(
                                width: 2,
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                        padding: const EdgeInsets.all(AppSizes.spacingMedium),
                        onPressed: () {
                          Navigator.pushNamed(context, addAddressScreen,
                                  arguments: AddressNavigationData(
                                      isEdit: false, addressModel: null))
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 12,
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
              child: ListView.builder(
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
                    );
                  }),
            ),
          )
        ],
      );
    }
  }

  fetchAddressData() async {
    AddressBloc addressBloc = context.read<AddressBloc>();
    addressBloc.add(FetchAddressEvent());
  }
}
