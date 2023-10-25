/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, deprecated_member_use, unnecessary_null_comparison

import 'package:bagisto_app_demo/common_widget/common_error_msg.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/helper/no_data_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Configuration/mobikul_theme.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../helper/shared_preference_helper.dart';
import '../../../routes/route_constants.dart';
import '../bloc/address_bloc.dart';
import '../events/fetch_address_event.dart';
import '../state/address_base_state.dart';
import '../state/ferch_address_state.dart';
import '../state/initial_address_state.dart';
import '../state/remove_address_state.dart';
import 'add_new_address_button.dart';
import 'saved_address_list.dart';

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
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:Scaffold(
        appBar: (widget.isFromDashboard ?? false)
            ? null
            : AppBar(
                centerTitle: false,
                title: CommonWidgets.getHeadingText(
                    "Address".localized(), context),
              ),
        body:  _addressBloc(context),
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
            // _addressModel==null?
            _addressModel = state.addressModel;
          }
        }
        if (state is RemoveAddressState) {
          if (state.status == AddressStatus.fail) {
            ShowMessage.showNotification(
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == AddressStatus.success) {
            ShowMessage.showNotification(
                state.response?.message ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
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
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }

    if (state is InitialAddressState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is RemoveAddressState) {
      if (state.status == AddressStatus.success) {
        var customerId = state.customerDeletedId;
        if (_addressModel!.addressData != null) {
          _addressModel!.addressData!.removeWhere(
              (element) => element.id.toString() == customerId.toString());
          return _addressList(_addressModel!);
        } else {}
      }
    }

    return Container();
  }

  ///this method will show address list
  _addressList(AddressModel addressModel) {
    if (addressModel == null) {
      SharedPreferenceHelper.setAddressData(true);
      return const NoDataFound();
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
          CommonWidgets().getTextFieldHeight(AppSizes.spacingTiny),
          Card(
            elevation: 2,
            child: (widget.isFromDashboard ?? false)
                ? null
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            side: BorderSide(
                                width: 2,
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                        padding: const EdgeInsets.all(AppSizes.mediumPadding),
                        onPressed: () {
                          Navigator.pushNamed(context, AddAddress,
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
                              "AddNewAddress".localized().toUpperCase(),
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
              color: MobikulTheme.accentColor,
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
    addressBloc?.add(FetchAddressEvent());
  }
}

///class used to send data on edit/add screen
class AddressNavigationData {
  AddressNavigationData({this.isEdit, this.addressModel});

  bool? isEdit;
  AddressData? addressModel;
}
