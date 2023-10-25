
import '../../../models/downloadable_products/download_product_model.dart';
import '../../../models/downloadable_products/downloadable_product_model.dart';
import '../../cart_screen/view/cart_index.dart';
import '../events/downloadable_products_events.dart';
import '../repository/dowbloadable_products_repository.dart';
import '../state/downlaodable_products_state.dart';

class DownloadableProductsBloc extends Bloc<DownloadableProductsBaseEvent, DownloadableProductsBaseState> {
  DownloadableProductsRepository? repository;
  bool isLoading = false;

  DownloadableProductsBloc({@required this.repository}) : super(DownloadableProductsInitialState()){
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