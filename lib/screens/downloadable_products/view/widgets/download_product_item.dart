/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/downloadable_products/utils/index.dart';


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
              padding: const EdgeInsets.all(AppSizes.spacingNormal),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.spacingNormal)),
                ),
                child: Stack(
                  children: [
                    ((linkPurchases?.orderItem?.product?.images?.length ?? 0) > 0)
                        ? ImageView(
                            url: linkPurchases?.orderItem?.product?.images?.firstOrNull?.url,
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
                      const SizedBox(height: AppSizes.spacingNormal),
                      SizedBox(
                          child: Text(linkPurchases?.productName ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                  fontSize: 16))),
                      const SizedBox(height: AppSizes.spacingNormal),
                      Text(linkPurchases?.createdAt ?? ""),
                      const SizedBox(height: AppSizes.spacingNormal),
                      Text((available == 0)
                          ? StringConstants.expired.localized()
                          : (linkPurchases?.order?.status?.toLowerCase() != StringConstants.pending.toLowerCase()
                              ? StringConstants.available.localized()
                              : StringConstants.pending.localized())),
                      const SizedBox(height: AppSizes.spacingNormal),
                      Text("${StringConstants.remainingDownloads.localized()} $available"),
                      const SizedBox(height: AppSizes.spacingLarge),
                      if(linkPurchases?.order?.status?.toLowerCase() != StringConstants.pending.toLowerCase()
                      && available>0)
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
