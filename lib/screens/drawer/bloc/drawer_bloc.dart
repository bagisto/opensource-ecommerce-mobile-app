/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';

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
            await repository?.getDrawerCategoriesList(event.filters);
        if (getDrawerCategoriesData?.responseStatus == true) {
          emit(FetchDrawerPageDataState.success(
              getCategoriesDrawerData: getDrawerCategoriesData));
        } else {
          emit(FetchDrawerPageDataState.fail(
              error: getDrawerCategoriesData?.success));
        }
      } catch (e) {
        emit(FetchDrawerPageDataState.fail(
            error: StringConstants.contactAdmin.localized()));
      }
    }
    if (event is CurrencyLanguageEvent) {
      try {
        CurrencyLanguageList? currencyLanguageList =
            await repository?.getLanguageCurrencyList();
        emit(FetchLanguageCurrencyState.success(
          currencyLanguageList: currencyLanguageList,
        ));
      } catch (e) {
        emit(FetchLanguageCurrencyState.fail(
            error: StringConstants.somethingWrong.localized()));
      }
    }
  }
}
