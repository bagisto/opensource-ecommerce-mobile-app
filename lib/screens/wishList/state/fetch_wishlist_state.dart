
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/screens/wishList/state/wishlist_base_state.dart';

import '../../../models/wishlist_model/wishlist_model.dart';

class FetchDataState extends WishListBaseState {
  //T data;
  WishListStatus? status;
  String? error;
  WishListData? wishListProducts;

  FetchDataState.success({this.wishListProducts}) : status = WishListStatus.success;

  FetchDataState.fail({this.error}) : status = WishListStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [wishListProducts!];
}
