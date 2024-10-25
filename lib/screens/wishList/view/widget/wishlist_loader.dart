/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/wishList/utils/index.dart';


class WishListLoader extends StatelessWidget {
  const WishListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
        child: SkeletonGridLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          items: 10,
          builder:const Card(color: Colors.red,margin: EdgeInsets.zero,),childAspectRatio:0.6,mainAxisSpacing: 8,),
      ),
    );
  }
}
