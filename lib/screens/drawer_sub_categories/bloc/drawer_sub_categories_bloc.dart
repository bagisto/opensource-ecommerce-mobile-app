import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/string_constants.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import 'drawer_sub_categories_event.dart';
import 'drawer_sub_categories_repository.dart';
import 'drawer_sub_categories_state.dart';

class DrawerSubCategoriesBloc extends Bloc<DrawerSubCategoriesEvent, DrawerSubCategoriesState>{
  DrawerSubCategoryRepo? repository;

  DrawerSubCategoriesBloc(this.repository) : super(DrawerSubCategoryInitialState()){
    on<DrawerSubCategoriesEvent>(mapEventToState);
  }

  void mapEventToState(DrawerSubCategoriesEvent event, Emitter<DrawerSubCategoriesState> emit) async {
    if(event is FetchDrawerSubCategoryEvent){
      emit(DrawerSubCategoryInitialState());
      try {
        GetDrawerCategoriesData? data =
        await repository?.getDrawerSubCategories(id: event.categoryId);
        emit(FetchDrawerSubCategoryState.success(getCategoriesData: data));
      } catch (e) {
        emit(
            FetchDrawerSubCategoryState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}