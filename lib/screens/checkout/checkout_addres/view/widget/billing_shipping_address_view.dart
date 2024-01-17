import 'package:bagisto_app_demo/utils/index.dart';
import 'package:flutter/material.dart';
import '../../../../../../data_model/app_route_arguments.dart';
import '../../../../../../utils/assets_constants.dart';
import '../../../../address_list/data_model/address_model.dart';
import '../../bloc/checkout_bloc.dart';

// ignore: must_be_immutable
class BillingAndShippingAddressView extends StatefulWidget {
  AddressData? address;
  AddressData? shippingAddress;
  AddressData? billingAddress;
  final String? title;
  final AddressModel? addressModel;

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
      String? shippingCompanyName,
      String? shippingFirstName,
      String? shippingLastName,
      String? shippingAddress,
      String? shippingAddress2,
      String? shippingCountry,
      String? shippingState,
      String? shippingCity,
      String? shippingPostCode,
      String? shippingPhone, int billingId, int shippingId)? callBack;
  BillingAndShippingAddressView(
      {Key? key,
      this.address,
      this.addressModel,
      this.title,
      this.callBack,
      this.shippingAddress,
      this.billingAddress})
      : super(key: key);

  @override
  State<BillingAndShippingAddressView> createState() =>
      _BillingAndShippingAddressViewState();
}

class _BillingAndShippingAddressViewState
    extends State<BillingAndShippingAddressView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text((widget.title ?? "").localized(),
                  style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: AppSizes.spacingNormal),
            if (widget.address != null) _getFormattedAddress(widget.address!),
            if (widget.address != null)
              const SizedBox(height: AppSizes.spacingNormal),
            Padding(
                padding:
                    const EdgeInsets.fromLTRB(AppSizes.spacingNormal, 0, 0, 0),
                child: Row(
                  children: [
                    Text("Mobile: ",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.grey.shade600)),
                    Text(
                      widget.address?.phone ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                )),
            const SizedBox(height: AppSizes.spacingLarge),
            CommonWidgets().divider(),
            widget.address == null
                ? MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, addAddressScreen,
                              arguments: AddressNavigationData(
                                  isEdit: false, addressModel: null))
                          .then((value) {
                        if (value is AddressData) {
                          widget.address = value;
                          if (widget.title == StringConstants.billingAddress) {
                            setState(() {
                              widget.billingAddress = value;
                            });
                          } else {
                            setState(() {
                              widget.shippingAddress = value;
                            });
                          }
                          if (widget.callBack != null) {
                            widget.callBack!(
                              widget.billingAddress?.companyName,
                              widget.billingAddress?.firstName,
                              widget.billingAddress?.lastName,
                              widget.billingAddress?.address1,
                              widget.billingAddress?.address1,
                              widget.billingAddress?.countryName,
                              widget.billingAddress?.state,
                              widget.billingAddress?.city,
                              widget.billingAddress?.postcode,
                              widget.billingAddress?.phone,
                              widget.shippingAddress?.companyName,
                              widget.shippingAddress?.firstName,
                              widget.shippingAddress?.lastName,
                              widget.shippingAddress?.address1,
                              widget.shippingAddress?.address1,
                              widget.shippingAddress?.countryName,
                              widget.shippingAddress?.state,
                              widget.shippingAddress?.city,
                              widget.shippingAddress?.postcode,
                              widget.shippingAddress?.phone,
                              int.parse(widget.billingAddress?.id ?? "0"),
                              int.parse(widget.shippingAddress?.id ?? "0")
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onPrimary,
                            size: AppSizes.spacingWide
                        ),
                        Text(StringConstants.add.localized()
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            Row(
              children: [
                widget.address != null
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.grey.shade300, width: 1)),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, addAddressScreen,
                                      arguments: AddressNavigationData(
                                          isEdit: false, addressModel: null))
                                  .then((value) {
                                if (value is AddressData) {
                                  widget.address = value;
                                  if (widget.title == StringConstants.billingAddress) {
                                    setState(() {
                                      widget.billingAddress = value;
                                    });
                                  } else {
                                    setState(() {
                                      widget.shippingAddress = value;
                                    });
                                  }
                                  if (widget.callBack != null) {
                                    widget.callBack!(
                                      widget.billingAddress?.companyName,
                                      widget.billingAddress?.firstName,
                                      widget.billingAddress?.lastName,
                                      widget.billingAddress?.address1,
                                      widget.billingAddress?.address1,
                                      widget.billingAddress?.countryName,
                                      widget.billingAddress?.state,
                                      widget.billingAddress?.city,
                                      widget.billingAddress?.postcode,
                                      widget.billingAddress?.phone,
                                      widget.shippingAddress?.companyName,
                                      widget.shippingAddress?.firstName,
                                      widget.shippingAddress?.lastName,
                                      widget.shippingAddress?.address1,
                                      widget.shippingAddress?.address1,
                                      widget.shippingAddress?.countryName,
                                      widget.shippingAddress?.state,
                                      widget.shippingAddress?.city,
                                      widget.shippingAddress?.postcode,
                                      widget.shippingAddress?.phone,
                                        int.parse(widget.billingAddress?.id ?? "0"),
                                        int.parse(widget.shippingAddress?.id ?? "0")
                                    );
                                  }
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                size: AppSizes.spacingWide,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                Text(StringConstants.add.localized()
                                      .localized(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.address != null
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.grey.shade300, width: 1)),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, checkOutAddressList,
                                      arguments: widget.addressModel)
                                  .then((value) {
                                if (value is AddressData) {
                                  widget.address = value;
                                  if (widget.title == StringConstants.billingAddress) {
                                    setState(() {
                                      widget.billingAddress = value;
                                    });
                                  } else {
                                    setState(() {
                                      widget.shippingAddress = value;
                                    });
                                  }
                                  if (widget.callBack != null) {
                                    widget.callBack!(
                                      widget.billingAddress?.companyName,
                                      widget.billingAddress?.firstName,
                                      widget.billingAddress?.lastName,
                                      widget.billingAddress?.address1,
                                      widget.billingAddress?.address1,
                                      widget.billingAddress?.country,
                                      widget.billingAddress?.state,
                                      widget.billingAddress?.city,
                                      widget.billingAddress?.postcode,
                                      widget.billingAddress?.phone,
                                      widget.shippingAddress?.companyName,
                                      widget.shippingAddress?.firstName,
                                      widget.shippingAddress?.lastName,
                                      widget.shippingAddress?.address1,
                                      widget.shippingAddress?.address1,
                                      widget.shippingAddress?.country,
                                      widget.shippingAddress?.state,
                                      widget.shippingAddress?.city,
                                      widget.shippingAddress?.postcode,
                                      widget.shippingAddress?.phone,
                                        int.parse(widget.billingAddress?.id ?? "0"),
                                        int.parse(widget.shippingAddress?.id ?? "0")
                                    );
                                  }
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.onPrimary,
                                      BlendMode.srcIn,
                                    ),
                                    child: Image.asset(AssetConstants.changeIcon,
                                      height: AppSizes.spacingWide,
                                      width: AppSizes.spacingWide,
                                    )),
                                Text(StringConstants.change.localized(),
                                  style:Theme.of(context).textTheme.bodyMedium),

                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ]),
    );
  }

  _getFormattedAddress(AddressData? addressModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        "${"${addressModel?.firstName ?? ""} ${addressModel?.lastName ?? ""}\n\n${addressModel?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}"}, "
        "${addressModel?.city ?? ""}, ${addressModel?.stateName ?? ""} ${addressModel?.countryName ?? ""}, ${addressModel?.postcode ?? ""}",
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }
}
