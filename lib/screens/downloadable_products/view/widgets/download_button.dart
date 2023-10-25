import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/events/downloadable_products_events.dart';
import 'package:flutter/material.dart';
import '../../../../Configuration/mobikul_theme.dart';
import '../../../../common_widget/show_message.dart';
import '../../../../helper/string_constants.dart';
import '../../../../models/downloadable_products/downloadable_product_model.dart';
import '../../bloc/downloadable_products_bloc.dart';

class DownloadButton extends StatelessWidget {
  final int available;
  final DownloadableProductsBloc? downloadableProductsBloc;
  final DownloadableLinkPurchases? linkPurchases;
  DownloadButton({Key? key, required this.available, this.downloadableProductsBloc, this.linkPurchases}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(
            const Size(DownloadScreenButtonWith, 104)),
        foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primaryContainer,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.background,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: (available != 0 && (linkPurchases?.order?.status == "completed")) ? () {
        if ((linkPurchases != null)) {
          int id = int.tryParse(linkPurchases?.id ?? "0") ?? 0;
          downloadableProductsBloc?.add(DownloadProductEvent(id));

        } else {
          ShowMessage.showNotification("contactAdmin".localized(), "",
              Colors.red, const Icon(Icons.cancel_outlined));
        }
      } : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download,
            size: 17,
            color: MobikulTheme.primaryColor,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            "download".localized() ?? "",
            style:  TextStyle(fontSize: 14,color:  MobikulTheme.primaryColor,),
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}