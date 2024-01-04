import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../../utils/index.dart';
import '../../../../utils/mobikul_theme.dart';

class AddressLoader extends StatelessWidget {
  final bool ? isFromDashboard;
  const AddressLoader({Key? key, this.isFromDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          (isFromDashboard ?? false)
              ? Container()
              :  SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
              builder: const SizedBox(height: 90,child: Card(color: Colors.red,))),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(4),
            child: SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
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
