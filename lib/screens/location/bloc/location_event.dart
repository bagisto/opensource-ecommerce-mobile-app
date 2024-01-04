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

