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
import 'package:bagisto_app_demo/helper/badge_helper.dart';
import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/helper/no_data_class.dart';
import 'package:bagisto_app_demo/helper/shared_preference_helper.dart';
import 'package:bagisto_app_demo/common_widget/show_message.dart';
import 'package:bagisto_app_demo/models/add_to_cart_model/add_to_cart_model.dart';
import 'package:bagisto_app_demo/screens/sub_categories/events/loader_sub_categories_event.dart';
import 'package:bagisto_app_demo/screens/sub_categories/view/sub_categories_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widget/circular_progress_indicator.dart';
import '../../../common_widget/common_error_msg.dart';
import '../../../configuration/app_global_data.dart';
import '../../../models/categories_data_model/categories_product_model.dart';
import '../../../models/categories_data_model/filter_product_model.dart';
import '../../../routes/route_constants.dart';
import '../bloc/sub_categories_bloc.dart';
import '../events/fetch_sub_categories_event.dart';
import '../state/add_delete_item_sub_category_state.dart';
import '../state/addtocart_subcategory_state.dart';
import '../state/addtocompare_subcategory_state.dart';
import '../state/fetch_sub_category_state.dart';
import '../state/loader_sub_category_state.dart';
import '../state/show_loader_category_state.dart';
import '../state/sub_categories_base_state.dart';
import 'empty_sub_categories.dart';

class SubCategoryScreen extends StatefulWidget {
  String? title;
  String? image;
  String? categorySlug;
  String? metaDescription;

  SubCategoryScreen(
      {Key? key,
      this.title,
      this.image,
      this.categorySlug,
      this.metaDescription})
      : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoggedIn = false;
  final StreamController _myStreamCtrl = StreamController.broadcast();
  CategoriesProductModel? categoriesData;


  Stream get onVariableChanged => _myStreamCtrl.stream;
  int? cartCount = 0;
  AddToCartModel? addToCartModel;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;
  bool? isGrid = true;
  int page = 1;
  SubCategoryBloc ? subCategoryBloc;
  ScrollController? _scrollController;
  List<FilterAttribute>? data;

  @override
  void initState() {
    _fetchSharedPreferenceData();
    getSharePreferenceCartCount().then((value) {
      _myStreamCtrl.sink.add(value);
    });
    _scrollController = ScrollController();
    _scrollController?.addListener(() => _setItemScrollListener());
     subCategoryBloc = context.read<SubCategoryBloc>();
    subCategoryBloc?.add(FilterFetchEvent(widget.categorySlug));
    super.initState();
  }

  _setItemScrollListener() {
    if (_scrollController!.hasClients &&
        _scrollController?.position.maxScrollExtent ==
            _scrollController?.offset) {
      if (hasMoreData()) {
        page += 1;
        subCategoryBloc?.add(FetchSubCategoryEvent(widget.categorySlug ?? "", page,"",""/*0,500*/));
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
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Directionality(
        textDirection: GlobalData.contentDirection(),
        child:Scaffold(
          appBar: AppBar(
            title: CommonWidgets.getHeadingText(
                widget.title != null ? widget.title! : "", context),
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
              )
            ],
          ),
          body:  _setSubCategoryData(context),
          ),
        ),
    );
  }

  _cartButtonValue(int count) {
    return BadgeIcon(
        icon: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, CartPage);
          },
        ),
        badgeCount: count);
  }

  ///Sub categories bloc method
  _setSubCategoryData(BuildContext context) {
    return BlocConsumer<SubCategoryBloc, SubCategoriesBaseState>(
      listener: (BuildContext context, SubCategoriesBaseState state) {
        if (state is FetchDeleteAddItemCategoryState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.showNotification("Failed",state.error??"",Colors.red,const Icon(Icons.cancel_outlined));
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.showNotification(state.successMsg??"", "",const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
          }
        }
        if (state is RemoveWishlistState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.showNotification("Failed",state.error??"",Colors.red,const Icon(Icons.cancel_outlined));
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.showNotification(state.response?.success??"","",const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
          }
        }
        if (state is AddToCompareSubCategoryState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.showNotification("Failed",state.error??"",Colors.red,const Icon(Icons.cancel_outlined));
          } else if (state.status == CategoriesStatus.success) {
            ShowMessage.showNotification(state.successMsg??"","",const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));

          }
        }
        if (state is AddToCartSubCategoriesState) {
          if (state.status == CategoriesStatus.fail) {
            ShowMessage.showNotification("Failed",state.error??"",Colors.red,const Icon(Icons.cancel_outlined));
          } else if (state.status == CategoriesStatus.success) {
            addToCartModel = state.response;
            ShowMessage.showNotification(state.successMsg??"","", const Color.fromRGBO(140,194,74,5),const Icon(Icons.check_circle_outline));
          }
        }
      },
      buildWhen: (SubCategoriesBaseState prev, SubCategoriesBaseState current) {
        if (current is FetchSubCategoryState) {
          return true;
        }
        if (current is ShowLoaderCategoryState) {
          return true;
        }
        if (current is FilterFetchState) {
          return true;
        }
        if (current is FetchDeleteAddItemCategoryState) {
          if ((current).status == CategoriesStatus.success) {
            return true;
          }
        }
        if (current is RemoveWishlistState) {
          if ((current).status == CategoriesStatus.success) {
            return true;
          }
        }
        if (current is AddToCartSubCategoriesState) {
          if ((current).status == CategoriesStatus.success) {
            return true;
          }
        }
        if (current is OnClickSubCategoriesLoaderState) {
          return true;
        }
        if (current is AddToCompareSubCategoryState) {
          return true;
        }

        return false;
      },
      builder: (BuildContext context, SubCategoriesBaseState state) {
        return buildContainer(context, state);
      },
    );
  }

  ///build container method
  Widget buildContainer(BuildContext context, SubCategoriesBaseState state) {
    if (state is ShowLoaderCategoryState) {
      return Center(
        child:
            CircularProgressIndicatorClass.circularProgressIndicator(context),
      );
    }
    if (state is FetchSubCategoryState) {
      if (state.status == CategoriesStatus.success) {
        if (page > 1) {
          categoriesData?.data?.addAll(state. categoriesData?.data ?? []);
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
        SharedPreferenceHelper.setCartCount(addToCartModel?.cart?.itemsCount ?? 0);
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
      // return _subCategoriesData(_categoriesData!,  isLoading );
      // }
    }
    if (state is FilterFetchState) {
      subCategoryBloc?.add(FetchSubCategoryEvent(widget.categorySlug ?? "", page,"",""/*0,500*/));
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
      return const NoDataFound();
    } else if (categoriesData?.data!.isEmpty ?? false) {
      return const EmptySubCategories();
    } else {
      return  SubCategoriesView(isLoading,page,subCategoryBloc,_scrollController,widget.title,widget.image,widget.categorySlug,widget.metaDescription,categoriesData,isLoggedIn,data);
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
