import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../../utils/mobikul_theme.dart';

class CheckoutOrderReviewLoaderView extends StatelessWidget {
  const CheckoutOrderReviewLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              items: 3,
              builder: const SizedBox(
                  height: 160,
                  child: Card(
                    color: Colors.red,
                  ))),
          const SizedBox(
            height: 4,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              builder: const SizedBox(
                  height: 125,
                  child: Card(
                    color: Colors.red,
                  ))),
          const SizedBox(
            height: 4,
          ),
          const SkeletonLoader(
              builder: SizedBox(
                  height: 200,
                  child: Card(
                    color: Colors.red,
                  ))),
        ],
      ),
    );
  }
}
