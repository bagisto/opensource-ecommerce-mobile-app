// ignore_for_file: file_names, deprecated_member_use, unnecessary_null_comparison

import 'dart:async';
import 'package:bagisto_app_demo/screens/compare/view/widget/compare_loader_view.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/badge_helper.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/shared_preference_helper.dart';
import '../../../utils/status_color_helper.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_error_msg.dart';
import '../../../widgets/empty_data_view.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/show_message.dart';
import '../../cart_screen/cart_model/add_to_cart_model.dart';
import '../bloc/compare_base_state.dart';
import '../bloc/compare_screen_bloc.dart';
import '../bloc/compare_screen_event.dart';
import '../data_model/compare_product_model.dart';
import 'widget/compare_view.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen>
    with OrderStatusBGColorHelper {
  CompareProductsData? _compareScreenModel;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  final StreamController streamController = StreamController.broadcast();
  CompareScreenBloc? compareScreenBloc;

  Stream get onVariableChanged => _myStreamCtrl.stream;

  Stream get onUpdate => streamController.stream;
  int? cartCount = 5;
  GlobalKey key = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  final bool _isVisible = false;

  @override
  void initState() {
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    compareScreenBloc = context.read<CompareScreenBloc>();
    compareScreenBloc?.add(CompareScreenFetchEvent());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _myStreamCtrl.close();
  }

  ///method to get cart count save in share pref
  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(StringConstants.compare.localized()),
            actions: [
              StreamBuilder(
                stream: onVariableChanged,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _cartButtonValue(0);
                  }
                  return _cartButtonValue(
                      int.tryParse(snapshot.data.toString()) ?? 0);
                },
              )
            ],
          ),
          body: _compareData(context),
          floatingActionButton: StreamBuilder(
            stream: onUpdate,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Visibility(
                  visible: _isVisible,
                  child: FloatingActionButton(
                    onPressed: () {
                      CompareScreenBloc compareScreenBloc =
                          context.read<CompareScreenBloc>();
                      compareScreenBloc.add(
                          OnClickCompareLoaderEvent(isReqToShowLoader: true));
                      compareScreenBloc.add(RemoveAllCompareListEvent(""));
                    },
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                );
              }
              return Visibility(
                visible: snapshot.data.toString() == "true" ? true : false,
                child: FloatingActionButton(
                  onPressed: () {
                    CompareScreenBloc compareScreenBloc =
                        context.read<CompareScreenBloc>();
                    compareScreenBloc
                        .add(OnClickCompareLoaderEvent(isReqToShowLoader: true));
                    compareScreenBloc.add(RemoveAllCompareListEvent(""));
                  },
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ///method to set badge value
  _cartButtonValue(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BadgeIcon(
          icon: IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            // color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, cartScreen);
            },
          ),
          badgeCount: count),
    );
  }

  ///bloc method
  _compareData(BuildContext context) {
    return BlocConsumer<CompareScreenBloc, CompareScreenBaseState>(
      listener: (BuildContext context, CompareScreenBaseState state) {
        if (state is RemoveFromCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),state.error,  Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),state.successMsg,
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllCompareProductState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(), state.error, Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg,
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToCartCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.successMsg, Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg,
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToWishlistCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(), state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
      },
      builder: (BuildContext context, CompareScreenBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, CompareScreenBaseState state) {
    if (state is CompareScreenInitialState) {
      return const CompareLoaderView();
    }
    if (state is CompareScreenFetchDataState) {
      if (state.status == CompareStatusStatus.success) {
        _compareScreenModel = state.compareScreenModel;

        if ((_compareScreenModel?.data?.length ?? 0) > 0) {
          streamController.add(true);

          SharedPreferenceHelper.setCartCount(
              _compareScreenModel?.data?[0].cart?.itemsCount ?? 0);
          _myStreamCtrl.sink
              .add(_compareScreenModel?.data?[0].cart?.itemsCount ?? 0);
        }

        return _compareScreen(state.compareScreenModel!, isLoading);
      }
      if (state.status == CompareStatusStatus.fail) {
        return ErrorMessage.errorMsg(state.error!);
      }
    }
    if (state is RemoveFromCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        var productId = state.productDeletedId;
        if (_compareScreenModel != null) {
          _compareScreenModel!.data!.removeWhere((element) =>
              element.productId.toString() == productId.toString());
          return _compareScreen(_compareScreenModel!, isLoading);
        } else {
          streamController.add(false);
        }
      }
    }
    if (state is RemoveAllCompareProductState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        if (_compareScreenModel != null) {
          _compareScreenModel?.data?.clear();
          streamController.add(false);
          return _compareScreen(_compareScreenModel!, isLoading);
        } else {}
      }
    }
    if (state is AddToCartCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        AddToCartModel addToCartModel = state.response!;
        SharedPreferenceHelper.setCartCount(
            addToCartModel.cart?.itemsCount ?? 0);
        _myStreamCtrl.sink.add(addToCartModel.cart?.itemsCount ?? 0);
      }
    }
    if (state is AddToWishlistCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        getSharePreferenceCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    }
    if (state is RemoveFromWishlistState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        getSharePreferenceCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    }
    if (state is OnClickCompareLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
      getSharePreferenceCartCount().then((value) {
        _myStreamCtrl.sink.add(value);
      });
    }

    return _compareScreen(_compareScreenModel!, isLoading);
  }

  ///method for ui of whole compare screen
  _compareScreen(CompareProductsData compareScreenModel, bool isLoading) {
    if (compareScreenModel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loader(),
            const SizedBox(
              height: AppSizes.spacingNormal,
            ),
            Text(
              StringConstants.processWaitingMsg.localized(),
              softWrap: true,
            ),
          ],
        ),
      );
    } else if (compareScreenModel.data?.isEmpty ??
        false || compareScreenModel.data == null) {
      streamController.add(false);
      return const EmptyDataView();
    } else {
      return Stack(
        children: [
          SingleChildScrollView(child: CompareView(compareScreenBloc: compareScreenBloc, compareScreenModel: compareScreenModel,)),
          if (isLoading)
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                  child:
                      Loader()),
            )
        ],
      );
    }
  }
}
