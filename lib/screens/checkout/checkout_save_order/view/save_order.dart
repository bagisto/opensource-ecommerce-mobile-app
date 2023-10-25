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

import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/bloc/save_order_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_order_base_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_order_initial_state.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/state/save_oredr_fetch_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/app_global_data.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../common_widget/circular_progress_indicator.dart';
import '../../../../common_widget/common_error_msg.dart';
import '../../../../models/checkout_models/save_order_model.dart';
import '../../../../routes/route_constants.dart';
import '../event/save_order_fetch_data_event.dart';


class CheckOutSaveOrder extends StatefulWidget {
  const CheckOutSaveOrder({Key? key}) : super(key: key);

  @override
  State<CheckOutSaveOrder> createState() => _CheckOutSaveOrderState();
}

class _CheckOutSaveOrderState extends State<CheckOutSaveOrder> {
  @override
  void initState() {
    SaveOrderBloc saveOrderBloc = context.read<SaveOrderBloc>();
    saveOrderBloc.add(SaveOrderFetchDataEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
          textDirection: GlobalData.contentDirection(),
          child:   _saveOrderBloc(context)
      )
    );
  }


  ///SaverOrder BLOC CONTAINER///
  _saveOrderBloc(BuildContext context) {

    return BlocConsumer<SaveOrderBloc, SaveOrderBaseState>(
      listener: (BuildContext context, SaveOrderBaseState state) {},
      builder: (BuildContext context, SaveOrderBaseState state) {
        return buildUI(context, state);
      },
    );
  }

  ///SaverOrder UI METHODS///
  Widget buildUI(BuildContext context, SaveOrderBaseState state) {
    if (state is SaveOrderFetchDataState) {
      if (state.status == SaveOrderStatus.success) {
        return _orderPlacedView(state.saveOrderModel!);
      }
      if (state.status == SaveOrderStatus.fail) {
        return ErrorMessage.errorMsg("${state.error ?? ""} PleaseAddmoreproductsforplacingorder".localized()
            );
      }
    }
    if (state is SaveOrderInitialState) {
      return  CircularProgressIndicatorClass.circularProgressIndicator(context);
    }

    return Container();
  }


  _orderPlacedView(SaveOrderModel saveOrderModel) {
    return Container(

      height: double.infinity,
      padding: const EdgeInsets.all(NormalPadding),
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Card(
            elevation: 0,
            shape: const ContinuousRectangleBorder(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.normalHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height:AppSizes.mediumPadding,
                  ),
                  Wrap(
                    children: [
                      Text("OrderReceivedMsg".localized()
                       .toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppSizes.normalFontSize,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height:  AppSizes.mediumPadding,
                  ),
                  Wrap(
                    children: [
                      Text(
                       "ThankYouMsg".localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.normalFontSize,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.normalHeight,
                  ),
                  Wrap(
                    children: [
                      Text( "${"YourOrderIdMsg".localized()} ${saveOrderModel.order?.id??""}"
                        ,style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize:AppSizes.normalFontSize,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height:  AppSizes.mediumPadding,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                   "OrderConfirmationMsg".localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.normalFontSize,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.mediumPadding,
                  ),
                  MaterialButton(
                    color:  Theme.of(context).colorScheme.background,
                    elevation: 0.0,
                    textColor: Theme.of(context).colorScheme.onBackground,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Home);
                    },
                    child: Text(
                       "ContinueShopping".localized().toUpperCase(),
                      style:  const TextStyle(
                          fontSize:AppSizes.normalFontSize, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height:  AppSizes.mediumPadding,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
