import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/mobikul_theme.dart';


class CheckoutGuestAddressLoaderView extends StatelessWidget {
  const CheckoutGuestAddressLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
              items: 11,
              builder:
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,0,0,12),
                child: Container(
                  height: AppSizes.spacingWide*3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
