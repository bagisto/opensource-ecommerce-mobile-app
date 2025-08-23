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

class AddNewAddressButton extends StatelessWidget {
  final  VoidCallback? reload;
  final bool? isFromDashboard;
  const AddNewAddressButton({super.key,  this.reload,this.isFromDashboard});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          (isFromDashboard ?? false)
              ? const SizedBox()
              : Padding(
                padding: const EdgeInsets.all(AppSizes.spacingNormal),
                child: MaterialButton(
            color: Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.all(AppSizes.spacingMedium),
            onPressed: () {
                Navigator.pushNamed(context, addAddressScreen,
                        arguments: AddressNavigationData(
                            isEdit: false, addressModel: null, isCheckout: false))
                    .then((value) {
                  if (reload != null) {
                    reload!();
                  }
                });
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.add,
                    color:Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    StringConstants.addNewAddress.localized().toUpperCase(),
                    style: TextStyle(color: Theme.of(context).colorScheme.surface),
                  )
                ],
            ),
          ),
              ),
          const EmptyDataView(assetPath: AssetConstants.emptyAddress,
          message: StringConstants.noAddress),
        ],
      ),
    );
  }
}
