
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data_model/categories_data_model/filter_product_model.dart';
import '../../../utils/string_constants.dart';
import 'filter_event.dart';
import 'filter_repository.dart';
import 'filter_state.dart';


class FilterBloc extends Bloc<FilterBaseEvent, FilterBaseState> {
  FilterRepository? repository;

  FilterBloc(this.repository) : super(FilterInitialState()){
    on<FilterBaseEvent>(mapEventToState);
  }
  void mapEventToState(FilterBaseEvent event,Emitter<FilterBaseState> emit) async{
    if  (event is FilterSortFetchEvent) {
      try {
        GetFilterAttribute? filterModel = await repository?.getFilterProducts(event.categorySlug ?? "");
        if (filterModel?.status == true) {
          emit (FilterFetchState.success(filterModel: filterModel));
        }  else {
          emit( FilterFetchState.fail(error: filterModel?.success??""));
        }
      } catch (e) {
        emit (FilterFetchState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}