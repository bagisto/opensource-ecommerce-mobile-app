
import 'dart:async';
import 'package:bagisto_app_demo/screens/cart_screen/cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/screens/recent_product/utils/database.dart';
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_product_entity.dart';
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_view_controller.dart';
import 'package:bagisto_app_demo/utils/badge_helper.dart';
import 'package:bagisto_app_demo/utils/check_internet_connection.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../../cart_screen/cart_model/cart_data_model.dart';


//ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  int? productId;
  String? title;
  String? urlKey;

  ProductScreen({Key? key, this.title, this.productId, this.urlKey})
      : super(key: key);

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
  int bundleQty = 1;
  dynamic configurableProductId;
  String? price;
  NewProducts? productData;
  CartModel? cart;
  final StreamController myStreamCtrl = StreamController.broadcast();
  dynamic productFlats;
  Stream get onVariableChanged => myStreamCtrl.stream;
  AddToCartModel? addToCartModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  final _scrollController = ScrollController();
  ProductScreenBLoc? productScreenBLoc;

  @override
  void initState() {
    _fetchSharedPreferenceData();
    getSharePreferenceCartCount().then((value) {
      myStreamCtrl.sink.add(value);
      productScreenBLoc = context.read<ProductScreenBLoc>();
      productScreenBLoc?.add(FetchProductEvent(widget.urlKey ?? ""));
    });
    super.initState();
  }

  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  @override
  void dispose() {
    myStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? '', style: Theme.of(context).textTheme.labelLarge),
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: IconButton(onPressed: () {
              if(productData != null){
                setRecentViewed();
              }
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_ios)),
            actions: [
              IconButton(
                  onPressed: () async {
                    await FlutterShare.share(
                        title: widget.title ?? "",
                        text: '',
                        linkUrl: productData?.shareURL ?? "",
                        chooserTitle: '');
                  },
                  icon: const Icon(
                    Icons.share,
                  )),
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
            ],
          ),
          body: _setProductData(context),
          bottomNavigationBar: SizedBox(
            height: AppSizes.spacingWide*4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.spacingMedium),
                    side: BorderSide(color: Theme.of(context).colorScheme.onBackground)
                  ),
                  elevation: AppSizes.spacingSmall,
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
                        ShowMessage.errorNotification(StringConstants.internetIssue.localized(), context);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.addToCart.localized().toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  _cartButtonValue(int count) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: BadgeIcon(
            icon: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                checkInternetConnection().then((value) {
                  if (value) {
                    Navigator.pushNamed(context, cartScreen).then((value) {
                      if (value == true) {
                        ProductScreenBLoc productScreenBLoc =
                            context.read<ProductScreenBLoc>();
                        productScreenBLoc.add(FetchProductEvent(widget.urlKey ?? ""));
                      }
                    });
                  } else {
                    ShowMessage.errorNotification(StringConstants.internetIssue.localized(), context);
                  }
                });
              },
            ),
            badgeCount: count),
      ),
      onTap: () {
        Navigator.pushNamed(context, cartScreen).then((value) {
          if (value == true) {
            productScreenBLoc?.add(FetchProductEvent(widget.urlKey ?? ""));
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
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == ProductStatus.success) {
            addToCartModel = state.response;
            ShowMessage.successNotification(
                state.successMsg ?? "", context);
          }
        }
        if (state is AddToCompareListState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == ProductStatus.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
        if (state is AddToWishListProductState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == ProductStatus.success) {
            ShowMessage.successNotification(
                StringConstants.success.localized(), context);
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == ProductStatus.success) {
            ShowMessage.successNotification(StringConstants.success.localized(), context);
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
      return const ProductDetailLoader();
    }
    if (state is FetchProductState) {
      if (state.status == ProductStatus.success) {
        productData = state.productData;
        productFlats = productData?.productFlats?.firstWhereOrNull((e) => e.locale==GlobalData.locale );

        cart = state.productData?.cart;
        SharedPreferenceHelper.setCartCount(productData?.cart?.itemsCount ?? 0);
        myStreamCtrl.sink.add(productData?.cart?.itemsCount ?? 0);
      } else if (state.status == ProductStatus.fail) {
        Future.delayed(Duration.zero).then((value) => const NoInternetError());
        return CommonWidgets().getHeightSpace(0);
      }
    }
    if (state is AddToCompareListState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        getSharePreferenceCartCount().then((value) {
          myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is AddToCartProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        SharedPreferenceHelper.setCartCount(
            addToCartModel?.cart?.itemsCount ?? 0);
        myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount ?? 0);
      }
    }
    if (state is AddToWishListProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        getSharePreferenceCartCount().then((value) {
          myStreamCtrl.sink.add(value);
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
          myStreamCtrl.sink.add(value);
        });
      }
    }

    return ProductView(
      productData: productData,
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
    if (productData?.type == StringConstants.grouped) {
      if (groupedParams.isNotEmpty) {
        list.add(groupedParams);
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            productData?.id ?? "",
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            configurableProductId,
            ""));
      } else {
        ShowMessage.warningNotification(StringConstants.atLeastOneWarning.localized(), context);
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == StringConstants.bundle) {
        if (bundleParams.isNotEmpty) {
          print("BundleParams-->$bundleParams");
          list.add(bundleParams);
          productScreenBLoc.add(AddToCartProductEvent(
              qty,
              productData?.id ?? "",
              downloadLinks,
              groupedParams,
              bundleParams,
              configurableParams,
              configurableProductId,
              ""));
        } else {
          ShowMessage.warningNotification(StringConstants.atLeastOneWarning.localized(), context);

          productScreenBLoc
              .add(OnClickProductLoaderEvent(isReqToShowLoader: false));
          return;
        }
    } else if (productData?.type == StringConstants.downloadable) {
      if (downloadLinks.isNotEmpty) {
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            productData?.id ?? "",
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            configurableProductId,
            ""));
      } else {
        ShowMessage.warningNotification(StringConstants.linkRequired.localized(),context);
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == StringConstants.configurable) {
      String? id = getId(productData, configurableParams);

      if (configurableParams.isEmpty || configurableProductId == null) {
        ShowMessage.warningNotification(StringConstants.pleaseSelectVariants.localized(), context);

        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));
      } else {
        productScreenBLoc.add(AddToCartProductEvent(
            qty,
            productData?.id ?? "",
            downloadLinks,
            groupedParams,
            bundleParams,
            configurableParams,
            id,
            ""));
      }
    } else {
      productScreenBLoc.add(AddToCartProductEvent(
          qty,
          productData?.id ?? "",
          downloadLinks,
          groupedParams,
          bundleParams,
          configurableParams,
          configurableProductId,
          ""));
    }
  }

  String? getId(NewProducts? productData, List? configurableParams) {
    String? id = "0";
    if ((productData?.configurableData?.index ?? []).isNotEmpty) {
      id = productData?.configurableData?.index?[0].id;
    }
    for (var indexData = 0;
        indexData < (productData?.configurableData?.index?.length ?? 0);
        indexData++) {
      List map = [];

      Index? data = productData?.configurableData?.index?[indexData];

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
              isNew: productData?.productFlats?[0].isNew,
              isInSale:productData?.isInSale ,
              name: productFlats?.name ?? productData?.productFlats?[0].name,
              price: productData?.priceHtml?.priceHtml,
              specialPrice: productData?.priceHtml?.formattedFinalPrice ,
              type: productData?.type,
              urlKey: productData?.urlKey,
              shortDescription: productData?.productFlats?[0].shortDescription,
              productId: productData?.productFlats?[0].id,
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

