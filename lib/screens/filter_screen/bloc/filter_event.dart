
import 'package:equatable/equatable.dart';

abstract class FilterBaseEvent extends Equatable {}

class FilterSortFetchEvent extends FilterBaseEvent {
  final String ? categorySlug;
  FilterSortFetchEvent(this.categorySlug);

  @override
  List<Object> get props => [];
}
