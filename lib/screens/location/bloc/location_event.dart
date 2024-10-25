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

abstract class LocationScreenEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class SearchPlaceInitialEvent extends LocationScreenEvent{}

class SearchPlaceEvent extends LocationScreenEvent{
  final String query;
  SearchPlaceEvent(this.query);
}

