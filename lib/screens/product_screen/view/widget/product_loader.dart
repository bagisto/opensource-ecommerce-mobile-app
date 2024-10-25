/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class ProductDetailLoader extends StatelessWidget {
  const ProductDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
    Column(children: [
      SkeletonLoader( highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).scaffoldBackgroundColor,builder: Container(margin:const EdgeInsets.only(bottom: 8),color: Colors.red,height: AppSizes.screenHeight/1.9,)),
      SkeletonLoader( highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          items:6,builder: Container(margin:const EdgeInsets.only(bottom: 8),color: Colors.red,height:150,)),
    ],),);

  }
}
