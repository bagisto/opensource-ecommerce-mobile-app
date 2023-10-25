/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

import 'dart:developer';
import 'package:bagisto_app_demo/api/graph_ql.dart';
import 'package:bagisto_app_demo/base_model/graphql_base_model.dart';
import 'package:bagisto_app_demo/configuration/app_global_data.dart';
import 'package:bagisto_app_demo/models/add_review_model/add_review_model.dart';
import 'package:bagisto_app_demo/models/categories_data_model/categories_product_model.dart';
import 'package:bagisto_app_demo/models/currency_language_model.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:bagisto_app_demo/models/homepage_model/home_sliders_model.dart';
import 'package:bagisto_app_demo/models/order_model/OrdersListModel.dart';
import 'package:bagisto_app_demo/models/order_model/order_detail_model.dart'
    as order_detail;
import 'package:bagisto_app_demo/models/review_model/review_model.dart';
import 'package:bagisto_app_demo/models/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/models/wishlist_model/wishlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../helper/shared_preference_helper.dart';
import '../models/account_models/account_info_details.dart';
import '../models/account_models/account_update_model.dart';
import '../models/add_to_cart_model/add_to_cart_model.dart';
import '../models/add_to_wishlist_model/add_wishlist_model.dart';
import '../models/address_model/address_model.dart';
import '../models/address_model/country_model.dart';
import '../models/address_model/update_address_model.dart';
import '../models/cart_model/cart_data_model.dart';
import '../models/categories_data_model/filter_product_model.dart';
import '../models/checkout_models/apply_coupon.dart';
import '../models/checkout_models/checkout_save_address_model.dart';
import '../models/checkout_models/checkout_save_shipping_model.dart';
import '../models/checkout_models/save_order_model.dart';
import '../models/checkout_models/save_payment_model.dart';
import '../models/cms_model/cms_model.dart';
import '../models/compare_model/compare_product_model.dart';
import '../models/downloadable_products/download_product_model.dart';
import '../models/downloadable_products/downloadable_product_model.dart';
import '../models/homepage_model/get_categories_drawer_data_model.dart';
import '../models/homepage_model/new_product_data.dart';
import '../models/notification_model/notification_model.dart';
import '../models/order_model/order_invoices_model.dart';
import '../models/order_model/order_refund_model.dart';
import '../models/order_model/shipment_model.dart';
import '../models/product_model/product_screen_model.dart' as product;
import 'mutation_query.dart';

typedef Parser<T> = T Function(Map<String, dynamic> json);

class ApiClient {
  GraphQlApiCalling client = GraphQlApiCalling();
  MutationsData mutation = MutationsData();

  Future<T?> handleResponse<T>(
    QueryResult<Object?> result,
    String operation,
    Parser<T> parser,)
  async {
// Logging response
    log("\nDATA -> ${result.data}\n\n");
    log("\n COOKIE DATA -> ${result.context.entry<HttpLinkResponseContext>()?.headers?['set-cookie']}\n\n");
    await SharedPreferenceHelper.setCookie(result.context
            .entry<HttpLinkResponseContext>()
            ?.headers?['set-cookie'] ??
        "");
    GlobalData.cookie = await SharedPreferenceHelper.getCookie();
    log("\nEXCEPTION -> ${result.exception}\n\n");

    Map<String, dynamic>? data = {};
    if (result.hasException) {
      data.putIfAbsent(
        "success",
        () => result.exception?.graphqlErrors.first.message,
      );
      data.putIfAbsent("status", () => false);
    } else {
      // to parse model if it is List
      if (result.data![operation] is List) {
        data = {'data': result.data![operation]};
      } else {
        data = result.data![operation];
      }
      data?.putIfAbsent("status", () => true);

      // this will work if model already contains status key
      data?.putIfAbsent("responseStatus", () => true);
    }
    return parser(data ?? {});
  }

  //Customer Register
  Future<SignInModel?> getSignUpData(
    String email,
    String firstName,
    String lastName,
    String password,
    String confirmPassword,
  ) async {
    var response = await (client.clientToQuery()).mutate(
      MutationOptions(
          document: gql(
            mutation.customerRegister(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              confirmPassword: confirmPassword,
            ),
          ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    // Response nwResponse=SignUpResponseModel.fromJson(json)

    return handleResponse(
      response,
      'customerRegister',
      (json) => SignInModel.fromJson(json),
    );
  }

//Customer Login
  Future<SignInModel?> getSignInData(
    String email,
    String password,
    bool remember,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.customerLogin(
          email: email,
          password: password,
          remember: remember,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));
    return handleResponse(
      response,
      'customerLogin',
      (json) => SignInModel.fromJson(json),
    );
  }

//forget Password
  Future<GraphQlBaseModel?> forgotPassword(
    String email,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
      document: gql(
        mutation.forgotPassword(
          email: email,
        ),
      ),
    ));
    return handleResponse(
      response,
      'forgotPassword',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }
  //sharewishlist
  Future<ShareWishlistData?> shareWishlist(
    bool shared,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.shareWishlist(
          shared: shared,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
      parserFn: (json) {
        return ShareWishlistData.fromJson(json['shareWishlist']);
      },
    ));
    return handleResponse(
       response,
      'shareWishlist',
      (json) => ShareWishlistData.fromJson(json),
    );
  }

//account info
  Future<AccountInfoDetails?> getCustomerData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
      document: gql(
        mutation.getCustomerData(),
      ),
      parserFn: (json) {
        return AccountInfoDetails.fromJson(json['accountInfo']);
      },
    ));

    return handleResponse(
      response,
      'accountInfo',
      (json) => AccountInfoDetails.fromJson(json),
    );
  }

//account update
  Future<AccountUpdate?> updateCustomerData(
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? phone,
    String? password,
    String? confirmPassword,
    String? oldpassword,
    String? avatar,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache,

        document: gql(
          mutation.updateAccount(
              firstName: firstName,
              lastName: lastName,
              email: email,
              gender: gender,
              dateOfBirth: dateOfBirth,
              phone: phone,
              oldpassword: oldpassword,
              password: password,
              confirmPassword: confirmPassword,
              avatar: avatar),
        ),
       ));
    return handleResponse(
      response,
      'updateAccount',
      (json) => AccountUpdate.fromJson(json),
    );
  }

  //logout customer
  Future<GraphQlBaseModel?> customerLogout() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.customerLogout(),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
        ));

    return handleResponse(
      response,
      'customerLogout',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //delete   Account
  Future<GraphQlBaseModel?> deleteCustomerAccount(
    String password,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.deleteAccount(
            password: password,
          ),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
        ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'deleteAccount',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //Get address list
  Future<AddressModel?> getAddressData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getAddressList(),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));

    return handleResponse(
      response,
      'addresses',
      (json) => AddressModel.fromJson(json),
    );
  }

  //address update
  Future<UpdateAddressModel?> updateAddress(
    int id,
    String companyName,
    String firstName,
    String lastName,
    String address,
    String address2,
    String country,
    String state,
    String city,
    String postCode,
    String phone,
    String vatId,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.updateAddress(
              id: id,
              companyName: companyName,
              firstName: firstName,
              lastName: lastName,
              address: address,
              address2: address2,
              country: country,
              state: state,
              city: city,
              postCode: postCode,
              phone: phone,
              vatId: vatId),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
        ));
    return handleResponse(
      response,
      'updateAddress',
      (json) => UpdateAddressModel.fromJson(json),
    );
  }

  //add address
  Future<GraphQlBaseModel?> createAddress(
    String companyName,
    String firstName,
    String lastName,
    String address,
    String address2,
    String country,
    String state,
    String city,
    String postCode,
    String phone,
    String vatId,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.createAddress(
              companyName: companyName,
              firstName: firstName,
              lastName: lastName,
              address: address,
              address2: address2,
              country: country,
              state: state,
              city: city,
              postCode: postCode,
              phone: phone,
              vatId: vatId),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
        ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'createAddress',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //delete   address
  Future<GraphQlBaseModel?> deleteAddress(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.deleteAddress(
            id: id,
          ),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'deleteAddress',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //Get orders list
  Future<OrdersListModel?> getOrderList(String ? id,String ? startDate,String ? endDate,String ? status,  double? total,int page) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getOrdersList(id: id,startDate: startDate,endDate: endDate,status: status,total:total,page: page),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

      // parserFn: (json) {
        //   return OrdersListModel.fromJson(json['ordersList']);
        // },
        ));
    // debugPrint(response);
    // debugPrint(response.data);

    return handleResponse(
      response,
      'ordersList',
      (json) => OrdersListModel.fromJson(json),
    );
  }

  //Get order detail
  Future<order_detail.OrderDetail?> getOrderDetail(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getOrderDetail(id),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.cacheAndNetwork

      // parserFn: (json) {
        //   return OrderDetailModel.fromJson(json['orderDetail']);
        // },
        ));
    // debugPrint(response);
    // debugPrint(response.data);

    return handleResponse(
      response,
      'orderDetail',
      (json) => order_detail.OrderDetail.fromJson(json),
    );
  }

  //Get wishlist data
  Future<WishListData?> getWishList() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.wishlistData(),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

        ));

    return handleResponse(
      response,
      'wishlists',
      (json) => WishListData.fromJson(json),
    );
  }

  //add to wishlist
  Future<AddWishListModel?> addToWishlist(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.addToWishlist(
          id: id,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'addToWishlist',
      (json) => AddWishListModel.fromJson(json),
    );
  }

  //Remove from wishlist
  Future<GraphQlBaseModel?> removeFromWishlist(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.removeFromWishlist(
          id: id,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeFromWishlist',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //Move from wishlist to cart
  Future<AddToCartModel?> moveToCart(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.moveToCart(
          id: id,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'moveToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }
  Future<AddToCartModel?> moveToWishlist(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.moveToWishlist(
          id: id,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'moveToWishlist',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  //Get drawer categories list
  Future<GetDrawerCategoriesData?> getDrawerCategoriesList() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getDrawerCategories(),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,));
    return handleResponse(
      response,
      'homeCategories',
      (json) => GetDrawerCategoriesData.fromJson(json),
    );
  }

  //Get cart details
  Future<CartModel?> getCartDetails() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getCartDetails(),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,
    ));


    return handleResponse(
      response,
      'cartDetail',
      (json) => CartModel.fromJson(json),
    );
  }

  //Get homepage sliders
  Future<HomeSlidersData?> getHomePageSliders() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getHomepageSliders(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.cacheAndNetwork
    ));
    return handleResponse(
      response,
      'homeSliders',
      (json) => HomeSlidersData.fromJson(json),
    );
  }

  //Get homepage advertisements
  Future<Advertisements?> getAdvertisements() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getAdvertisementData(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.cacheAndNetwork
    ));
    return handleResponse(
      response,
      'advertisements',
      (json) => Advertisements.fromJson(json),
    );
  }

  Future<DownloadableProductModel?> getCustomerDownloadableProducts(int page, int limit) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadableProductsCustomer(page, limit),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    // print(response);
    // print(response.data);

    return handleResponse(
      response,
      'downloadableLinkPurchases',
          (json) => DownloadableProductModel.fromJson(json),
    );
  }

  Future<DownloadLink?> downloadLinksProduct(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadProduct(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'downloadLink',
          (json) => DownloadLink.fromJson(json),
    );
  }


  //get cart count
  Future<Advertisements?> getCartCount() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getCartCount(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'advertisements',
          (json) => Advertisements.fromJson(json),
    );
  }


  //Get new products
  Future<NewProductsModel?> getNewProducts() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getNewProducts(),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (response == null) {
      return null;
    }

    return handleResponse(
      response,
      'newProducts',
          (json) => NewProductsModel.fromJson(json),
    );
  }

  //Get Featured products
  Future<NewProductsModel?> getFeaturedProducts() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getFeaturedProduct(),
        ),
        fetchPolicy: FetchPolicy.networkOnly
    ));
    if (response == null) {
      return null;
    }

    return handleResponse(
      response,
      'featuredProducts',
      (json) => NewProductsModel.fromJson(json),
    );
  }

  //Get compare products
  Future<CompareProductsData?> getCompareProducts() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getCompareProducts(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'compareProducts',
      (json) => CompareProductsData.fromJson(json),
    );
  }

  //Remove from compare
  Future<GraphQlBaseModel?> removeFromCompare(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.removeFromCompare(
          id: id,
        ),
      ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeFromCompareProduct',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //add to compare
  Future<GraphQlBaseModel?> addToCompare(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.addToCompare(
          id: id,
        ),
      ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'addToCompare',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //add  to cart
  Future<AddToCartModel?> addToCart(
      int quantity,
      int productId,
      List downloadLinks,
      List groupedParams,
      List bundleParams,
      List configurableParams,
      String? configurableId) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.addToCart(
          quantity: quantity,
          productId: productId,
          downloadableLinks: downloadLinks,
          groupedParams: groupedParams,
          bundleParams: bundleParams,
          configurableParams: configurableParams,
          configurableId: configurableId ?? null,
        ),
      ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'addItemToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

//product details
  Future<product.Product?> getProductDetail(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.productDetail(id),
      ),
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
      fetchPolicy: FetchPolicy.cacheAndNetwork,

    ));

    return handleResponse(
      response,
      'product',
      (json) => product.Product.fromJson(json),
    );
  }

  //check save address
  Future<SaveCheckoutAddresses?> checkoutSaveAddress(
    String? billingCompanyName,
    String? billingFirstName,
    String? billingLastName,
    String? billingAddress,
    String? billingEmail,
    String? billingAddress2,
    String? billingCountry,
    String? billingState,
    String? billingCity,
    String? billingPostCode,
    String? billingPhone,
    String? shippingCompanyName,
    String? shippingFirstName,
    String? shippingLastName,
    String? shippingAddress,
    String? shippingEmail,
    String? shippingAddress2,
    String? shippingCountry,
    String? shippingState,
    String? shippingCity,
    String? shippingPostCode,
    String? shippingPhone,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.checkoutSaveAddress(
          billingCompanyName,
          billingFirstName,
          billingLastName,
          billingAddress,
          billingEmail,
          billingAddress2,
          billingCountry,
          billingState,
          billingCity,
          billingPostCode,
          billingPhone,
          shippingCompanyName,
          shippingFirstName,
          shippingLastName,
          shippingAddress,
          shippingEmail,
          shippingAddress2,
          shippingCountry,
          shippingState,
          shippingCity,
          shippingPostCode,
          shippingPhone,
        ),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'saveCheckoutAddresses',
      (json) => SaveCheckoutAddresses.fromJson(json),
    );
  }

  //save shipping and get payments
  Future<PaymentMethods?> saveShippingMethods(String? shippingMethod) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.checkoutSaveShipping(shippingMethod: shippingMethod),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'paymentMethods',
      (json) => PaymentMethods.fromJson(json),
    );
  }

  //save payment and get review order
  Future<SavePayment?> saveAndReview(String? paymentMethod) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.saveAndReview(paymentMethod: paymentMethod
        ),

      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'savePayment',
      (json) => SavePayment.fromJson(json),
    );
  }

  //place order
  Future<SaveOrderModel?> placeOrder() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.placeOrder(),
      ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,

    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'placeOrder',
      (json) => SaveOrderModel.fromJson(json),
    );
  }

  //get CMS Data
  Future<CmsData?> getCmsData() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getCmsData(),
      ),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,

    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'cmsPages',
      (json) => CmsData.fromJson(json),
    );
  }

  Future<CategoriesProductModel?> getCategoriesProduct(
      String categorySlug,
      String searchQuery,
      String order,
      String sort,
      int page,
      List filter) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getCategoriesProduct(
              categorySlug,
              searchQuery,
              order,
              sort,
              page,
          filter),
        ),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'getProductListing',
      (json) => CategoriesProductModel.fromJson(json),
    );
  }

  Future<GetFilterAttribute?> getFilterProducts(String categorySlug) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getFilterProducts(categorySlug),
        ),
      cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
      fetchPolicy: FetchPolicy.noCache,));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'getFilterAttribute',
      (json) => GetFilterAttribute.fromJson(json),
    );
  }

  Future<ApplyCoupon?> applyCoupon(String couponCode) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.applyCoupon(couponCode),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'applyCoupon',
      (json) => ApplyCoupon.fromJson(json),
    );
  }

  Future<ApplyCoupon?> removeCoupon() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeCoupon(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeCoupon',
          (json) => ApplyCoupon.fromJson(json),
    );
  }

  Future<ReviewModel?> getReviewList() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getReviewList(),
      ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'reviewsList',
      (json) => ReviewModel.fromJson(json),
    );
  }

  Future<AddReviewModel?> addReview(String name, String title, int rating,
      String comment, int productId) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.addReview(name = name, title = title, rating = rating,
            comment = comment, productId = productId),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'createReview',
      (json) => AddReviewModel.fromJson(json),
    );
  }

  Future<CurrencyLanguageList?> getLanguageCurrency() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getLanguageCurrencyList(),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'getDefaultChannel',
      (json) => CurrencyLanguageList.fromJson(json),
    );
  }

  Future<NotificationListModel?> getNotificationList() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getNotificationList(),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'notificationList',
      (json) => NotificationListModel.fromJson(json),
    );
  }

  Future<CountriesData?> getCountryStateList() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getCountryStateList(),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'countries',
      (json) => CountriesData.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeItemFromCart(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.removeFromCart(id),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeCartItem',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }
  Future<GraphQlBaseModel?> removeAllCartItem() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.removeAllCartItem(),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeAllCartItem',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }
  Future<AddToCartModel?> updateItemToCart(List<Map<dynamic,String>> item) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.updateItemToCart(item: item),
      ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache,
        parserFn: (data) {
        return AddToCartModel.fromJson(data["updateItemToCart"]);
      }
    ));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'updateItemToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<SignInModel?> socialLogin(
    String email,
    String firstName,
    String lastName,
    String phone,
  ) async {
    var response = await (client.clientToQuery()).mutate(
      MutationOptions(
          document: gql(
            mutation.socialLogin(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone),
          ),
          cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
          fetchPolicy: FetchPolicy.noCache),
    );
    return handleResponse(
      response,
      'customerSocialSignUp',
      (json) => SignInModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeReview(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeReview(
            id,
          ),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'deleteReview',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllCompareProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllCompareProducts(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeAllCompareProducts',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllReviews() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.deleteAllReview(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'deleteAllReview',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllWishlistProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllWishlistProducts(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'removeAllWishlists',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> cancelOrder(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.cancelOrder(id),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));
    debugPrint(response.toString());
    debugPrint(response.data.toString());
    return handleResponse(
      response,
      'cancelCustomerOrder',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }


  Future<ShipmentModel?> getShipmentList(int page, int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getShipmentsList(page, orderId),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));

    return handleResponse(
      response,
      'viewShipments',
          (json) => ShipmentModel.fromJson(json),
    );
  }

  Future<InvoicesModel?> getInvoiceList(int page, int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getInvoicesList(page, orderId),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));

    return handleResponse(
      response,
      'viewInvoices',
          (json) => InvoicesModel.fromJson(json),
    );
  }

  Future<OrderRefundModel?> getRefundList(int page, int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getRefundList(page, orderId),
        ),
        cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic,
        fetchPolicy: FetchPolicy.noCache));

    return handleResponse(
      response,
      'viewRefunds',
          (json) => OrderRefundModel.fromJson(json),
    );
  }
}
