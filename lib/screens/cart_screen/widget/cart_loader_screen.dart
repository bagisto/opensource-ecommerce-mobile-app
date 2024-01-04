import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../utils/mobikul_theme.dart';

class CartLoaderView extends StatelessWidget {
  const CartLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                SkeletonLoader(
                    highlightColor: Theme.of(context).highlightColor,
                    baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                        MobikulTheme.primaryColor,
                    builder: const SizedBox(
                        height: 270,
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
                SkeletonLoader(
                    items: 3,
                    builder: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: const Card(
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
                        height: 170,
                        child: Card(
                          color: Colors.red,
                        ))),
              ],
            ),
          ),
        ),
         SkeletonLoader(
            highlightColor: Theme.of(context).highlightColor,
            baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
            builder: const SizedBox(
                height: 70,
                child: Card(
                  color: Colors.red,
                ))),
      ],
    );
  }
}
