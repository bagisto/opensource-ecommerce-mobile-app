/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

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
