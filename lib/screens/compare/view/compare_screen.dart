// ignore_for_file: file_names, deprecated_member_use, unnecessary_null_comparison

import '../../../configuration/app_global_data.dart';
import 'compare_index.dart';

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
  bool isVisible = false;

  @override
  void initState() {
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    compareScreenBloc = context.read<CompareScreenBloc>();
    compareScreenBloc?.add(CompareScreenFetchEvent());

    super.initState();
  }

  ///method to get cart count save in share pref
  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child:Directionality(
        textDirection: GlobalData.contentDirection(),
        child:  Scaffold(
        appBar: AppBar(

          title: CommonWidgets.getHeadingText("Compare".localized(), context),
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
        body:  _compareData( context),
        floatingActionButton: StreamBuilder(
          stream: onUpdate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Visibility(
                visible: isVisible,
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
    )   );
  }

  ///method to set badge value
  _cartButtonValue(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BadgeIcon(
          icon: IconButton(
            icon: const Icon(Icons.shopping_cart),
            // color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, CartPage);
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
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                state.successMsg,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveAllCompareProductState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification(
                state.error, "", Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                state.successMsg,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddToCartCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification("Failed", state.successMsg, Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                state.response?.message,
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is AddtoWishlistCompareState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == CompareStatusStatus.fail) {
            ShowMessage.showNotification("Failed", state.error ?? "",
                Colors.red, const Icon(Icons.cancel_outlined));
          } else if (state.status == CompareStatusStatus.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
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
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
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
              element.productFlatId.toString() == productId.toString());
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
    if (state is AddtoWishlistCompareState) {
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
            CircularProgressIndicatorClass.circularProgressIndicator(context),
            const SizedBox(
              height: AppSizes.widgetSidePadding,
            ),
            Text(
              "PleaseWaitProcessingRequest".localized(),
              softWrap: true,
            ),
          ],
        ),
      );
    } else if (compareScreenModel.data?.isEmpty ??
        false || compareScreenModel.data == null) {
      streamController.add(false);
      return const EmptyCompareScreen();
    } else {
      return Stack(
        children: [
          SingleChildScrollView(
              child: CompareView(
            compareScreenBloc: compareScreenBloc,
            compareScreenModel: compareScreenModel,
          )),
          if (isLoading)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  child:
                      CircularProgressIndicatorClass.circularProgressIndicator(
                          context)),
            )
        ],
      );
    }
  }
}
