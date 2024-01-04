
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'app_constants.dart';


class DialogHelper {
  static networkErrorDialog(BuildContext context, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          StringConstants.networkError.localized(),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 19,
              fontWeight: FontWeight.w500),
        ),
        content: Text(
          StringConstants.networkConnectionError.localized(),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                closeDialog(ctx);
                onConfirm();
              }
            },
            child: Text(StringConstants.serverError.localized(),
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static searchDialog(BuildContext context, GestureTapCallback onImageTap,
      GestureTapCallback onTextTap) {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      useRootNavigator: false,
      context: context,
      builder: (ctx) => AlertDialog(
        // titlePadding: const EdgeInsets.all(AppSizes.spacingLarge),
        title: Text(StringConstants.searchByScanning.localized(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[500])),
        backgroundColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.all(AppSizes.spacingNormal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: onTextTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.format_color_text),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.spacingNormal),
                    child: Text(StringConstants.textSearch.localized(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height:AppSizes.spacingNormal),
            InkWell(
              onTap: onImageTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.image_search),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.spacingNormal),
                    child: Text(StringConstants.imageSearch.localized(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height:AppSizes.spacingNormal),
          ],
        ),
      ),
    );
  }
}
