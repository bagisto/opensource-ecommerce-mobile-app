// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../configuration/app_sizes.dart';
import '../../../models/categories_data_model/categories_product_model.dart';

class EmptySearchScreen extends StatelessWidget {
  CategoriesProductModel ? model;

  EmptySearchScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ((model?.data ?? []).isEmpty) ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme
                  .of(context)
                  .colorScheme
                  .onPrimary,
              BlendMode.srcIn,
            ),
            child: LottieBuilder.asset(
              "assets/lottie/empty_catalog.json",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: AppSizes.widgetHeight,
          ),
          Text(
            "EmptyPageGenericLabel".localized(),
            softWrap: true,
          ),
        ],
      ),
    ) : Container();
  }
}
