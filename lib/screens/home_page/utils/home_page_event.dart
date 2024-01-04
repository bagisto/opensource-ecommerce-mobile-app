import 'package:bagisto_app_demo/screens/home_page/bloc/home_page_bloc.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/show_message.dart';
import '../bloc/home_page_event.dart';
import '../data_model/new_product_data.dart';

void homepageEvent(NewProducts? data, HomePageAction type, bool? isLogin, HomePageBloc? homepageBloc,
    BuildContext context) {
  switch (type) {
    case HomePageAction.addToCart:
      if (data != null) {
        var dict = <String, dynamic>{};
        dict[StringConstants.productId] = data.id ?? '';
        dict[StringConstants.quantity] = 1;
        homepageBloc?.add(AddToCartEvent(int.parse(data.id ?? ""), 1, ""));
      }

      break;
    case HomePageAction.fetchDeleteAdd:
      if (isLogin ?? false) {
        if (data != null) {
          homepageBloc?.add(FetchAddWishlistHomepageEvent(data.id, data));
        }
      } else {
        homepageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
        ShowMessage.warningNotification(StringConstants.pleaseLogin.localized(), context);
      }
      break;
    case HomePageAction.addCompare:
      if (isLogin ?? false) {
        if (data != null) {
          homepageBloc?.add(AddToCompareHomepageEvent(data.id, ""));
        }
      } else {
        homepageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
        ShowMessage.warningNotification(StringConstants.pleaseLogin.localized(), context);
      }
      break;
  }
}

enum HomePageAction {
  addToCart,
  fetchDeleteAdd,
  addCompare,
}