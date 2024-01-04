
import 'package:equatable/equatable.dart';
import '../../../data_model/categories_data_model/filter_product_model.dart';

abstract class FilterBaseState extends Equatable {}

enum FilterStatus { success, fail }

class FilterInitialState extends FilterBaseState {
  @override
  List<Object> get props => [];
}

class FilterFetchState extends FilterBaseState {
  final FilterStatus? status;
  final String? error;
  final GetFilterAttribute? filterModel;

  FilterFetchState.success({this.error, this.filterModel})
      : status = FilterStatus.success;

  FilterFetchState.fail({this.error, this.filterModel}) : status = FilterStatus.fail;

  @override
  List<Object> get props => [if (filterModel != null) filterModel! else ""];
}
