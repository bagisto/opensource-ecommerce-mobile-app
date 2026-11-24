import 'package:bagisto_flutter/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seller and shop endpoints are derived from one base', () {
    expect(ApiEnv.base, 'https://demo-mp-api.bagisto.com');
    expect(ApiEnv.shopGraphql, '${ApiEnv.base}/api/graphql');
    expect(ApiEnv.sellerGraphql, '${ApiEnv.base}/api/seller/graphql');
  });

  test('legacy constants alias the new environment', () {
    expect(bagistoEndpoint, ApiEnv.shopGraphql);
    expect(storefrontKey, ApiEnv.storefrontKey);
  });

  test('storefront key is non-empty', () {
    expect(ApiEnv.storefrontKey.isNotEmpty, isTrue);
  });
}
