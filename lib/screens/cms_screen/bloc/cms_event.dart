import 'package:equatable/equatable.dart';
abstract class CmsBaseEvent extends Equatable{}

class FetchCmsDataEvent extends CmsBaseEvent {
  final String? id;
  FetchCmsDataEvent(this.id);

  @override
  List<Object> get props => [];
}