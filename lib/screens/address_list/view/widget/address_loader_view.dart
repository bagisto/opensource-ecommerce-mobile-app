/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/address_list/utils/index.dart';

class AddressLoader extends StatelessWidget {
  final bool ? isFromDashboard;
  const AddressLoader({Key? key, this.isFromDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          (isFromDashboard ?? false)
              ? const SizedBox()
              :  SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              builder: const SizedBox(height: 90,child: Card(color: Colors.red,))),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(4),
            child: SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              items: 6,
              builder: Card(
                child: Container(height: 155,),
              ),),
          ),
        ],
      ),
    );
  }
}
