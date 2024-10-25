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


class CheckoutGuestAddressLoaderView extends StatelessWidget {
  const CheckoutGuestAddressLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12,),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              items: 11,
              builder:
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,0,0,12),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
