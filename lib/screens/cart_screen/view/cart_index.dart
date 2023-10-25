import '../../../models/cart_model/cart_data_model.dart';
import '../bloc/cart_screen_bloc.dart';
export 'dart:async';
export 'package:flutter/material.dart';
export 'package:bagisto_app_demo/Configuration/mobikul_theme.dart';
export 'package:bagisto_app_demo/common_widget/common_error_msg.dart';
export 'package:bagisto_app_demo/common_widget/common_widgets.dart';
export 'package:bagisto_app_demo/common_widget/image_view.dart';
export 'package:bagisto_app_demo/common_widget/show_message.dart';
export 'package:bagisto_app_demo/helper/application_localization.dart';
export 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
export 'package:bagisto_app_demo/helper/string_constants.dart';
export 'package:bagisto_app_demo/screens/cart_screen/state/ShowLoaderCartState.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/no_item_cart.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export '../../../api/graph_ql.dart';
export '../../../common_widget/circular_progress_indicator.dart';
export '../../../configuration/app_sizes.dart';
export '../../../helper/prefetching_helper.dart';
export '../../../models/cart_model/cart_data_model.dart';
export '../../../routes/route_constants.dart';
export '../../homepage/view/homepage.dart';
export '../../homepage/view/homepage_view.dart';
export '../../product_screen/view/quantity_view.dart';
export '../bloc/cart_screen_bloc.dart';
export '../events/add_coupon_cart_event.dart';
export '../events/fetch_cart_data_event.dart';
export '../events/remove_cart_coupom_state.dart';
export '../events/remove_cart_item_event.dart';
export '../state/add_coupon_state.dart';
export '../state/cart_screen_base_state.dart';
export '../state/fetch_cart_data_state.dart';
export '../state/remove_cart_coupon_state.dart';
export '../state/remove_cart_item_state.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/apply_coupon_view.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/button_view.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/cart_item.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/price_details_view.dart';
export 'package:bagisto_app_demo/screens/cart_screen/view/widget/proceed_view.dart';

///class used to send data on checkout
class CartNavigationData {
  CartNavigationData(
      {this.total,
      this.cartDetailsModel,
      this.cartScreenBloc,
      this.isDownloadable});

  String? total;
  CartModel? cartDetailsModel;
  CartScreenBloc? cartScreenBloc;
  bool? isDownloadable;
}
