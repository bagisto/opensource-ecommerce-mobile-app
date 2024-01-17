/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_model/currency_language_model.dart';
import '../../../utils/string_constants.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../../home_page/data_model/get_categories_drawer_data_model.dart';
import 'drawer_events.dart';
import 'drawer_repository.dart';
import 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerPageBaseState> {
  DrawerPageRepository? repository;

  DrawerBloc({this.repository}) : super(InitialState()) {
    on<DrawerEvent>(mapEventToState);
  }

  void mapEventToState(
      DrawerEvent event, Emitter<DrawerPageBaseState> emit) async {
    if (event is FetchDrawerPageEvent) {
      try {
        GetDrawerCategoriesData? getDrawerCategoriesData =
        await repository?.getDrawerCategoriesList(event.categoryId);
        if (getDrawerCategoriesData?.responseStatus == true) {
          emit(FetchDrawerPageDataState.success(
              getCategoriesDrawerData: getDrawerCategoriesData));
        } else {
          emit(FetchDrawerPageDataState.fail(
              error: getDrawerCategoriesData?.success));
        }
      }
     catch (e) {
        emit(FetchDrawerPageDataState.fail(
            error: StringConstants.contactAdmin.localized()));
      }
    }
    if (event is CurrencyLanguageEvent) {
      try {
        CurrencyLanguageList? currencyLanguageList = await repository?.getLanguageCurrencyList();
        if (currencyLanguageList?.status == true) {
          emit(FetchLanguageCurrencyState.success(
            currencyLanguageList: currencyLanguageList,
          ));
        } else {
          emit(FetchLanguageCurrencyState.fail(error: currencyLanguageList?.success));
        }
      } catch (e) {
        emit(FetchLanguageCurrencyState.fail(error:StringConstants.somethingWrong.localized()));
      }
    }
    if (event is FetchCMSDataEvent) {
      try {
        CmsData? cmsData = await repository?.callCmsData("");
        emit(FetchCMSDataState.success(cmsData: cmsData));
      } catch (e) {
        emit(FetchCMSDataState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
