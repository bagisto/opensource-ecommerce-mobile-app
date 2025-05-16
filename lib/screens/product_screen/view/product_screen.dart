/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/cart_screen/utils/cart_index.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import '../data_model/download_sample_model.dart';

class ProductScreen extends StatefulWidget {
  final int? productId;
  final String? title;
  final String? urlKey;

  const ProductScreen({Key? key, this.title, this.productId, this.urlKey})
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
  dynamic productFlats;
  AddToCartModel? addToCartModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  final _scrollController = ScrollController();
  ProductScreenBLoc? productScreenBLoc;
  DownloadSampleModel? downloadSampleModel;

  @override
  void initState() {
    isLoggedIn = appStoragePref.getCustomerLoggedIn();
    GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
    productScreenBLoc = context.read<ProductScreenBLoc>();
    productScreenBLoc?.add(FetchProductEvent(widget.urlKey ?? ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? '',
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                if (productData != null) {
                  setRecentViewed(productData);
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
                onPressed: () async {
                  await Share.share(
                    productData?.shareURL ?? "",
                    subject: widget.title ?? "",
                  );
                },
                icon: const Icon(
                  Icons.share,
                )),
            StreamBuilder(
              stream: GlobalData.cartCountController.stream,
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
                        productScreenBLoc
                            .add(FetchProductEvent(widget.urlKey ?? ""));
                      }
                    });
                  } else {
                    ShowMessage.errorNotification(
                        StringConstants.internetIssue.localized(), context);
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
            ShowMessage.successNotification(state.successMsg ?? "", context);
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
            ShowMessage.successNotification(state.successMsg ?? '', context);
          }
        } else if (state is RemoveFromWishlistState) {
          if (state.status == ProductStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == ProductStatus.success) {
            ShowMessage.successNotification(state.successMsg ?? '', context);
          }
        } else if (state is DownloadProductSampleState) {
          downloadSampleModel = state.model;

          if (state.model?.success == true) {
            DownloadFile().saveBase64String(
                downloadSampleModel?.string ?? "", state.fileName ?? "Sample");
          } else {
            ShowMessage.errorNotification(state.error ?? "", context);
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
        productFlats = productData?.productFlats
            ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

        cart = state.productData?.cart;
        GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
      } else if (state.status == ProductStatus.fail) {
        Future.delayed(Duration.zero).then((value) => const NoInternetError());
        return CommonWidgets().getHeightSpace(0);
      }
    }
    if (state is AddToCompareListState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {}
    }
    if (state is AddToCartProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {
        GlobalData.cartCountController.sink
            .add(addToCartModel?.cart?.itemsQty ?? 0);
      }
    }
    if (state is AddToWishListProductState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {}
    }
    if (state is OnClickProductLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }
    if (state is RemoveFromWishlistState) {
      isLoading = false;
      if (state.status == ProductStatus.success) {}
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingWide * 4),
          child: ProductView(
            productData: productData,
            isLoading: isLoading,
            isLoggedIn: isLoggedIn,
            callback: (configurableParams,
                bundleParams,
                selectList,
                selectParam,
                groupedParams,
                downloadLinks,
                qty,
                configurableProductId) {
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
          ),
        ),
        Opacity(
          opacity: (productData?.isSaleable ?? false) ? 1 : 0.2,
          child: Container(
            height: AppSizes.spacingWide * 4,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.spacingMedium),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground)),
                  elevation: AppSizes.spacingSmall,
                  height: AppSizes.buttonHeight,
                  minWidth: MediaQuery.of(context).size.width,
                  textColor: Theme.of(context).colorScheme.onBackground,
                  onPressed: (productData?.isSaleable ?? false)
                      ? () {
                          checkInternetConnection().then((value) {
                            if (value) {
                              ProductScreenBLoc productBloc =
                                  context.read<ProductScreenBLoc>();
                              productBloc.add(OnClickProductLoaderEvent(
                                  isReqToShowLoader: true));
                              _addToCart(context);
                            } else {
                              ShowMessage.errorNotification(
                                  StringConstants.internetIssue.localized(),
                                  context);
                            }
                          });
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(StringConstants.addToCart.localized().toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                    ],
                  )),
            ),
          ),
        )
      ],
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
        ShowMessage.warningNotification(
            StringConstants.atLeastOneWarning.localized(), context);
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == StringConstants.bundle) {
      if (bundleParams.isNotEmpty) {
        debugPrint("BundleParams-->$bundleParams");
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
        debugPrint("BundleParams-->$bundleParams");
        ShowMessage.warningNotification(
            StringConstants.atLeastOneWarning.localized(), context);

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
        ShowMessage.warningNotification(
            StringConstants.linkRequired.localized(), context);
        productScreenBLoc
            .add(OnClickProductLoaderEvent(isReqToShowLoader: false));

        return;
      }
    } else if (productData?.type == StringConstants.configurable) {
      String? id = getId(productData, configurableParams);

      if ((configurableParams.isEmpty || configurableProductId == null) ||
          configurableParams.length <
              (productData?.configurableData?.attributes?.length ?? 0)) {
        ShowMessage.warningNotification(
            StringConstants.pleaseSelectVariants.localized(), context);

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

  void setRecentViewed(NewProducts? productData) async {
    Hive.openBox("recentProducts").then((box) {
      box.put(productData?.id, productData).then(
            (value) =>
                RecentViewController.controller.sink.add(productData?.id),
          );
    });
  }
}
