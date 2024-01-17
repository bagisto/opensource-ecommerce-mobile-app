import '../screens/address_list/data_model/address_model.dart';
import '../screens/cart_screen/bloc/cart_screen_bloc.dart';
import '../screens/cart_screen/cart_model/cart_data_model.dart';

class CategoriesArguments {
  String? title;
  String? image;
  String? categorySlug;
  String? id;
  String? metaDescription;

  CategoriesArguments(
      {this.title, this.categorySlug, this.image, this.metaDescription, this.id});
}

///class use to pass data on cms screens
class CmsDataContent {
  String? title;
  int? id;
  int? index;

  CmsDataContent({
    this.title,
    this.id,
    this.index,
  });
}

///class used to send data on edit/add screen
class AddressNavigationData {
  bool? isEdit;
  AddressData? addressModel;
  bool? isCheckout;

  AddressNavigationData({this.isEdit, this.addressModel, this.isCheckout});
}

///class used to send data on checkout
class CartNavigationData {
  String? total;
  CartModel? cartDetailsModel;
  CartScreenBloc? cartScreenBloc;
  bool? isDownloadable;

  CartNavigationData(
      {this.total,
      this.cartDetailsModel,
      this.cartScreenBloc,
      this.isDownloadable});
}

//add review data
class AddReviewDetail {
  String? imageUrl;
  String? productId;
  String? productName;

  AddReviewDetail({this.imageUrl, this.productId, this.productName});
}
