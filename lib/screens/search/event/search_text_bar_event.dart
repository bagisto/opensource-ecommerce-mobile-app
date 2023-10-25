
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


import 'search_base_state.dart';

class SearchBarTextEvent extends SearchBaseEvent {

  String? searchText;
  SearchBarTextEvent({this.searchText});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
