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

import 'package:bagisto_app_demo/screens/product_screen/state/product_base_state.dart';

import '../../../models/product_model/product_screen_model.dart';


class FetchProductState extends ProductBaseState {

  ProductStatus? status;
  String? error;
  Product? productData;

  FetchProductState.success({this.productData}) : status = ProductStatus.success;

  FetchProductState.fail({this.error}) : status = ProductStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (productData !=null) productData! else ""];}
