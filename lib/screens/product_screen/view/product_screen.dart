// ignore_for_file: file_names, must_be_immutable, unnecessary_null_comparison, deprecated_member_use, implementation_imports, avoid_print, prefer_is_empty
import 'package:bagisto_app_demo/screens/product_screen/view/product_screen_index.dart';
import '../../../configuration/app_global_data.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../models/cart_model/cart_data_model.dart';
import '../../recent_product/database.dart';
import '../../recent_product/recent_product_entity.dart';
import '../../recent_product/recent_view_controller.dart';
import 'package:collection/collection.dart';
class ProductScreen extends StatefulWidget {
  int? productId;
  String? title;

  ProductScreen({Key? key, this.title, this.productId}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoggedIn = false;
  int qty = 1;
  List downloadLinks = [];
  List groupedParams = [];
  List bundleParams = [];
  List configurableParams = [];
  List selectList = [];
  List selectParam = [];
  dynamic configurableProductId;
  String? price;
  Product? productData;
  CartModel? cart;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  dynamic productFlats;
  Stream get onVariableChanged => _myStreamCtrl.stream;
  int? cartCount = 5;
  AddToCartModel? addToCartModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  final _scrollController = ScrollController();
  CartScreenBloc? cartScreenBloc;
  ProductScreenBLoc? productScreenBLoc;

  @override
  void initState() {
    _fetchSharedPreferenceData();
    cartScreenBloc = context.read<CartScreenBloc>();
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
      productScreenBLoc = context.read<ProductScreenBLoc>();
      productScreenBLoc?.add(FetchProductEvent(widget.productId));
    });
    super.initState();
  }

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
          title: CommonWidgets.getHeadingText(widget.title ?? '', context),
          centerTitle: false,
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
            ),
            IconButton(
                onPressed: () async {
                  await FlutterShare.share(
                      title: productFlats?.name ?? productData?.productFlats?[0].name ?? "",
                      text: '',
                      linkUrl: productData?.shareURL ?? "",
                      chooserTitle: '');
                },
                icon: const Icon(
                  Icons.share,
                )),
          ],
        ),
        body:  _setProductData(context),

        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12),
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: AppSizes.elevation,
                height: AppSizes.buttonHeight,
                minWidth: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                textColor: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  checkInternetConnection().then((value) {
                    if (value) {
                      ProductScreenBLoc productBloc =
                          context.read<ProductScreenBLoc>();
                      productBloc.add(
                          OnClickProductLoaderEvent(isReqToShowLoader: true));
                      _addToCart(context);
                    } else {
                      ShowMessage.showNotification("InternetIssue".localized(),
                          "", Colors.red, const Icon(Icons.cancel_outlined));
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "AddToCart".localized().toUpperCase(),
                      style: const TextStyle(
                          fontSize: AppSizes.normalFontSize,
                          color: Colors.white),
                    ),
                  ],
                )),
          ),
        ),
      ), ),
    );
  }

  _cartButtonValue(int count) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: BadgeIcon(
            icon: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                checkInternetConnection().then((value) {
                  if (value) {
                    Navigator.pushNamed(context, CartPage).then((value) {
                      if (value == true) {
                        ProductScreenBLoc productScreenBLoc =
                        context.read<ProductScreenBLoc>();
                        productScreenBLoc.add(FetchProductEvent(widget.productId));
                      }
                    });
                  } else {
                    ShowMessage.showNotification("InternetIssue".localized(),
                        "", Colors.red, const Icon(Icons.cancel_outlined));
                  }
                });

              },
            ),
            badgeCount: count),
      ),
      onTap: () {
        Navigator.pushNamed(context, CartPage).then((value) {
          if (value == true) {
            ProductScreenBLoc productScreenBLoc =
                context.read<ProductScreenBLoc>();
            productScreenBLoc.add(FetchProductEvent(widget.productId));
          }
        });
      },
    );
  }

  /// Product bloc method
  _setProductData(BuildContext context) {
    return BlocConsumer<ProductScreenBLoc, ProductBaseState>(
      listener: (BuildContext context, ProductBaseState state) {
        if (state is AddToCartProductState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ProductStatus.success) {
            addToCartModel = state.response;
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is AddToCompareListState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ProductStatus.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
        if (state is AddToWishListProductState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ProductStatus.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.showNotification(state.error ?? "", "", Colors.red,
                const Icon(Icons.cancel_outlined));
          } else if (state.status == ProductStatus.success) {
            ShowMessage.showNotification(
                state.successMsg ?? "",
                "",
                const Color.fromRGBO(140, 194, 74, 5),
                const Icon(Icons.check_circle_outline));
          }
        }
      },
      builder: (BuildContext context, ProductBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, ProductBaseState state) {
    if (state is ProductInitialState) {
      return CircularProgressIndicatorClass.circularProgressIndicator(context);
    }
    if (state is FetchProductState) {
      if (state.status == ProductStatus.success) {
        productData = state.productData;
         productFlats = productData?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

        cart = state.productData?.cart;
        SharedPreferenceHelper.setCartCount(productData?.cart?.itemsCount ?? 0);
        _myStreamCtrl.sink.add(productData?.cart?.itemsCount ?? 0);
        setRecentViewed();
      } else if (state.status == ProductStatus.fail) {
        Future.delayed(Duration.zero).then((value) => const NoInternetError());
        return CommonWidgets().getTextFieldHeight(0);
      }
    }
    if (state is AddToCompareListState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        getSharePreferenceCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is AddToCartProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        SharedPreferenceHelper.setCartCount(
            addToCartModel?.cart?.itemsCount ?? 0);
        _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount ?? 0);
      }
    }
    if (state is AddToWishListProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        getSharePreferenceCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is OnClickProductLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }
    if (state is RemoveFromWishlistState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        getSharePreferenceCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    return ProductView(
      productData: productData!,
      isLoading: isLoading,
      isLoggedIn: isLoggedIn,
      callback: (configurableParams, bundleParams, selectList, selectParam,
          groupedParams, downloadLinks, qty, configurableProductId) {
        this.configurableParams = configurableParams;
        this.bundleParams = bundleParams;
        this.selectList = selectList;
        this.selectParam = selectParam;
        this.groupedParams = groupedParams;
        this.downloadLinks = downloadLinks;
        this.qty = qty;
        this.configurableProductId = configurableProductId;
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      productId: widget.productId,
      price: price,
      configurableProductId: configurableProductId,
      productScreenBLoc: productScreenBLoc,
      scrollController: _scrollController,
    );
  }

  _addToCart(BuildContext context) {
    ProductScreenBLoc productScreenBLoc = context.read<ProductScreenBLoc>();
    List list = [];
    if (productData?.type == Grouped) {
      if (groupedParams.isNotEmpty) {
        list.add(groupedParams);
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            int.parse(productData?.id ?? ""),
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            configurableProductId ?? 0,
            ""));
      } else {
        ShowMessage.showNotification("AtleastOneWarning".localized(), "",
            Colors.yellow, const Icon(Icons.warning_amber));
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == Bundle) {
      productData?.bundleOptions?.forEach((element) {
        if (bundleParams.isNotEmpty) {
          list.add(bundleParams);
          productScreenBLoc.add(AddToCartProductEvent(
              qty,
              int.parse(productData?.id ?? ""),
              downloadLinks,
              groupedParams,
              bundleParams,
              configurableParams,
              configurableProductId ?? 0,
              ""));
          debugPrint("dedcdscdsedfef  ${bundleParams.toString()}");
        } else {
          ShowMessage.showNotification("AtleastOneWarning".localized(), "",
              Colors.yellow, const Icon(Icons.warning_amber));

          productScreenBLoc
              .add(OnClickProductLoaderEvent(isReqToShowLoader: false));
          return;
        }
      });
    } else if (productData?.type == Downloadable) {
      if (downloadLinks.isNotEmpty) {
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            int.parse(productData?.id ?? ""),
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            configurableProductId ?? 0,
            ""));
      } else {
        ShowMessage.showNotification("LinkRequired".localized(), "",
            Colors.yellow, const Icon(Icons.warning_amber));
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == configurable) {
      debugPrint("param --> $configurableParams");
      debugPrint("param --> $configurableProductId");

      String? id = getId(productData, configurableParams);

      if (configurableParams == null || configurableProductId == null) {
        ShowMessage.showNotification("PleaseSelectVariants".localized(), "",
            Colors.yellow, const Icon(Icons.warning_amber));

        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));
      } else {
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            int.parse(productData?.id ?? ""),
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            id ?? 0,
            ""));
      }
    } else {
      productScreenBLoc.add(AddToCartProductEvent(
          qty,
          int.tryParse(productData?.id ?? "") ?? 0,
          downloadLinks,
          groupedParams,
          bundleParams,
          configurableParams,
          configurableProductId ?? "0",
          ""));
    }
  }

  String? getId(Product? productData, List? configurableParams) {
    String? id = "0";
    if ((productData?.configutableData?.index ?? []).isNotEmpty) {
      id = productData?.configutableData?.index?[0].id;
    }
    for (var indexData = 0;
        indexData < (productData?.configutableData?.index?.length ?? 0);
        indexData++) {
      List map = [];

      Index? data = productData?.configutableData?.index?[indexData];

      for (int i = 0; i < (data?.attributeOptionIds?.length ?? 0); i++) {
        AttributeOptionIds? item = data?.attributeOptionIds?[i];
        for (int j = 0; j < (configurableParams?.length ?? 0); j++) {
          var param = configurableParams?[j];
          if (item?.attributeId.toString() ==
                  param?["attributeId"].toString() &&
              item?.attributeOptionId.toString() ==
                  param?["attributeOptionId"].toString()) {
            map.add(j);
            break;
          }
        }
      }

      if (map.length == configurableParams?.length) {
        debugPrint("map ==> $map ${data?.id}");
        return data?.id;
      }
    }
    return id;
  }

  void setRecentViewed() {
    AppDatabase.getDatabase().then(
      (value) => value.recentProductDao
          .insertRecentProduct(
            RecentProduct(
              id: productData?.id,
              isInWishlist: productData?.isInWishlist,
              isNew: productFlats?.isNew ?? productData?.productFlats?[0].isNew,
              name: productFlats?.name ?? productData?.productFlats?[0].name,
              price: productData?.priceHtml?.regular,
              type: productData?.type,
              shortDescription: productFlats?.shortDescription ?? productData?.productFlats?[0].shortDescription,
              productId: productFlats?.id ?? productData?.productFlats?[0].id,
              url: (productData?.images ?? []).isNotEmpty
                  ? (productData?.images?[0].url.toString())
                  : "",
              rating: (productData?.reviews ?? []).isNotEmpty
                  ? (productData?.reviews?[0].rating ?? 0)
                  : 0,
            ),
          )
          .then(
            (value) =>
                RecentViewController.controller.sink.add(productData?.id),
          ),
    );
  }

  ///fetch data from shared pref
  _fetchSharedPreferenceData() {
    getCustomerLoggedInPrefValue().then((isLogged) {
      if (isLogged) {
        SharedPreferenceHelper.getCustomerName().then((value) {
          setState(() {
            isLoggedIn = isLogged;
          });
        });
      } else {
        setState(() {
          isLoggedIn = isLogged;
        });
      }
    });
  }
}

///fetch that the user is login or not?
Future getCustomerLoggedInPrefValue() async {
  return await SharedPreferenceHelper.getCustomerLoggedIn();
}

class ProductData {
  ProductData({this.product, this.typeParam, this.price, this.selectParam});

  Product? product;
  String? price;
  List? typeParam = [];
  List? selectParam = [];
}
