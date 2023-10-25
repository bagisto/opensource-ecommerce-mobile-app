/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: constant_identifier_names, file_names

import 'package:bagisto_app_demo/models/address_model/address_model.dart';
import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:bagisto_app_demo/screens/Currency/currency.dart';
import 'package:bagisto_app_demo/screens/Languages/languages.dart';
import 'package:bagisto_app_demo/screens/account/bloc/account_info_bloc.dart';
import 'package:bagisto_app_demo/screens/account/repository/account_info_repository.dart';
import 'package:bagisto_app_demo/screens/account/view/account_screen.dart';
import 'package:bagisto_app_demo/screens/checkout/CheckOutAddres/checkout/view/checkout_address_list.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/bloc/save_order_bloc.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/repository/save_order_repositroy.dart';
import 'package:bagisto_app_demo/screens/checkout/checkout_save_order/view/save_order.dart';
import 'package:bagisto_app_demo/screens/checkout/guest_add_address/view/guest_add_address_form.dart';
import 'package:bagisto_app_demo/screens/checkout/view/checkout_screen.dart';
import 'package:bagisto_app_demo/screens/compare/bloc/compare_screen_bloc.dart';
import 'package:bagisto_app_demo/screens/compare/repository/compare_screen_repository.dart';
import 'package:bagisto_app_demo/screens/compare/view/compare_screen.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/bloc/downloadable_products_bloc.dart';
import 'package:bagisto_app_demo/screens/downloadable_products/repository/dowbloadable_products_repository.dart';
import 'package:bagisto_app_demo/screens/drawer/bloc/drawer_bloc.dart';
import 'package:bagisto_app_demo/screens/drawer/repository/drawer_repository.dart';
import 'package:bagisto_app_demo/screens/homepage/bloc/homepage_bloc.dart';
import 'package:bagisto_app_demo/screens/homepage/repository/homepage_repository.dart';
import 'package:bagisto_app_demo/screens/product_screen/view/product_review_summary_view.dart';
import 'package:bagisto_app_demo/screens/sign_in/bloc/sign_in_bloc.dart';
import 'package:bagisto_app_demo/screens/sign_in/repository/sign_in_repository.dart';
import 'package:bagisto_app_demo/screens/sign_in/view/sign_in_screen.dart';
import 'package:bagisto_app_demo/screens/splash_screen.dart';
import 'package:bagisto_app_demo/screens/orders/bloc/order_bloc.dart';
import 'package:bagisto_app_demo/screens/orders/repository/order_repository.dart';
import 'package:bagisto_app_demo/screens/orders/view/order_list.dart';
import 'package:bagisto_app_demo/screens/review/bloc/review_bloc.dart';
import 'package:bagisto_app_demo/screens/review/repository/review_repository.dart';
import 'package:bagisto_app_demo/screens/review/view/reviews.dart';
import 'package:bagisto_app_demo/screens/search/bloc/search_bloc.dart';
import 'package:bagisto_app_demo/screens/search/repository/search_repository.dart';
import 'package:bagisto_app_demo/screens/search/view/search_screen.dart';
import 'package:bagisto_app_demo/screens/wishList/bloc/wishlist_bloc.dart';
import 'package:bagisto_app_demo/screens/wishList/respository/wishlist_repository.dart';
import 'package:bagisto_app_demo/screens/wishList/view/wishlist_screen.dart';
import '../screens/add_edit_address/bloc/add_edi_address_bloc.dart';
import '../screens/add_edit_address/repository/add_edit_address_repository.dart';
import '../screens/add_edit_address/view/add_edit_address_screen.dart';
import '../screens/add_review/bloc/add_review_bloc.dart';
import '../screens/add_review/repository/AddReviewRepository.dart';
import '../screens/add_review/view/add_review.dart';
import '../screens/address_list/bloc/address_bloc.dart';
import '../screens/address_list/repository/address_repository.dart';
import '../screens/address_list/view/address_screen.dart';
import '../screens/cart_screen/repository/cart_screen_repository.dart';
import '../screens/cart_screen/view/cart_index.dart';
import '../screens/cart_screen/view/cart_screen.dart';
import '../screens/cms_data/bloc/cms_bloc.dart';
import '../screens/cms_data/repository/cms_repository.dart';
import '../screens/cms_data/view/cms_content.dart';
import '../screens/cms_data/view/cms_item_list.dart';
import '../screens/dashboard/view/dashboard.dart';
import '../screens/downloadable_products/view/downloadable_products.dart';
import '../screens/forget_password/bloc/forget_password_bloc.dart';
import '../screens/forget_password/repository/forget_password_repository.dart';
import '../screens/forget_password/view/forget_password.dart';
import '../screens/homepage/view/homepage_view.dart';
import '../screens/invoices_list/bloc/invoices_bloc.dart';
import '../screens/invoices_list/bloc/invoices_repository.dart';
import '../screens/invoices_list/view/invoices_list_view.dart';
import '../screens/notifications/bloc/notification_bloc.dart';
import '../screens/notifications/bloc/notification_repository.dart';
import '../screens/notifications/notification_view.dart';
import '../screens/order_detail/bloc/order_detail_bloc.dart';
import '../screens/order_detail/repository/order_detail_repository.dart';
import '../screens/order_detail/view/order_detail.dart';
import '../screens/product_categories_screen/product_categories.dart';
import '../screens/product_screen/bloc/product_screen_bloc.dart';
import '../screens/product_screen/repository/product_repository.dart';
import '../screens/product_screen/view/product_screen.dart';
import '../screens/refund_list/refund_bloc/refund_bloc.dart';
import '../screens/refund_list/refund_bloc/refund_repository.dart';
import '../screens/refund_list/refund_view/refund_list_view.dart';
import '../screens/shipment_list/bloc/shipment_list_bloc.dart';
import '../screens/shipment_list/repository/shipment_list_repository.dart';
import '../screens/shipment_list/view/shipmrnt_list_view.dart';
import '../screens/sign_up/bloc/sign_up_bloc.dart';
import '../screens/sign_up/repository/sign_up_repository.dart';
import '../screens/sign_up/view/sign_up.dart';
import '../screens/sub_categories/bloc/sub_categories_bloc.dart';
import '../screens/sub_categories/repository/sub_categories_repository.dart';
import '../screens/sub_categories/view/sub_categories.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case Home:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomePageBloc>(
                create: (context) =>
                    HomePageBloc(repository: HomePageRepositoryImp(),context: context)),
            BlocProvider<DrawerBloc>(
                create: (context) =>
                    DrawerBloc(repository: DrawerPageRepositoryImp())),
          ],
          child: const HomeScreen(),
        ),
      );
    case SignIn:
      return MaterialPageRoute(builder: (_) =>   BlocProvider(
        create: (context) => SignInBloc(repository: SignInRepositoryImp()),
        child: const SignInScreen(),
      ));
    case SignUp:
      return MaterialPageRoute(builder: (_) =>   BlocProvider(
        create: (context) => SignUpBloc(repository: SignUpRepositoryImp()),
        child: const SignUpScreen(),
      ));

  // const SignUpScreen());
    case CurrenciesPage:
      return MaterialPageRoute(
          builder: (_) =>
              CurrencyData(currencyLanguageList: settings.arguments as CurrencyLanguageList));
    case Languages:
      return MaterialPageRoute(
        builder: (_) => const Language(),
      );

    case CategoryProduct:
      DrawerSubCategories argData = settings.arguments as DrawerSubCategories;
      return MaterialPageRoute(
          builder: (_) => ProductCategoriesList(
            title: (argData.title),
            category: (argData.category),
          ));
    case SubCategory:
      CategoryProductData productData=settings.arguments as CategoryProductData;
      return MaterialPageRoute(
          builder: (_) =>  BlocProvider(
              create: (context) => SubCategoryBloc(repository: SubCategoriesRepositoryImp(),context: context),
              child:     SubCategoryScreen(
                title: (productData.title),
                image: (productData.image),
                categorySlug: (productData.categorySlug),
                metaDescription: (productData.metaDescription),
              )
          ));

    case CmsDataList:
      return MaterialPageRoute(
          builder: (_) =>  BlocProvider(
              create: (context) => CmsBloc(repository: CmsRepositoryImp()),
              child:     CmsItemsList(
              )
          ));
    case ProductPage:
      PassProductData productData=settings.arguments as PassProductData;
      return MaterialPageRoute(
          builder: (_) =>
              MultiBlocProvider(
                  providers: [
                    BlocProvider<ProductScreenBLoc>(create: (BuildContext context) => ProductScreenBLoc(repository: ProductScreenRepositoryImp())),
                    BlocProvider<CartScreenBloc>(create: (BuildContext context) => CartScreenBloc(repository:  CartScreenRepositoryImp())),
                  ],
            child:    ProductScreen(title: (productData.title),
              productId: productData.productId,),
          )
      );

    case Search:
      return MaterialPageRoute(builder: (_)=>
          MultiBlocProvider(
            providers: [
              BlocProvider<SearchBloc>(create: (BuildContext context) => SearchBloc(repository: SearchRepositoryImp())),
            ],
            child: const SearchScreen(),
          )

      );

    case OrderPlacedScreen:
      return MaterialPageRoute(builder: (_)=> BlocProvider(
        create: (context) => SaveOrderBloc(repository: SaveOrderRepositoryImp()),
        child: const CheckOutSaveOrder(),
      )

      );


    case AccountInfo:
      return  MaterialPageRoute(
          builder: (_) =>  BlocProvider(
              create: (context) => AccountInfoBloc(repository: AccountInfoRepositoryImp()),
              child:     const AccountScreen(
              )
          ));



    case AddressList:
      return MaterialPageRoute(
          builder: (_) =>  BlocProvider(
              create: (context) => AddressBloc(repository: AddressRepositoryImp()),
              child:      const AddressScreen(
              )
          ));
    case Dashboard:
      return  MaterialPageRoute(builder: (context)=>const DashboardScreen());
    case ReviewList:
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
          create: (context) => ReviewsBloc(repository: ReviewsRepositoryImp(),context: context),
          child:      ReviewsScreen(
          )
      ));
    case AddReviewData:
      AddReviewDetail addReviewDetail=settings.arguments as AddReviewDetail;
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
        create: (context) => AddReviewBloc(repository: AddReviewRepositoryImp()),
        child:AddReview(imageUrl: addReviewDetail.imageUrl,productId: addReviewDetail.productId,productName: addReviewDetail.productName,),
      ));

    case WishListDataScreen:
      return MaterialPageRoute(builder: (_)=> BlocProvider(
          create: (context) => WishListBloc(repository: WishListRepositoryImp(),context: context),
          child:     const WishListScreen(
          )
      )
      );

    case OrderListData:
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
          create: (context) => OrderListBloc(repository: OrderListRepositoryImp(),context: context),
          child:      OrdersList()
      )
      );

    case DownLoadProductData:
      return MaterialPageRoute(builder: (_)=> const DownLoadableScreen(),
      );
    case CmsContentData:
      CmsDataContent cmsDataContent=settings.arguments as CmsDataContent;
      return  MaterialPageRoute(
          builder: (_) =>  BlocProvider(
              create: (context) => CmsBloc(repository: CmsRepositoryImp()),
              child:     CmsContent(
                title: cmsDataContent.title,
                id:cmsDataContent.id,
                index: cmsDataContent.index,
              )
          ));

    case AddAddress:
      AddressNavigationData addressNavigationData=settings.arguments as AddressNavigationData;
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
        create: (context) => AddEditAddressBloc(repository: AddEditAddressRepositoryImp()),
        child:AddNewAddress(addressNavigationData.isEdit!,
            addressNavigationData.addressModel),
      ));

    case CompareProduct:
      return MaterialPageRoute(builder: (_)=> /*const CompareScreen(),*/BlocProvider(
        create: (context) => CompareScreenBloc(repository: CompareScreenRepositoryImp(),context: context),
        child: const CompareScreen(),
      )
      );

    case OrderDetailPage:
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
          create: (context) => OrderDetailBloc(repository: OrderDetailRepositoryImp()),
          child:     OrderDetailScreen(orderId:settings.arguments as int
          )
      )

      );

    case CartPage:
      return MaterialPageRoute(builder: (_)=> BlocProvider(
        create: (context) => CartScreenBloc(repository: CartScreenRepositoryImp()),
        child:const CartScreen(),
      ),
      );

    case Checkout:
      CartNavigationData cartNavigationData=settings.arguments as CartNavigationData;
      return MaterialPageRoute(builder: (_)=>  CheckoutScreen(total:cartNavigationData.total,cartScreenBloc:cartNavigationData.cartScreenBloc,
          cartDetailsModel: cartNavigationData.cartDetailsModel, isDownloadable: cartNavigationData.isDownloadable),
      );

    case CheckOutAddressList:
      return MaterialPageRoute(builder: (_)=>  CheckoutAddressList(addressModel: settings.arguments as AddressModel,),
      );

    case CheckOutAddressForm:
      return MaterialPageRoute(builder: (_)=>  GuestAddAddressForm(),
      );

    case ForgetPassword:
      return MaterialPageRoute(builder: (_)=>  BlocProvider(
          create: (context) => ForgetPasswordBloc(repository: ForgetPasswordRepositoryImp(),),
          child:     const ForgetPasswordScreen()
      )
      );

    case Notifications:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => NotificationScreenBloc(
                  repository: NotificationRepositoryImp()),
              child: const NotificationScreen()));

    case DownloadableProducts:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => DownloadableProductsBloc(
                  repository: DownloadableProductsRepositoryImp()),
              child: const DownLoadableScreen()));

    case ShipmentListView:
      Map<String, dynamic> data = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => ShipmentListBloc(
                  repository: ShipmentListRepositoryImp()),
              child:  ShipmentListScreen(orderId: data["orderId"], orderDetailModel: data["orderDetailModel"],)));

    case InvoiceListView:
      Map<String, dynamic> data = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => InvoiceListBloc(
                  repository: InvoiceListRepositoryImp()),
              child:  OrderInvoiceListScreen(orderId: data["orderId"], orderDetailModel: data["orderDetailModel"],)));

    case RefundListView:
      Map<String, dynamic> data = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => RefundListBloc(
                  repository: RefundListRepositoryImp()),
              child:  OrderRefundListScreen(orderId: data["orderId"], orderDetailModel: data["orderDetailModel"],)));

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}
