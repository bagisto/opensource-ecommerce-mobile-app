import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/image_view.dart';
import '../../../home_page/data_model/new_product_data.dart';
import '../../bloc/downloadable_products_bloc.dart';
import '../../data_model/downloadable_product_model.dart';
import 'download_button.dart';

class DownloadProductItem extends StatelessWidget {
  final int available;
  final DownloadableLinkPurchases? linkPurchases;
  final DownloadableProductsBloc? downloadableProductsBloc;
  final NewProducts? product;

  const DownloadProductItem(
      {Key? key,
      this.linkPurchases,
      this.downloadableProductsBloc,
      required this.available,
      this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                    ((product?.images?.length ?? 0) > 0)
                        ? ImageView(
                            url: (product?.images![0].path ?? ""),
                            width: MediaQuery.of(context).size.width / 2.9,
                          )
                        : ImageView(
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
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(linkPurchases?.orderId ?? ""),
                      const SizedBox(height: 8),
                      SizedBox(
                          child: Text(linkPurchases?.productName ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                  fontSize: 16))),
                      const SizedBox(height: 8),
                      Text(linkPurchases?.createdAt ?? ""),
                      const SizedBox(height: 8),
                      Text((available == 0)
                          ? StringConstants.expired.localized()
                          : (linkPurchases?.order?.status?.toLowerCase() != StringConstants.pending.toLowerCase()
                              ? StringConstants.available.localized()
                              : StringConstants.pending.localized())),
                      const SizedBox(height: 8),
                      Text("${StringConstants.remainingDownloads.localized()} $available"),
                      const SizedBox(height: AppSizes.spacingLarge),
                      if(linkPurchases?.order?.status?.toLowerCase() != StringConstants.pending.toLowerCase())
                        DownloadButton(
                        available: available,
                        downloadableProductsBloc: downloadableProductsBloc,
                        linkPurchases: linkPurchases,
                      )
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
