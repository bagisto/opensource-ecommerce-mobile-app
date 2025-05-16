/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/downloadable_products/utils/index.dart';

import '../data_model/download_product_Image_model.dart';

class DownloadableProductsBloc
    extends Bloc<DownloadableProductsBaseEvent, DownloadableProductsBaseState> {
  DownloadableProductsRepository? repository;

  DownloadableProductsBloc(this.repository)
      : super(DownloadableProductsInitialState()) {
    on<DownloadableProductsBaseEvent>(mapEventToState);
  }
  void mapEventToState(DownloadableProductsBaseEvent event,
      Emitter<DownloadableProductsBaseState> emit) async {
    if (event is DownloadableProductsCustomerEvent) {
      try {
        DownloadableProductModel? productsList = await repository!
            .getDownloadableProductCustomerData(event.page, event.limit,
                title: event.title,
                status: event.status,
                orderId: event.orderId,
                orderDateFrom: event.orderDateFrom,
                orderDateTo: event.orderDateTo);
        if (productsList.status == true) {
          emit(DownloadableProductsCustomerDataState.success(
              productsList: productsList));
        }
      } catch (e) {
        emit(DownloadableProductsCustomerDataState.fail(error: e.toString()));
      }
    } else if (event is DownloadProductEvent) {
      emit(ShowLoaderState());
      try {
        Download? linkData = await repository!.downloadProductLink(event.id);
        if (linkData != null) {
          emit(DownloadProductState.success(downloadLink: linkData));
        } else {
          emit(DownloadProductState.fail(
              error: StringConstants.somethingWrong.localized()));
        }
      } catch (e) {
        emit(DownloadProductState.fail(error: e.toString()));
      }
    } else if (event is DownloadBase64ProductEvent) {
      try {
        DownloadLinkDataModel? linkData =
            await repository?.dataBase64ProductModel(event.id);
        if (linkData?.success == true) {
          emit(DownloadBase64ProductState.success(
              downloadLinkProduct: linkData));
        } else {
          emit(DownloadBase64ProductState.fail(error: linkData?.graphqlErrors));
        }
      } catch (e) {
        emit(DownloadBase64ProductState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
