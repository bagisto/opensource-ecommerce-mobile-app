/// Single source of truth for backend endpoints and keys.
///
/// Override at build time:
///   flutter run --dart-define=API_BASE=https://example.com/public \
///               --dart-define=STOREFRONT_KEY=pk_storefront_xxx
class ApiEnv {
  const ApiEnv._();

  /// Bagisto install the app talks to.
  static const String base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://your-bagisto-domain.com/graphql',
  );

  /// Customer storefront GraphQL endpoint.
  static const String shopGraphql = '$base/api/graphql';

  /// Storefront key, required on every [shopGraphql] request.
  static const String storefrontKey = String.fromEnvironment(
    'STOREFRONT_KEY',
    defaultValue: 'your_storefront_key_here',
  );
}

/// Bagisto storefront GraphQL endpoint.
const String bagistoEndpoint = ApiEnv.shopGraphql;

/// Storefront key for the Bagisto storefront API.
const String storefrontKey = ApiEnv.storefrontKey;

/// Default channel code used by request headers.
const String channelCode = 'default';

/// Default Bagisto channel ID used during app bootstrap.
const int channelId = 1;

/// Company name
const String companyName = 'Webkul Software (Registered in India)';
