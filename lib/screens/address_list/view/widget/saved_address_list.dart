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

class SavedAddressList extends StatelessWidget {
  final AddressData? addressModel;
  final VoidCallback? reload;
  final bool isFromDashboard;
  final AddressBloc? addressBloc;
  const SavedAddressList({Key? key, this.addressModel, this.reload, this.isFromDashboard = false,
    this.addressBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddressBloc addressBloc = context.read<AddressBloc>();
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppSizes.spacingNormal,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
                  child: Text(
                    "${addressModel?.firstName ?? ""} ${addressModel?.lastName ?? ""}",
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.spacingLarge),
                  ),
                ),
              ),
              if(isFromDashboard == false)
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.only(left: AppSizes.spacingMedium, right: AppSizes.spacingMedium,
                  top: 8, bottom: 8),
                  margin: const EdgeInsets.only(right: AppSizes.spacingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimary
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: (addressModel?.isDefault ?? true) ?
                    Theme.of(context).brightness==Brightness.light ? AppColors.lightWhiteColor : null : null
                  ),
                  child: Text((addressModel?.isDefault ?? true) ? StringConstants.defaultAddress.localized()
                      : StringConstants.setDefault.localized()),
                ),
                onTap: (){
                  if(addressModel?.isDefault == false){
                    addressBloc.add(SetDefaultAddressEvent(addressModel?.id ?? "0"));
                  }
                },
              )
            ],
          ),
          const SizedBox(
            height: AppSizes.spacingLarge,
          ),
          _getFormattedAddress(addressModel),
          const SizedBox(
            height: AppSizes.spacingLarge,
          ),
          Padding(
              padding:
                  const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
              child: Row(
                children: [
                  Text("Mobile: ",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: AppSizes.spacingLarge)),
                  Text(
                    addressModel?.phone ?? "",
                    style: TextStyle(
                        fontSize: AppSizes.spacingLarge,
                        color: Colors.grey[600]),
                  ),
                ],
              )),
          const SizedBox(
            height: AppSizes.spacingMedium,
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1.5,
            height: 1,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right:
                            BorderSide(color: Colors.grey.shade300, width: 1)),
                  ),
                  child: MaterialButton(
                    elevation: 0.0,
                    onPressed: () {
                      Navigator.pushNamed(context, addAddressScreen,
                              arguments: AddressNavigationData(
                                  isEdit: true, addressModel: addressModel, isCheckout: false))
                          .then((value) {
                        if (reload != null) {
                          reload!();
                        }
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_edit_outline_outlined,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            StringConstants.edit.localized(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left:
                            BorderSide(color: Colors.grey.shade300, width: 1)),
                  ),
                  child: MaterialButton(
                    elevation: 0.0,
                    onPressed: () {
                      _onPressRemove(context, addressBloc);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          StringConstants.remove.localized(),
                          style:Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onPressRemove(BuildContext context, AddressBloc addressBloc) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            StringConstants.deleteAddressWarning.localized(),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                StringConstants.no.localized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  addressBloc.add(
                      RemoveAddressEvent(addressModel?.id ?? ""));
                },
                child: Text(StringConstants.yes.localized(),
                    style: Theme.of(context).textTheme.bodyMedium))
          ],
        );
      },
    );
  }

  ///this method is used to format address
  _getFormattedAddress(AddressData? addressModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spacingMedium, 0, 0, 0),
      child: Text(
        "${addressModel?.address1!.replaceAll("[", "").replaceAll("]", "") ?? ""}, ${addressModel?.city ?? ""}, ${addressModel?.stateName ?? (addressModel?.state ?? "")}, ${addressModel?.countryName ?? (addressModel?.country ?? "")}, ${addressModel?.postcode ?? ""}",
        style: TextStyle(
            fontSize: AppSizes.spacingLarge, color: Colors.grey[600]),
      ),
    );
  }
}
