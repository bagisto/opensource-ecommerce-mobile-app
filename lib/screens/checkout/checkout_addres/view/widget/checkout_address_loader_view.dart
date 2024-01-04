import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../../../../../utils/mobikul_theme.dart';


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
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
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
