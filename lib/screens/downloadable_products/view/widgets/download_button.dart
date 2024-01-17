import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../utils/string_constants.dart';
import '../../../../widgets/show_message.dart';
import '../../bloc/downloadable_products_bloc.dart';
import '../../bloc/downloadable_products_events.dart';
import '../../data_model/downloadable_product_model.dart';

class DownloadButton extends StatelessWidget {
  final int available;
  final DownloadableProductsBloc? downloadableProductsBloc;
  final DownloadableLinkPurchases? linkPurchases;

  const DownloadButton(
      {Key? key,
      required this.available,
      this.downloadableProductsBloc,
      this.linkPurchases})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(const Size(270, 104)),
        foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.background,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.onBackground,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: (available != 0 &&
              (linkPurchases?.order?.status?.toLowerCase() == StringConstants.completed.toLowerCase()))
          ? () {
              if ((linkPurchases != null)) {
                int id = int.tryParse(linkPurchases?.id ?? "0") ?? 0;
                downloadableProductsBloc?.add(DownloadProductEvent(id));
              } else {
                ShowMessage.showNotification(
                    StringConstants.failed.localized(),
                    StringConstants.contactAdmin.localized(),
                    Colors.red,
                    const Icon(Icons.cancel_outlined));
              }
            }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download,
            size: 17,
            color: Theme.of(context).colorScheme.background,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            ApplicationLocalizations.of(context)
                    ?.translate(StringConstants.download) ??
                "",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.background,
            ),
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
