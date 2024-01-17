import '../../home_page/data_model/get_categories_drawer_data_model.dart';

abstract class DrawerSubCategoriesState{}

enum Status {success, fail}

class DrawerSubCategoryInitialState extends DrawerSubCategoriesState {}

class FetchDrawerSubCategoryState extends DrawerSubCategoriesState {
  Status? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;

  FetchDrawerSubCategoryState.success({this.getCategoriesData}) : status = Status.success;

  FetchDrawerSubCategoryState.fail({this.error}) : status = Status.fail;
}
