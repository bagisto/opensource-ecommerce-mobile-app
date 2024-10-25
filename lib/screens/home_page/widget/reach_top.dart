/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/utils/index.dart';


Widget buildReachBottomView(
    BuildContext context, ScrollController scrollController) {
  return Container(
    color: Theme.of(context).colorScheme.secondaryContainer,
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(
      top: AppSizes.spacingMedium,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(StringConstants.youHaveReachedToTheBottomOfThePage.localized(),
            style: Theme.of(context).textTheme.bodySmall),
        TextButton(
            onPressed: () {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: Text(StringConstants.backToTop.localized(), style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.blue
            ))),
      ],
    ),
  );
}
