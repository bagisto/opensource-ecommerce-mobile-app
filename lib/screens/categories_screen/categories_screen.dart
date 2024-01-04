/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, implementation_imports, deprecated_member_use

import 'dart:async';
import 'package:bagisto_app_demo/screens/categories_screen/widget/sub_categories_loader_view.dart';
import 'package:bagisto_app_demo/screens/categories_screen/widget/sub_categories_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_model/categories_data_model/filter_product_model.dart';
import '../../utils/app_global_data.dart';
import '../../utils/assets_constants.dart';
import '../../utils/shared_preference_helper.dart';
import '../../utils/string_constants.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_error_msg.dart';
import '../../widgets/empty_data_view.dart';
import '../../widgets/show_message.dart';
import '../cart_screen/cart_model/add_to_cart_model.dart';
import '../home_page/data_model/new_product_data.dart';
import 'bloc/categories_bloc.dart';
import 'bloc/categories_event.dart';
import 'bloc/categories_state.dart';

class SubCategoryScreen extends StatefulWidget {
  String? title;
  String? image;
  String? categorySlug;
  String? id;
  String? metaDescription;

  SubCategoryScreen(
      {Key? key,
      this.title,
      this.image,
      this.categorySlug,
      this.metaDescription, this.id})
      : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoggedIn = false;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  NewProductsModel? categoriesData;
  AddToCartModel? addToCartModel;
  bool isLoading = false;
  bool? isGrid = true;
  int page = 1;
  List<Map<String, dynamic>> filters = [];
  CategoryBloc? subCategoryBloc;
  ScrollController? _scrollController;
  List<FilterAttribute>? data;

  @override
  void initState() {
    filters.add({"key": '\"category_id\"', "value": '\"${widget.id}\"'});

    _fetchSharedPreferenceData();
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    _scrollController = ScrollController();
    _scrollController?.addListener(() => _setItemScrollListener());
    subCategoryBloc = context.read<CategoryBloc>();
    subCategoryBloc?.add(FilterFetchEvent(widget.categorySlug));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _myStreamCtrl.close();
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

  Future getSharePreferenceCartCount() async {
    return await SharedPreferenceHelper.getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GlobalData.contentDirection(),
      child: Scaffold(
          appBar: CommonAppBar(widget.title ?? ""),
          body: _setSubCategoryData(context)),
    );
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
            ShowMessage.successNotification(state.response?.success ?? "", context);
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
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.errorNotification(state.error ?? "", context);
          } else if (state.status == CategoriesStatus.success) {
            addToCartModel = state.response;
            ShowMessage.successNotification(state.successMsg ?? "", context);
          }
        }
      },
      builder: (BuildContext context, CategoriesBaseState state) {
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
      if (state.status == CategoriesStatus.success) {
        if (page > 1) {
          categoriesData?.data?.addAll(state.categoriesData?.data ?? []);
        } else {
          categoriesData = state.categoriesData;
          isLoading = false;
        }

        if ((categoriesData?.data?.length ?? 0) > 0) {
          SharedPreferenceHelper.setCartCount(
              categoriesData?.data?[0].cart?.itemsCount ?? 0);
          _myStreamCtrl.sink
              .add(categoriesData?.data?[0].cart?.itemsCount ?? 0);
        }
      }
      if (state.status == CategoriesStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
    }
    if (state is FetchDeleteAddItemCategoryState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is RemoveWishlistState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is AddToCartSubCategoriesState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {
        SharedPreferenceHelper.setCartCount(
            addToCartModel?.cart?.itemsCount ?? 0);
        _myStreamCtrl.sink.add(addToCartModel?.cart?.itemsCount);
      }
    }
    if (state is AddToCompareSubCategoryState) {
      isLoading = false;
      if (state.status == CategoriesStatus.success) {
        SharedPreferenceHelper.getCartCount().then((value) {
          _myStreamCtrl.sink.add(value);
        });
      }
    }
    if (state is OnClickSubCategoriesLoaderState) {
      isLoading = state.isReqToShowLoader ?? false;

      SharedPreferenceHelper.getCartCount().then((value) {
        _myStreamCtrl.sink.add(value);
      });
    }
    if (state is FilterFetchState) {
      subCategoryBloc?.add(FetchSubCategoryEvent(
          filters, page));
      if (state.status == CategoriesStatus.success) {
        data = state.filterModel?.filterAttributes;
      }
      if (state.status == CategoriesStatus.fail) {
        return ErrorMessage.errorMsg(state.error ?? "Error");
      }
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
    } else if (categoriesData?.data?.isEmpty ?? false) {
      return const EmptyDataView(
        assetPath: AssetConstants.emptyCatalog,
        message: StringConstants.emptyPageGenericLabel,
      );
    } else {
      return SubCategoriesView(
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
          data, filters);
    }
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
