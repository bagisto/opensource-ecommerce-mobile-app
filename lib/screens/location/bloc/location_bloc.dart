import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagisto_app_demo/screens/location/utils/index.dart';

class LocationScreenBloc
    extends Bloc<LocationScreenEvent, LocationScreenState> {
  LocationRepositoryImp? repository;

  LocationScreenBloc({this.repository}) : super(LocationScreenInitialState()) {
    on<LocationScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      LocationScreenEvent event, Emitter<LocationScreenState> emit) async {
    if (event is SearchPlaceEvent) {
      emit(LocationScreenLoadingState());
      try {
        var model = await repository?.getPlace(event.query);
        if (model != null) {
          emit(SearchPlaceSuccessState(model));
        } else {
          emit(SearchPlaceErrorState(''));
        }
      } catch (error, _) {
        emit(SearchPlaceErrorState(error.toString()));
      }
    } else if (event is SearchPlaceInitialEvent) {
      emit(LocationScreenInitialState());
    }
  }
}
