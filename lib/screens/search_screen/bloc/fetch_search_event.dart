/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


abstract class SearchBaseEvent {}

class FetchSearchEvent extends SearchBaseEvent {
  List<Map<String, dynamic>> filters;
  FetchSearchEvent(this.filters);

}

class FetchCategoryPageEvent extends SearchBaseEvent {
  int? categoryId;

  FetchCategoryPageEvent(this.categoryId);
}

class CircularBarEvent extends SearchBaseEvent{
  final bool? isReqToShowLoader;
  CircularBarEvent({this.isReqToShowLoader});
}

class SearchBarTextEvent extends SearchBaseEvent {

  final String? searchText;
  SearchBarTextEvent({this.searchText});
}
