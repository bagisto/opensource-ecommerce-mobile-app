import 'package:flutter/material.dart';
import '../../../../../../common_widget/common_widgets.dart';
import '../../../../../../configuration/app_sizes.dart';
import '../../../../../../helper/application_localization.dart';
import '../../../../../../helper/string_constants.dart';
import '../../../../../../models/address_model/address_model.dart';
import '../../../../../../routes/route_constants.dart';
import '../../../../../address_list/view/address_screen.dart';
// ignore: must_be_immutable
class BillingAndShippingAddressView extends StatefulWidget {
   AddressData ? address;
   final String ? title;
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
       String? shippingPhone)? callBack;
   BillingAndShippingAddressView({Key? key, this.address, this.addressModel, this.title,this.callBack}) : super(key: key);

  @override
  State<BillingAndShippingAddressView> createState() => _BillingAndShippingAddressViewState();
}

class _BillingAndShippingAddressViewState extends State<BillingAndShippingAddressView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                    ApplicationLocalizations.of(context)!
                        .translate(widget.title ?? ""),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.normalFontSize,
                      color: Theme.of(context).colorScheme.onPrimary,)
                ),
              ),
              CommonWidgets().getTextFieldHeight(NormalPadding),
              if (widget.address != null)
                _getFormattedAddress(widget.address!),
              if (widget.address != null)
                CommonWidgets().getTextFieldHeight(NormalHeight),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: ("Mobile: "),
                          style: TextStyle(
                              fontSize: AppSizes.normalFontSize, color: Colors.grey[600])),
                      TextSpan(
                          text: (widget.address?.phone ?? ''),
                          style: TextStyle(fontSize: AppSizes.normalFontSize, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              CommonWidgets().getTextFieldHeight(
                AppSizes.spacingDefault,
              ),
              CommonWidgets().divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.address == null
                      ? MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddAddress,
                          arguments: AddressNavigationData(
                              isEdit: false,
                              addressModel: null))
                          .then((value) {
                        if (value is AddressData) {
                          setState(() {
                            widget.address = value;
                          });

                          if (widget.callBack != null) {
                            widget.callBack!(
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color:  Theme.of(context).colorScheme.onPrimary,
                        ),
                        Text(
                          ApplicationLocalizations.of(context)!
                              .translate("add")
                              .toUpperCase(),
                          style: TextStyle(
                              color:  Theme.of(context).colorScheme.onPrimary,
                              fontSize: AppSizes.normalFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                      : Container(),
                  widget.address != null
                      ? MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddAddress,
                          arguments: AddressNavigationData(
                              isEdit: false,
                              addressModel: null))
                          .then((value) {
                        if (value is AddressData) {
                          setState(() {
                            widget.address = value;
                          });

                          if (widget.callBack != null) {
                            widget.callBack!(
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color:  Theme.of(context).colorScheme.onPrimary,
                        ),
                        Text(
                          ApplicationLocalizations.of(context)!
                              .translate("Add")
                              .localized(),
                          style: TextStyle(
                              color:  Theme.of(context).colorScheme.onPrimary,
                              fontSize: AppSizes.normalFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                      : Container(),
                  widget.address != null?
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CheckOutAddressList,
                          arguments: widget.addressModel)
                          .then((value) {
                        if (value is AddressData) {
                          setState(() {
                            widget.address = value;
                          });
                          if (widget.callBack != null) {
                            widget.callBack!(
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              "assets/images/change_icon.png",
                              height: 25,
                              width: 25,
                            )),
                        Text(
                          ApplicationLocalizations.of(context)!
                              .translate("change"),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              fontSize: AppSizes.normalFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ):Container(),
                  widget.address != null
                      ? MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddAddress,
                          arguments: AddressNavigationData(
                              isEdit: true,
                              addressModel: widget.address))
                          .then((value) {
                        if (value is AddressData) {
                          setState(() {
                            widget.address = value;
                          });

                          if (widget.callBack != null) {
                            widget.callBack!(
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                              widget.address?.companyName,
                              widget.address?.firstName,
                              widget.address?.lastName,
                              widget.address?.address1,
                              widget.address?.address1,
                              widget.address?.country,
                              widget.address?.state,
                              widget.address?.city,
                              widget.address?.postcode,
                              widget.address?.phone,
                            );
                          }
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary,
                        ),
                        Text(
                          ApplicationLocalizations.of(context)!
                              .translate("Edit"),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              fontSize: AppSizes.normalFontSize,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                      : Container(width: 0,),
                ],
              ),
              CommonWidgets().divider(),
            ]),
      ),
    );
  }
  _getFormattedAddress(AddressData? addressModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        "${"${addressModel?.firstName ?? ""} ${addressModel?.lastName ?? ""}\n\n${addressModel?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}"}, ${addressModel?.city ?? ""}, ${addressModel?.stateName ?? ""}, ${addressModel?.countryName ?? ""}, ${addressModel?.postcode ?? ""}",
        style: TextStyle(fontSize: AppSizes.normalFontSize, color: Colors.grey[600]),
      ),
    );
  }
}
