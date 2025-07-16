/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/data_model/account_models/account_update_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_pdf_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_model.dart';
import 'package:bagisto_app_demo/data_model/gdpr_models/gdpr_request_search_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/order_detail_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/order_refund_model.dart';
import 'package:bagisto_app_demo/data_model/order_model/orders_list_data_model.dart';
import 'package:bagisto_app_demo/data_model/product_model/booking_slots_modal.dart';
import 'package:bagisto_app_demo/data_model/review_model/review_model.dart';
import 'package:bagisto_app_demo/data_model/sign_in_model/signin_model.dart';
import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../data_model/account_models/account_info_details.dart';
import '../data_model/core_configs_model.dart';
import '../data_model/currency_language_model.dart';
import '../data_model/order_model/order_invoices_model.dart';
import '../data_model/order_model/shipment_model.dart';
import '../screens/add_review/data_model/add_review_model.dart';
import '../screens/address_list/data_model/default_address_model.dart';
import '../screens/address_list/data_model/update_address_model.dart';
import '../screens/cart_screen/cart_model/apply_coupon.dart';
import '../screens/categories_screen/utils/index.dart';
import '../screens/checkout/data_model/checkout_save_address_model.dart';
import '../screens/checkout/data_model/checkout_save_shipping_model.dart';
import '../screens/checkout/data_model/save_order_model.dart';
import '../screens/checkout/data_model/save_payment_model.dart';
import '../screens/checkout/utils/index.dart';
import '../screens/cms_screen/data_model/cms_details.dart';
import '../screens/cms_screen/data_model/cms_model.dart';
import '../screens/compare/utils/index.dart';
import '../screens/downloadable_products/data_model/download_product_Image_model.dart';
import '../screens/downloadable_products/data_model/download_product_model.dart';
import '../screens/downloadable_products/data_model/downloadable_product_model.dart';
import '../screens/home_page/data_model/get_categories_drawer_data_model.dart';
import '../screens/home_page/data_model/theme_customization.dart';
import '../screens/product_screen/data_model/download_sample_model.dart';
import '../screens/wishList/data_model/wishlist_model.dart';
import 'graph_ql.dart';
import 'mutation_query.dart';
import 'package:http/http.dart' as http;

typedef Parser<T> = T Function(Map<String, dynamic> json);

class ApiClient {
  GraphQlApiCalling client = GraphQlApiCalling();
  MutationsData mutation = MutationsData();

  /// Handle response from graphql by converting it to model
  Future<T?> handleResponse<T>(
    QueryResult<Object?> result,
    String operation,
    Parser<T> parser,
  ) async {
    String responseCookie = result.context
            .entry<HttpLinkResponseContext>()
            ?.headers?['set-cookie'] ??
        "";

    GlobalData.cookie = appStoragePref.getCookieGet();

    if (responseCookie.isNotEmpty) {
      appStoragePref.setCookieGet(responseCookie);
    }

    Map<String, dynamic>? data = {};
    // Handle exception if any
    if (result.hasException && (result.data?[operation]) == null) {
      data.putIfAbsent(
          "graphqlErrors",
          () =>
              (result!.exception!.graphqlErrors!.isNotEmpty
                  ? result.exception?.graphqlErrors.first.message
                  : null) ??
              "Some this went wrong connecting to server!");
      data.putIfAbsent("status", () => false);
    } else {
      // Handle data if no exception
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
    List<Map<String, dynamic>>? idFilter = [
      {
        "key": "id",
        "value": "$id",
      }
    ];

    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          (filters ?? []).isNotEmpty
              ? mutation.homeCategoriesFilters(filters: filters)
              : mutation.homeCategoriesFilters(filters: idFilter),
        ),
        cacheRereadPolicy:
            (filters ?? []).isEmpty ? CacheRereadPolicy.mergeOptimistic : null,
        fetchPolicy: ((filters ?? []).isEmpty && isPreFetchingEnable)
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.networkOnly));

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
        fetchPolicy: isPreFetchingEnable
            ? FetchPolicy.cacheAndNetwork
            : FetchPolicy.networkOnly));

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
        fetchPolicy: FetchPolicy.noCache,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll));

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
      fetchPolicy: isPreFetchingEnable
          ? FetchPolicy.cacheAndNetwork
          : FetchPolicy.networkOnly,
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
      String? configurableId,
      Map<String, dynamic>? bookingParams,
      [List<Map<String, dynamic>>? customizableOptions,
      List? customizableFiles]) async {
    // If there are files, use multipart, else normal mutation
    if (customizableFiles != null && customizableFiles.isNotEmpty) {
      // Prepare multipart request
      final uri = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        "Cookie": appStoragePref.getCookieGet(),
        "x-currency": GlobalData.currencyCode,
        "x-locale": GlobalData.locale,
        'Authorization': appStoragePref.getCustomerToken(),
      });

      // Prepare GraphQL mutation and variables
      final mutationString = '''
      mutation addItemToCart(\$input: AddItemToCartInput!) {
        addItemToCart(input: \$input) {
          success
          message
          cart {
            id
            itemsCount
            couponCode
            itemsQty
            taxTotal
          }
        }
      }
      ''';

      // Prepare input map, wrap all options inside customizableOptions
      final inputMap = {
        "productId": productId,
        "quantity": quantity,
        "selectedConfigurableOption": configurableId,
        "superAttribute": configurableParams,
        "qty": groupedParams,
        "links": downloadLinks,
        "bundleOptions": bundleParams,
        "booking": bookingParams,
        "customizableOptions": customizableOptions?.map((opt) {
          final map = {
            "id": opt["id"],
          };
          if (opt.containsKey("value")) {
            map["value"] = opt["value"];
          }
          if (opt.containsKey("file")) {
            map["file"] =
                null; // Placeholder, will be replaced by Upload variable
          }
          return map;
        }).toList(),
      };

      // Prepare operations and map for multipart
      // Only use 'file' keys inside customizableOptions, not as a separate variable
      final operations = json.encode({
        "query": mutationString,
        "variables": {
          "input": inputMap,
        }
      });

      // Map files to variables inside customizableOptions
      final fileMap = <String, List<String>>{};
      int fileIndex = 0;
      for (int i = 0; i < (customizableOptions?.length ?? 0); i++) {
        if (customizableOptions![i].containsKey("file")) {
          fileMap["$fileIndex"] = [
            "variables.input.customizableOptions.$i.file"
          ];
          fileIndex++;
        }
      }

      request.fields['operations'] = operations;
      request.fields['map'] = json.encode(fileMap);

      // Attach files
      for (int i = 0; i < customizableFiles.length; i++) {
        final file = customizableFiles[i];
        if (file != null) {
          final multipartFile = await http.MultipartFile.fromPath(
            "$i",
            file.path,
            filename: file.name,
          );
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(respStr);

      final QueryResult queryResult = QueryResult(
        options: QueryOptions(document: gql('')),
        source: QueryResultSource.network,
        data: jsonResponse['data'],
        exception: jsonResponse['errors'] != null
            ? OperationException(
                graphqlErrors: (jsonResponse['errors'] as List)
                    .map((e) => GraphQLErrorFromJson.fromJson(
                        e as Map<String, dynamic>))
                    .toList(),
              )
            : null,
      );

      return handleResponse(
        queryResult,
        'addItemToCart',
        (json) => AddToCartModel.fromJson(json),
      );
    } else {
      // No files, normal mutation
      var response = await (client.clientToQuery()).mutate(MutationOptions(
          document: gql(
            mutation.addToCart(
                quantity: quantity,
                productId: productId,
                downloadableLinks: downloadLinks,
                groupedParams: groupedParams,
                bundleParams: bundleParams,
                configurableParams: configurableParams,
                configurableId: configurableId,
                booking: bookingParams,
                customizableOptions: customizableOptions),
          ),
          fetchPolicy: FetchPolicy.networkOnly));
      return handleResponse(
        response,
        'addItemToCart',
        (json) => AddToCartModel.fromJson(json),
      );
    }
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

  Future<BaseModel?> customerLogout() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.customerLogout(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'customerLogout',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<BaseModel?> addToCompare(
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
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<CartModel?> getCartCount() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.cartDetails(),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'cartDetail',
      (json) => CartModel.fromJson(json),
    );
  }

  Future<AddToCartModel?> removeFromWishlist(
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
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<AccountInfoModel?> getCustomerData() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getCustomerData(),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    return handleResponse(
      response,
      'accountInfo',
      (json) => AccountInfoModel.fromJson(json),
    );
  }

  Future<CmsPage?> getCmsPageDetails(String id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.getCmsPageDetails(id),
      ),
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
      fetchPolicy: isPreFetchingEnable
          ? FetchPolicy.cacheAndNetwork
          : FetchPolicy.networkOnly,
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
      {List<Map<String, dynamic>>? filters, int? page, int limit = 15}) async {
    try {
      var response = await (client.clientToQuery()).query(QueryOptions(
          document: gql(
            mutation.allProductsList(
                filters: filters ?? [], page: page ?? 1, limit: limit),
          ),
          cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          fetchPolicy: FetchPolicy.noCache));

      NewProductsModel? model = await handleResponse(
        response,
        'allProducts',
        (json) => NewProductsModel.fromJson(json),
      );
      // log("modall data: ${model?.data?.map((item) => item.toJson()).toList()}");
      return model;
    } catch (e) {
      return null;
    }
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

  Future<BaseModel?> removeAllCartItem() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllCartItem(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'removeAllCartItem',
      (json) => BaseModel.fromJson(json),
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
      int id, String quantity) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.moveToCartFromWishlist(id, quantity),
      ),
    ));

    return handleResponse(
      response,
      'moveToCart',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<BaseModel?> removeAllWishlistProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllWishlistProducts(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeAllWishlists',
      (json) => BaseModel.fromJson(json),
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
      bool subscribeNewsletter,
      bool agreement) async {
    var response = await (client.clientToQuery()).mutate(
      MutationOptions(
          document: gql(
            mutation.customerRegister(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                subscribedToNewsLetter: subscribeNewsletter,
                agreement: agreement),
          ),
          fetchPolicy: FetchPolicy.networkOnly),
    );
    return handleResponse(
      response,
      'customerSignUp',
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
      bool? subscribedToNewsLetter) async {
    bool attachImage = false;
    String? imageField;
    final QueryResult queryResult;

    if (avatar == null) {
      imageField = 'omit';
    } else if (avatar == 'delete') {
      imageField = "delete";
    } else {
      attachImage = true;
    }

    final operations = mutation.updateAccount(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phone: phone,
        oldpassword: oldpassword,
        password: password,
        confirmPassword: confirmPassword,
        subscribedToNewsLetter: subscribedToNewsLetter,
        imageField: imageField);

    if (attachImage) {
      final uri = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        "Cookie": appStoragePref.getCookieGet(),
        "x-currency": GlobalData.currencyCode,
        "x-locale": GlobalData.locale,
        'Authorization': appStoragePref.getCustomerToken(),
      });

      final map = json.encode({
        "0": ["variables.input.image"]
      });

      request.fields['operations'] = operations;
      request.fields['map'] = map;
      final multipartFile = await http.MultipartFile.fromPath("0", avatar ?? "",
          filename: avatar?.split('/').last ?? "",
          contentType: DioMediaType('image', 'png'));

      request.files.add(multipartFile);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final Map<String, dynamic> jsonResponse = json.decode(respStr);
      queryResult = QueryResult(
        options:
            QueryOptions(document: gql('')), // Provide appropriate QueryOptions
        source: QueryResultSource.network, // Specify the source
        data: jsonResponse['data'],
        exception: jsonResponse['errors'] != null
            ? OperationException(graphqlErrors: jsonResponse['errors'])
            : null,
      );
    } else {
      queryResult = await (client.clientToQuery()).mutate(MutationOptions(
          document: gql(
            operations,
          ),
          fetchPolicy: FetchPolicy.networkOnly));
    }

    return handleResponse(
      queryResult,
      'updateAccount',
      (json) => AccountUpdate.fromJson(json),
    );
  }

  //delete   Account
  Future<BaseModel?> deleteCustomerAccount(
    String password,
  ) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.deleteAccount(
            password: password,
          ),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'deleteAccount',
      (json) => BaseModel.fromJson(json),
    );
  }

  //forget Password
  Future<BaseModel?> forgotPassword(
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
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<ReviewModel?> getReviewList(int page) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getReviewList(page),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
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
      int? page,
      bool? isFilterApply) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getOrderList(
              id: id ?? '',
              startDate: startDate ?? '',
              endDate: endDate ?? '',
              total: total ?? 0.0,
              status: status ?? '',
              page: page,
              isFilterApply: isFilterApply),
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
        fetchPolicy: FetchPolicy.noCache));

    return handleResponse(
      response,
      'orderDetail',
      (json) => OrderDetail.fromJson(json),
    );
  }

  //cancelOrder
  Future<BaseModel?> cancelOrder(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.cancelOrder(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'cancelCustomerOrder',
      (json) => BaseModel.fromJson(json),
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

  Future<BaseModel?> deleteAddress(
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
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<BaseModel?> createAddress(
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
      String email) async {
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
              email: email,
              postCode: postCode,
              phone: phone,
              vatId: vatId,
              isDefault: isDefault),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'createAddress',
      (json) => BaseModel.fromJson(json),
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
    String email,
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
              email: email,
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
  Future<SaveOrderModel?> placeOrder(
      {Map<String, dynamic>? serverPayload}) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.placeOrder(),
        ),
        variables: serverPayload ?? {},
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
      int id,
      {int? billingId,
      int? shippingId,
      bool useForShipping = true}) async {
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
              shippingId: shippingId ?? 0,
              useForShipping: useForShipping),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'saveCheckoutAddresses',
      (json) => SaveCheckoutAddresses.fromJson(json),
    );
  }

  Future<CompareProductsData?> getCompareProducts(page, limit) async {
    try {
      var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getCompareProducts(),
        ),
        variables: {
          'page': page, // <-- Dynamic value
          'first': limit,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      return handleResponse(
        response,
        'compareProducts',
        (json) => CompareProductsData.fromJson(json),
      );
    } catch (e) {
      return null;
    }
  }

  Future<BaseModel?> removeFromCompare(
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
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<BaseModel?> removeAllCompareProducts() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.removeAllCompareProducts(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'removeAllCompareProducts',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<AddReviewModel?> addReview(
      String name,
      String title,
      int rating,
      String comment,
      int productId,
      List<http.MultipartFile> attachments) async {
    //   final String createReviewMutation = r'''
    //   mutation CreateReview($input: CreateReviewInput!) {
    //     createReview(input: $input) {
    //       success
    //       message
    //       review {
    //         id
    //         title
    //         rating
    //         comment
    //         status
    //         createdAt
    //         updatedAt
    //         productId
    //         customerId
    //         customer {
    //           id
    //           firstName
    //           lastName
    //           name
    //           gender
    //           dateOfBirth
    //           email
    //           phone
    //           image
    //           imageUrl
    //           status
    //           password
    //           apiToken
    //           customerGroupId
    //           subscribedToNewsLetter
    //           isVerified
    //           isSuspended
    //           token
    //           rememberToken
    //           createdAt
    //           updatedAt
    //           customerGroup {
    //             id
    //             code
    //             name
    //             isUserDefined
    //             createdAt
    //             updatedAt
    //           }
    //         }
    //         images {
    //           id
    //           reviewId
    //           type
    //           mimeType
    //           path
    //           url
    //         }
    //         product {
    //           id
    //           sku
    //           type
    //           parentId
    //           attributeFamilyId
    //           productNumber
    //           name
    //           shortDescription
    //           description
    //           urlKey
    //           shareURL
    //           new
    //           featured
    //           status
    //           guestCheckout
    //           visibleIndividually
    //           metaTitle
    //           metaKeywords
    //           metaDescription
    //           price
    //           specialPrice
    //           specialPriceFrom
    //           specialPriceTo
    //           weight
    //           parentId
    //           attributeFamilyId
    //           createdAt
    //           updatedAt
    //         }
    //       }
    //     }
    //   }
    // ''';
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(mutation.addReview()),
        variables: {
          "input": {
            "name": name,
            "title": title,
            "rating": rating,
            "comment": comment,
            "productId": productId,
            "attachments": attachments,
          },
        },
        // mutation.addReview(
        //     name = name,
        //     title = title,
        //     rating = rating,
        //     comment = comment,
        //     productId = productId,
        //     attachments = attachments),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'createReview',
      (json) => AddReviewModel.fromJson(json),
    );
  }

  Future<DownloadableProductModel?> getCustomerDownloadableProducts(
      int page, int limit,
      {String? title,
      String? status,
      String? orderId,
      String? orderDateFrom,
      String? orderDateTo}) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadableProductsCustomer(page, limit,
              title: title ?? "",
              status: status ?? "",
              orderId: orderId ?? "",
              orderDateFrom: orderDateFrom ?? "",
              orderDateTo: orderDateTo ?? ""),
        ),
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'downloadableLinkPurchases',
      (json) => DownloadableProductModel.fromJson(json),
    );
  }

  Future<DownloadLinkDataModel?> downloadLinksProductAPI(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadProductQuery(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'downloadLink',
      (json) => DownloadLinkDataModel.fromJson(json),
    );
  }

  Future<Download?> downloadLinksProduct(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.downloadProduct(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'downloadableLinkPurchase',
      (json) => Download.fromJson(json),
    );
  }

  Future<InvoicesModel?> getInvoicesList(int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getInvoicesList(orderId),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'viewInvoices',
      (json) => InvoicesModel.fromJson(json),
    );
  }

  Future<ShipmentModel?> getShipmentsList(int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getShipmentsList(orderId),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'viewShipments',
      (json) => ShipmentModel.fromJson(json),
    );
  }

  Future<OrderRefundModel?> getRefundList(int orderId) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
        document: gql(
          mutation.getRefundList(orderId),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'viewRefunds',
      (json) => OrderRefundModel.fromJson(json),
    );
  }

  Future<AddToCartModel?> reOrderCustomerOrder(String? orderId) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.reOrderCustomerOrder(orderId),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'reorder',
      (json) => AddToCartModel.fromJson(json),
    );
  }

  Future<BaseModel?> contactUsApiClient(
      String name, String? email, String? phone, String? describe) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.contactUsApi(
              name: name, email: email, phone: phone, describe: describe),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'contactUs',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<SetDefaultAddress?> setDefaultAddress(String id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.setDefaultAddress(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'setDefaultAddress',
      (json) => SetDefaultAddress.fromJson(json),
    );
  }

  Future<DownloadSampleModel?> downloadSample(String type, String id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.downloadSample(type, id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'downloadSample',
      (json) => DownloadSampleModel.fromJson(json),
    );
  }

  Future<CoreConfigs?> getCoreConfigs() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.getCoreConfigs(),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'coreConfigs',
      (json) => CoreConfigs.fromJson(json),
    );
  }

  Future<BaseModel?> subscribeNewsletter(String email) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.subscribeNewsletter(email),
        ),
        fetchPolicy: FetchPolicy.networkOnly));
    return handleResponse(
      response,
      'subscribe',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<BookingSlotsData?> getSlots(
      {required int id, required String date}) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.getSlots(id: id, date: date),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    return handleResponse(
      response,
      'getSlots',
      (json) => BookingSlotsData.fromJson(json),
    );
  }

  Future<GdprRequestModel?> getGdprRequests() async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.gdprRequests(appStoragePref.getCustomerId() ?? 0),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    return handleResponse(
      response,
      'gdprRequests',
      (json) => GdprRequestModel.fromJson(json),
    );
  }

  Future<BaseModel?> createGdprRequest(Enum type, String? message) async {
    // Ensure the type matches the expected enum value

    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.createGdprRequestMutation,
        ),
        variables: {
          "input": {
            "type": type.toString().split('.').last,
            "message": message,
          }
        },
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'createGdprRequest',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<BaseModel?> revokeGdprRequest(int id) async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
        document: gql(
          mutation.revokeGdprRequest(id),
        ),
        fetchPolicy: FetchPolicy.networkOnly));

    return handleResponse(
      response,
      'revokeGdprRequest',
      (json) => BaseModel.fromJson(json),
    );
  }

  Future<GdprSearchModal?> gdprSearchRequest(int id) async {
    var response = await (client.clientToQuery()).query(QueryOptions(
      document: gql(
        mutation.gdprSearchRequest(id),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    return handleResponse(
      response,
      'gdprRequest',
      (json) => GdprSearchModal.fromJson(json),
    );
  }

  Future<GdprPdfModel?> downloadGdprData() async {
    var response = await (client.clientToQuery()).mutate(MutationOptions(
      document: gql(
        mutation.downloadGdprData(),
      ),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    return handleResponse(
      response,
      'downloadGdprData',
      (json) => GdprPdfModel.fromJson(json),
    );
  }
}

extension GraphQLErrorFromJson on GraphQLError {
  static GraphQLError fromJson(Map<String, dynamic> json) {
    return GraphQLError(
      message: json['message'] as String? ?? '',
      locations: (json['locations'] as List?)
          ?.map((loc) => ErrorLocation(
                line: loc['line'] as int? ?? 0,
                column: loc['column'] as int? ?? 0,
              ))
          .toList(),
      path: json['path'] as List?,
      extensions: json['extensions'] as Map<String, dynamic>?,
    );
  }
}
