

// ignore_for_file: must_be_immutable

import 'package:bagisto_app_demo/screens/sub_categories/events/sub_categories_base_event.dart';


class OnClickSubCategoriesLoaderEvent extends SubCategoryBaseEvent{
  final bool? isReqToShowLoader;
  OnClickSubCategoriesLoaderEvent({this.isReqToShowLoader});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}
class FilterFetchEvent extends SubCategoryBaseEvent {
  String ? categorySlug;
  FilterFetchEvent(this.categorySlug);

  // int? carouselIndex;
  @override
  // TODO: implement props
  List<Object> get props => [];
}
