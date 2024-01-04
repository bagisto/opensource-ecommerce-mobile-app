import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

Widget wishlistIcon(BuildContext context, bool? isInWishlist){
  return Container(
    padding: const EdgeInsets.all(AppSizes.spacingNormal),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme.primary,
      borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.spacingSmall)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child:
    isInWishlist ??
        false
        ? Icon(
      Icons.favorite,
      color: Theme.of(context)
          .colorScheme
          .onBackground,
      size: 16,
    )
        : Icon(
      Icons.favorite_border,
      size: 16,
      color: Theme.of(context)
          .colorScheme
          .onBackground,
    ),
  );
}

Widget compareIcon(BuildContext context){
  return Container(
    padding: const EdgeInsets.all(AppSizes.spacingNormal),
    margin: const EdgeInsets.only(top: AppSizes.spacingNormal),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .primary,
      borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.spacingSmall)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Image.asset(
      "assets/images/compare-icon.png",
      height: 18,
      width: 18,
      color: Theme.of(context).colorScheme.onBackground,
    ),
  );
}