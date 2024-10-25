/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */





import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';

class CheckOutBloc extends Bloc<CheckOutBaseEvent, CheckOutBaseState> {
  CheckOutRepository? repository;

  CheckOutBloc(this.repository) : super(CheckOutLoaderState()){
    on<CheckOutBaseEvent> (mapEventToState);
  }

void mapEventToState(CheckOutBaseEvent event,Emitter<CheckOutBaseState> emit) async {
    if (event is CheckOutAddressEvent) {
      try {
        AddressModel? addressModel = await repository?.callCheckoutAddressApi();

        emit (CheckOutAddressState.success(addressModel: addressModel));
      } catch (e) {
        emit (CheckOutAddressState.fail(error: e.toString()));
      }
    }

  }

}
