/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */




import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import '../../data_model/checkout_save_address_model.dart';
import 'checkout_fetch_shipping_state.dart';
import 'checkout_shipping_base_event.dart';
import 'checkout_shipping_repository.dart';

class CheckOutShippingBloc extends Bloc<CheckOutShippingBaseEvent, CheckOutShippingBaseState> {
  CheckOutShippingRepository? repository;

  CheckOutShippingBloc(this.repository) : super(CheckOutShippingInitialState()){
    on<CheckOutShippingBaseEvent> (mapEventToState);
  }


void mapEventToState(CheckOutShippingBaseEvent event,Emitter<CheckOutShippingBaseState> emit) async {
    if (event is CheckOutFetchShippingEvent) {
      try {
        int id = await SharedPreferenceHelper.getCustomerId();
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
          shippingId: event.shippingId
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
