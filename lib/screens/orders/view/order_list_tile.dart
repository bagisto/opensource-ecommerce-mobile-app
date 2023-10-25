/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: must_be_immutable, file_names

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/configuration/app_sizes.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/order_status_Bg_color_helper.dart';
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';
import '../../../../routes/route_constants.dart';

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
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                "OrderNo".localized(),
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                "Qty".localized(),
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                "totalPrice".localized(),
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                "date".localized(),
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.15,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0,8,8),
                          child: Column(
                            children: [
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(":",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(":",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(":",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(":",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                data?.id.toString() ?? "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                data?.formattedPrice?.grandTotal.toString() ??
                                    "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              Text(
                                data?.formattedPrice?.grandTotal.toString() ??
                                    "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              CommonWidgets()
                                  .getTextFieldHeight(AppSizes.normalPadding),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/3,
                                child: Text(
                                  data?.createdAt.toString() ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
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
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(AppSizes.normalPadding),
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
          CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: SizedBox(
              height: 40,
              child: MaterialButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                elevation: 0.0,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.onPrimary,
                textColor: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  Navigator.pushNamed(context, OrderDetailPage,
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
                    const Icon(Icons.info_outline),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "OrderDetails".localized().toUpperCase(),
                      style: const TextStyle(fontSize: AppSizes.normalFontSize),
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
