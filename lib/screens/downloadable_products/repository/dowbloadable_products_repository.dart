// ignore_for_file: file_names, avoid_print

import '../../../models/downloadable_products/download_product_model.dart';
import '../../../models/downloadable_products/downloadable_product_model.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../../../api/api_client.dart';

abstract class DownloadableProductsRepository {
  Future<DownloadableProductModel> getDownloadableProductCustomerData(int page, int limit);
  Future<DownloadLink> downloadProductLink(int id);
}

class DownloadableProductsRepositoryImp
    implements DownloadableProductsRepository {

  @override
  Future<DownloadableProductModel> getDownloadableProductCustomerData(int page, int limit) async{
    DownloadableProductModel? productData;

    try {
      productData = await ApiClient().getCustomerDownloadableProducts(page, limit);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return productData!;

  }

  @override
  Future<DownloadLink> downloadProductLink(int id) async{
    DownloadLink? downloadLink;

    try {
      downloadLink = await ApiClient().downloadLinksProduct(id);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return downloadLink!;
  }
}
