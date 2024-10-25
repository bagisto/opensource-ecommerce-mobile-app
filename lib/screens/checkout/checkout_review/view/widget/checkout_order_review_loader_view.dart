/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

class CheckoutOrderReviewLoaderView extends StatelessWidget {
  const CheckoutOrderReviewLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              items: 3,
              builder: const SizedBox(
                  height: 160,
                  child: Card(
                    color: Colors.red,
                  ))),
          const SizedBox(
            height: 4,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: const SizedBox(
                  height: 125,
                  child: Card(
                    color: Colors.red,
                  ))),
          const SizedBox(
            height: 4,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              builder: const SizedBox(
                  height: 200,
                  child: Card(
                    color: Colors.red,
                  ))),
        ],
      ),
    );
  }
}
