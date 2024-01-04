import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../../utils/index.dart';

class OrderDetailLoader extends StatelessWidget {
  const OrderDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 90,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 120,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 250,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              builder: Container(
                margin: const EdgeInsets.only(bottom: 1),
                color: Colors.red,
                height: 220,
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
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
