/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:equatable/equatable.dart';
import 'package:bagisto_app_demo/screens/location/utils/index.dart';

abstract class LocationScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationScreenInitialState extends LocationScreenState {}

class LocationScreenLoadingState extends LocationScreenState {}

class SearchPlaceSuccessState extends LocationScreenState {
  final GooglePlaceModel data;

  SearchPlaceSuccessState(this.data);
}

class SearchPlaceErrorState extends LocationScreenState {
  final String message;

  SearchPlaceErrorState(this.message);
}

class CompleteState extends LocationScreenState {}
