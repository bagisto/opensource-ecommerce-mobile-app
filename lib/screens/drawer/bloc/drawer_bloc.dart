/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names

import 'package:bagisto_app_demo/models/homepage_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/screens/drawer/events/drawer_base_event.dart';
import 'package:bagisto_app_demo/screens/drawer/events/fetch_drawer_event.dart';
import 'package:bagisto_app_demo/screens/drawer/repository/drawer_repository.dart';
import 'package:bagisto_app_demo/screens/drawer/state/drawer_base_state.dart';
import 'package:bagisto_app_demo/screens/drawer/state/fetch_drawer_state.dart';
import 'package:bagisto_app_demo/screens/drawer/state/drawer_initial_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DrawerBloc extends Bloc<DrawerEvent, DrawerPageBaseState> {
  DrawerPageRepository? repository;

  DrawerBloc({@required this.repository}) : super(InitialState()){
    on<DrawerEvent>(mapEventToState);
  }

  void mapEventToState(DrawerEvent event,Emitter<DrawerPageBaseState> emit) async {
    if (event is FetchDrawerPageEvent) {
      try {
        GetDrawerCategoriesData getDrawerCategoriesData = await repository!.getDrawerCategoriesList();
        if (getDrawerCategoriesData.responseStatus == true) {
          emit (FetchDrawerPageDataState.success(getCategoriesDrawerData: getDrawerCategoriesData));
        } else {
          emit (FetchDrawerPageDataState.fail(error: getDrawerCategoriesData.success));
        }
      } catch (e) {
        emit (FetchDrawerPageDataState.fail(error: "Contact Admin"/*ContactAdmin*/));
      }
    }
  }

}