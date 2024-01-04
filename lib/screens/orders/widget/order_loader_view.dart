import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../utils/index.dart';

class OrderLoader extends StatelessWidget {
  const OrderLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SkeletonLoader(
          highlightColor: Theme.of(context).highlightColor,
          baseColor: Theme.of(context).appBarTheme.backgroundColor ??
              MobikulTheme.primaryColor,
          items: 6,
          builder: Card(
            child: Container(
              height: 180,
            ),
          ),
        ),
      ),
    );
  }
}
