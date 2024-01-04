import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../utils/mobikul_theme.dart';

class SubCategoriesLoader extends StatelessWidget {
  const SubCategoriesLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).colorScheme.primary,
              builder: Padding(
                padding:  const EdgeInsets.fromLTRB(AppSizes.spacingNormal,AppSizes.spacingNormal,AppSizes.spacingNormal,0),
                child: Container(
                  height: 400,
                  color: Colors.red,
                ),
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
              builder: Padding(
                padding:  const EdgeInsets.all(AppSizes.spacingNormal),
                child: Container(
                  height: AppSizes.spacingWide*3,
                  color: Colors.red,
                ),
              )),
           Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spacingNormal,0,AppSizes.spacingNormal,0),
            child: SkeletonGridLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
              items: 10,
              builder:const Card(color: Colors.red,margin: EdgeInsets.zero,),childAspectRatio:0.5,mainAxisSpacing: 4,crossAxisSpacing: 4,),
          )
        ],
      ),
    );
  }
}
