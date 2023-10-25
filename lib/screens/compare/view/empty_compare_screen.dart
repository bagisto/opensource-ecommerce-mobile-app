import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../configuration/app_sizes.dart';

class EmptyCompareScreen extends StatelessWidget {
  const EmptyCompareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcIn,
            ),

            child: LottieBuilder.asset(
              "assets/lottie/empty_order_list.json",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: AppSizes.widgetSidePadding,
          ),
          Text(
            "EmptyPageGenericLabel".localized(),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
