

/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/screens/search/event/fetch_search_event.dart';
import 'package:bagisto_app_demo/screens/search/event/search_base_state.dart';
import 'package:bagisto_app_demo/screens/search/repository/search_repository.dart';
import 'package:bagisto_app_demo/screens/search/state/fetch_search_data_state.dart';
import 'package:bagisto_app_demo/screens/search/state/search_base_state.dart';
import 'package:bagisto_app_demo/screens/search/state/search_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/homepage_model/get_categories_drawer_data_model.dart';
import '../event/circular_bar_event.dart';
import '../event/search_text_bar_event.dart';
import '../state/appbar_search_text_state.dart';
import '../state/circular_bar_state.dart';
import '../state/clear_search_text_state.dart';


class SearchBloc extends Bloc<SearchBaseEvent,SearchBaseState>{
  SearchRepository? repository;

  SearchBloc({@required this.repository}):super(SearchInitialState()){
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
        CategoriesProductModel products   = await repository!.callSearchAPi(event.searchQuery,event.order,event.sort);

        emit( FetchSearchDataState.success(products: products));
      }
      catch (e) {
        emit (FetchSearchDataState.fail(error: e.toString()));

      }

    }
    if (event is FetchCategoryPageEvent) {
      try {
        GetDrawerCategoriesData getDrawerCategoriesData = await repository!.getCategoriesList();
        if (getDrawerCategoriesData.responseStatus == true) {
          emit (FetchCategoriesPageDataState.success(getCategoriesData: getDrawerCategoriesData));
        } else {
          emit (FetchCategoriesPageDataState.fail(error: getDrawerCategoriesData.success));
        }
      } catch (e) {
        emit (FetchCategoriesPageDataState.fail(error: "Contact Admin"/*ContactAdmin*/));
      }
    }
  }

}