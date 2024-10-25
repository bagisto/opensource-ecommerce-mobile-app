/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/home_page/utils/index.dart';

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