/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';

class SubCategoryScreen extends StatefulWidget {
  final String? title;
  final String? image;
  final String? categorySlug;
  final String? id;
  final String? metaDescription;
  final List<Map<String, dynamic>>? filters;

  const SubCategoryScreen(
      {super.key,
      this.title,
      this.image,
      this.categorySlug,
      this.metaDescription,
      this.id,
      this.filters});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoggedIn = false;
  NewProductsModel? categoriesData;
  AddToCartModel? addToCartModel;
  bool isLoading = false;
  bool? isGrid = true;
  int page = 1;
  List<Map<String, dynamic>> filters = [];
  CategoryBloc? subCategoryBloc;
  ScrollController? _scrollController;
  GetFilterAttribute? data;
  bool isPreCatching = true;

  @override
  void initState() {
    appStoragePref.setSortName("");

    if ((widget.filters ?? []).isNotEmpty) {
      List<Map<String, String>> formattedFilters = filters.map((filter) {
        return {
          "key": '"${filter['key']}"',
          "value": '"${filter['value']}"',
        };
      }).toList();
      filters.addAll(formattedFilters);
    } else {
      filters.add({"key": '"category_id"', "value": '"${widget.id}"'});
    }

    isLoggedIn = appStoragePref.getCustomerLoggedIn();
    _scrollController = ScrollController();
    _scrollController?.addListener(() => _setItemScrollListener());
    subCategoryBloc = context.read<CategoryBloc>();
    subCategoryBloc?.add(FilterFetchEvent(widget.categorySlug));
    super.initState();
  }

  _setItemScrollListener() {
    if (_scrollController!.hasClients &&
        _scrollController?.position.maxScrollExtent ==
            _scrollController?.offset) {
      if (hasMoreData()) {
        page += 1;
        subCategoryBloc?.add(FetchSubCategoryEvent(filters, page));
      }
    }
  }

  hasMoreData() {
    var total = categoriesData?.paginatorInfo?.total ?? 0;
    return (total > (categoriesData?.data?.length ?? 0) && !isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(widget.title ?? ""),
        body: _setSubCategoryData(context));
  }

  ///Sub categories bloc method
  _setSubCategoryData(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoriesBaseState>(
      listener: (BuildContext context, CategoriesBaseState state) {
        if (state is FetchDeleteAddItemCategoryState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
        if (state is RemoveWishlistState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.successNotification(
                state.response?.message ?? "", context);
          }
        }
        if (state is AddToCompareSubCategoryState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
        if (state is AddToCartSubCategoriesState) {
          isPreCatching = false;
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CategoriesStatus.success) {
            GlobalData.cartCountController.sink
                .add(state.response?.cart?.itemsQty ?? 0);
            addToCartModel = state.response;
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
      },
      builder: (BuildContext context, CategoriesBaseState state) {
        GlobalData.cartCountController.sink.add(appStoragePref.getCartCount());
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, CategoriesBaseState state) {
    if (state is ShowLoaderCategoryState) {
      return const SubCategoriesLoader();
    }
    if (state is FetchSubCategoryState) {
      isPreCatching = true;
      if (state.status == CategoriesStatus.success) {
        if (page > 1) {
          categoriesData?.data?.addAll(state.categoriesData?.data ?? []);
        } else {
          categoriesData = state.categoriesData;
          isLoading = false;
        }
      }
      if (state.status == CategoriesStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    if (state is FetchDeleteAddItemCategoryState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {}
    }
    if (state is RemoveWishlistState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {}
    }
    if (state is AddToCartSubCategoriesState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {
        GlobalData.cartCountController.sink.add(addToCartModel?.cart?.itemsQty);
      }
    }
    if (state is AddToCompareSubCategoryState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {}
    }
    if (state is OnClickSubCategoriesLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;
    }
    if (state is FilterFetchState) {
      subCategoryBloc?.add(FetchSubCategoryEvent(filters, page));
      data = state.filterModel;
    }
    return buildHomePageUI();
  }

  Widget buildHomePageUI() {
    return _subCategoriesData(isLoading);
  }

  ///Sub categories ui method
  _subCategoriesData(bool isLoading) {
    if (categoriesData?.data == null) {
      return const SubCategoriesLoader();
    }
    return SafeArea(
      child: SubCategoriesView(
          isLoading,
          page,
          subCategoryBloc,
          _scrollController,
          widget.title,
          widget.image,
          widget.categorySlug,
          widget.metaDescription,
          categoriesData,
          isLoggedIn,
          data,
          filters,
          isPreCatching),
    );
  }
}
