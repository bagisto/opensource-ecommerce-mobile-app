import 'package:equatable/equatable.dart';

abstract class GdprEvent extends Equatable {
  const GdprEvent();

  @override
  List<Object> get props => [];
}

class FetchGdprRequestsList extends GdprEvent {}

class CreateGdprRequest extends GdprEvent {
  final Enum type;
  final String message;

  const CreateGdprRequest({
    required this.type,
    required this.message,
  });

  @override
  List<Object> get props => [type, message];
}

class RevokeGdprRequest extends GdprEvent {
  final int id;

  const RevokeGdprRequest({required this.id});

  @override
  List<Object> get props => [id];
}

class GdprSearchRequest extends GdprEvent {
  final int id;

  const GdprSearchRequest({required this.id});

  @override
  List<Object> get props => [id];
}

class GdprPdfRequest extends GdprEvent {
  const GdprPdfRequest();

  @override
  List<Object> get props => [];
}
