/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/add_review/bloc/add_review_base_event.dart';
import 'package:bagisto_app_demo/screens/add_review/bloc/add_review_fetch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_model/add_review_model.dart';
import 'add_review_repository.dart';

class AddReviewBloc extends Bloc<AddReviewBaseEvent, AddReviewBaseState> {
  AddReviewRepository? repository;

  AddReviewBloc(this.repository) : super(AddReviewInitialState()){
    on<AddReviewBaseEvent>(mapEventToState);
  }

  void mapEventToState(AddReviewBaseEvent event,Emitter<AddReviewBaseState> emit) async{
    if (event is AddReviewFetchEvent) {
      try {
        AddReviewModel addReviewModel = await repository!.callAddReviewApi(event.name??"",event.title??"",event.rating??0,event.comment??"",event.productId??0,
        event.attachments);

        emit (AddReviewFetchState.success(addReviewModel: addReviewModel));
      } catch (e) {
        emit (AddReviewFetchState.fail(
            error: "e.toString()===>${e.toString()}"));
      }
    }else if(event is ImagePickerEvent){
      emit (ImagePickerState(event.image));
    }
  }
}
