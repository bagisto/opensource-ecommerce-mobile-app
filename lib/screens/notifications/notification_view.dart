/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/notifications/views/notification_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../common_widget/loader.dart';
import '../../common_widget/show_message.dart';
import '../../configuration/app_global_data.dart';
import '../../configuration/app_sizes.dart';
import '../../models/notification_model/notification_model.dart';
import 'bloc/notification_bloc.dart';
import 'bloc/notification_event.dart';
import 'bloc/notification_state.dart';



class NotificationScreen extends StatefulWidget {

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationListModel? _notificationModel;
  NotificationScreenBloc? _notificationScreenBloc;
  bool isLoading = true;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


  @override
  void initState() {
    _notificationScreenBloc = context.read<NotificationScreenBloc>();
    notificationData();
    super.initState();
  }

  notificationData() async {
    _notificationScreenBloc?.add(NotificationFetchEvent());
  }



  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:  Scaffold(
        appBar:AppBar(
          title: Text("Notifications".localized()),
        ),
        body:  BlocBuilder<NotificationScreenBloc, NotificationScreenState>(
            builder: (context, currentState) {
              if (currentState is NotificationInitial) {
               return Loader();
              } else if (currentState is NotificationSuccess) {
                _notificationModel = currentState.data;
                isLoading = false;
              } else if (currentState is NotificationError) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ShowMessage.showNotification(currentState.message??"","",Colors.red,const Icon(Icons.cancel_outlined));
                });

              }
              return _notificationDataView();
            },
          ),
        ),
      ),
    );
  }
 _notificationDataView(){
    if((_notificationModel?.data?.length ?? 0)>0){
      return _notificationView();
    } else {
      return   Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
              child: LottieBuilder.asset(
                "assets/lottie/empty_order_list.json",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: AppSizes.widgetSidePadding,
            ),
            Text(
              "EmptyPageGenericLabel".localized(),
              softWrap: true,
            ),
          ],
        ),
      );
    }
 }


  _notificationView() {
    return Stack(
      children: [
        Visibility(
          visible: (_notificationModel != null),
          child:  ListView.builder(
              itemCount:  _notificationModel?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return  NotificationScreenItem(
                  notification: _notificationModel?.data?[index],);
              }),
        ),
        Visibility(visible: isLoading, child:  Loader())
      ],
    );
  }
}
