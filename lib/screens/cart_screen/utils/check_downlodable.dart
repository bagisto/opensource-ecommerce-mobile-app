/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import '../../../utils/string_constants.dart';
import '../cart_model/cart_data_model.dart';

bool checkVirtualDownloadable(List<Items>? items) {
  for (Items product in (items ?? [])) {
    if (product.type?.toLowerCase() !=
            StringConstants.downloadable.toLowerCase() &&
        (product.type?.toLowerCase() !=
            StringConstants.virtual.toLowerCase()) &&
        product.type?.toLowerCase() != StringConstants.booking.toLowerCase()) {
      return false;
    }
  }
  return true;
}

bool checkDownloadable(List<Items>? items) {
  for (Items product in (items ?? [])) {
    if (product.type?.toLowerCase() ==
        StringConstants.downloadable.toLowerCase()) {
      return true;
    }
  }
  return false;
}
