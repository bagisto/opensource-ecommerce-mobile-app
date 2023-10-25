// ignore_for_file: file_names, must_be_immutable

import 'package:equatable/equatable.dart';
import '../../../models/categories_data_model/filter_product_model.dart';


abstract class FilterBaseState extends Equatable {}

enum FilterStatus { success, fail }

class FilterInitialState extends FilterBaseState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FilterFetchState extends FilterBaseState {
  FilterStatus? status;
  String? error;
  GetFilterAttribute? filterModel;

  FilterFetchState.success({this.filterModel})
      : status = FilterStatus.success;

  FilterFetchState.fail({this.error}) : status = FilterStatus.fail;

  @override
  // TODO: implement props
  List<Object> get props => [if (filterModel != null) filterModel! else ""];
}
