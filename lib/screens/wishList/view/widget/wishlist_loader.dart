import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../utils/mobikul_theme.dart';


class WishListLoader extends StatelessWidget {
  const WishListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
        child: SkeletonGridLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
          items: 10,
          builder:const Card(color: Colors.red,margin: EdgeInsets.zero,),childAspectRatio:0.6,mainAxisSpacing: 8,),
      ),
    );
  }
}
