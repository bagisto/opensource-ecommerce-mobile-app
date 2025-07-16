/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, deprecated_member_use, unnecessary_null_comparison

import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen>
    with OrderStatusBGColorHelper {
  final _scrollController = ScrollController();
  CompareProductsData? _compareScreenModel;
  final StreamController streamController = StreamController.broadcast();
  CompareScreenBloc? compareScreenBloc;
  GlobalKey key = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  final int limit = 3;
  int page = 1;
  @override
  void initState() {
    getSharePreferenceCartCount().then((value) {
      GlobalData.cartCountController.sink.add(value);
    });
    compareScreenBloc = context.read<CompareScreenBloc>();
    compareScreenBloc?.add(CompareScreenFetchEvent());
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    _scrollController.dispose();
  }

  ///method to get cart count save in share pref
  Future getSharePreferenceCartCount() async {
    return appStoragePref.getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.compare.localized()),
          centerTitle: false,
          actions: [
            StreamBuilder(
              stream: GlobalData.cartCountController.stream,
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
          stream: streamController.stream,
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;

            return Visibility(
              visible: count > 0,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  CompareScreenBloc compareScreenBloc =
                      context.read<CompareScreenBloc>();
                  compareScreenBloc
                      .add(OnClickCompareLoaderEvent(isReqToShowLoader: true));
                  compareScreenBloc.add(RemoveAllCompareListEvent(""));
                },
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ///method to set badge value
  _cartButtonValue(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingNormal),
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
            ShowMessage.showNotification(StringConstants.failed.localized(),
                state.error, Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg,
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllCompareProductState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(StringConstants.failed.localized(),
                state.error, Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg,
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToCartCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.successMsg,
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg,
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToWishlistCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.error ?? "",
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                Colors.green.shade400,
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                StringConstants.failed.localized(),
                state.error ?? "",
                Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                StringConstants.success.localized(),
                state.successMsg ?? "",
                Colors.green.shade400,
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
          streamController.add(_compareScreenModel?.data?.length ?? 0);
          // GlobalData.cartCountController.sink
          //     .add(_compareScreenModel?.data?[0].cart?.itemsQty ?? 0);
        }
        return _compareScreen(state.compareScreenModel, isLoading);
      }
      if (state.status == CompareStatusStatus.fail) {
        return ErrorMessage.errorMsg(state.error!);
      }
    }
    if (state is RemoveFromCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        compareScreenBloc?.add(CompareScreenFetchEvent());
        return _compareScreen(_compareScreenModel, isLoading);
      }
    }
    if (state is RemoveAllCompareProductState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        compareScreenBloc?.add(CompareScreenFetchEvent());
        return _compareScreen(_compareScreenModel, isLoading);
      }
    }
    if (state is AddToCartCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        AddToCartModel? addToCartModel = state.response;
        GlobalData.cartCountController.sink
            .add(addToCartModel?.cart?.itemsQty ?? 0);
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    }
    if (state is AddToWishlistCompareState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    }
    if (state is RemoveFromWishlistState) {
      isLoading = false;
      if (state.status == CompareStatusStatus.success) {
        compareScreenBloc?.add(CompareScreenFetchEvent());
      }
    }
    if (state is OnClickCompareLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }

    return _compareScreen(_compareScreenModel, isLoading);
  }

  ///method for ui of whole compare screen
  _compareScreen(CompareProductsData? compareScreenModel, bool isLoading) {
    if (compareScreenModel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Loader(),
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
      streamController.add(0);
      return const EmptyDataView();
    } else {
      return SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: CompareView(
              scrollController: _scrollController,
              compareScreenBloc: compareScreenBloc,
              compareScreenModel: compareScreenModel,
            )),
            if (isLoading)
              const Align(
                alignment: Alignment.center,
                child: SizedBox(child: Loader()),
              )
          ],
        ),
      );
    }
  }
}
