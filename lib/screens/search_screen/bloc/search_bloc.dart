/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/search_screen/utils/index.dart';


class SearchBloc extends Bloc<SearchBaseEvent,SearchBaseState>{
  SearchRepository? repository;

  SearchBloc(this.repository):super(SearchInitialState()){
    on<SearchBaseEvent>(mapEventToState);
  }

  void mapEventToState(SearchBaseEvent event,Emitter<SearchBaseState> emit) async{

    if (event is SearchBarTextEvent) {
      if (event.searchText!.isEmpty) {
        emit (ClearSearchBarTextState());
      } else {
        emit (AppBarSearchTextState(searchText: event.searchText));
      }
    }
    else if(event is CircularBarEvent){
      emit (CircularBarState(isReqToShowLoader: event.isReqToShowLoader));
    }
    if (event is FetchSearchEvent) {
      try {
        NewProductsModel? products = await repository?.callSearchAPi(event.filters);

        emit( FetchSearchDataState.success(products: products));
      }
      catch (e) {
        emit (FetchSearchDataState.fail(error: e.toString()));

      }

    }
    if (event is FetchCategoryPageEvent) {
      try {
        GetDrawerCategoriesData? getDrawerCategoriesData = await repository?.getCategoriesList(filters: event.filters);
        if (getDrawerCategoriesData?.responseStatus == true) {
          emit (FetchCategoriesPageDataState.success(getCategoriesData: getDrawerCategoriesData));
        } else {
          emit (FetchCategoriesPageDataState.fail(error: getDrawerCategoriesData?.success));
        }
      } catch (e) {
        emit (FetchCategoriesPageDataState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }

}