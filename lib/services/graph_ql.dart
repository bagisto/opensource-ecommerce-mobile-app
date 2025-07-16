/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:graphql_flutter/graphql_flutter.dart';

import '../utils/app_global_data.dart';
import '../utils/server_configuration.dart';
import '../utils/shared_preference_helper.dart';

String appDocPath = "";

/*
 * GraphQlApiCalling class is used to call graphql api and return graphql client object to call api
 */
class GraphQlApiCalling {
  final loggerLink = LoggerLink();
  final authLink = AuthLink(
    getToken: appStoragePref.getCustomerToken,
  );

  GraphQLClient clientToQuery() {
    final httpLink = HttpLink(baseUrl, defaultHeaders: {
      "Cookie": appStoragePref.getCookieGet(),
      "x-currency": GlobalData.currencyCode,
      "x-locale": GlobalData.locale,
      "is-cookie-exist": "1"
    });
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      queryRequestTimeout: const Duration(seconds: 40),
      link: loggerLink.concat(authLink.concat(httpLink)),
    );
  }
}

/// LoggerLink class is used to log the graphql api request and response
class LoggerLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    return forward!(request);
  }
}
