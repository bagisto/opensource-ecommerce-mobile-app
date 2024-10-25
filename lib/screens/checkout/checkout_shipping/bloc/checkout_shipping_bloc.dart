/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */






import 'package:bagisto_app_demo/screens/checkout/data_model/checkout_save_address_model.dart';
import 'package:bagisto_app_demo/screens/checkout/utils/index.dart';
class CheckOutShippingBloc extends Bloc<CheckOutShippingBaseEvent, CheckOutShippingBaseState> {
  CheckOutShippingRepository? repository;

  CheckOutShippingBloc(this.repository) : super(CheckOutShippingInitialState()){
    on<CheckOutShippingBaseEvent> (mapEventToState);
  }


void mapEventToState(CheckOutShippingBaseEvent event,Emitter<CheckOutShippingBaseState> emit) async {
    if (event is CheckOutFetchShippingEvent) {
      try {
        int id = appStoragePref.getCustomerId();
        SaveCheckoutAddresses? checkOutSaveAddressModel = await repository?.saveCheckOutShipping(
          event.billingCompanyName,
          event.billingFirstName,
          event.billingLastName,
          event.billingAddress,
          event.billingEmail,
          event.billingAddress2,
          event.billingCountry,
          event.billingState,
          event.billingCity,
          event.billingPostCode,
          event.billingPhone,
          event.shippingCompanyName,
          event.shippingFirstName,
          event.shippingLastName,
          event.shippingAddress,
          event.shippingEmail,
          event.shippingAddress2,
          event.shippingCountry,
          event.shippingState,
          event.shippingCity,
          event.shippingPostCode,
          event.shippingPhone,
          id,
          billingId: event.billingId,
          shippingId: event.shippingId,
          useForShipping: event.useForShipping
        );
        if (checkOutSaveAddressModel?.responseStatus == false) {
          emit (CheckOutFetchShippingState.fail(error: checkOutSaveAddressModel?.success));

        } else {
          emit (CheckOutFetchShippingState.success(checkOutSaveAddressModel: checkOutSaveAddressModel));
        }
      } catch (e) {
        emit (CheckOutFetchShippingState.fail(error: StringConstants.somethingWrong.localized()));
      }
    }

  }

}
