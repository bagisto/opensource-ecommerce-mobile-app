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
import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';
import 'package:bagisto_app_demo/screens/drawer_sub_categories/utils/index.dart';

import '../../widgets/price_widget.dart';
import '../../widgets/wishlist_compare_widget.dart';
import '../home_page/data_model/new_product_data.dart';

class DrawerSubCategoryView extends StatefulWidget {
  final String? title;
  final String? id;
  final String? image;
  final String? categorySlug;
  final String? metaDescription;
  final String? parentId;

  const DrawerSubCategoryView(
      {Key? key,
      this.title,
      this.id,
      this.image,
      this.categorySlug,
      this.metaDescription,
      this.parentId})
      : super(key: key);

  @override
  State<DrawerSubCategoryView> createState() => _DrawerSubCategoryViewState();
}

class _DrawerSubCategoryViewState extends State<DrawerSubCategoryView> {
  GetDrawerCategoriesData? categoriesData;
  NewProductsModel? categoriesProductData;
  DrawerSubCategoriesBloc? bloc;
  bool isLoading = false;

  @override
  void initState() {
    bloc = context.read<DrawerSubCategoriesBloc>();
    bloc?.add(FetchDrawerSubCategoryEvent([
      {"key": '"status"', "value": '"1"'},
      {"key": '"locale"', "value": '"${GlobalData.locale}"'},
      {"key": '"parent_id"', "value": '"${widget.parentId}"'}
    ]));
    super.initState();
  }

  fetchProducts() {
    bloc?.add(FetchCategoryProductsEvent([
      {"key": '"category_id"', "value": '"${widget.id}"'}
    ], 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        centerTitle: false,
      ),
      body: _subCategoriesList(),
    );
  }

  _subCategoriesList() {
    return BlocConsumer<DrawerSubCategoriesBloc, DrawerSubCategoriesState>(
      listener: (context, state) {
        if (state is AddToCartState) {
          isLoading = false;
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(
                state.graphQlBaseModel?.graphqlErrors ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.graphQlBaseModel?.message ?? "", context);
            appStoragePref
                .setCartCount(state.graphQlBaseModel?.cart?.itemsQty ?? 0);
            GlobalData.cartCountController.sink
                .add(state.graphQlBaseModel?.cart?.itemsQty ?? 0);
          }
        } else if (state is AddWishlistState) {
          fetchProducts();
          isLoading = false;
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.message ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        } else if (state is RemoveWishlistState) {
          fetchProducts();
          isLoading = false;
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.message ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        }
        if (state is AddToCompareState) {
          isLoading = false;
          if (state.status == Status.fail) {
            ShowMessage.errorNotification(state.successMsg ?? "", context);
          } else if (state.status == Status.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
      },
      builder: (context, state) {
        if (state is DrawerSubCategoryInitialState) {
          isLoading = true;
        } else if (state is FetchDrawerSubCategoryState) {
          fetchProducts();
          if (state.status == Status.success) {
            categoriesData = state.getCategoriesData;
          } else if (state.status == Status.fail) {}
        }
        if (state is FetchCategoryProductsState) {
          isLoading = false;
          if (state.status == Status.success) {
            categoriesProductData = state.categoriesData;
          }
          if (state.status == Status.fail) {}
        }

        var allParents = categoriesData?.data
            ?.firstWhereOrNull((element) => element.id == widget.id);

        return SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.image != "" && widget.image != null
                        ? ImageView(
                            url: widget.image ?? "",
                            height: MediaQuery.of(context).size.height / 3.5,
                            width: MediaQuery.of(context).size.width,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if((categoriesData?.data ?? []).isNotEmpty || (allParents?.children ?? []).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(StringConstants.subCategories.localized(),
                          style: Theme.of(context).textTheme.titleMedium),
                        ),

                        if (widget.parentId != "1")
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...?categoriesData?.data
                                  ?.map((parent) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppSizes.spacingMedium),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        foregroundImage: NetworkImage(
                                            parent.logoUrl ?? ""),
                                        radius: 30,
                                        backgroundImage: const AssetImage(
                                            AssetConstants.placeHolder),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: AppSizes.screenWidth / 4,
                                        child: Text(parent.name ?? "",
                                            style: const TextStyle(
                                                fontSize: 12
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            softWrap: true),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if ((parent.children ?? []).isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, drawerSubCategoryScreen,
                                        arguments: CategoriesArguments(
                                            categorySlug: parent.slug,
                                            title: parent.name,
                                            id: parent.id.toString(),
                                            image: parent.bannerUrl,
                                            parentId:
                                            parent.id.toString()));
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      categoryScreen,
                                      arguments: CategoriesArguments(
                                          metaDescription:
                                          parent.description,
                                          categorySlug: parent.slug,
                                          title: parent.name,
                                          id: parent.id.toString(),
                                          image: parent.bannerUrl),
                                    );
                                  }
                                },
                              ))
                                  .toList(),
                            ],
                          ),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...?allParents?.children
                                  ?.map((parent) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppSizes.spacingMedium),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        foregroundImage: NetworkImage(
                                            parent.logoUrl ?? ""),
                                        radius: 30,
                                        backgroundImage: const AssetImage(
                                            AssetConstants.placeHolder),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: AppSizes.screenWidth / 4,
                                        child: Text(parent.name ?? "",
                                            style: const TextStyle(
                                                fontSize: 12
                                            ),
                                            maxLines: 2,
                                        textAlign: TextAlign.center,
                                        softWrap: true),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, drawerSubCategoryScreen,
                                      arguments: CategoriesArguments(
                                          categorySlug: parent.slug,
                                          title: parent.name,
                                          id: parent.id.toString(),
                                          image: parent.bannerUrl,
                                          parentId: parent.id.toString()));
                                },
                              ))
                                  .toList()
                            ],
                          ),
                        )
                      ],
                    ),
                    productsView(appStoragePref.getCustomerLoggedIn()),
                  ],
                ),
              ),
              Visibility(visible: isLoading, child: const Loader()),
            ],
          ),
        );
      },
    );
  }

  Widget productsView(bool isLogin) {
    return ((categoriesProductData?.data ?? []).isNotEmpty || isLoading)
        ? Container(
            height: (categoriesProductData?.data?.isNotEmpty ?? false)
                ? (MediaQuery.of(context).size.width / 1.5) + 220
                : 0,
            color: Theme.of(context).colorScheme.secondaryContainer,
            padding: const EdgeInsets.all(AppSizes.spacingNormal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.products.localized(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, categoryScreen,
                            arguments: CategoriesArguments(
                                metaDescription: widget.metaDescription,
                                categorySlug: widget.categorySlug ?? "",
                                title: widget.title,
                                id: widget.id,
                                image: widget.image ?? ""));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightWhiteColor),
                        ),
                        child: Text(StringConstants.viewAllLabel.localized(),
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categoriesProductData?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        NewProducts? val = categoriesProductData?.data?[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, productScreen,
                                arguments: PassProductData(
                                    title: val?.name ?? "",
                                    urlKey: val?.urlKey,
                                    productId: int.parse(val?.id ?? "")));
                          },
                          child: SizedBox(
                            width: AppSizes.screenWidth / 1.8,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      (val?.url != null ||
                                              ((val?.images?.length ?? 0) > 0 &&
                                                  (val?.images ?? [])
                                                      .isNotEmpty))
                                          ? ImageView(
                                              url: val?.images?[0].url ??
                                                  val?.url ??
                                                  "",
                                              height:
                                                  AppSizes.screenHeight * 0.25,
                                              width: AppSizes.screenWidth,
                                              fit: BoxFit.fill,
                                            )
                                          : ImageView(
                                              url: "",
                                              height:
                                                  AppSizes.screenHeight * 0.25,
                                              width: AppSizes.screenWidth,
                                              fit: BoxFit.fill,
                                            ),
                                      (val?.isInSale ?? false)
                                          ? Positioned(
                                              left: AppSizes.spacingNormal,
                                              top: AppSizes.spacingNormal,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: AppSizes
                                                            .spacingMedium,
                                                        vertical: AppSizes
                                                            .spacingSmall),
                                                    child: Text(
                                                      StringConstants.sale
                                                          .localized(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ))
                                          : ((val?.productFlats?[0].isNew ??
                                                      true) ||
                                                  (val?.isNew ?? false))
                                              ? Positioned(
                                                  left: AppSizes.spacingSmall,
                                                  top: AppSizes.spacingSmall,
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              AppSizes
                                                                  .spacingLarge)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: AppSizes
                                                            .spacingNormal,
                                                        right: AppSizes
                                                            .spacingNormal,
                                                        top: AppSizes
                                                                .spacingSmall /
                                                            2,
                                                        bottom: AppSizes
                                                            .spacingSmall,
                                                      ),
                                                      child: Text(
                                                        StringConstants
                                                            .statusNew
                                                            .localized(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  color: Colors.transparent,
                                                ),
                                      Positioned(
                                        right: AppSizes.spacingNormal,
                                        top: 10,
                                        child: InkWell(
                                            onTap: () {
                                              checkInternetConnection()
                                                  .then((value) {
                                                if (value) {
                                                  if (isLogin) {
                                                    if (val?.isInWishlist ??
                                                        false) {
                                                      bloc?.add(
                                                        RemoveWishlistItemEvent(
                                                          val?.id ?? "",
                                                        ),
                                                      );
                                                    } else {
                                                      bloc?.add(
                                                        AddWishlistEvent(
                                                          val?.id ?? "",
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    ShowMessage
                                                        .warningNotification(
                                                            StringConstants
                                                                .pleaseLogin
                                                                .localized(),
                                                            context);
                                                  }
                                                } else {
                                                  ShowMessage.errorNotification(
                                                      StringConstants
                                                          .internetIssue
                                                          .localized(),
                                                      context);
                                                }
                                              });
                                            },
                                            child: wishlistIcon(
                                                context, val?.isInWishlist)),
                                      ),
                                      Positioned(
                                        right: 8.0,
                                        top: 45,
                                        child: InkWell(
                                            onTap: () {
                                              checkInternetConnection()
                                                  .then((value) {
                                                if (value) {
                                                  if (isLogin) {
                                                    bloc?.add(
                                                      AddToCompareEvent(
                                                          val?.id ??
                                                              val?.productId ??
                                                              ""),
                                                    );
                                                  } else {
                                                    ShowMessage
                                                        .warningNotification(
                                                            StringConstants
                                                                .pleaseLogin
                                                                .localized(),
                                                            context);
                                                  }
                                                } else {
                                                  ShowMessage.errorNotification(
                                                      StringConstants
                                                          .internetIssue
                                                          .localized(),
                                                      context);
                                                }
                                              });
                                            },
                                            child: compareIcon(context)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: AppSizes.spacingNormal,
                                        ),
                                        child: SizedBox(
                                          width: AppSizes.screenWidth / 2,
                                          child: CommonWidgets()
                                              .getDrawerTileText(
                                                  val?.productFlats
                                                          ?.firstWhereOrNull(
                                                              (element) =>
                                                                  element
                                                                      .locale ==
                                                                  GlobalData
                                                                      .locale)
                                                          ?.name ??
                                                      val?.name ??
                                                      "",
                                                  context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSizes.spacingLarge),
                                  PriceWidgetHtml(
                                      priceHtml:
                                          val?.priceHtml?.priceHtml ?? ""),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: Opacity(
                                      opacity:
                                          (val?.isSaleable ?? false) ? 1 : 0.3,
                                      child: CommonWidgets().appButton(
                                          context,
                                          StringConstants.addToCart.localized(),
                                          MediaQuery.of(context).size.width,
                                          (val?.isSaleable ?? false)
                                              ? () {
                                                  checkInternetConnection()
                                                      .then((value) {
                                                    if (value) {
                                                      if (((val?.priceHtml
                                                                  ?.type) ==
                                                              StringConstants
                                                                  .simple ||
                                                          val?.type ==
                                                              StringConstants
                                                                  .simple ||
                                                          val?.type ==
                                                              StringConstants
                                                                  .virtual)&& ((val?.customizableOptions??[]).length ==0) ) {
                                                        bloc?.add(
                                                            AddToCartEvent(
                                                                int.parse(
                                                                    val?.id ??
                                                                        "0"),
                                                                1));
                                                      } else {
                                                        ShowMessage
                                                            .warningNotification(
                                                                StringConstants
                                                                    .addOptions
                                                                    .localized(),
                                                                context);
                                                        Navigator.pushNamed(context, productScreen,
                                                            arguments: PassProductData(
                                                                title: val?.name ?? "",
                                                                urlKey: val?.urlKey,
                                                                productId: int.parse(val?.id ?? "")));
                                                      }
                                                    } else {
                                                      ShowMessage
                                                          .errorNotification(
                                                              StringConstants
                                                                  .internetIssue
                                                                  .localized(),
                                                              context);
                                                    }
                                                  });
                                                }
                                              : () {}),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        : const EmptyDataView(
            assetPath: AssetConstants.emptyCatalog,
            message: StringConstants.noProducts,
          );
  }
}
