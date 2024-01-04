/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:bagisto_app_demo/utils/status_color_helper.dart';
import '../../../utils/index.dart';
import '../../../data_model/order_model/orders_list_data_model.dart';

//ignore: must_be_immutable
class OrdersListTile extends StatelessWidget with OrderStatusBGColorHelper {
  Data? data;
  VoidCallback? reload;

  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  OrdersListTile({Key? key, this.data, this.reload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                StringConstants.orderNo.localized(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.15
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                StringConstants.qty.localized(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    letterSpacing: 0.15
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                StringConstants.totalPrice.localized(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    letterSpacing: 0.15
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                StringConstants.date.localized(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    letterSpacing: 0.15
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0,8,8),
                          child: Column(
                            children: [
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(":",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Colors.grey.shade600,
                                  )),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(":",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  )),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(":",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  )),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(":",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                data?.id.toString() ?? "",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                data?.totalQtyOrdered.toString() ??
                                    "",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              Text(
                                data?.formattedPrice?.grandTotal.toString() ??
                                    "",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: AppSizes.spacingNormal),
                              SizedBox(
                              width: MediaQuery.of(context).size.width/3,
                                child: Text(
                                  data?.createdAt.toString() ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(AppSizes.spacingNormal),
                padding: const EdgeInsets.all(AppSizes.spacingNormal),
                decoration: BoxDecoration(
                    color: getOrderBgColor(data?.status ?? ""),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Text(
                  capitalize(data?.status ?? "".toUpperCase()),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingNormal),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.spacingWide/2, vertical: 5.0),
            child: SizedBox(
              height: AppSizes.spacingWide*2,
              child: MaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                elevation: 0.0,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  Navigator.pushNamed(context, orderDetailPage,
                          arguments: data?.id)
                      .then((value) {
                    if (reload != null) {
                      reload!();
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.background),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      StringConstants.orderDetails.localized().toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.background),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
