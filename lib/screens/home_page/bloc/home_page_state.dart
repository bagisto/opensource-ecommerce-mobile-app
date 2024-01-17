import '../../../data_model/account_models/account_info_details.dart';
import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../../data_model/graphql_base_model.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/advertisement_data.dart';
import '../data_model/get_categories_drawer_data_model.dart';
import '../data_model/new_product_data.dart';
import '../data_model/theme_customization.dart';

abstract class HomePageBaseState {}

enum Status { success, fail, loading }

class OnClickLoaderState extends HomePageBaseState {
  final bool? isReqToShowLoader;

  OnClickLoaderState({this.isReqToShowLoader});
}

class ShowLoaderState extends HomePageBaseState {}

class FetchHomeCustomDataState extends HomePageBaseState {
  Status? status;
  String? error;
  ThemeCustomDataModel? homepageSliders;
  int? index;

  FetchHomeCustomDataState.success({this.homepageSliders, this.index})
      : status = Status.success;

  FetchHomeCustomDataState.fail({this.error}) : status = Status.fail;
}

class FetchAllProductsState extends HomePageBaseState {
  Status? status;
  String? error;
  NewProductsModel? allProducts;
  int? index;

  FetchAllProductsState.success({this.allProducts, this.index})
      : status = Status.success;

  FetchAllProductsState.fail({this.error}) : status = Status.fail;
}

class FetchCartCountState extends HomePageBaseState {
  Status? status;
  String? error;
  Advertisements? advertisementData;

  FetchCartCountState.success({
    this.advertisementData,
  }) : status = Status.success;

  FetchCartCountState.fail({this.error}) : status = Status.fail;
}

class CustomerDetailsState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  AccountInfoDetails? accountInfoDetails;

  CustomerDetailsState.success({this.accountInfoDetails, this.successMsg})
      : status = Status.success;

  CustomerDetailsState.fail({this.error}) : status = Status.fail;
}

class FetchAddWishlistHomepageState extends HomePageBaseState {
  Status? status;
  String? successMsg = "";
  String? error = "";
  AddWishListModel? response;
  String? productDeletedId;

  FetchAddWishlistHomepageState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = Status.success;
  FetchAddWishlistHomepageState.fail({this.error}) : status = Status.fail;
}

class RemoveWishlistState extends HomePageBaseState {
  Status? status;
  String? successMsg = "";
  String? error = "";
  GraphQlBaseModel? response;
  String? productDeletedId;

  RemoveWishlistState.success(
      {this.response, this.productDeletedId, this.successMsg})
      : status = Status.success;
  RemoveWishlistState.fail({this.error}) : status = Status.fail;
}

class AddToCompareHomepageState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  GraphQlBaseModel? baseModel;

  AddToCompareHomepageState.success({this.successMsg, this.baseModel})
      : status = Status.success;
  AddToCompareHomepageState.fail({this.error}) : status = Status.fail;
}

class AddToCartState extends HomePageBaseState {
  Status? status;
  String? error;
  String? successMsg;
  AddToCartModel? graphQlBaseModel;

  AddToCartState.success({this.graphQlBaseModel, this.successMsg})
      : status = Status.success;
  AddToCartState.fail({this.error}) : status = Status.fail;
}

class FetchHomeCategoriesState extends HomePageBaseState {
  Status? status;
  String? error;
  GetDrawerCategoriesData? getCategoriesData;
  int? index;

  FetchHomeCategoriesState.success({this.getCategoriesData, this.index})
      : status = Status.success;

  FetchHomeCategoriesState.fail({this.error}) : status = Status.fail;
}
