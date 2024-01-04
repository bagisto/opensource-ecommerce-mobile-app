
import '../../../services/api_client.dart';
import '../data_model/download_product_model.dart';
import '../data_model/downloadable_product_model.dart';
import 'package:flutter/material.dart';

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
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return productData!;

  }

  @override
  Future<DownloadLink> downloadProductLink(int id) async{
    DownloadLink? downloadLink;

    try {
      downloadLink = await ApiClient().downloadLinksProduct(id);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return downloadLink!;
  }
}
