/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/data_model/app_route_arguments.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_bloc.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_repository.dart';
import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/bloc/add_edit_address_bloc.dart';
import 'package:bagisto_app_demo/screens/add_edit_address/bloc/add_edit_address_repository.dart';
import 'package:bagisto_app_demo/screens/address_list/bloc/address_bloc.dart';
import 'package:bagisto_app_demo/screens/address_list/bloc/address_repository.dart';
import 'package:bagisto_app_demo/screens/address_list/view/address_screen.dart';
import 'package:bagisto_app_demo/screens/categories_screen/bloc/categories_bloc.dart';
import 'package:bagisto_app_demo/screens/categories_screen/bloc/categories_repository.dart';
import 'package:bagisto_app_demo/screens/categories_screen/categories_screen.dart';
import 'package:bagisto_app_demo/screens/drawer/bloc/drawer_bloc.dart';
import 'package:bagisto_app_demo/screens/drawer/bloc/drawer_repository.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_bloc.dart';
import 'package:bagisto_app_demo/screens/forget_password/bloc/forget_password_repository.dart';
import 'package:bagisto_app_demo/screens/forget_password/forget_password.dart';
import 'package:bagisto_app_demo/screens/home_page/bloc/home_page_bloc.dart';
import 'package:bagisto_app_demo/screens/home_page/bloc/home_page_repository.dart';
import 'package:bagisto_app_demo/screens/home_page/home_page.dart';
import 'package:bagisto_app_demo/screens/order_detail/bloc/order_detail_bloc.dart';
import 'package:bagisto_app_demo/screens/order_detail/bloc/order_detail_repository.dart';
import 'package:bagisto_app_demo/screens/order_detail/view/order_detail.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_bloc.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_repo.dart';
import 'package:bagisto_app_demo/screens/review/screen/reviews.dart';
import 'package:bagisto_app_demo/screens/sign_in/bloc/sign_in_bloc.dart';
import 'package:bagisto_app_demo/screens/sign_in/bloc/sign_in_repository.dart';
import 'package:bagisto_app_demo/screens/sign_in/sign_in_screen.dart';
import 'package:bagisto_app_demo/screens/sign_up/bloc/sign_up_bloc.dart';
import 'package:bagisto_app_demo/screens/sign_up/bloc/sign_up_repository.dart';
import 'package:bagisto_app_demo/screens/sign_up/sign_up.dart';
import 'package:bagisto_app_demo/screens/splash_screen/splash_screen.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import '../screens/add_edit_address/view/add_edit_address_screen.dart';
import '../screens/add_review/bloc/add_review_bloc.dart';
import '../screens/add_review/bloc/add_review_repository.dart';
import '../screens/add_review/view/add_review.dart';
import '../screens/address_list/data_model/address_model.dart';
import '../screens/cart_screen/bloc/cart_screen_bloc.dart';
import '../screens/cart_screen/bloc/cart_screen_repository.dart';
import '../screens/cart_screen/cart_screen.dart';
import '../screens/checkout/checkout_addres/bloc/checkout_bloc.dart';
import '../screens/checkout/checkout_addres/bloc/checkout_repository.dart';
import '../screens/checkout/checkout_addres/view/widget/checkout_address_list.dart';
import '../screens/checkout/checkout_save_order/bloc/save_order_bloc.dart';
import '../screens/checkout/checkout_save_order/bloc/save_order_repositroy.dart';
import '../screens/checkout/checkout_save_order/view/save_order.dart';
import '../screens/checkout/view/checkout_screen.dart';
import '../screens/cms_screen/bloc/cms_bloc.dart';
import '../screens/cms_screen/bloc/cms_repository.dart';
import '../screens/cms_screen/cms_view.dart';
import '../screens/compare/bloc/compare_screen_bloc.dart';
import '../screens/compare/bloc/compare_screen_repository.dart';
import '../screens/compare/view/compare_screen.dart';
import '../screens/dashboard/view/dashboard.dart';
import '../screens/downloadable_products/bloc/dowbloadable_products_repository.dart';
import '../screens/downloadable_products/bloc/downloadable_products_bloc.dart';
import '../screens/downloadable_products/view/downloadable_products.dart';
import '../screens/drawer_sub_categories/bloc/drawer_sub_categories_bloc.dart';
import '../screens/drawer_sub_categories/bloc/drawer_sub_categories_repository.dart';
import '../screens/drawer_sub_categories/drawer_sub_categories.dart';
import '../screens/home_page/utils/route_argument_helper.dart';
import '../screens/orders/bloc/order_list_bloc.dart';
import '../screens/orders/bloc/order_list_repo.dart';
import '../screens/orders/screen/order_list.dart';
import '../screens/product_screen/bloc/product_page_bloc.dart';
import '../screens/product_screen/bloc/product_page_repository.dart';
import '../screens/product_screen/view/product_screen.dart';
import '../screens/search_screen/bloc/search_bloc.dart';
import '../screens/search_screen/bloc/search_repository.dart';
import '../screens/search_screen/view/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/wishList/bloc/wishlist_bloc.dart';
import '../screens/wishList/bloc/wishlist_repository.dart';
import '../screens/wishList/view/wishlist_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case home:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomePageBloc>(
                create: (context) => HomePageBloc(HomePageRepositoryImp())),
            BlocProvider<DrawerBloc>(
                create: (context) =>
                    DrawerBloc(repository: DrawerPageRepositoryImp())),
          ],
          child: const HomeScreen(),
        ),
      );

    case categoryScreen:
      CategoriesArguments data = settings.arguments as CategoriesArguments;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> CategoryBloc(CategoriesRepo()),
          child: SubCategoryScreen(title: data.title, image: data.image,
          categorySlug: data.categorySlug, metaDescription: data.metaDescription, id: data.id),
        ),
      );

    case productScreen :
      PassProductData productData = settings.arguments as PassProductData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> ProductScreenBLoc(ProductScreenRepo()),
          child: ProductScreen(title: (productData.title),
            productId: productData.productId, urlKey: productData.urlKey),
        ),
      );

    case searchScreen :
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> SearchBloc(SearchRepositoryImp()),
          child: const SearchScreen(),
        ),
      );

    case cartScreen :
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> CartScreenBloc(CartScreenRepositoryImp()),
          child: const CartScreen(),
        ),
      );

    case cmsScreen :
      CmsDataContent? data = settings.arguments as CmsDataContent;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> CmsBloc(CmsRepositoryImp()),
          child: CmsContent(title: data.title, id: data.id, index: data.index),
        ),
      );

    case wishlistScreen :
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> WishListBloc(WishListRepositoryImp()),
          child: const WishListScreen(),
        ),
      );

    case signIn:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                SignInBloc(repository: SignInRepositoryImp()),
            child: const SignInScreen(),
          ));

    case signUp:
      bool addShopSlug = settings.arguments as bool;
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                SignUpBloc(repository: SignUpRepositoryImp()),
            child: SignUpScreen(
              addShopSlug: addShopSlug,
            ),
          ));

    case forgotPassword:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => ForgetPasswordBloc(
                repository: ForgetPasswordRepositoryImp(),
              ),
              child: const ForgetPasswordScreen()));

    case accountInfo:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) =>
                  AccountInfoBloc(repository: AccountInfoRepositoryImp()),
              child: const AccountScreen()));

    case orderDetailPage:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) =>
                  OrderDetailBloc(repository: OrderDetailRepositoryImp()),
              child: OrderDetailScreen(orderId: settings.arguments as int)));

    case addressList:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) =>
                  AddressBloc( AddressRepositoryImp()),
              child: const AddressScreen()));

    case reviewList:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => ReviewsBloc(
                  repository: ReviewsRepositoryImp(), context: context),
              child: ReviewsScreen()));


    case addressListScreen :
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> AddressBloc(AddressRepositoryImp()),
          child: const AddressScreen(),
        ),
      );

    case addAddressScreen :
      AddressNavigationData data = settings.arguments as AddressNavigationData;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context)=> AddEditAddressBloc(AddEditAddressRepositoryImp()),
          child: AddNewAddress(data.isEdit ?? false, data.addressModel, isCheckout: data.isCheckout),
        ),
      );

    case checkOutAddressList:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (BuildContext context) => CheckOutBloc(CheckOutRepositoryImp()),
          child: CheckoutAddressList(
            addressModel: settings.arguments as AddressModel,
          ),
        ),
      );

    case orderPlacedScreen:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                SaveOrderBloc(SaveOrderRepositoryImp()),
            child: const CheckOutSaveOrder(),
          ));

    case checkoutScreen:
      CartNavigationData cartNavigationData =
      settings.arguments as CartNavigationData;
      return MaterialPageRoute(
        builder: (_) => CheckoutScreen(
            total: cartNavigationData.total,
            cartScreenBloc: cartNavigationData.cartScreenBloc,
            cartDetailsModel: cartNavigationData.cartDetailsModel,
            isDownloadable: cartNavigationData.isDownloadable),
      );

    case orderListScreen:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => OrderListBloc(
                  repository: OrderListRepositoryImp()),
              child: const OrdersList()));

    case dashboardScreen:
      return MaterialPageRoute(builder: (context) => const DashboardScreen());

    case addReviewScreen:
      AddReviewDetail addReviewDetail = settings.arguments as AddReviewDetail;
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => AddReviewBloc(
                  AddReviewRepositoryImp()),
              child: AddReview(imageUrl: addReviewDetail.imageUrl,
                productId: addReviewDetail.productId,
                productName: addReviewDetail.productName)));

    case compareScreen:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => CompareScreenBloc(
                  CompareScreenRepositoryImp()),
              child: const CompareScreen()));

    case downloadableProductScreen:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => DownloadableProductsBloc(
                  DownloadableProductsRepositoryImp()),
              child: const DownLoadableScreen()));

    case drawerSubCategoryScreen:
      CategoriesArguments data = settings.arguments as CategoriesArguments;
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => DrawerSubCategoriesBloc(
                  DrawerSubCategoryRepo()),
              child: DrawerSubCategoryView(id: data.id, title: data.title)));

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

