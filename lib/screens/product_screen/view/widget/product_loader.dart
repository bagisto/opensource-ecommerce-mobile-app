import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';

class ProductDetailLoader extends StatelessWidget {
  const ProductDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
    Column(children: [
      SkeletonLoader( highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,builder: Container(margin:const EdgeInsets.only(bottom: 8),color: Colors.red,height: AppSizes.screenHeight/1.9,)),
      SkeletonLoader( highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,items:6,builder: Container(margin:const EdgeInsets.only(bottom: 8),color: Colors.red,height:150,)),
    ],),);

  }
}
