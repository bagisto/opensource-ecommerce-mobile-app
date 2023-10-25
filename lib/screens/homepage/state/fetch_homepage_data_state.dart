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

import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';

import '../../../models/cms_model/cms_model.dart';
import '../../../models/homepage_model/new_product_data.dart';
import 'hoempage_base_state.dart';


class FetchHomepageSlidersState extends HomePageBaseState {
  Status? status;
  String? error;
  HomeSlidersData? homepageSliders;
  int? index;

  FetchHomepageSlidersState.success({this.homepageSliders, this.index})
      : status = Status.success;

  FetchHomepageSlidersState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (homepageSliders != null) homepageSliders! else ""];
}

class FetchAdvertisementState extends HomePageBaseState {
  Status? status;
  String? error;
  Advertisements? advertisementData;
  int? index;

  FetchAdvertisementState.success({this.advertisementData, this.index})
      : status = Status.success;

  FetchAdvertisementState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (advertisementData != null) advertisementData! else ""];
}

class FetchCartCountState extends HomePageBaseState {
  Status? status;
  String? error;
  Advertisements? advertisementData;

  FetchCartCountState.success({this.advertisementData, })
      : status = Status.success;

  FetchCartCountState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (advertisementData != null) advertisementData! else ""];
}

class NewProductDataState extends HomePageBaseState {
  Status? status;
  String? error;
  NewProductsModel? newProductsModel;
  int? index;

  NewProductDataState.success({this.newProductsModel, this.index})
      : status = Status.success;

  NewProductDataState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (newProductsModel != null) newProductsModel! else ""];
}

class FeaturedProductDataState extends HomePageBaseState {
  Status? status;
  String? error;
  NewProductsModel? newProductsModel;
  int? index;

  FeaturedProductDataState.success({this.newProductsModel, this.index}) : status = Status.success;

  FeaturedProductDataState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (newProductsModel != null) newProductsModel! else ""];
}
class FetchLanguageCurrencyState extends HomePageBaseState {
  Status? status;
  String? error;
  CurrencyLanguageList? currencyLanguageList;

  FetchLanguageCurrencyState.success({this.currencyLanguageList,})
      : status = Status.success;

  FetchLanguageCurrencyState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props =>
      [if (currencyLanguageList != null) currencyLanguageList! else ""];
}


class FetchCMSDataState extends HomePageBaseState {
  Status? status;
  String? error;
  CmsData? cmsData;

  FetchCMSDataState.success({this.cmsData}) : status = Status.success;

  FetchCMSDataState.fail({this.error}) : status = Status.fail;

  // TODO: implement props
  List<Object> get props => [if (cmsData !=null) cmsData! else ""];
}
