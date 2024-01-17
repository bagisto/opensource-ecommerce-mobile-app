import '../../../utils/string_constants.dart';
import '../cart_model/cart_data_model.dart';

bool checkVirtualDownloadable(List<Items>? items) {
  for (Items product in (items ?? [])) {
    if (product.type?.toLowerCase() != StringConstants.downloadable.toLowerCase() &&
        (product.type?.toLowerCase() != StringConstants.virtual.toLowerCase())) {
      return false;
    }
  }
  return true;
}

bool checkDownloadable(List<Items>? items) {
  for (Items product in (items ?? [])) {
    if (product.type?.toLowerCase() == StringConstants.downloadable.toLowerCase()) {
      return true;
    }
  }
  return false;
}