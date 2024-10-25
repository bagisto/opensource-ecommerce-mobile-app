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
import '../../data_model/save_order_model.dart';


class CheckOutSaveOrder extends StatefulWidget {
  const CheckOutSaveOrder({Key? key}) : super(key: key);

  @override
  State<CheckOutSaveOrder> createState() => _CheckOutSaveOrderState();
}

class _CheckOutSaveOrderState extends State<CheckOutSaveOrder> {
  bool isLoggedIn = false;

  @override
  void initState() {
    SaveOrderBloc saveOrderBloc = context.read<SaveOrderBloc>();
    saveOrderBloc.add(SaveOrderFetchDataEvent());
    isLoggedIn = appStoragePref.getCustomerLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _saveOrderBloc(context));
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
        return ErrorMessage.errorMsg(
            "${state.error ?? ""} ${StringConstants.addMoreProductsMsg}"
                .localized());
      }
    }
    if (state is SaveOrderInitialState) {
      return const Loader();
    }

    return const SizedBox();
  }

  _orderPlacedView(SaveOrderModel saveOrderModel) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingNormal),
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Card(
            elevation: 0,
            shape: const ContinuousRectangleBorder(),
            // color: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    children: [
                      Text(
                        StringConstants.orderReceivedMsg
                            .localized()
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    children: [
                      Text(
                        StringConstants.thankYouMsg.localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  InkWell(
                    onTap: isLoggedIn ? () async {
                        Navigator.pushNamed(context, orderDetailPage,
                            arguments: saveOrderModel.order?.id);
                    } : null,
                    child: Wrap(
                      children: [
                        Text(
                          "${StringConstants.yourOrderIdMsg.localized()} ${saveOrderModel.order?.id ?? ""}",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isLoggedIn ? Colors.blueAccent : null
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        StringConstants.orderConfirmationMsg.localized(),
                        style: const TextStyle(
                          fontSize: AppSizes.spacingLarge,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.onBackground,
                    elevation: 0.0,
                    textColor: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, home);
                    },
                    child: Text(
                      StringConstants.continueShopping
                          .localized()
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.background
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.spacingMedium,
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
