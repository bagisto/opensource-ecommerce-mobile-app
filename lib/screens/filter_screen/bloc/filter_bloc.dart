
// ignore_for_file: file_names


import 'package:bagisto_app_demo/models/categories_data_model/filter_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/filter_event.dart';
import '../repository/filter_repository.dart';
import '../state/filter_state.dart';


class FilterBloc extends Bloc<FilterBaseEvent, FilterBaseState> {
  FilterRepository? repository;
  bool isLoading = false;

  FilterBloc({@required this.repository, required BuildContext context}) : super(FilterInitialState()){
    on<FilterBaseEvent>(mapEventToState);
  }
  void mapEventToState(FilterBaseEvent event,Emitter<FilterBaseState> emit ) async{
    if  (event is FilterSortFetchEvent) {
      try {
        GetFilterAttribute  filterModel = await repository!.getFilterProducts(event.categorySlug ?? "");
        if (filterModel.status == true) {
          emit (FilterFetchState.success(filterModel: filterModel));
        }  else {
          emit( FilterFetchState.fail(error: filterModel.success??""));
        }
      } catch (e) {
        emit (FilterFetchState.fail(error: e.toString()));
      }
    }
  }
}