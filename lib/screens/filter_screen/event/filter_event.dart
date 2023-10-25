// ignore_for_file: file_names, must_be_immutable

import 'package:equatable/equatable.dart';

abstract class FilterBaseEvent extends Equatable {}

class FilterSortFetchEvent extends FilterBaseEvent {
  String ? categorySlug;
  FilterSortFetchEvent(this.categorySlug);
  @override
  // TODO: implement props
  List<Object> get props => [];
}
