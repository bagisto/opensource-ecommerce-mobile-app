
/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/notification_model/notification_model.dart';
import 'notification_event.dart';
import 'notification_repository.dart';
import 'notification_state.dart';


class NotificationScreenBloc extends Bloc<NotificationScreenEvent, NotificationScreenState> {
  NotificationRepository? repository;

  NotificationScreenBloc({this.repository}) : super(NotificationInitial()) {
    on<NotificationScreenEvent>(mapEventToState);
  }

  void mapEventToState(
      NotificationScreenEvent event, Emitter<NotificationScreenState> emit) async {
    if (event is NotificationFetchEvent) {
      try {
        NotificationListModel? model = await repository?.getNotificationData();
        if (model != null) {
          emit( NotificationSuccess(model));
        } else {
          emit(NotificationError(''));
        }
      } catch (error, _) {
        emit(NotificationError(error.toString()));
      }
    }

  }
}