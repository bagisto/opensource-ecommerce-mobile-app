

import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downloadable_products_events.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/dowbloadable_products_repository.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downlaodable_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_model/download_product_model.dart';
import '../data_model/downloadable_product_model.dart';


class DownloadableProductsBloc extends Bloc<DownloadableProductsBaseEvent, DownloadableProductsBaseState> {
  DownloadableProductsRepository? repository;

  DownloadableProductsBloc(this.repository) : super(DownloadableProductsInitialState()){
    on<DownloadableProductsBaseEvent>(mapEventToState);
  }
  void mapEventToState(DownloadableProductsBaseEvent event,Emitter<DownloadableProductsBaseState> emit ) async{
    if(event is DownloadableProductsCustomerEvent) {
      try {
        DownloadableProductModel? productsList = await repository!.getDownloadableProductCustomerData(event.page, event.limit);
        if (productsList.status == true) {
          emit (DownloadableProductsCustomerDataState.success(productsList: productsList));
        }  else {
          emit( DownloadableProductsCustomerDataState.fail(error: productsList.success??""));
        }
      } catch (e) {
        emit (DownloadableProductsCustomerDataState.fail(error: e.toString()));
      }
    }
    else  if(event is DownloadProductEvent) {
      try {
        DownloadLink? linkData = await repository!.downloadProductLink(event.id);
        if (linkData.status == true) {
          emit (DownloadProductState.success(downloadLink: linkData));
        }  else {
          emit( DownloadProductState.fail(error: linkData.success??""));
        }
      } catch (e) {
        emit (DownloadProductState.fail(error: e.toString()));
      }
    }
  }


}