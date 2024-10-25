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

class CheckoutAddressLoaderView extends StatelessWidget {
  const CheckoutAddressLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              items:3,
              builder: const Padding(
                padding: EdgeInsets.fromLTRB(0,12.0,0,0),
                child: SizedBox(
                  height: 225,
                  child: Card(color: Colors.red,margin: EdgeInsets.zero,),
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
