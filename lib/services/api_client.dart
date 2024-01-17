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
import 'package:flutter/material.dart';
import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/orders_list_data_model.dart';
import 'package:bagisto_app_demo/data_model/review_model/review_model.dart';
import 'package:bagisto_app_demo/data_model/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/screens/cart_screen/cart_model/cart_data_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../data_model/account_models/account_info_details.dart';
import '../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../data_model/categories_data_model/filter_product_model.dart';
import '../data_model/currency_language_model.dart';
import '../data_model/graphql_base_model.dart';
import '../screens/add_review/data_model/add_review_model.dart';
import '../screens/address_list/data_model/address_model.dart';
import '../screens/address_list/data_model/country_model.dart';
import '../screens/address_list/data_model/update_address_model.dart';
import '../screens/cart_screen/cart_model/add_to_cart_model.dart';
import '../screens/cart_screen/cart_model/apply_coupon.dart';
import '../screens/checkout/data_model/checkout_save_address_model.dart';
import '../screens/checkout/data_model/checkout_save_shipping_model.dart';
import '../screens/checkout/data_model/save_order_model.dart';
import '../screens/checkout/data_model/save_payment_model.dart';
import '../screens/cms_screen/data_model/cms_details.dart';
import '../screens/cms_screen/data_model/cms_model.dart';
import '../screens/compare/data_model/compare_product_model.dart';
import '../screens/downloadable_products/data_model/download_product_model.dart';
import '../screens/downloadable_products/data_model/downloadable_product_model.dart';
import '../screens/home_page/data_model/advertisement_data.dart';
import '../screens/home_page/data_model/get_categories_drawer_data_model.dart';
import '../screens/home_page/data_model/new_product_data.dart';
import '../screens/home_page/data_model/theme_customization.dart';
import '../screens/wishList/data_model/wishlist_model.dart';
import '../utils/app_global_data.dart';
import '../utils/shared_preference_helper.dart';
import 'graph_ql.dart';
import 'mutation_query.dart';

typedef Parser<T> = T Function(Map<String, dynamic> json);

class ApiClient {
  GraphQlApiCalling client = GraphQlApiCalling();
  MutationsData mutation = MutationsData();

  Future<T?> handleResponse<T>(
    QueryResult<Object?> result,
    String operation,
    Parser<T> parser,
  ) async {
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
      if (result.data![operation] is List) {
        data = {'data': result.data![operation]};
      } else {
        data = result.data![operation];
      }
      data?.putIfAbsent("status", () => true);
      data?.putIfAbsent("responseStatus", () => true);
    }
    return parser(data ?? {});
  }

  Future<GetDrawerCategoriesData?> homeCategories(
      {int? id, List<Map<String, dynamic>>? filters}) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          (filters ?? []).isNotEmpty ? mutation.homeCategoriesFilters(filters: filters) : mutation.homeCategories(id: id ?? 1),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'homeCategories',
      (json) => GetDrawerCategoriesData.fromJson(json),
    );
  }

  Future<CurrencyLanguageList?> getLanguageCurrency() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getLanguageCurrencyList(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.cacheAndNetwork));

    return handleResponse(
      response,
      'getDefaultChannel',
      (json) => CurrencyLanguageList.fromJson(json),
    );
  }

  Future<ThemeCustomDataModel?> getThemeCustomizationData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.themeCustomizationData(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'themeCustomization',
      (json) => ThemeCustomDataModel.fromJson(json),
    );
  }

  Future<CmsData?> getCmsPagesData() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getCmsPagesData(),
      ),
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));
    return handleResponse(
      response,
      'cmsPages',
      (json) => CmsData.fromJson(json),
    );
  }

  Future<AddToCartModel?> addToCart(
      int quantity,
      String productId,
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
              configurableId: configurableId),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'addItemToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<AddWishListModel?> addToWishlist(
    String? id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.addToWishlist(
          id: id,
        ),
      ),
    ));
    return handleResponse(
      response,
      'addToWishlist',
      (json) => AddWishListModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> customerLogout() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.customerLogout(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'customerLogout',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> addToCompare(
    String? id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.addToCompare(
            id: id,
          ),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'addToCompare',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<Advertisements?> getCartCount() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getAdvertisementData(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'advertisements',
      (json) => Advertisements.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeFromWishlist(
    String? id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.removeFromWishlist(
          id: id,
        ),
      ),
    ));
    return handleResponse(
      response,
      'removeFromWishlist',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<AccountInfoDetails?> getCustomerData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getCustomerData(),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
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

  Future<CmsPage?> getCmsPageDetails(String id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getCmsPageDetails(id),
      ),
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));
    return handleResponse(
      response,
      'cmsPage',
      (json) => CmsPage.fromJson(json),
    );
  }

  Future<GetFilterAttribute?> getFilterAttributes(String categorySlug) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getFilterAttributes(categorySlug),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'getFilterAttribute',
      (json) => GetFilterAttribute.fromJson(json),
    );
  }

  Future<NewProductsModel?> getAllProducts(
      {List<Map<String, dynamic>>? filters, int? page}) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.allProductsList(filters: filters ?? [], page: page ?? 1),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'allProducts',
      (json) => NewProductsModel.fromJson(json),
    );
  }

  Future<CartModel?> getCartDetails() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.cartDetails(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'cartDetail',
      (json) => CartModel.fromJson(json),
    );
  }

  Future<AddToCartModel?> updateItemToCart(
      List<Map<dynamic, String>> items) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.updateItemToCart(items: items),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'updateItemToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<AddToCartModel?> removeItemFromCart(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeFromCart(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeCartItem',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<ApplyCoupon?> applyCoupon(String couponCode) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.applyCoupon(couponCode),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

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
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeCoupon',
      (json) => ApplyCoupon.fromJson(json),
    );
  }

  Future<AddToCartModel?> moveCartToWishlist(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.moveCartToWishlist(id),
      ),
    ));

    return handleResponse(
      response,
      'moveToWishlist',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllCartItem() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllCartItem(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'removeAllCartItem',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<WishListData?> getWishList() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.wishlistData(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'wishlists',
      (json) => WishListData.fromJson(json),
    );
  }

  //Move from wishlist to cart
  Future<AddToCartModel?> moveFromWishlistToCart(
    int id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.moveToCartFromWishlist(
          id,
        ),
      ),
    ));

    return handleResponse(
      response,
      'moveToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllWishlistProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllWishlistProducts(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeAllWishlists',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<SignInModel?> socialLogin(String email, String firstName,
      String lastName, String phone, String signUpType) async {
    var response = await (client.clientToQuery()).mutate(
      MutationOptions(
          document: gql(
            mutation.getSocialLoginResponse(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                signUpType: signUpType),
          ),
          fetchPolicy: FetchPolicy.networkOnly),
    );
    return handleResponse(
      response,
      'customerSocialSignUp',
      (json) => SignInModel.fromJson(json),
    );
  }

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
    ));
    return handleResponse(
      response,
      'customerLogin',
      (json) => SignInModel.fromJson(json),
    );
  }

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
          fetchPolicy: FetchPolicy.networkOnly),
    );
    return handleResponse(
      response,
      'customerRegister',
      (json) => SignInModel.fromJson(json),
    );
  }

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
        document: gql(
          mutation.updateAccount(
              firstName: firstName,
              lastName: lastName,
              email: email,
              gender: gender,
              dateOfBirth: dateOfBirth,
              phone: phone,
              oldPassword: oldpassword,
              password: password,
              confirmPassword: confirmPassword,
              avatar: avatar),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'updateAccount',
      (json) => AccountUpdate.fromJson(json),
    );
  }

  //logout customer
  Future<GraphQlBaseModel?> customerLogoutCall() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.customerLogout(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

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
        fetchPolicy: FetchPolicy.networkOnly));
    print(response);
    print(response.data);
    return handleResponse(
      response,
      'deleteAccount',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //forget Password
  Future<GraphQlBaseModel?> forgotPassword(
    String email,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
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

  Future<ReviewModel?> getReviewList() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getReviewList(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    debugPrint("$response");
    debugPrint("${response.data}");
    return handleResponse(
      response,
      'reviewsList',
      (json) => ReviewModel.fromJson(json),
    );
  }

  //Get orders list
  Future<OrdersListModel?> getOrderList(
      String? id,
      String? startDate,
      String? endDate,
      String? status,
      double? total,
      int? page
      ) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getOrderList(
              id: id,
              startDate: startDate,
              endDate: endDate,
              total: total,
              status: status,
              page: page),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'ordersList',
      (json) => OrdersListModel.fromJson(json),
    );
  }

  //Get order detail
  Future<OrderDetail?> getOrderDetail(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getOrderDetail(id),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.cacheAndNetwork));

    return handleResponse(
      response,
      'orderDetail',
      (json) => OrderDetail.fromJson(json),
    );
  }

  //cancelOrder
  Future<GraphQlBaseModel?> cancelOrder(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.cancelOrder(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    debugPrint("$response");
    debugPrint("${response.data}");
    return handleResponse(
      response,
      'cancelCustomerOrder',
      (json) => GraphQlBaseModel.fromJson(json),
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
        fetchPolicy: FetchPolicy.networkOnly));
    debugPrint("$response");
    debugPrint("${response.data}");
    return handleResponse(
      response,
      'deleteReview',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  //Get address list
  Future<AddressModel?> getAddressData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getAddressList(),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    return handleResponse(
      response,
      'addresses',
      (json) => AddressModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> deleteAddress(
    String? id,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.deleteAddress(
            id,
          ),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'deleteAddress',
      (json) => GraphQlBaseModel.fromJson(json),
    );
  }

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
    bool? isDefault,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.createNewAddress(
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
              vatId: vatId,
              isDefault: isDefault),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'createAddress',
      (json) => GraphQlBaseModel.fromJson(json),
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
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'updateAddress',
      (json) => UpdateAddressModel.fromJson(json),
    );
  }

  Future<CountriesData?> getCountryStateList() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getCountryStateList(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'countries',
          (json) => CountriesData.fromJson(json),
    );
  }

  //save shipping and get payments
  Future<PaymentMethods?> saveShippingMethods(String? shippingMethod) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.paymentMethods(shippingMethod: shippingMethod),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

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
          mutation.savePaymentAndReview(paymentMethod: paymentMethod),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

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
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'placeOrder',
          (json) => SaveOrderModel.fromJson(json),
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
      int id, {
        int? billingId,
        int? shippingId}
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
            id,
            billingId: billingId ?? 0,
            shippingId: shippingId ?? 0
          ),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'saveCheckoutAddresses',
          (json) => SaveCheckoutAddresses.fromJson(json),
    );
  }

  Future<CompareProductsData?> getCompareProducts() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getCompareProducts(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'compareProducts',
          (json) => CompareProductsData.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeFromCompare(
      int id,
      ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeFromCompare(
            id: id,
          ),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeFromCompareProduct',
          (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<GraphQlBaseModel?> removeAllCompareProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllCompareProducts(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeAllCompareProducts',
          (json) => GraphQlBaseModel.fromJson(json),
    );
  }

  Future<AddReviewModel?> addReview(
      String name,
      String title,
      int rating,
      String comment,
      int productId,
      List<Map<String, String>> attachments) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.addReview(
              name = name,
              title = title,
              rating = rating,
              comment = comment,
              productId = productId,
              attachments = attachments),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'createReview',
          (json) => AddReviewModel.fromJson(json),
    );
  }

  Future<DownloadableProductModel?> getCustomerDownloadableProducts(
      int page, int limit) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadableProductsCustomer(page, limit),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

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
}
