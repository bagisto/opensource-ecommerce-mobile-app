/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/order_detail/utils/index.dart';



class OrderDetailLoader extends StatelessWidget {
  const OrderDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 90,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 120,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 250,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 220,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 300,
              )),
        ],
      ),
    );
  }
}
