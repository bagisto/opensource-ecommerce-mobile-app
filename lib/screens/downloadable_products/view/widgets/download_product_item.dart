import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common_widget/common_widgets.dart';
import '../../../../common_widget/image_view.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/downloadable_products/downloadable_product_model.dart';
import '../../../../models/homepage_model/new_product_data.dart';
import '../../bloc/downloadable_products_bloc.dart';
import 'download_button.dart';

class DownloadProductItem extends StatelessWidget {
  final int available;
  final DownloadableLinkPurchases? linkPurchases;
  final DownloadableProductsBloc? downloadableProductsBloc;
  final NewProducts? product;
  const DownloadProductItem({Key? key, this.linkPurchases, this.downloadableProductsBloc, required this.available,
  this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.elevation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Stack(
                  children: [
                    ((product?.images?.length??0)>0)?
                    ImageView(
                      url:(imageUrl) + (product
                          ?.images![0].path ?? ""),
                      width: MediaQuery.of(context).size.width / 2.9,
                    ): ImageView(
                      url: "",
                      width: MediaQuery.of(context).size.width / 2.9,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.mediumPadding),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(linkPurchases?.orderId ?? ""),
                      CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                      SizedBox(
                          child: Text(
                              linkPurchases?.productName ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                  fontSize: 16))),
                      CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                      Text(linkPurchases?.createdAt ?? ""),
                      CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                      Text((available == 0) ? "expired".localized() :
                      ( linkPurchases?.order?.status !=   "pending" ? "available".localized() : "pending".localized())),
                      CommonWidgets().getTextFieldHeight(AppSizes.normalPadding),
                      Text("remainingDownloads".localized() + " $available"),
                      CommonWidgets()
                          .getTextFieldHeight(AppSizes.extraPadding),
                      DownloadButton(available: available, downloadableProductsBloc: downloadableProductsBloc,
                        linkPurchases: linkPurchases,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
