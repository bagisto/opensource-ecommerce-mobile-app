# Marketplace Foundation and Seller Auth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Point the app at the marketplace backend, add a seller GraphQL client and an isolated seller session, and ship a working seller login that lands on a real seller shell.

**Architecture:** All marketplace code lives under `lib/marketplace/`, mirroring the app's existing `data/models` → `data/repository` → `presentation/{bloc,pages,widgets}` convention. Seller traffic goes to a second GraphQL endpoint through a new factory on the existing `GraphQLClientProvider`, carrying a seller Bearer token and no storefront key. The seller session is stored under its own SharedPreferences keys so it never collides with the customer session.

**Tech Stack:** Flutter, Dart, `graphql_flutter` 5.2, `flutter_bloc` 9.1, `equatable`, `shared_preferences`, `flutter_test` with hand-written fakes (this repo uses no mocking package).

## Global Constraints

- Base URL for all traffic: `http://192.168.15.239/theme/api-4.9/public`. Storefront key: `pk_storefront_6QKdh4o5lNaePydMNCbOa7T6sOLQluBA`. Both are overridable with `--dart-define`.
- The seller endpoint must never receive an `X-STOREFRONT-KEY` header.
- Seller session keys are prefixed `seller_` and are never mixed with the customer's `auth_token`.
- All GraphQL clients come from `GraphQLClientProvider`. No `GraphQLClient` is constructed anywhere else.
- Repositories own GraphQL documents and JSON mapping. Blocs and Cubits own state. Widgets call neither.
- Server-issued IRIs are stored and echoed verbatim; never rebuilt from an integer.
- Marketplace code stays under `lib/marketplace/`. The only files touched outside it are `api_constants.dart`, `graphql_client.dart`, `account_menu_page.dart`, the ARB files, and `AGENTS.md`.
- Tests live flat in `test/`, named `marketplace_*_test.dart`, and use hand-written fakes.
- Run `flutter analyze` before every commit; it must report no new issues.

---

## File Structure

**Created**

| File | Responsibility |
|---|---|
| `lib/marketplace/core/api/seller_iri.dart` | Wraps a server-issued IRI; extracts the trailing numeric id |
| `lib/marketplace/core/api/paginated_result.dart` | Maps the `{collection, paginationInfo}` envelope |
| `lib/marketplace/core/api/seller_error_mapper.dart` | Turns seller GraphQL errors into user-facing messages |
| `lib/marketplace/core/session/seller_auth_storage.dart` | Persists the seller token and identity |
| `lib/marketplace/core/session/seller_permissions.dart` | Answers `can(key)` from the cached ACL |
| `lib/marketplace/core/session/seller_session_cubit.dart` | Holds token, profile and permissions; emits session state |
| `lib/marketplace/graphql/seller_auth.dart` | Login, register, logout, forgot, reset, attributes documents |
| `lib/marketplace/graphql/seller_account.dart` | Profile and ACL documents |
| `lib/marketplace/features/auth/data/models/seller_auth_models.dart` | `SellerLoginResult`, `SellerAttribute`, `SellerAttributeOption` |
| `lib/marketplace/features/auth/data/repository/seller_auth_repository.dart` | Seller auth calls |
| `lib/marketplace/features/account/data/models/seller_profile.dart` | `SellerProfile`, `SellerAclPermission` |
| `lib/marketplace/features/account/data/repository/seller_account_repository.dart` | Profile and ACL calls |
| `lib/marketplace/features/auth/presentation/bloc/seller_login_bloc.dart` | Login form state machine |
| `lib/marketplace/features/auth/presentation/pages/seller_login_page.dart` | Seller login screen |
| `lib/marketplace/shell/marketplace_shell.dart` | Seller bottom-tab shell |
| `lib/marketplace/shell/marketplace_entry.dart` | Decides login vs shell, wires providers |
| `tool/marketplace_seed/seed.sh` | Seeds demo data through the live API |

**Modified**

| File | Change |
|---|---|
| `lib/core/constants/api_constants.dart` | Add `ApiEnv`; existing constants become derived aliases |
| `lib/core/graphql/graphql_client.dart` | Add `buildSellerClient` |
| `lib/features/account/presentation/pages/account_menu_page.dart` | Add the "Sell on marketplace" entry |
| `lib/l10n/app_en.arb` | Add seller strings |
| `AGENTS.md` | Add the Marketplace rules section |

---

### Task 1: Environment configuration

**Files:**
- Modify: `lib/core/constants/api_constants.dart`
- Test: `test/marketplace_api_env_test.dart`

**Interfaces:**
- Produces: `ApiEnv.base`, `ApiEnv.shopGraphql`, `ApiEnv.sellerGraphql`, `ApiEnv.storefrontKey` (all `String`). Existing top-level `bagistoEndpoint` and `storefrontKey` keep working as aliases.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_api_env_test.dart`:

```dart
import 'package:bagisto_flutter/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seller and shop endpoints are derived from one base', () {
    expect(ApiEnv.base, 'http://192.168.15.239/theme/api-4.9/public');
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
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_api_env_test.dart`
Expected: FAIL — `Undefined name 'ApiEnv'`.

- [ ] **Step 3: Write the implementation**

Replace the whole of `lib/core/constants/api_constants.dart` with:

```dart
/// Single source of truth for backend endpoints and keys.
///
/// Override at build time:
///   flutter run --dart-define=API_BASE=https://example.com/public \
///               --dart-define=STOREFRONT_KEY=pk_storefront_xxx
class ApiEnv {
  const ApiEnv._();

  /// Marketplace install the app talks to.
  static const String base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://192.168.15.239/theme/api-4.9/public',
  );

  /// Customer + buyer-side marketplace GraphQL endpoint.
  static const String shopGraphql = '$base/api/graphql';

  /// Seller panel GraphQL endpoint. Never send the storefront key here.
  static const String sellerGraphql = '$base/api/seller/graphql';

  /// Storefront key, required on every [shopGraphql] request.
  static const String storefrontKey = String.fromEnvironment(
    'STOREFRONT_KEY',
    defaultValue: 'pk_storefront_6QKdh4o5lNaePydMNCbOa7T6sOLQluBA',
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
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_api_env_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 5: Check the app still analyzes and its existing tests pass**

Run: `flutter analyze lib/core/constants/api_constants.dart` — expected: `No issues found!`
Run: `flutter test` — expected: the pre-existing suite passes.

- [ ] **Step 6: Commit**

```bash
git add lib/core/constants/api_constants.dart test/marketplace_api_env_test.dart
git commit -m "feat: point app at the marketplace backend via ApiEnv"
```

---

### Task 2: Seller GraphQL client factory

**Files:**
- Modify: `lib/core/graphql/graphql_client.dart`
- Test: `test/marketplace_seller_client_test.dart`

**Interfaces:**
- Consumes: `ApiEnv.sellerGraphql` from Task 1.
- Produces: `GraphQLClientProvider.buildSellerClient({String? token})` returning `GraphQLClient`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_client_test.dart`:

```dart
import 'package:bagisto_flutter/core/constants/api_constants.dart';
import 'package:bagisto_flutter/core/graphql/graphql_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

HttpLink _findHttpLink(Link link) {
  if (link is HttpLink) return link;
  if (link is LinkChain) {
    for (final child in link.links) {
      if (child is HttpLink) return child;
      if (child is LinkChain) return _findHttpLink(child);
    }
  }
  throw StateError('no HttpLink in chain');
}

void main() {
  test('seller client targets the seller endpoint', () {
    final client = GraphQLClientProvider.buildSellerClient();
    final httpLink = _findHttpLink(client.link);

    expect(httpLink.uri.toString(), ApiEnv.sellerGraphql);
  });

  test('seller client never sends the storefront key', () {
    final client = GraphQLClientProvider.buildSellerClient(token: 'abc');
    final httpLink = _findHttpLink(client.link);

    expect(httpLink.defaultHeaders.containsKey('X-STOREFRONT-KEY'), isFalse);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_client_test.dart`
Expected: FAIL — `The method 'buildSellerClient' isn't defined`.

- [ ] **Step 3: Write the implementation**

In `lib/core/graphql/graphql_client.dart`, inside `class GraphQLClientProvider`, immediately after the existing `buildClient` method, add:

```dart
  /// Client for the marketplace **seller** API.
  ///
  /// Two deliberate differences from [buildClient]:
  /// * it targets [ApiEnv.sellerGraphql], and
  /// * it sends no `X-STOREFRONT-KEY` — the server scopes that key to the shop
  ///   API and rejects seller routes that carry it.
  static GraphQLClient buildSellerClient({String? token}) {
    final httpClient = LoggingHttpClient(
      inner: TimeoutHttpClient(
        connectTimeout: _kTimeout,
        receiveTimeout: _kTimeout,
      ),
    );

    final httpLink = HttpLink(
      ApiEnv.sellerGraphql,
      httpClient: httpClient,
      defaultHeaders: const {'Content-Type': 'application/json'},
    );

    final Link link;
    if (token != null && token.isNotEmpty) {
      link = AuthLink(getToken: () async => 'Bearer $token').concat(httpLink);
    } else {
      link = httpLink;
    }

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
      queryRequestTimeout: _kTimeout,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }
```

The existing `_attachDynamicHeaders` in `LoggingHttpClient` adds `X-CHANNEL`, `X-LOCALE` and `X-CURRENCY`. Those are harmless on seller routes and keep locale-aware responses working, so leave that method alone.

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_client_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/core/graphql/graphql_client.dart test/marketplace_seller_client_test.dart
git commit -m "feat: add seller GraphQL client factory"
```

---

### Task 3: IRI and pagination primitives

**Files:**
- Create: `lib/marketplace/core/api/seller_iri.dart`
- Create: `lib/marketplace/core/api/paginated_result.dart`
- Test: `test/marketplace_primitives_test.dart`

**Interfaces:**
- Produces:
  - `SellerIri` with `SellerIri(String value)`, `SellerIri.fromJson(Object? json)`, `String get value`, `int get numericId`, `String toString()`.
  - `PaginatedResult<T>` with `PaginatedResult({required List<T> items, required int totalCount, required int lastPage, required int currentPage})`, `bool get hasNextPage`, and `PaginatedResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) mapItem, {int requestedPage = 1})`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_primitives_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_iri.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SellerIri', () {
    test('keeps the install path prefix the server sent', () {
      const raw = '/theme/api-4.9/public/api/seller/products/26';
      final iri = SellerIri.fromJson(raw);

      expect(iri.value, raw);
      expect(iri.toString(), raw);
    });

    test('reads the trailing numeric id', () {
      final iri = SellerIri.fromJson('/api/seller/products/26');

      expect(iri.numericId, 26);
    });

    test('throws when the trailing segment is not numeric', () {
      final iri = SellerIri.fromJson('/api/seller/profile');

      expect(() => iri.numericId, throwsFormatException);
    });

    test('fromJson returns null for a null input', () {
      expect(SellerIri.fromJson(null), isNull);
    });
  });

  group('PaginatedResult', () {
    test('maps a collection envelope', () {
      final json = {
        'collection': [
          {'name': 'first'},
          {'name': 'second'},
        ],
        'paginationInfo': {
          'totalCount': 42,
          'lastPage': 5,
          'itemsPerPage': 10,
        },
      };

      final result = PaginatedResult<String>.fromJson(
        json,
        (item) => item['name'] as String,
        requestedPage: 2,
      );

      expect(result.items, ['first', 'second']);
      expect(result.totalCount, 42);
      expect(result.lastPage, 5);
      expect(result.currentPage, 2);
      expect(result.hasNextPage, isTrue);
    });

    test('has no next page on the last page', () {
      final json = {
        'collection': const <dynamic>[],
        'paginationInfo': {'totalCount': 0, 'lastPage': 1},
      };

      final result = PaginatedResult<String>.fromJson(
        json,
        (item) => item['name'] as String,
        requestedPage: 1,
      );

      expect(result.items, isEmpty);
      expect(result.hasNextPage, isFalse);
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_primitives_test.dart`
Expected: FAIL — the two target files do not exist.

- [ ] **Step 3: Write `seller_iri.dart`**

```dart
/// A resource identifier issued by the seller API.
///
/// The server returns IRIs prefixed with the install path, for example
/// `/theme/api-4.9/public/api/seller/products/26`. Mutations only accept the
/// exact string the server handed out, so this type stores it verbatim and
/// never rebuilds one from an integer.
class SellerIri {
  const SellerIri(this.value);

  /// Reads an IRI from a JSON field. Returns null when the field is absent.
  static SellerIri? fromJson(Object? json) {
    if (json == null) return null;
    final text = json.toString();
    if (text.isEmpty) return null;
    return SellerIri(text);
  }

  /// The IRI exactly as the server sent it.
  final String value;

  /// The trailing path segment as an integer.
  ///
  /// Throws [FormatException] for IRIs that end in a word, such as
  /// `/api/seller/profile`.
  int get numericId {
    final segment = value.split('/').last;
    final parsed = int.tryParse(segment);
    if (parsed == null) {
      throw FormatException('IRI has no numeric id: $value');
    }
    return parsed;
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is SellerIri && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
```

- [ ] **Step 4: Write `paginated_result.dart`**

```dart
/// One page of a seller API collection.
///
/// Every seller list returns `{ collection, paginationInfo }`, so this maps
/// the envelope once instead of in twenty repositories.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.lastPage,
    required this.currentPage,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> item) mapItem, {
    int requestedPage = 1,
  }) {
    final rawItems = (json['collection'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(mapItem)
        .toList();

    final info = json['paginationInfo'] as Map<String, dynamic>? ?? const {};

    return PaginatedResult<T>(
      items: rawItems,
      totalCount: (info['totalCount'] as num?)?.toInt() ?? rawItems.length,
      lastPage: (info['lastPage'] as num?)?.toInt() ?? 1,
      currentPage: requestedPage,
    );
  }

  final List<T> items;
  final int totalCount;
  final int lastPage;
  final int currentPage;

  bool get hasNextPage => currentPage < lastPage;
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/marketplace_primitives_test.dart`
Expected: PASS, 6 tests.

- [ ] **Step 6: Commit**

```bash
git add lib/marketplace/core/api test/marketplace_primitives_test.dart
git commit -m "feat: add seller IRI and pagination primitives"
```

---

### Task 4: Seller error mapper

**Files:**
- Create: `lib/marketplace/core/api/seller_error_mapper.dart`
- Test: `test/marketplace_error_mapper_test.dart`

**Interfaces:**
- Produces: `SellerApiException` with `final String message` and `final SellerApiFailure kind`; enum `SellerApiFailure { unauthorized, forbidden, notFound, validation, unknown }`; `SellerErrorMapper.fromResult(QueryResult result)` returning `SellerApiException`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_error_mapper_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

QueryResult _resultWithError(String message) {
  return QueryResult(
    options: QueryOptions(document: gql('{ __typename }')),
    data: null,
    source: QueryResultSource.network,
    exception: OperationException(
      graphqlErrors: [GraphQLError(message: message)],
    ),
  );
}

void main() {
  test('maps an unauthorized message', () {
    final error = SellerErrorMapper.fromResult(_resultWithError('Unauthorized.'));

    expect(error.kind, SellerApiFailure.unauthorized);
    expect(error.message, 'Unauthorized.');
  });

  test('maps a missing resource', () {
    final error =
        SellerErrorMapper.fromResult(_resultWithError('Resource not found.'));

    expect(error.kind, SellerApiFailure.notFound);
  });

  test('maps a permission denial', () {
    final error = SellerErrorMapper.fromResult(
      _resultWithError('You do not have permission to perform this action.'),
    );

    expect(error.kind, SellerApiFailure.forbidden);
  });

  test('maps a validation message', () {
    final error =
        SellerErrorMapper.fromResult(_resultWithError('The SKU field is required.'));

    expect(error.kind, SellerApiFailure.validation);
    expect(error.message, 'The SKU field is required.');
  });

  test('joins several messages', () {
    final result = QueryResult(
      options: QueryOptions(document: gql('{ __typename }')),
      data: null,
      source: QueryResultSource.network,
      exception: OperationException(
        graphqlErrors: [
          GraphQLError(message: 'The SKU field is required.'),
          GraphQLError(message: 'The name field is required.'),
        ],
      ),
    );

    final error = SellerErrorMapper.fromResult(result);

    expect(
      error.message,
      'The SKU field is required.\nThe name field is required.',
    );
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_error_mapper_test.dart`
Expected: FAIL — target file does not exist.

- [ ] **Step 3: Write the implementation**

Create `lib/marketplace/core/api/seller_error_mapper.dart`:

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

/// Why a seller API call failed, in terms the UI can branch on.
enum SellerApiFailure { unauthorized, forbidden, notFound, validation, unknown }

/// A seller API failure carrying the server's own wording.
class SellerApiException implements Exception {
  const SellerApiException(this.message, this.kind);

  final String message;
  final SellerApiFailure kind;

  @override
  String toString() => message;
}

/// Turns a failed [QueryResult] into a [SellerApiException].
///
/// The seller API answers `200` with an `errors[]` array rather than HTTP
/// status codes, so the message text is the only signal available.
class SellerErrorMapper {
  const SellerErrorMapper._();

  static SellerApiException fromResult(QueryResult result) {
    final exception = result.exception;
    final graphqlErrors = exception?.graphqlErrors ?? const [];

    if (graphqlErrors.isEmpty) {
      final linkMessage = exception?.linkException?.toString();
      return SellerApiException(
        linkMessage == null || linkMessage.isEmpty
            ? 'Something went wrong. Please try again.'
            : 'Network error. Please check your connection.',
        SellerApiFailure.unknown,
      );
    }

    final message = graphqlErrors.map((e) => e.message).join('\n');
    return SellerApiException(message, _classify(message));
  }

  static SellerApiFailure _classify(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('unauthorized') || lower.contains('unauthenticated')) {
      return SellerApiFailure.unauthorized;
    }
    if (lower.contains('permission') || lower.contains('forbidden')) {
      return SellerApiFailure.forbidden;
    }
    if (lower.contains('resource not found') || lower.contains('not found')) {
      return SellerApiFailure.notFound;
    }
    if (lower.contains('required') ||
        lower.contains('invalid') ||
        lower.contains('must ') ||
        lower.contains('credentials')) {
      return SellerApiFailure.validation;
    }
    return SellerApiFailure.unknown;
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_error_mapper_test.dart`
Expected: PASS, 5 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/marketplace/core/api/seller_error_mapper.dart test/marketplace_error_mapper_test.dart
git commit -m "feat: add seller API error mapper"
```

---

### Task 5: Seller auth storage

**Files:**
- Create: `lib/marketplace/core/session/seller_auth_storage.dart`
- Test: `test/marketplace_seller_auth_storage_test.dart`

**Interfaces:**
- Produces: `SellerAuthStorage` with static futures `saveSession({required String token, required String name, required String email, String? slug, int? sellerId})`, `getToken()`, `getName()`, `getEmail()`, `getSlug()`, `getSellerId()`, `savePermissions({required String permissionType, required List<String> permissions})`, `getPermissionType()`, `getPermissions()`, `isLoggedIn()`, `clear()`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_auth_storage_test.dart`:

```dart
import 'package:bagisto_flutter/features/auth/domain/services/auth_storage.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_auth_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('stores and reads a seller session', () async {
    await SellerAuthStorage.saveSession(
      token: 'seller-token',
      name: 'Acme',
      email: 'seller@example.com',
      slug: 'acme-store',
      sellerId: 7,
    );

    expect(await SellerAuthStorage.getToken(), 'seller-token');
    expect(await SellerAuthStorage.getName(), 'Acme');
    expect(await SellerAuthStorage.getEmail(), 'seller@example.com');
    expect(await SellerAuthStorage.getSlug(), 'acme-store');
    expect(await SellerAuthStorage.getSellerId(), 7);
    expect(await SellerAuthStorage.isLoggedIn(), isTrue);
  });

  test('stores permissions', () async {
    await SellerAuthStorage.savePermissions(
      permissionType: 'custom',
      permissions: const ['dashboard', 'sales.orders'],
    );

    expect(await SellerAuthStorage.getPermissionType(), 'custom');
    expect(
      await SellerAuthStorage.getPermissions(),
      const ['dashboard', 'sales.orders'],
    );
  });

  test('clearing the seller session leaves the customer session intact',
      () async {
    await AuthStorage.saveToken('customer-token');
    await SellerAuthStorage.saveSession(
      token: 'seller-token',
      name: 'Acme',
      email: 'seller@example.com',
    );

    await SellerAuthStorage.clear();

    expect(await SellerAuthStorage.getToken(), isNull);
    expect(await SellerAuthStorage.isLoggedIn(), isFalse);
    expect(await AuthStorage.getToken(), 'customer-token');
  });

  test('clearing the customer session leaves the seller session intact',
      () async {
    await AuthStorage.saveToken('customer-token');
    await SellerAuthStorage.saveSession(
      token: 'seller-token',
      name: 'Acme',
      email: 'seller@example.com',
    );

    await AuthStorage.clearAuth();

    expect(await SellerAuthStorage.getToken(), 'seller-token');
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_auth_storage_test.dart`
Expected: FAIL — target file does not exist.

- [ ] **Step 3: Write the implementation**

Create `lib/marketplace/core/session/seller_auth_storage.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the seller session.
///
/// Every key is prefixed `seller_` so a seller signing out never disturbs the
/// customer session, and the two can be active at the same time.
class SellerAuthStorage {
  const SellerAuthStorage._();

  static const String _tokenKey = 'seller_token';
  static const String _nameKey = 'seller_name';
  static const String _emailKey = 'seller_email';
  static const String _slugKey = 'seller_slug';
  static const String _idKey = 'seller_id';
  static const String _permissionTypeKey = 'seller_permission_type';
  static const String _permissionsKey = 'seller_permissions';

  static Future<void> saveSession({
    required String token,
    required String name,
    required String email,
    String? slug,
    int? sellerId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    if (slug != null) await prefs.setString(_slugKey, slug);
    if (sellerId != null) await prefs.setInt(_idKey, sellerId);
  }

  static Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  static Future<String?> getName() async =>
      (await SharedPreferences.getInstance()).getString(_nameKey);

  static Future<String?> getEmail() async =>
      (await SharedPreferences.getInstance()).getString(_emailKey);

  static Future<String?> getSlug() async =>
      (await SharedPreferences.getInstance()).getString(_slugKey);

  static Future<int?> getSellerId() async =>
      (await SharedPreferences.getInstance()).getInt(_idKey);

  static Future<void> savePermissions({
    required String permissionType,
    required List<String> permissions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_permissionTypeKey, permissionType);
    await prefs.setStringList(_permissionsKey, permissions);
  }

  static Future<String?> getPermissionType() async =>
      (await SharedPreferences.getInstance()).getString(_permissionTypeKey);

  static Future<List<String>> getPermissions() async =>
      (await SharedPreferences.getInstance()).getStringList(_permissionsKey) ??
      const [];

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in const [
      _tokenKey,
      _nameKey,
      _emailKey,
      _slugKey,
      _idKey,
      _permissionTypeKey,
      _permissionsKey,
    ]) {
      await prefs.remove(key);
    }
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_auth_storage_test.dart`
Expected: PASS, 4 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/marketplace/core/session/seller_auth_storage.dart test/marketplace_seller_auth_storage_test.dart
git commit -m "feat: add isolated seller session storage"
```

---

### Task 6: Seller permissions

**Files:**
- Create: `lib/marketplace/core/session/seller_permissions.dart`
- Test: `test/marketplace_seller_permissions_test.dart`

**Interfaces:**
- Produces: `SellerPermissions` with `SellerPermissions({required String type, required Set<String> keys})`, `SellerPermissions.all()`, `SellerPermissions.none()`, `bool can(String key)`, `bool canAny(List<String> keys)`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_permissions_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('permissionType all grants everything', () {
    final permissions = SellerPermissions.all();

    expect(permissions.can('sales.orders.invoice'), isTrue);
    expect(permissions.can('anything.at.all'), isTrue);
  });

  test('custom type grants only the listed keys', () {
    final permissions = SellerPermissions(
      type: 'custom',
      keys: const {'dashboard', 'sales.orders', 'sales.orders.view'},
    );

    expect(permissions.can('sales.orders.view'), isTrue);
    expect(permissions.can('sales.orders.invoice'), isFalse);
  });

  test('canAny is true when at least one key is granted', () {
    final permissions = SellerPermissions(
      type: 'custom',
      keys: const {'sales.orders'},
    );

    expect(
      permissions.canAny(const ['product_catalog.products', 'sales.orders']),
      isTrue,
    );
    expect(permissions.canAny(const ['settings.users']), isFalse);
  });

  test('none grants nothing', () {
    expect(SellerPermissions.none().can('dashboard'), isFalse);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_permissions_test.dart`
Expected: FAIL — target file does not exist.

- [ ] **Step 3: Write the implementation**

Create `lib/marketplace/core/session/seller_permissions.dart`:

```dart
/// The ACL keys the signed-in seller holds.
///
/// The seller API guards every endpoint with a key such as
/// `sales.orders.invoice`. A role of type `all` bypasses the list entirely.
class SellerPermissions {
  const SellerPermissions({required this.type, required this.keys});

  factory SellerPermissions.all() =>
      const SellerPermissions(type: 'all', keys: <String>{});

  factory SellerPermissions.none() =>
      const SellerPermissions(type: 'custom', keys: <String>{});

  /// Either `all` or `custom`.
  final String type;

  /// Granted keys. Ignored when [type] is `all`.
  final Set<String> keys;

  bool get grantsEverything => type == 'all';

  bool can(String key) => grantsEverything || keys.contains(key);

  bool canAny(List<String> candidates) => candidates.any(can);
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_permissions_test.dart`
Expected: PASS, 4 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/marketplace/core/session/seller_permissions.dart test/marketplace_seller_permissions_test.dart
git commit -m "feat: add seller ACL permission model"
```

---

### Task 7: Seller auth documents, models and repository

**Files:**
- Create: `lib/marketplace/graphql/seller_auth.dart`
- Create: `lib/marketplace/features/auth/data/models/seller_auth_models.dart`
- Create: `lib/marketplace/features/auth/data/repository/seller_auth_repository.dart`
- Test: `test/marketplace_seller_auth_repository_test.dart`

**Interfaces:**
- Consumes: `SellerErrorMapper`, `SellerApiException`, `SellerApiFailure` (Task 4).
- Produces:
  - `SellerAuthDocuments.login`, `.register`, `.logout`, `.forgotPassword`, `.resetPassword`, `.attributes` (all `String`).
  - `SellerLoginResult({required bool success, String? token, String? message})`.
  - `SellerAttribute({required String code, required String name, required String type, required bool isRequired, List<SellerAttributeOption> options})` and `SellerAttributeOption({required String id, required String label})`.
  - `SellerAuthRepository({required GraphQLClient client})` with `Future<SellerLoginResult> login({required String email, required String password})`, `Future<List<SellerAttribute>> signUpAttributes()`, `Future<String> register({...})`, `Future<void> forgotPassword(String email)`, `Future<void> logout()`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_auth_repository_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Builds a client whose link answers with [data] or [errors] without a network.
GraphQLClient _clientReturning({
  Map<String, dynamic>? data,
  List<String> errors = const [],
}) {
  final link = Link.function((request, [forward]) async* {
    yield Response(
      data: data,
      errors: errors.map((message) => GraphQLError(message: message)).toList(),
      response: const {},
      context: const Context(),
    );
  });

  return GraphQLClient(cache: GraphQLCache(store: InMemoryStore()), link: link);
}

void main() {
  test('login returns the token on success', () async {
    final repository = SellerAuthRepository(
      client: _clientReturning(
        data: {
          'createSellerLogin': {
            'sellerLogin': {
              'token': '107|abc',
              'success': true,
              'message': 'You have logged in successfully.',
            },
          },
        },
      ),
    );

    final result = await repository.login(
      email: 'seller@example.com',
      password: 'secret',
    );

    expect(result.success, isTrue);
    expect(result.token, '107|abc');
  });

  test('login throws the server message on bad credentials', () async {
    final repository = SellerAuthRepository(
      client: _clientReturning(
        errors: const ['Please check your credentials and try again.'],
      ),
    );

    await expectLater(
      repository.login(email: 'seller@example.com', password: 'wrong'),
      throwsA(
        isA<SellerApiException>()
            .having((e) => e.kind, 'kind', SellerApiFailure.validation)
            .having(
              (e) => e.message,
              'message',
              'Please check your credentials and try again.',
            ),
      ),
    );
  });

  test('sign-up attributes map code, requiredness and options', () async {
    final repository = SellerAuthRepository(
      client: _clientReturning(
        data: {
          'sellerAttributes': [
            {
              'code': 'business_name',
              'name': 'Business Name',
              'type': 'text',
              'isRequired': true,
              'options': null,
            },
            {
              'code': 'business_type',
              'name': 'Business Type',
              'type': 'select',
              'isRequired': false,
              'options': [
                {'id': '1', 'label': 'Retail'},
              ],
            },
          ],
        },
      ),
    );

    final attributes = await repository.signUpAttributes();

    expect(attributes, hasLength(2));
    expect(attributes.first.code, 'business_name');
    expect(attributes.first.isRequired, isTrue);
    expect(attributes.last.options.single.label, 'Retail');
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_auth_repository_test.dart`
Expected: FAIL — target files do not exist.

- [ ] **Step 3: Write `seller_auth.dart`**

```dart
/// GraphQL documents for the seller session.
///
/// Field names copied from the live schema at `/api/seller/graphql`.
class SellerAuthDocuments {
  const SellerAuthDocuments._();

  static const String login = r'''
    mutation SellerLogin($input: createSellerLoginInput!) {
      createSellerLogin(input: $input) {
        sellerLogin { token success message }
      }
    }
  ''';

  static const String register = r'''
    mutation SellerRegister($input: createSellerRegisterInput!) {
      createSellerRegister(input: $input) {
        sellerRegister { success isApproved message }
      }
    }
  ''';

  static const String logout = r'''
    mutation SellerLogout {
      createSellerLogout(input: {}) {
        sellerLogout { success message }
      }
    }
  ''';

  static const String forgotPassword = r'''
    mutation SellerForgotPassword($input: createSellerForgotPasswordInput!) {
      createSellerForgotPassword(input: $input) {
        sellerForgotPassword { success message }
      }
    }
  ''';

  static const String resetPassword = r'''
    mutation SellerResetPassword($input: createSellerResetPasswordInput!) {
      createSellerResetPassword(input: $input) {
        sellerResetPassword { success message }
      }
    }
  ''';

  static const String attributes = r'''
    query SellerAttributes {
      sellerAttributes {
        code
        name
        type
        isRequired
        isUnique
        options { id label }
      }
    }
  ''';
}
```

- [ ] **Step 4: Write `seller_auth_models.dart`**

```dart
import 'package:equatable/equatable.dart';

/// Outcome of `createSellerLogin`.
class SellerLoginResult extends Equatable {
  const SellerLoginResult({required this.success, this.token, this.message});

  factory SellerLoginResult.fromJson(Map<String, dynamic> json) {
    return SellerLoginResult(
      success: json['success'] == true,
      token: json['token'] as String?,
      message: json['message'] as String?,
    );
  }

  final bool success;
  final String? token;
  final String? message;

  @override
  List<Object?> get props => [success, token, message];
}

/// One selectable value on a `select` or `multiselect` attribute.
class SellerAttributeOption extends Equatable {
  const SellerAttributeOption({required this.id, required this.label});

  factory SellerAttributeOption.fromJson(Map<String, dynamic> json) {
    return SellerAttributeOption(
      id: json['id'].toString(),
      label: json['label']?.toString() ?? '',
    );
  }

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

/// A field the registration and profile forms must render.
///
/// The admin can add attributes, so the form is built from this list rather
/// than hardcoded.
class SellerAttribute extends Equatable {
  const SellerAttribute({
    required this.code,
    required this.name,
    required this.type,
    required this.isRequired,
    this.options = const [],
  });

  factory SellerAttribute.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List<dynamic>? ?? const [];
    return SellerAttribute(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      isRequired: json['isRequired'] == true,
      options: rawOptions
          .whereType<Map<String, dynamic>>()
          .map(SellerAttributeOption.fromJson)
          .toList(),
    );
  }

  final String code;
  final String name;
  final String type;
  final bool isRequired;
  final List<SellerAttributeOption> options;

  /// Fields the register mutation takes at the top level rather than inside
  /// its `attributes` list.
  static const Set<String> fixedCodes = {
    'name',
    'email',
    'slug',
    'password',
    'phone',
  };

  bool get isFixedField => fixedCodes.contains(code);

  @override
  List<Object?> get props => [code, name, type, isRequired, options];
}
```

- [ ] **Step 5: Write `seller_auth_repository.dart`**

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../../../graphql/seller_auth.dart';
import '../models/seller_auth_models.dart';

/// Seller session calls against `/api/seller/graphql`.
class SellerAuthRepository {
  const SellerAuthRepository({required this.client});

  final GraphQLClient client;

  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(SellerAuthDocuments.login),
        variables: {
          'input': {'email': email, 'password': password},
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final payload =
        result.data?['createSellerLogin']?['sellerLogin'] as Map<String, dynamic>?;
    if (payload == null) {
      throw const SellerApiException(
        'Invalid response from server',
        SellerApiFailure.unknown,
      );
    }

    final login = SellerLoginResult.fromJson(payload);
    if (!login.success || login.token == null || login.token!.isEmpty) {
      throw SellerApiException(
        login.message ?? 'Login failed',
        SellerApiFailure.validation,
      );
    }
    return login;
  }

  Future<List<SellerAttribute>> signUpAttributes() async {
    final result = await client.query(
      QueryOptions(
        document: gql(SellerAuthDocuments.attributes),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final raw = result.data?['sellerAttributes'] as List<dynamic>? ?? const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(SellerAttribute.fromJson)
        .toList();
  }

  /// Registers a seller. Returns the server's message, which states whether
  /// the account still needs admin approval.
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(SellerAuthDocuments.register),
        variables: {
          'input': {
            'name': name,
            'email': email,
            'slug': slug,
            'password': password,
            'passwordConfirmation': passwordConfirmation,
            if (phone != null && phone.isNotEmpty) 'phone': phone,
            if (attributes.isNotEmpty)
              'attributes': attributes.entries
                  .map((entry) => {'code': entry.key, 'value': entry.value})
                  .toList(),
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final payload = result.data?['createSellerRegister']?['sellerRegister']
        as Map<String, dynamic>?;
    if (payload == null || payload['success'] != true) {
      throw SellerApiException(
        payload?['message']?.toString() ?? 'Registration failed',
        SellerApiFailure.validation,
      );
    }
    return payload['message']?.toString() ?? 'Registration successful';
  }

  Future<void> forgotPassword(String email) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(SellerAuthDocuments.forgotPassword),
        variables: {
          'input': {'email': email},
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);
  }

  Future<void> logout() async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(SellerAuthDocuments.logout),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    // A rejected logout still ends the local session, so failures are ignored
    // here and the caller clears storage regardless.
    if (result.hasException) return;
  }
}
```

- [ ] **Step 6: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_auth_repository_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 7: Verify against the live server**

Run:
```bash
curl -s -X POST 'http://192.168.15.239/theme/api-4.9/public/api/seller/graphql' \
  -H 'Content-Type: application/json' \
  -d '{"query":"mutation SellerLogin($input: createSellerLoginInput!){ createSellerLogin(input:$input){ sellerLogin { token success message } } }","variables":{"input":{"email":"ashifwebkul@gmail.com","password":"seller123"}}}'
```
Expected: JSON containing `"success":true` and a `token`. This confirms the document in `SellerAuthDocuments.login` matches the deployed schema.

- [ ] **Step 8: Commit**

```bash
git add lib/marketplace/graphql/seller_auth.dart \
        lib/marketplace/features/auth/data \
        test/marketplace_seller_auth_repository_test.dart
git commit -m "feat: add seller auth documents, models and repository"
```

---

### Task 8: Seller profile and ACL repository

**Files:**
- Create: `lib/marketplace/graphql/seller_account.dart`
- Create: `lib/marketplace/features/account/data/models/seller_profile.dart`
- Create: `lib/marketplace/features/account/data/repository/seller_account_repository.dart`
- Test: `test/marketplace_seller_account_repository_test.dart`

**Interfaces:**
- Consumes: `SellerErrorMapper`, `SellerApiException` (Task 4); `SellerPermissions` (Task 6).
- Produces:
  - `SellerAccountDocuments.profile`, `.updateProfile`, `.aclPermissions` (all `String`).
  - `SellerProfile` with `fromJson`, fields `name`, `email`, `slug`, `phone`, `businessName`, `businessDescription`, `logoUrl`, `bannerUrl`, `isApproved`, `isSuspended`, `city`, `state`, `country`, plus `SellerProfile copyWith({...})`.
  - `SellerAclPermission({required String key, required String name, String? parent, required int level})`.
  - `SellerAccountRepository({required GraphQLClient client})` with `Future<SellerProfile> profile()`, `Future<List<SellerAclPermission>> aclPermissions()`, `Future<SellerPermissions> permissions()`, `Future<SellerProfile> updateProfile(Map<String, dynamic> input)`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_account_repository_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient _clientReturning(Map<String, dynamic> data) {
  final link = Link.function((request, [forward]) async* {
    yield Response(data: data, response: const {}, context: const Context());
  });
  return GraphQLClient(cache: GraphQLCache(store: InMemoryStore()), link: link);
}

void main() {
  test('profile maps identity and approval state', () async {
    final repository = SellerAccountRepository(
      client: _clientReturning({
        'sellerProfile': {
          'name': 'Ashif',
          'email': 'seller@example.com',
          'slug': 'acme-store',
          'phone': '9999999999',
          'businessName': 'Acme Store',
          'businessDescription': 'We sell quality goods.',
          'logoUrl': 'https://example.com/logo.png',
          'bannerUrl': null,
          'isApproved': true,
          'isSuspended': false,
          'city': 'Pune',
          'state': 'MH',
          'country': 'IN',
        },
      }),
    );

    final profile = await repository.profile();

    expect(profile.name, 'Ashif');
    expect(profile.businessName, 'Acme Store');
    expect(profile.isApproved, isTrue);
    expect(profile.isSuspended, isFalse);
    expect(profile.bannerUrl, isNull);
  });

  test('permissions collapse the ACL list into a lookup', () async {
    final repository = SellerAccountRepository(
      client: _clientReturning({
        'sellerAclPermissions': [
          {'key': 'dashboard', 'name': 'Dashboard', 'parent': null, 'level': 0},
          {'key': 'sales', 'name': 'Sales', 'parent': null, 'level': 0},
          {
            'key': 'sales.orders',
            'name': 'Orders',
            'parent': 'sales',
            'level': 1,
          },
        ],
      }),
    );

    final permissions = await repository.permissions();

    expect(permissions.can('sales.orders'), isTrue);
    expect(permissions.can('settings.users'), isFalse);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_account_repository_test.dart`
Expected: FAIL — target files do not exist.

- [ ] **Step 3: Write `seller_account.dart`**

```dart
/// GraphQL documents for the seller's own account.
class SellerAccountDocuments {
  const SellerAccountDocuments._();

  /// `id` is the fixed IRI `/api/seller/profile`; it always resolves to the
  /// authenticated seller.
  static const String profile = r'''
    query SellerProfile {
      sellerProfile(id: "/api/seller/profile") {
        name
        email
        slug
        phone
        businessName
        businessDescription
        logoUrl
        bannerUrl
        isApproved
        isSuspended
        city
        state
        country
      }
    }
  ''';

  static const String updateProfile = r'''
    mutation UpdateSellerProfile($input: updateSellerProfileInput!) {
      updateSellerProfile(input: $input) {
        sellerProfile {
          name
          email
          slug
          phone
          businessName
          businessDescription
          logoUrl
          bannerUrl
          isApproved
          isSuspended
          city
          state
          country
        }
      }
    }
  ''';

  static const String aclPermissions = r'''
    query SellerAclPermissions {
      sellerAclPermissions { key name parent level }
    }
  ''';
}
```

- [ ] **Step 4: Write `seller_profile.dart`**

```dart
import 'package:equatable/equatable.dart';

/// The signed-in seller's shop identity.
class SellerProfile extends Equatable {
  const SellerProfile({
    required this.name,
    required this.email,
    this.slug,
    this.phone,
    this.businessName,
    this.businessDescription,
    this.logoUrl,
    this.bannerUrl,
    this.isApproved = false,
    this.isSuspended = false,
    this.city,
    this.state,
    this.country,
  });

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      slug: json['slug']?.toString(),
      phone: json['phone']?.toString(),
      businessName: json['businessName']?.toString(),
      businessDescription: json['businessDescription']?.toString(),
      logoUrl: json['logoUrl']?.toString(),
      bannerUrl: json['bannerUrl']?.toString(),
      isApproved: json['isApproved'] == true,
      isSuspended: json['isSuspended'] == true,
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
    );
  }

  final String name;
  final String email;
  final String? slug;
  final String? phone;
  final String? businessName;
  final String? businessDescription;
  final String? logoUrl;
  final String? bannerUrl;
  final bool isApproved;
  final bool isSuspended;
  final String? city;
  final String? state;
  final String? country;

  /// What the shell header shows.
  String get displayName =>
      (businessName != null && businessName!.isNotEmpty) ? businessName! : name;

  SellerProfile copyWith({
    String? name,
    String? email,
    String? slug,
    String? phone,
    String? businessName,
    String? businessDescription,
    String? logoUrl,
    String? bannerUrl,
    bool? isApproved,
    bool? isSuspended,
    String? city,
    String? state,
    String? country,
  }) {
    return SellerProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      slug: slug ?? this.slug,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      isApproved: isApproved ?? this.isApproved,
      isSuspended: isSuspended ?? this.isSuspended,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        slug,
        phone,
        businessName,
        businessDescription,
        logoUrl,
        bannerUrl,
        isApproved,
        isSuspended,
        city,
        state,
        country,
      ];
}

/// One ACL key the seller's role may grant.
class SellerAclPermission extends Equatable {
  const SellerAclPermission({
    required this.key,
    required this.name,
    required this.level,
    this.parent,
  });

  factory SellerAclPermission.fromJson(Map<String, dynamic> json) {
    return SellerAclPermission(
      key: json['key']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      parent: json['parent']?.toString(),
      level: (json['level'] as num?)?.toInt() ?? 0,
    );
  }

  final String key;
  final String name;
  final String? parent;
  final int level;

  @override
  List<Object?> get props => [key, name, parent, level];
}
```

- [ ] **Step 5: Write `seller_account_repository.dart`**

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../../../core/session/seller_permissions.dart';
import '../../../../graphql/seller_account.dart';
import '../models/seller_profile.dart';

/// Reads and writes the seller's own account.
class SellerAccountRepository {
  const SellerAccountRepository({required this.client});

  final GraphQLClient client;

  Future<SellerProfile> profile() async {
    final result = await client.query(
      QueryOptions(
        document: gql(SellerAccountDocuments.profile),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final payload = result.data?['sellerProfile'] as Map<String, dynamic>?;
    if (payload == null) {
      throw const SellerApiException(
        'Profile unavailable',
        SellerApiFailure.notFound,
      );
    }
    return SellerProfile.fromJson(payload);
  }

  Future<List<SellerAclPermission>> aclPermissions() async {
    final result = await client.query(
      QueryOptions(
        document: gql(SellerAccountDocuments.aclPermissions),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final raw =
        result.data?['sellerAclPermissions'] as List<dynamic>? ?? const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(SellerAclPermission.fromJson)
        .toList();
  }

  /// The ACL as a lookup the UI can gate on.
  ///
  /// `sellerAclPermissions` lists what the account *may* hold, which for an
  /// owner account is everything; a staff account is narrowed by its role.
  Future<SellerPermissions> permissions() async {
    final acl = await aclPermissions();
    return SellerPermissions(
      type: 'custom',
      keys: acl.map((permission) => permission.key).toSet(),
    );
  }

  /// Partial update. Only the keys present in [input] are written.
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(SellerAccountDocuments.updateProfile),
        variables: {
          'input': {'id': '/api/seller/profile', ...input},
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final payload = result.data?['updateSellerProfile']?['sellerProfile']
        as Map<String, dynamic>?;
    if (payload == null) {
      throw const SellerApiException(
        'Profile update failed',
        SellerApiFailure.unknown,
      );
    }
    return SellerProfile.fromJson(payload);
  }
}
```

- [ ] **Step 6: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_account_repository_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 7: Commit**

```bash
git add lib/marketplace/graphql/seller_account.dart \
        lib/marketplace/features/account/data \
        test/marketplace_seller_account_repository_test.dart
git commit -m "feat: add seller profile and ACL repository"
```

---

### Task 9: Seller session cubit

**Files:**
- Create: `lib/marketplace/core/session/seller_session_cubit.dart`
- Test: `test/marketplace_seller_session_cubit_test.dart`

**Interfaces:**
- Consumes: `SellerAuthStorage` (Task 5), `SellerPermissions` (Task 6), `SellerAuthRepository` (Task 7), `SellerAccountRepository` + `SellerProfile` (Task 8).
- Produces:
  - `enum SellerSessionStatus { unknown, unauthenticated, loading, active, pendingApproval, suspended, failed }`
  - `SellerSessionState` with `status`, `profile`, `permissions`, `errorMessage`, and `copyWith`.
  - `SellerSessionCubit({required SellerAuthRepository authRepository, required SellerAccountRepository Function(String token) accountRepositoryBuilder})` with `Future<void> bootstrap()`, `Future<void> signIn({required String email, required String password})`, `Future<void> signOut()`, and `String? get token`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_session_cubit_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_auth_storage.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements SellerAuthRepository {
  _FakeAuthRepository({this.loginResult, this.loginError});

  final SellerLoginResult? loginResult;
  final SellerApiException? loginError;
  bool logoutCalled = false;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async {
    if (loginError != null) throw loginError!;
    return loginResult!;
  }

  @override
  Future<void> logout() async => logoutCalled = true;

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<List<SellerAttribute>> signUpAttributes() async => const [];

  @override
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async =>
      'ok';
}

class _FakeAccountRepository implements SellerAccountRepository {
  _FakeAccountRepository(this._profile);

  final SellerProfile _profile;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProfile> profile() async => _profile;

  @override
  Future<List<SellerAclPermission>> aclPermissions() async => const [
        SellerAclPermission(key: 'dashboard', name: 'Dashboard', level: 0),
      ];

  @override
  Future<SellerPermissions> permissions() async =>
      const SellerPermissions(type: 'custom', keys: {'dashboard'});

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async =>
      _profile;
}

SellerSessionCubit _cubit({
  required _FakeAuthRepository auth,
  required SellerProfile profile,
}) {
  return SellerSessionCubit(
    authRepository: auth,
    accountRepositoryBuilder: (_) => _FakeAccountRepository(profile),
  );
}

const _approvedProfile = SellerProfile(
  name: 'Ashif',
  email: 'seller@example.com',
  businessName: 'Acme Store',
  isApproved: true,
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('sign-in stores the token and becomes active', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    expect(cubit.state.status, SellerSessionStatus.active);
    expect(cubit.state.profile?.businessName, 'Acme Store');
    expect(cubit.state.permissions.can('dashboard'), isTrue);
    expect(await SellerAuthStorage.getToken(), '107|abc');
  });

  test('an unapproved seller lands in pendingApproval', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(
      auth: auth,
      profile: const SellerProfile(
        name: 'New',
        email: 'new@example.com',
        isApproved: false,
      ),
    );

    await cubit.signIn(email: 'new@example.com', password: 'secret');

    expect(cubit.state.status, SellerSessionStatus.pendingApproval);
  });

  test('a suspended seller lands in suspended', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(
      auth: auth,
      profile: const SellerProfile(
        name: 'Blocked',
        email: 'blocked@example.com',
        isApproved: true,
        isSuspended: true,
      ),
    );

    await cubit.signIn(email: 'blocked@example.com', password: 'secret');

    expect(cubit.state.status, SellerSessionStatus.suspended);
  });

  test('a rejected sign-in surfaces the server message', () async {
    final auth = _FakeAuthRepository(
      loginError: const SellerApiException(
        'Please check your credentials and try again.',
        SellerApiFailure.validation,
      ),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.signIn(email: 'seller@example.com', password: 'wrong');

    expect(cubit.state.status, SellerSessionStatus.failed);
    expect(
      cubit.state.errorMessage,
      'Please check your credentials and try again.',
    );
    expect(await SellerAuthStorage.getToken(), isNull);
  });

  test('sign-out clears storage and calls the API', () async {
    final auth = _FakeAuthRepository(
      loginResult: const SellerLoginResult(success: true, token: '107|abc'),
    );
    final cubit = _cubit(auth: auth, profile: _approvedProfile);
    await cubit.signIn(email: 'seller@example.com', password: 'seller123');

    await cubit.signOut();

    expect(auth.logoutCalled, isTrue);
    expect(cubit.state.status, SellerSessionStatus.unauthenticated);
    expect(await SellerAuthStorage.getToken(), isNull);
  });

  test('bootstrap with no stored token is unauthenticated', () async {
    final auth = _FakeAuthRepository();
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.bootstrap();

    expect(cubit.state.status, SellerSessionStatus.unauthenticated);
  });

  test('bootstrap restores an existing session', () async {
    await SellerAuthStorage.saveSession(
      token: 'stored-token',
      name: 'Ashif',
      email: 'seller@example.com',
    );
    final auth = _FakeAuthRepository();
    final cubit = _cubit(auth: auth, profile: _approvedProfile);

    await cubit.bootstrap();

    expect(cubit.state.status, SellerSessionStatus.active);
    expect(cubit.token, 'stored-token');
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_session_cubit_test.dart`
Expected: FAIL — target file does not exist.

- [ ] **Step 3: Write the implementation**

Create `lib/marketplace/core/session/seller_session_cubit.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/seller_error_mapper.dart';
import '../../features/account/data/models/seller_profile.dart';
import '../../features/account/data/repository/seller_account_repository.dart';
import '../../features/auth/data/repository/seller_auth_repository.dart';
import 'seller_auth_storage.dart';
import 'seller_permissions.dart';

/// Where the seller stands with the marketplace right now.
enum SellerSessionStatus {
  unknown,
  unauthenticated,
  loading,
  active,
  pendingApproval,
  suspended,
  failed,
}

class SellerSessionState extends Equatable {
  const SellerSessionState({
    this.status = SellerSessionStatus.unknown,
    this.profile,
    this.permissions = const SellerPermissions(type: 'custom', keys: {}),
    this.errorMessage,
  });

  final SellerSessionStatus status;
  final SellerProfile? profile;
  final SellerPermissions permissions;
  final String? errorMessage;

  bool get canUsePanel => status == SellerSessionStatus.active;

  SellerSessionState copyWith({
    SellerSessionStatus? status,
    SellerProfile? profile,
    SellerPermissions? permissions,
    String? errorMessage,
  }) {
    return SellerSessionState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      permissions: permissions ?? this.permissions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        permissions.type,
        permissions.keys,
        errorMessage,
      ];
}

/// Owns the seller session: sign-in, restore, gate state and sign-out.
///
/// The account repository is built per token because each seller call needs a
/// client carrying that seller's Bearer token.
class SellerSessionCubit extends Cubit<SellerSessionState> {
  SellerSessionCubit({
    required this.authRepository,
    required this.accountRepositoryBuilder,
  }) : super(const SellerSessionState());

  final SellerAuthRepository authRepository;
  final SellerAccountRepository Function(String token) accountRepositoryBuilder;

  String? _token;

  String? get token => _token;

  /// Restores a stored session at app start.
  Future<void> bootstrap() async {
    final stored = await SellerAuthStorage.getToken();
    if (stored == null || stored.isEmpty) {
      emit(const SellerSessionState(status: SellerSessionStatus.unauthenticated));
      return;
    }

    _token = stored;
    emit(state.copyWith(status: SellerSessionStatus.loading));
    await _loadAccount(stored);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: SellerSessionStatus.loading));

    try {
      final login = await authRepository.login(email: email, password: password);
      final token = login.token!;
      _token = token;
      await SellerAuthStorage.saveSession(
        token: token,
        name: '',
        email: email,
      );
      await _loadAccount(token);
    } on SellerApiException catch (error) {
      _token = null;
      await SellerAuthStorage.clear();
      emit(
        state.copyWith(
          status: SellerSessionStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.logout();
    } finally {
      _token = null;
      await SellerAuthStorage.clear();
      emit(const SellerSessionState(status: SellerSessionStatus.unauthenticated));
    }
  }

  Future<void> _loadAccount(String token) async {
    final repository = accountRepositoryBuilder(token);

    try {
      final profile = await repository.profile();
      final permissions = await repository.permissions();

      await SellerAuthStorage.saveSession(
        token: token,
        name: profile.name,
        email: profile.email,
        slug: profile.slug,
      );
      await SellerAuthStorage.savePermissions(
        permissionType: permissions.type,
        permissions: permissions.keys.toList(),
      );

      emit(
        SellerSessionState(
          status: _statusFor(profile),
          profile: profile,
          permissions: permissions,
        ),
      );
    } on SellerApiException catch (error) {
      if (error.kind == SellerApiFailure.unauthorized) {
        _token = null;
        await SellerAuthStorage.clear();
        emit(
          const SellerSessionState(status: SellerSessionStatus.unauthenticated),
        );
        return;
      }
      emit(
        state.copyWith(
          status: SellerSessionStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }

  SellerSessionStatus _statusFor(SellerProfile profile) {
    if (profile.isSuspended) return SellerSessionStatus.suspended;
    if (!profile.isApproved) return SellerSessionStatus.pendingApproval;
    return SellerSessionStatus.active;
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_session_cubit_test.dart`
Expected: PASS, 7 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/marketplace/core/session/seller_session_cubit.dart \
        test/marketplace_seller_session_cubit_test.dart
git commit -m "feat: add seller session cubit"
```

---

### Task 10: Seller login screen

The session cubit from Task 9 already models login state, so the screen drives it directly instead of adding a second bloc.

**Files:**
- Create: `lib/marketplace/features/auth/presentation/pages/seller_login_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Test: `test/marketplace_seller_login_page_test.dart`

**Interfaces:**
- Consumes: `SellerSessionCubit`, `SellerSessionState`, `SellerSessionStatus` (Task 9).
- Produces: `SellerLoginPage` — a `StatefulWidget` with `const SellerLoginPage({super.key})`. It expects a `SellerSessionCubit` above it in the tree.

- [ ] **Step 1: Add the strings**

In `lib/l10n/app_en.arb`, add these keys before the closing brace (keep the file's existing formatting — two-space indent, no trailing comma on the last entry):

```json
  "sellerLoginTitle": "Seller sign in",
  "sellerLoginSubtitle": "Manage your shop, products and orders",
  "sellerEmailLabel": "Email",
  "sellerPasswordLabel": "Password",
  "sellerSignInAction": "Sign in",
  "sellerEmailRequired": "Enter your email",
  "sellerPasswordRequired": "Enter your password",
  "sellerPendingApprovalTitle": "Waiting for approval",
  "sellerPendingApprovalBody": "The marketplace admin has not approved this shop yet. You will be able to sign in once they do.",
  "sellerSuspendedTitle": "Shop suspended",
  "sellerSuspendedBody": "This shop has been suspended by the marketplace admin.",
  "accountSellOnMarketplace": "Sell on marketplace"
```

- [ ] **Step 2: Regenerate the localizations**

Run: `flutter gen-l10n`
Expected: `lib/l10n/app_localizations.dart` regenerates with the new getters and no errors. Other locales fall back to English until translated.

- [ ] **Step 3: Write the failing test**

Create `test/marketplace_seller_login_page_test.dart`:

```dart
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/pages/seller_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingSessionCubit extends Cubit<SellerSessionState>
    implements SellerSessionCubit {
  _RecordingSessionCubit() : super(const SellerSessionState());

  String? capturedEmail;
  String? capturedPassword;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    capturedEmail = email;
    capturedPassword = password;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrap(Widget child, _RecordingSessionCubit cubit) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<SellerSessionCubit>.value(value: cubit, child: child),
  );
}

void main() {
  testWidgets('empty fields block submission and show validation', (
    tester,
  ) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    await tester.tap(find.byKey(const Key('sellerLoginSubmit')));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(cubit.capturedEmail, isNull);
  });

  testWidgets('valid credentials reach the session cubit', (tester) async {
    final cubit = _RecordingSessionCubit();
    await tester.pumpWidget(_wrap(const SellerLoginPage(), cubit));

    await tester.enterText(
      find.byKey(const Key('sellerLoginEmail')),
      'seller@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('sellerLoginPassword')),
      'seller123',
    );
    await tester.tap(find.byKey(const Key('sellerLoginSubmit')));
    await tester.pumpAndSettle();

    expect(cubit.capturedEmail, 'seller@example.com');
    expect(cubit.capturedPassword, 'seller123');
  });
}
```

- [ ] **Step 4: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_login_page_test.dart`
Expected: FAIL — target file does not exist.

- [ ] **Step 5: Write the implementation**

Create `lib/marketplace/features/auth/presentation/pages/seller_login_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/session/seller_session_cubit.dart';

/// Seller sign-in. Credentials are separate from the customer account.
class SellerLoginPage extends StatefulWidget {
  const SellerLoginPage({super.key});

  @override
  State<SellerLoginPage> createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<SellerSessionCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerLoginTitle)),
      body: BlocConsumer<SellerSessionCubit, SellerSessionState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        },
        builder: (context, state) {
          final isBusy = state.status == SellerSessionStatus.loading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.sellerLoginSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('sellerLoginEmail'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l10n.sellerEmailLabel,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? l10n.sellerEmailRequired
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('sellerLoginPassword'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.sellerPasswordLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? l10n.sellerPasswordRequired
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('sellerLoginSubmit'),
                    onPressed: isBusy ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(l10n.sellerSignInAction),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 6: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_login_page_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 7: Commit**

```bash
git add lib/marketplace/features/auth/presentation \
        lib/l10n/app_en.arb lib/l10n/app_localizations*.dart \
        test/marketplace_seller_login_page_test.dart
git commit -m "feat: add seller login screen"
```

---

### Task 11: Marketplace shell and entry point

**Files:**
- Create: `lib/marketplace/shell/marketplace_shell.dart`
- Create: `lib/marketplace/shell/marketplace_entry.dart`
- Test: `test/marketplace_entry_test.dart`

**Interfaces:**
- Consumes: `SellerSessionCubit`, `SellerSessionState`, `SellerSessionStatus` (Task 9); `SellerLoginPage` (Task 10); `GraphQLClientProvider.buildSellerClient` (Task 2); `SellerAuthRepository` (Task 7); `SellerAccountRepository` (Task 8).
- Produces:
  - `MarketplaceShell` — `const MarketplaceShell({super.key})`, four tabs, reads `SellerSessionCubit` for the header.
  - `MarketplaceEntry` — `const MarketplaceEntry({super.key})`, creates the cubit, calls `bootstrap()`, and routes by status. This is the only widget the customer app pushes.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_entry_test.dart`:

```dart
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_session_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/pages/seller_login_page.dart';
import 'package:bagisto_flutter/marketplace/shell/marketplace_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubSessionCubit extends Cubit<SellerSessionState>
    implements SellerSessionCubit {
  _StubSessionCubit(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrap(Widget child, _StubSessionCubit cubit) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<SellerSessionCubit>.value(value: cubit, child: child),
  );
}

void main() {
  testWidgets('unauthenticated shows the login screen', (tester) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.unauthenticated),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.byType(SellerLoginPage), findsOneWidget);
  });

  testWidgets('active shows the shell', (tester) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(
        status: SellerSessionStatus.active,
        profile: SellerProfile(
          name: 'Ashif',
          email: 'seller@example.com',
          businessName: 'Acme Store',
          isApproved: true,
        ),
      ),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.byType(MarketplaceShell), findsOneWidget);
    expect(find.text('Acme Store'), findsOneWidget);
  });

  testWidgets('pending approval explains the wait instead of the shell', (
    tester,
  ) async {
    final cubit = _StubSessionCubit(
      const SellerSessionState(status: SellerSessionStatus.pendingApproval),
    );

    await tester.pumpWidget(_wrap(const MarketplaceGate(), cubit));
    await tester.pumpAndSettle();

    expect(find.byType(MarketplaceShell), findsNothing);
    expect(find.text('Waiting for approval'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_entry_test.dart`
Expected: FAIL — `MarketplaceGate` and `MarketplaceShell` do not exist.

- [ ] **Step 3: Write `marketplace_shell.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../core/session/seller_session_cubit.dart';

/// Bottom-tab shell for the seller panel.
///
/// Tabs beyond Dashboard are filled in by later milestones; each starts as a
/// named placeholder so navigation is testable from day one.
class MarketplaceShell extends StatefulWidget {
  const MarketplaceShell({super.key});

  @override
  State<MarketplaceShell> createState() => _MarketplaceShellState();
}

class _MarketplaceShellState extends State<MarketplaceShell> {
  int _index = 0;

  static const _tabs = <_SellerTab>[
    _SellerTab(label: 'Dashboard', icon: Icons.dashboard_outlined),
    _SellerTab(label: 'Products', icon: Icons.inventory_2_outlined),
    _SellerTab(label: 'Orders', icon: Icons.receipt_long_outlined),
    _SellerTab(label: 'More', icon: Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = context.select(
      (SellerSessionCubit cubit) => cubit.state.profile,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(profile?.displayName ?? 'Seller'),
        actions: [
          IconButton(
            tooltip: 'Back to shopping',
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          _tabs[_index].label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        indicatorColor: AppColors.primary500.withValues(alpha: 0.15),
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

class _SellerTab {
  const _SellerTab({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
```

- [ ] **Step 4: Write `marketplace_entry.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/graphql/graphql_client.dart';
import '../../l10n/app_localizations.dart';
import '../core/session/seller_session_cubit.dart';
import '../features/account/data/repository/seller_account_repository.dart';
import '../features/auth/data/repository/seller_auth_repository.dart';
import '../features/auth/presentation/pages/seller_login_page.dart';
import 'marketplace_shell.dart';

/// Everything the customer app needs to open the seller panel.
///
/// Push this route; it owns the session cubit and decides what to show.
class MarketplaceEntry extends StatelessWidget {
  const MarketplaceEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SellerSessionCubit>(
      create: (_) => SellerSessionCubit(
        authRepository: SellerAuthRepository(
          client: GraphQLClientProvider.buildSellerClient(),
        ),
        accountRepositoryBuilder: (token) => SellerAccountRepository(
          client: GraphQLClientProvider.buildSellerClient(token: token),
        ),
      )..bootstrap(),
      child: const MarketplaceGate(),
    );
  }
}

/// Renders login, shell, or a state screen from the session status.
class MarketplaceGate extends StatelessWidget {
  const MarketplaceGate({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SellerSessionCubit, SellerSessionState>(
      builder: (context, state) {
        switch (state.status) {
          case SellerSessionStatus.unknown:
          case SellerSessionStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case SellerSessionStatus.unauthenticated:
          case SellerSessionStatus.failed:
            return const SellerLoginPage();
          case SellerSessionStatus.pendingApproval:
            return _SellerNotice(
              title: l10n.sellerPendingApprovalTitle,
              body: l10n.sellerPendingApprovalBody,
              icon: Icons.hourglass_top_outlined,
            );
          case SellerSessionStatus.suspended:
            return _SellerNotice(
              title: l10n.sellerSuspendedTitle,
              body: l10n.sellerSuspendedBody,
              icon: Icons.block_outlined,
            );
          case SellerSessionStatus.active:
            return const MarketplaceShell();
        }
      },
    );
  }
}

class _SellerNotice extends StatelessWidget {
  const _SellerNotice({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(body, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () =>
                  context.read<SellerSessionCubit>().signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/marketplace_entry_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 6: Commit**

```bash
git add lib/marketplace/shell test/marketplace_entry_test.dart
git commit -m "feat: add marketplace shell and session gate"
```

---

### Task 12: "Sell on marketplace" entry in the customer account menu

**Files:**
- Modify: `lib/features/account/presentation/pages/account_menu_page.dart`
- Test: `test/marketplace_account_menu_entry_test.dart`

**Interfaces:**
- Consumes: `MarketplaceEntry` (Task 11), `l10n.accountSellOnMarketplace` (Task 10).
- Produces: a new `AccountMenuAction.sellOnMarketplace` case that pushes `MarketplaceEntry`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_account_menu_entry_test.dart`:

```dart
import 'package:bagisto_flutter/features/account/presentation/pages/account_menu_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the menu exposes a marketplace action', () {
    expect(
      AccountMenuAction.values.map((action) => action.name),
      contains('sellOnMarketplace'),
    );
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_account_menu_entry_test.dart`
Expected: FAIL — the enum has no `sellOnMarketplace` value.

- [ ] **Step 3: Add the enum value**

In `lib/features/account/presentation/pages/account_menu_page.dart`, find the `enum AccountMenuAction` declaration and add `sellOnMarketplace` as the last value.

- [ ] **Step 4: Add the menu item**

In the same file, in the settings menu column, insert immediately before the `AccountMenuItem` whose label is `l10n.accountLogout`:

```dart
          AccountMenuItem(
            label: l10n.accountSellOnMarketplace,
            trailingIcon: Icons.chevron_right,
            onTap: () =>
                _onMenuItemTap(context, AccountMenuAction.sellOnMarketplace),
          ),
          const SizedBox(height: 2),
```

- [ ] **Step 5: Handle the tap**

In `_onMenuItemTap`, add this case to the switch:

```dart
      case AccountMenuAction.sellOnMarketplace:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MarketplaceEntry()),
        );
        break;
```

Add the import at the top of the file:

```dart
import '../../../../marketplace/shell/marketplace_entry.dart';
```

- [ ] **Step 6: Run the test and the analyzer**

Run: `flutter test test/marketplace_account_menu_entry_test.dart` — expected: PASS.
Run: `flutter analyze lib/features/account/presentation/pages/account_menu_page.dart` — expected: `No issues found!`. A non-exhaustive-switch error here means the new case was not added.

- [ ] **Step 7: Commit**

```bash
git add lib/features/account/presentation/pages/account_menu_page.dart \
        test/marketplace_account_menu_entry_test.dart
git commit -m "feat: open the seller panel from the account menu"
```

---

### Task 13: Seller dashboard

**Files:**
- Create: `lib/marketplace/graphql/seller_dashboard.dart`
- Create: `lib/marketplace/features/dashboard/data/models/seller_dashboard.dart`
- Create: `lib/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart`
- Create: `lib/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart`
- Create: `lib/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart`
- Modify: `lib/marketplace/shell/marketplace_shell.dart`
- Test: `test/marketplace_seller_dashboard_test.dart`

**Interfaces:**
- Consumes: `SellerErrorMapper` (Task 4), `GraphQLClientProvider.buildSellerClient` (Task 2), `SellerSessionCubit` (Task 9).
- Produces:
  - `SellerDashboardDocuments.dashboard` (`String`).
  - `SellerDashboard` with `fromJson`, fields `dateRange`, `overAll`, `totalSales`, `recentOrders`, `stockThreshold`, `topProducts`, `topCustomers`, `topCategories` (all `Map<String, dynamic>` except `dateRange`), plus `SellerKpi kpi(String key)`.
  - `SellerKpi({required num current, required num previous, required num progress, String? formattedTotal})`.
  - `SellerDashboardRepository({required GraphQLClient client})` with `Future<SellerDashboard> load({String? start, String? end})`.
  - `SellerDashboardCubit({required SellerDashboardRepository repository})` with `Future<void> load()` and `SellerDashboardState { status, dashboard, errorMessage }`.

- [ ] **Step 1: Write the failing test**

Create `test/marketplace_seller_dashboard_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/features/dashboard/data/models/seller_dashboard.dart';
import 'package:bagisto_flutter/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Shape copied from a live `sellerDashboard` response.
const _liveDashboard = {
  'sellerDashboard': {
    'id': '/theme/api-4.9/public/api/seller/dashboard',
    'startDate': '2026-07-15T00:00:00+05:30',
    'endDate': '2026-08-14T15:39:23+05:30',
    'dateRange': '15 Jul - 14 Aug',
    'overAll': {
      'total_customers': {'previous': 2, 'current': 5, 'progress': 150},
      'total_orders': {'previous': 4, 'current': 6, 'progress': 50},
      'total_sales': {
        'previous': 100,
        'current': 250,
        'formatted_total': r'$250.00',
        'progress': 150,
      },
    },
    'totalSales': {
      'over_time': [
        {'label': '15 Jul', 'total': 0, 'count': 0},
      ],
    },
    'recentOrders': {'pending': []},
    'stockThreshold': [],
    'topProducts': [],
    'topCustomers': [],
    'topCategories': [],
  },
};

GraphQLClient _clientReturning(Map<String, dynamic> data) {
  final link = Link.function((request, [forward]) async* {
    yield Response(data: data, response: const {}, context: const Context());
  });
  return GraphQLClient(cache: GraphQLCache(store: InMemoryStore()), link: link);
}

void main() {
  test('maps the panels and the date range', () async {
    final repository =
        SellerDashboardRepository(client: _clientReturning(_liveDashboard));

    final dashboard = await repository.load();

    expect(dashboard.dateRange, '15 Jul - 14 Aug');
    expect(dashboard.overAll.containsKey('total_orders'), isTrue);
    expect(dashboard.totalSales['over_time'], isA<List<dynamic>>());
  });

  test('reads a KPI including its formatted total', () async {
    final repository =
        SellerDashboardRepository(client: _clientReturning(_liveDashboard));

    final dashboard = await repository.load();
    final sales = dashboard.kpi('total_sales');

    expect(sales.current, 250);
    expect(sales.previous, 100);
    expect(sales.progress, 150);
    expect(sales.formattedTotal, r'$250.00');
  });

  test('an unknown KPI reads as zero rather than throwing', () async {
    final repository =
        SellerDashboardRepository(client: _clientReturning(_liveDashboard));

    final dashboard = await repository.load();
    final missing = dashboard.kpi('total_refunds');

    expect(missing.current, 0);
    expect(missing.formattedTotal, isNull);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_dashboard_test.dart`
Expected: FAIL — target files do not exist.

- [ ] **Step 3: Write `seller_dashboard.dart` (documents)**

```dart
/// GraphQL document for the seller home screen.
class SellerDashboardDocuments {
  const SellerDashboardDocuments._();

  /// `id` is the fixed IRI `/api/seller/dashboard`.
  ///
  /// Keys *inside* each panel are snake_case — they are the panel's own
  /// payload, passed through by the server unchanged.
  static const String dashboard = r'''
    query SellerDashboard($id: ID!, $start: String, $end: String) {
      sellerDashboard(id: $id, start: $start, end: $end) {
        id
        startDate
        endDate
        dateRange
        overAll
        totalSales
        recentOrders
        stockThreshold
        topProducts
        topCustomers
        topCategories
      }
    }
  ''';
}
```

- [ ] **Step 4: Write the model**

Create `lib/marketplace/features/dashboard/data/models/seller_dashboard.dart`:

```dart
import 'package:equatable/equatable.dart';

/// One headline figure with its previous-period comparison.
class SellerKpi extends Equatable {
  const SellerKpi({
    required this.current,
    required this.previous,
    required this.progress,
    this.formattedTotal,
  });

  factory SellerKpi.fromJson(Map<String, dynamic> json) {
    return SellerKpi(
      current: (json['current'] as num?) ?? 0,
      previous: (json['previous'] as num?) ?? 0,
      progress: (json['progress'] as num?) ?? (json['percent'] as num?) ?? 0,
      formattedTotal: json['formatted_total']?.toString(),
    );
  }

  static const empty = SellerKpi(current: 0, previous: 0, progress: 0);

  final num current;
  final num previous;
  final num progress;
  final String? formattedTotal;

  bool get isUp => progress >= 0;

  @override
  List<Object?> get props => [current, previous, progress, formattedTotal];
}

/// The seller home screen in one object.
class SellerDashboard extends Equatable {
  const SellerDashboard({
    required this.dateRange,
    required this.overAll,
    required this.totalSales,
    required this.recentOrders,
    required this.stockThreshold,
    required this.topProducts,
    required this.topCustomers,
    required this.topCategories,
  });

  factory SellerDashboard.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> panel(String key) =>
        (json[key] as Map<String, dynamic>?) ?? const {};

    List<dynamic> list(String key) =>
        (json[key] as List<dynamic>?) ?? const <dynamic>[];

    return SellerDashboard(
      dateRange: json['dateRange']?.toString() ?? '',
      overAll: panel('overAll'),
      totalSales: panel('totalSales'),
      recentOrders: panel('recentOrders'),
      stockThreshold: list('stockThreshold'),
      topProducts: list('topProducts'),
      topCustomers: list('topCustomers'),
      topCategories: list('topCategories'),
    );
  }

  final String dateRange;
  final Map<String, dynamic> overAll;
  final Map<String, dynamic> totalSales;
  final Map<String, dynamic> recentOrders;
  final List<dynamic> stockThreshold;
  final List<dynamic> topProducts;
  final List<dynamic> topCustomers;
  final List<dynamic> topCategories;

  /// Reads a headline figure such as `total_orders` or `total_sales`.
  ///
  /// Returns [SellerKpi.empty] for a panel this marketplace does not report,
  /// so the UI never has to null-check a tile.
  SellerKpi kpi(String key) {
    final raw = overAll[key];
    if (raw is Map<String, dynamic>) return SellerKpi.fromJson(raw);
    return SellerKpi.empty;
  }

  @override
  List<Object?> get props => [
        dateRange,
        overAll,
        totalSales,
        recentOrders,
        stockThreshold,
        topProducts,
        topCustomers,
        topCategories,
      ];
}
```

- [ ] **Step 5: Write the repository**

Create `lib/marketplace/features/dashboard/data/repository/seller_dashboard_repository.dart`:

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../../../graphql/seller_dashboard.dart';
import '../models/seller_dashboard.dart';

/// Loads the seller home screen.
class SellerDashboardRepository {
  const SellerDashboardRepository({required this.client});

  final GraphQLClient client;

  /// Window defaults to the last 30 days when [start] and [end] are omitted.
  Future<SellerDashboard> load({String? start, String? end}) async {
    final result = await client.query(
      QueryOptions(
        document: gql(SellerDashboardDocuments.dashboard),
        variables: {
          'id': '/api/seller/dashboard',
          'start': start,
          'end': end,
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw SellerErrorMapper.fromResult(result);

    final payload = result.data?['sellerDashboard'] as Map<String, dynamic>?;
    if (payload == null) {
      throw const SellerApiException(
        'Dashboard unavailable',
        SellerApiFailure.notFound,
      );
    }
    return SellerDashboard.fromJson(payload);
  }
}
```

- [ ] **Step 6: Run the repository tests**

Run: `flutter test test/marketplace_seller_dashboard_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 7: Write the cubit**

Create `lib/marketplace/features/dashboard/presentation/bloc/seller_dashboard_cubit.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../data/models/seller_dashboard.dart';
import '../../data/repository/seller_dashboard_repository.dart';

enum SellerDashboardStatus { initial, loading, loaded, failed }

class SellerDashboardState extends Equatable {
  const SellerDashboardState({
    this.status = SellerDashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  final SellerDashboardStatus status;
  final SellerDashboard? dashboard;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}

class SellerDashboardCubit extends Cubit<SellerDashboardState> {
  SellerDashboardCubit({required this.repository})
      : super(const SellerDashboardState());

  final SellerDashboardRepository repository;

  Future<void> load({String? start, String? end}) async {
    emit(const SellerDashboardState(status: SellerDashboardStatus.loading));
    try {
      final dashboard = await repository.load(start: start, end: end);
      emit(
        SellerDashboardState(
          status: SellerDashboardStatus.loaded,
          dashboard: dashboard,
        ),
      );
    } on SellerApiException catch (error) {
      emit(
        SellerDashboardState(
          status: SellerDashboardStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }
}
```

- [ ] **Step 8: Write the page**

Create `lib/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/models/seller_dashboard.dart';
import '../bloc/seller_dashboard_cubit.dart';

/// Seller home: headline figures for the selected window.
class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerDashboardCubit, SellerDashboardState>(
      builder: (context, state) {
        switch (state.status) {
          case SellerDashboardStatus.initial:
          case SellerDashboardStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case SellerDashboardStatus.failed:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? 'Something went wrong'),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<SellerDashboardCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          case SellerDashboardStatus.loaded:
            final dashboard = state.dashboard!;
            final tiles = <_TileData>[
              _TileData('Orders', dashboard.kpi('total_orders')),
              _TileData('Sales', dashboard.kpi('total_sales')),
              _TileData('Customers', dashboard.kpi('total_customers')),
              _TileData('Remaining payout', dashboard.kpi('remaining_payout')),
            ];

            return RefreshIndicator(
              onRefresh: () => context.read<SellerDashboardCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    dashboard.dateRange,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      for (final tile in tiles)
                        _KpiTile(label: tile.label, kpi: tile.kpi),
                    ],
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class _TileData {
  const _TileData(this.label, this.kpi);

  final String label;
  final SellerKpi kpi;
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.label, required this.kpi});

  final String label;
  final SellerKpi kpi;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.neutral500),
          ),
          const SizedBox(height: 6),
          Text(
            kpi.formattedTotal ?? '${kpi.current}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            '${kpi.progress >= 0 ? '+' : ''}${kpi.progress}%',
            style: TextStyle(
              fontSize: 12,
              color: kpi.isUp
                  ? AppColors.successGreen
                  : AppColors.primary600,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 9: Mount the dashboard in the shell**

In `lib/marketplace/shell/marketplace_shell.dart`, replace the placeholder `body:` with a page list, and add the imports:

```dart
import '../../core/graphql/graphql_client.dart';
import '../features/dashboard/data/repository/seller_dashboard_repository.dart';
import '../features/dashboard/presentation/bloc/seller_dashboard_cubit.dart';
import '../features/dashboard/presentation/pages/seller_dashboard_page.dart';
```

Replace the `body:` expression with:

```dart
      body: IndexedStack(
        index: _index,
        children: [
          BlocProvider(
            create: (context) => SellerDashboardCubit(
              repository: SellerDashboardRepository(
                client: GraphQLClientProvider.buildSellerClient(
                  token: context.read<SellerSessionCubit>().token,
                ),
              ),
            )..load(),
            child: const SellerDashboardPage(),
          ),
          const Center(child: Text('Products')),
          const Center(child: Text('Orders')),
          const Center(child: Text('More')),
        ],
      ),
```

- [ ] **Step 10: Run the whole suite and the analyzer**

Run: `flutter test` — expected: all tests pass, including `test/marketplace_entry_test.dart`, whose "active shows the shell" case now builds the dashboard tab.
Run: `flutter analyze lib/marketplace` — expected: `No issues found!`.

- [ ] **Step 11: Commit**

```bash
git add lib/marketplace/graphql/seller_dashboard.dart \
        lib/marketplace/features/dashboard \
        lib/marketplace/shell/marketplace_shell.dart \
        test/marketplace_seller_dashboard_test.dart
git commit -m "feat: add seller dashboard"
```

---

### Task 14: Seller profile view and edit

**Files:**
- Create: `lib/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart`
- Create: `lib/marketplace/features/account/presentation/pages/seller_profile_page.dart`
- Modify: `lib/marketplace/shell/marketplace_shell.dart`
- Modify: `lib/l10n/app_en.arb`
- Test: `test/marketplace_seller_profile_cubit_test.dart`

**Interfaces:**
- Consumes: `SellerAccountRepository`, `SellerProfile` (Task 8); `SellerSessionCubit` (Task 9).
- Produces:
  - `SellerProfileCubit({required SellerAccountRepository repository})` with `Future<void> load()`, `Future<void> save(Map<String, dynamic> input)`, and `SellerProfileState { status, profile, errorMessage, savedAt }` where `status` is `SellerProfileStatus { initial, loading, loaded, saving, failed }`.
  - `SellerProfilePage` — `const SellerProfilePage({super.key})`.

- [ ] **Step 1: Add the strings**

In `lib/l10n/app_en.arb` add:

```json
  "sellerProfileTitle": "Shop profile",
  "sellerBusinessNameLabel": "Business name",
  "sellerBusinessDescriptionLabel": "About the shop",
  "sellerPhoneLabel": "Phone",
  "sellerSaveAction": "Save changes",
  "sellerProfileSaved": "Profile updated"
```

Run: `flutter gen-l10n` — expected: no errors.

- [ ] **Step 2: Write the failing test**

Create `test/marketplace_seller_profile_cubit_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/core/session/seller_permissions.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:bagisto_flutter/marketplace/features/account/data/repository/seller_account_repository.dart';
import 'package:bagisto_flutter/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAccountRepository implements SellerAccountRepository {
  _FakeAccountRepository({required this.stored, this.failWith});

  SellerProfile stored;
  final SellerApiException? failWith;
  Map<String, dynamic>? lastInput;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerProfile> profile() async => stored;

  @override
  Future<List<SellerAclPermission>> aclPermissions() async => const [];

  @override
  Future<SellerPermissions> permissions() async => SellerPermissions.none();

  @override
  Future<SellerProfile> updateProfile(Map<String, dynamic> input) async {
    if (failWith != null) throw failWith!;
    lastInput = input;
    stored = stored.copyWith(
      businessName: input['businessName'] as String?,
      phone: input['phone'] as String?,
    );
    return stored;
  }
}

const _profile = SellerProfile(
  name: 'Ashif',
  email: 'seller@example.com',
  businessName: 'Acme Store',
  phone: '111',
  isApproved: true,
);

void main() {
  test('load reads the profile', () async {
    final cubit = SellerProfileCubit(
      repository: _FakeAccountRepository(stored: _profile),
    );

    await cubit.load();

    expect(cubit.state.status, SellerProfileStatus.loaded);
    expect(cubit.state.profile?.businessName, 'Acme Store');
  });

  test('save sends only the changed fields and keeps the result', () async {
    final repository = _FakeAccountRepository(stored: _profile);
    final cubit = SellerProfileCubit(repository: repository);
    await cubit.load();

    await cubit.save({'businessName': 'Acme Store v2'});

    expect(repository.lastInput, {'businessName': 'Acme Store v2'});
    expect(cubit.state.profile?.businessName, 'Acme Store v2');
    expect(cubit.state.status, SellerProfileStatus.loaded);
    expect(cubit.state.savedAt, isNotNull);
  });

  test('a rejected save surfaces the server message', () async {
    final cubit = SellerProfileCubit(
      repository: _FakeAccountRepository(
        stored: _profile,
        failWith: const SellerApiException(
          'The slug has already been taken.',
          SellerApiFailure.validation,
        ),
      ),
    );
    await cubit.load();

    await cubit.save({'slug': 'taken-slug'});

    expect(cubit.state.status, SellerProfileStatus.failed);
    expect(cubit.state.errorMessage, 'The slug has already been taken.');
  });
}
```

- [ ] **Step 3: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_profile_cubit_test.dart`
Expected: FAIL — `SellerProfileCubit` does not exist.

- [ ] **Step 4: Write the cubit**

Create `lib/marketplace/features/account/presentation/bloc/seller_profile_cubit.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../data/models/seller_profile.dart';
import '../../data/repository/seller_account_repository.dart';

enum SellerProfileStatus { initial, loading, loaded, saving, failed }

class SellerProfileState extends Equatable {
  const SellerProfileState({
    this.status = SellerProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.savedAt,
  });

  final SellerProfileStatus status;
  final SellerProfile? profile;
  final String? errorMessage;

  /// Bumped on every successful save so the UI can show a confirmation once.
  final DateTime? savedAt;

  SellerProfileState copyWith({
    SellerProfileStatus? status,
    SellerProfile? profile,
    String? errorMessage,
    DateTime? savedAt,
  }) {
    return SellerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, savedAt];
}

/// Reads and partially updates the seller's shop profile.
class SellerProfileCubit extends Cubit<SellerProfileState> {
  SellerProfileCubit({required this.repository})
      : super(const SellerProfileState());

  final SellerAccountRepository repository;

  Future<void> load() async {
    emit(state.copyWith(status: SellerProfileStatus.loading));
    try {
      final profile = await repository.profile();
      emit(
        state.copyWith(status: SellerProfileStatus.loaded, profile: profile),
      );
    } on SellerApiException catch (error) {
      emit(
        state.copyWith(
          status: SellerProfileStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }

  /// [input] carries only the fields the seller changed; the API is partial.
  Future<void> save(Map<String, dynamic> input) async {
    emit(state.copyWith(status: SellerProfileStatus.saving));
    try {
      final profile = await repository.updateProfile(input);
      emit(
        SellerProfileState(
          status: SellerProfileStatus.loaded,
          profile: profile,
          savedAt: DateTime.now(),
        ),
      );
    } on SellerApiException catch (error) {
      emit(
        state.copyWith(
          status: SellerProfileStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_profile_cubit_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 6: Write the page**

Create `lib/marketplace/features/account/presentation/pages/seller_profile_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../bloc/seller_profile_cubit.dart';

/// Shop profile: read the current values, edit the ones the seller changes.
class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Only send what changed — `updateSellerProfile` is a partial update.
  Map<String, dynamic> _changedFields(SellerProfileState state) {
    final profile = state.profile;
    final changes = <String, dynamic>{};

    if (_businessNameController.text != (profile?.businessName ?? '')) {
      changes['businessName'] = _businessNameController.text;
    }
    if (_descriptionController.text != (profile?.businessDescription ?? '')) {
      changes['businessDescription'] = _descriptionController.text;
    }
    if (_phoneController.text != (profile?.phone ?? '')) {
      changes['phone'] = _phoneController.text;
    }
    return changes;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SellerProfileCubit, SellerProfileState>(
      listener: (context, state) {
        if (state.status == SellerProfileStatus.loaded && !_seeded) {
          _businessNameController.text = state.profile?.businessName ?? '';
          _descriptionController.text =
              state.profile?.businessDescription ?? '';
          _phoneController.text = state.profile?.phone ?? '';
          _seeded = true;
        }
        if (state.status == SellerProfileStatus.failed &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        if (state.status == SellerProfileStatus.initial ||
            (state.status == SellerProfileStatus.loading &&
                state.profile == null)) {
          return const Center(child: CircularProgressIndicator());
        }

        final isSaving = state.status == SellerProfileStatus.saving;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.sellerProfileTitle)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                key: const Key('sellerProfileBusinessName'),
                controller: _businessNameController,
                decoration: InputDecoration(
                  labelText: l10n.sellerBusinessNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.sellerBusinessDescriptionLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.sellerPhoneLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('sellerProfileSave'),
                onPressed: isSaving
                    ? null
                    : () {
                        final changes = _changedFields(state);
                        if (changes.isEmpty) return;
                        context.read<SellerProfileCubit>().save(changes);
                      },
                child: Text(l10n.sellerSaveAction),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 7: Reach the profile from the shell**

In `lib/marketplace/shell/marketplace_shell.dart`, replace the `More` tab placeholder `const Center(child: Text('More'))` with a menu that opens the profile:

```dart
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('Shop profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final token = context.read<SellerSessionCubit>().token;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => SellerProfileCubit(
                          repository: SellerAccountRepository(
                            client: GraphQLClientProvider.buildSellerClient(
                              token: token,
                            ),
                          ),
                        )..load(),
                        child: const SellerProfilePage(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () => context.read<SellerSessionCubit>().signOut(),
              ),
            ],
          ),
```

Add the imports:

```dart
import '../features/account/data/repository/seller_account_repository.dart';
import '../features/account/presentation/bloc/seller_profile_cubit.dart';
import '../features/account/presentation/pages/seller_profile_page.dart';
```

- [ ] **Step 8: Run the suite and the analyzer**

Run: `flutter test` — expected: all pass.
Run: `flutter analyze lib/marketplace` — expected: `No issues found!`.

- [ ] **Step 9: Commit**

```bash
git add lib/marketplace/features/account/presentation \
        lib/marketplace/shell/marketplace_shell.dart \
        lib/l10n/app_en.arb lib/l10n/app_localizations*.dart \
        test/marketplace_seller_profile_cubit_test.dart
git commit -m "feat: add seller shop profile view and edit"
```

---

### Task 15: Demo data seeding script

The seller account starts with almost nothing, so every screen looks broken in a demo. This seeds the backend through the real API — the app still reads everything dynamically.

**Files:**
- Create: `tool/marketplace_seed/seed.sh`
- Create: `tool/marketplace_seed/README.md`

**Interfaces:**
- Consumes: nothing in the app. Talks to `ApiEnv.base` over HTTP.
- Produces: a seller account with an inventory source and eight products across the common types.

- [ ] **Step 1: Write the script**

Create `tool/marketplace_seed/seed.sh`:

```bash
#!/usr/bin/env bash
# Seeds demo data into the marketplace through the seller GraphQL API.
#
# Usage:
#   BASE=http://192.168.15.239/theme/api-4.9/public \
#   EMAIL=ashifwebkul@gmail.com PASSWORD=seller123 \
#   ./tool/marketplace_seed/seed.sh
#
# Idempotency: SKUs are suffixed with the run stamp passed in RUN_ID, so a
# second run adds a second batch rather than failing on duplicate SKUs.
set -euo pipefail

BASE="${BASE:-http://192.168.15.239/theme/api-4.9/public}"
EMAIL="${EMAIL:-ashifwebkul@gmail.com}"
PASSWORD="${PASSWORD:-seller123}"
RUN_ID="${RUN_ID:-$(date +%s)}"
ENDPOINT="$BASE/api/seller/graphql"

gql() {
  # $1 = query, $2 = variables JSON
  curl -sS -X POST "$ENDPOINT" \
    -H 'Content-Type: application/json' \
    ${TOKEN:+-H "Authorization: Bearer $TOKEN"} \
    -d "$(jq -n --arg q "$1" --argjson v "$2" '{query:$q, variables:$v}')"
}

echo "==> Signing in as $EMAIL"
TOKEN=""
LOGIN=$(gql 'mutation($i: createSellerLoginInput!){ createSellerLogin(input:$i){ sellerLogin { token success message } } }' \
  "$(jq -n --arg e "$EMAIL" --arg p "$PASSWORD" '{i:{email:$e,password:$p}}')")
TOKEN=$(echo "$LOGIN" | jq -r '.data.createSellerLogin.sellerLogin.token // empty')
if [ -z "$TOKEN" ]; then
  echo "Login failed: $LOGIN" >&2
  exit 1
fi
echo "    token acquired"

echo "==> Ensuring an inventory source"
SOURCE_ID=$(gql 'query { sellerInventorySources(page:1){ collection { _id code } } }' '{}' \
  | jq -r '.data.sellerInventorySources.collection[0]._id // empty')

if [ -z "$SOURCE_ID" ]; then
  SOURCE=$(gql 'mutation($i: createSellerInventorySourceInput!){ createSellerInventorySource(input:$i){ sellerInventorySource { _id code name } } }' \
    "$(jq -n --arg c "warehouse_$RUN_ID" '{i:{
        code:$c, name:"Demo Warehouse", description:"Seeded by seed.sh",
        contactName:"Demo Contact", contactEmail:"warehouse@example.com",
        contactNumber:"9876543210", contactFax:"0112345678",
        street:"Plot 42, Sector 63", country:"IN", state:"UP",
        city:"Noida", postcode:"201301", priority:1,
        latitude:28.6139, longitude:77.209, status:true }}')")
  SOURCE_ID=$(echo "$SOURCE" | jq -r '.data.createSellerInventorySource.sellerInventorySource._id // empty')
fi
echo "    inventory source: $SOURCE_ID"

echo "==> Reading assignable categories"
CATEGORY_IDS=$(gql 'query { sellerProductCategories { _id name level } }' '{}' \
  | jq -c '[.data.sellerProductCategories[]? | select(.level > 0) | ._id] | .[0:2]')
echo "    categories: $CATEGORY_IDS"

create_simple_product() {
  local sku="$1" name="$2" price="$3" qty="$4" image="$5"

  local created
  created=$(gql 'mutation($i: createSellerProductInput!){ createSellerProduct(input:$i){ sellerProduct { id productId sku } } }' \
    "$(jq -n --arg s "$sku" '{i:{type:"simple", attributeFamilyId:1, sku:$s, isDraft:false}}')")

  local iri
  iri=$(echo "$created" | jq -r '.data.createSellerProduct.sellerProduct.id // empty')
  if [ -z "$iri" ]; then
    echo "    skipped $sku: $(echo "$created" | jq -r '.errors[0].message // "unknown error"')"
    return
  fi

  gql 'mutation($i: updateSellerProductInput!){ updateSellerProduct(input:$i){ sellerProduct { sku name price } } }' \
    "$(jq -n --arg id "$iri" --arg s "$sku" --arg n "$name" --arg img "$image" \
             --argjson p "$price" --argjson q "$qty" --argjson src "$SOURCE_ID" \
             --argjson cats "$CATEGORY_IDS" '{i:{
        id:$id, sku:$s, name:$n, urlKey:$s,
        shortDescription:("<p>" + $n + "</p>"),
        description:("<p>" + $n + " — seeded demo product.</p>"),
        metaTitle:$n, price:$p, weight:1,
        status:1, visibleIndividually:1, new:1, featured:1, guestCheckout:1,
        categories:$cats,
        inventories:[{inventorySourceId:$src, qty:$q}],
        images:[$img],
        isDraft:false }}')" > /dev/null

  echo "    created $sku"
}

echo "==> Creating products"
create_simple_product "demo-tee-$RUN_ID"      "Classic Cotton Tee"   19.99  120 "https://cdn.pixabay.com/photo/2017/05/23/10/53/t-shirt-design-2336850_960_720.jpg"
create_simple_product "demo-mug-$RUN_ID"      "Stoneware Mug"         12.50   80 "https://cdn.pixabay.com/photo/2016/11/29/12/54/cup-1869820_960_720.jpg"
create_simple_product "demo-backpack-$RUN_ID" "Everyday Backpack"     59.00   40 "https://cdn.pixabay.com/photo/2016/11/19/13/06/bag-1839640_960_720.jpg"
create_simple_product "demo-watch-$RUN_ID"    "Minimal Wrist Watch"   89.90   25 "https://cdn.pixabay.com/photo/2015/09/05/07/28/watch-923673_960_720.jpg"
create_simple_product "demo-sneaker-$RUN_ID"  "Runner Sneakers"       74.00   60 "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_960_720.jpg"
create_simple_product "demo-lamp-$RUN_ID"     "Desk Lamp"             34.25   45 "https://cdn.pixabay.com/photo/2016/11/18/17/20/lamp-1835337_960_720.jpg"

echo "==> Result"
gql 'query { sellerProducts(page:1){ paginationInfo { totalCount } } }' '{}' \
  | jq -r '"    products now: " + (.data.sellerProducts.paginationInfo.totalCount|tostring)'
```

- [ ] **Step 2: Write the README**

Create `tool/marketplace_seed/README.md`:

```markdown
# Marketplace demo seeding

`seed.sh` fills a seller account with demo data by calling the live seller
GraphQL API — the same endpoints the app uses. Nothing is hardcoded in the
app; the app reads whatever the backend holds.

## Requirements

`curl` and `jq`.

## Run

```bash
BASE=http://192.168.15.239/theme/api-4.9/public \
EMAIL=ashifwebkul@gmail.com PASSWORD=seller123 \
./tool/marketplace_seed/seed.sh
```

## What it creates

- an inventory source, if the seller has none
- six simple products with images, prices, stock and categories

## Notes

- SKUs carry a run stamp, so a repeat run adds a second batch instead of
  failing on duplicates.
- Orders are not seeded here: an order needs a customer checkout, which runs
  through the storefront API. Place one from the customer side of the app to
  populate the dashboard's order figures.
```

- [ ] **Step 3: Make it executable and run it**

Run:
```bash
chmod +x tool/marketplace_seed/seed.sh
./tool/marketplace_seed/seed.sh
```
Expected: `token acquired`, an inventory source id, one `created …` line per product, and a final `products now: N` where N grew by six.

- [ ] **Step 4: Verify through the API the app will use**

Run:
```bash
curl -s -X POST 'http://192.168.15.239/theme/api-4.9/public/api/seller/graphql' \
  -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" \
  -d '{"query":"{ sellerProducts(page:1){ collection { sku name price quantity } paginationInfo { totalCount } } }"}'
```
Expected: the seeded SKUs with their prices and quantities.

- [ ] **Step 5: Commit**

```bash
git add tool/marketplace_seed
git commit -m "chore: add marketplace demo data seeding script"
```

---

### Task 16: Documentation and graph refresh

**Files:**
- Modify: `AGENTS.md`
- Modify: `plan.md`

- [ ] **Step 1: Add the marketplace rules to `AGENTS.md`**

Insert this section immediately before the `## AI Workflow` heading:

```markdown
## Marketplace Rules

The marketplace (seller panel + buyer-facing marketplace) lives in `lib/marketplace/**`.

1. `ApiEnv` in `lib/core/constants/api_constants.dart` owns the base URL, the shop endpoint, the seller endpoint and the storefront key. Nothing else hardcodes a URL.
2. The host runs two independent installs. `theme/api-4.9` is the one this app targets; `theme/apis_v2.4.9` has its own database, key and sellers. A rejected key or credential usually means the wrong base path.
3. Seller traffic goes through `GraphQLClientProvider.buildSellerClient` and never carries `X-STOREFRONT-KEY`.
4. Seller session keys are prefixed `seller_` and are independent of the customer's `auth_token`. Both sessions may be active at once.
5. Server-issued IRIs are stored and echoed verbatim. They include the install path, so they are never rebuilt from an integer.
6. On a product, `id` is the seller catalogue id used in URLs and IRIs; `productId` is the core catalog id used inside bodies. They are not interchangeable.
7. Product and profile updates are partial, but any nested list you send replaces that whole set, and marketing rules replace wholesale.
8. Gate seller UI on `SellerPermissions.can(key)` before rendering an action, not only when handling its error.
9. Endpoint behaviour is documented in `aidocs/engineering/16-marketplace-seller-api-reference.md` and `17-marketplace-shop-api-reference.md`. Request shapes come from `MarketplaceApi.graphql.postman_collection.json`.
10. Demo data is seeded through the live API with `tool/marketplace_seed/seed.sh`. Never hardcode sample data in the app.
```

- [ ] **Step 2: Note the marketplace in `plan.md`**

Add a bullet under the architecture summary recording that `lib/marketplace/**` holds the seller panel and buyer-side marketplace, with its own session and GraphQL endpoint.

- [ ] **Step 3: Refresh the knowledge graph**

Run: `graphify update .`
Expected: `graphify-out/GRAPH_REPORT.md` regenerates and now includes the `lib/marketplace` nodes.

- [ ] **Step 4: Full verification**

Run: `flutter analyze` — expected: no new issues.
Run: `flutter test` — expected: the whole suite passes.

- [ ] **Step 5: Manual end-to-end check**

Run the app, open Account → **Sell on marketplace**, sign in with the seeded seller, and confirm: the dashboard renders live figures, More → Shop profile loads and saves, and Sign out returns to the login screen.

- [ ] **Step 6: Commit**

```bash
git add AGENTS.md plan.md graphify-out
git commit -m "docs: record marketplace rules and refresh the code graph"
```

---

### Task 17: Seller registration and forgot password

Closes the rest of the seller session surface. The registration form is built from `sellerAttributes`, because the admin can add required fields that no hardcoded form would know about.

**Files:**
- Create: `lib/marketplace/features/auth/presentation/bloc/seller_register_cubit.dart`
- Create: `lib/marketplace/features/auth/presentation/pages/seller_register_page.dart`
- Create: `lib/marketplace/features/auth/presentation/pages/seller_forgot_password_page.dart`
- Modify: `lib/marketplace/features/auth/presentation/pages/seller_login_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Test: `test/marketplace_seller_register_cubit_test.dart`

**Interfaces:**
- Consumes: `SellerAuthRepository`, `SellerAttribute` (Task 7); `SellerApiException` (Task 4).
- Produces:
  - `SellerRegisterCubit({required SellerAuthRepository repository})` with `Future<void> loadAttributes()`, `Future<void> submit({required String name, required String email, required String slug, required String password, required String passwordConfirmation, String? phone, Map<String, String> customValues = const {}})`, and `SellerRegisterState { status, attributes, message, errorMessage }` where `status` is `SellerRegisterStatus { initial, loading, ready, submitting, submitted, failed }`.
  - `SellerRegisterPage` — `const SellerRegisterPage({super.key})`.
  - `SellerForgotPasswordPage` — `const SellerForgotPasswordPage({super.key})`.

- [ ] **Step 1: Add the strings**

In `lib/l10n/app_en.arb` add:

```json
  "sellerRegisterTitle": "Become a seller",
  "sellerRegisterAction": "Create shop",
  "sellerNameLabel": "Your name",
  "sellerShopUrlLabel": "Shop URL",
  "sellerConfirmPasswordLabel": "Confirm password",
  "sellerPasswordMismatch": "Passwords do not match",
  "sellerFieldRequired": "This field is required",
  "sellerForgotPasswordTitle": "Reset password",
  "sellerForgotPasswordAction": "Send reset link",
  "sellerForgotPasswordSent": "If that email has a shop, a reset link is on its way.",
  "sellerNoAccountPrompt": "New seller? Create a shop",
  "sellerForgotPasswordPrompt": "Forgot password?"
```

Run: `flutter gen-l10n` — expected: no errors.

- [ ] **Step 2: Write the failing test**

Create `test/marketplace_seller_register_cubit_test.dart`:

```dart
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/models/seller_auth_models.dart';
import 'package:bagisto_flutter/marketplace/features/auth/data/repository/seller_auth_repository.dart';
import 'package:bagisto_flutter/marketplace/features/auth/presentation/bloc/seller_register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeAuthRepository implements SellerAuthRepository {
  _FakeAuthRepository({this.attributes = const [], this.failWith});

  final List<SellerAttribute> attributes;
  final SellerApiException? failWith;
  Map<String, String>? capturedAttributes;
  String? capturedSlug;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerAttribute>> signUpAttributes() async => attributes;

  @override
  Future<String> register({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> attributes = const {},
  }) async {
    if (failWith != null) throw failWith!;
    capturedSlug = slug;
    capturedAttributes = attributes;
    return 'Your shop is awaiting admin approval.';
  }

  @override
  Future<SellerLoginResult> login({
    required String email,
    required String password,
  }) async =>
      const SellerLoginResult(success: true, token: 'x');

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> logout() async {}
}

const _customAttribute = SellerAttribute(
  code: 'vatNumber',
  name: 'VAT Number',
  type: 'text',
  isRequired: true,
);

void main() {
  test('loads the sign-up attributes the admin configured', () async {
    final cubit = SellerRegisterCubit(
      repository: _FakeAuthRepository(
        attributes: const [
          SellerAttribute(
            code: 'name',
            name: 'Name',
            type: 'text',
            isRequired: true,
          ),
          _customAttribute,
        ],
      ),
    );

    await cubit.loadAttributes();

    expect(cubit.state.status, SellerRegisterStatus.ready);
    // Fixed fields have their own form controls, so only custom ones are
    // rendered dynamically.
    expect(cubit.state.customAttributes.single.code, 'vatNumber');
  });

  test('submits custom attributes as code/value pairs', () async {
    final repository = _FakeAuthRepository(attributes: const [_customAttribute]);
    final cubit = SellerRegisterCubit(repository: repository);
    await cubit.loadAttributes();

    await cubit.submit(
      name: 'Demo Seller',
      email: 'demo@example.com',
      slug: 'demo-shop',
      password: 'secret123',
      passwordConfirmation: 'secret123',
      customValues: const {'vatNumber': '123456789'},
    );

    expect(cubit.state.status, SellerRegisterStatus.submitted);
    expect(cubit.state.message, 'Your shop is awaiting admin approval.');
    expect(repository.capturedSlug, 'demo-shop');
    expect(repository.capturedAttributes, {'vatNumber': '123456789'});
  });

  test('a rejected registration surfaces the server message', () async {
    final cubit = SellerRegisterCubit(
      repository: _FakeAuthRepository(
        failWith: const SellerApiException(
          'The email has already been taken.',
          SellerApiFailure.validation,
        ),
      ),
    );

    await cubit.submit(
      name: 'Demo Seller',
      email: 'taken@example.com',
      slug: 'demo-shop',
      password: 'secret123',
      passwordConfirmation: 'secret123',
    );

    expect(cubit.state.status, SellerRegisterStatus.failed);
    expect(cubit.state.errorMessage, 'The email has already been taken.');
  });
}
```

- [ ] **Step 3: Run the test to verify it fails**

Run: `flutter test test/marketplace_seller_register_cubit_test.dart`
Expected: FAIL — `SellerRegisterCubit` does not exist.

- [ ] **Step 4: Write the cubit**

Create `lib/marketplace/features/auth/presentation/bloc/seller_register_cubit.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/seller_error_mapper.dart';
import '../../data/models/seller_auth_models.dart';
import '../../data/repository/seller_auth_repository.dart';

enum SellerRegisterStatus {
  initial,
  loading,
  ready,
  submitting,
  submitted,
  failed,
}

class SellerRegisterState extends Equatable {
  const SellerRegisterState({
    this.status = SellerRegisterStatus.initial,
    this.attributes = const [],
    this.message,
    this.errorMessage,
  });

  final SellerRegisterStatus status;
  final List<SellerAttribute> attributes;
  final String? message;
  final String? errorMessage;

  /// Admin-defined fields the form must render itself. The fixed ones (name,
  /// email, slug, password, phone) already have dedicated controls.
  List<SellerAttribute> get customAttributes =>
      attributes.where((attribute) => !attribute.isFixedField).toList();

  SellerRegisterState copyWith({
    SellerRegisterStatus? status,
    List<SellerAttribute>? attributes,
    String? message,
    String? errorMessage,
  }) {
    return SellerRegisterState(
      status: status ?? this.status,
      attributes: attributes ?? this.attributes,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, attributes, message, errorMessage];
}

/// Drives seller sign-up, including the attributes the admin added.
class SellerRegisterCubit extends Cubit<SellerRegisterState> {
  SellerRegisterCubit({required this.repository})
      : super(const SellerRegisterState());

  final SellerAuthRepository repository;

  Future<void> loadAttributes() async {
    emit(state.copyWith(status: SellerRegisterStatus.loading));
    try {
      final attributes = await repository.signUpAttributes();
      emit(
        state.copyWith(
          status: SellerRegisterStatus.ready,
          attributes: attributes,
        ),
      );
    } on SellerApiException catch (error) {
      emit(
        state.copyWith(
          status: SellerRegisterStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }

  Future<void> submit({
    required String name,
    required String email,
    required String slug,
    required String password,
    required String passwordConfirmation,
    String? phone,
    Map<String, String> customValues = const {},
  }) async {
    emit(state.copyWith(status: SellerRegisterStatus.submitting));
    try {
      final message = await repository.register(
        name: name,
        email: email,
        slug: slug,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        attributes: customValues,
      );
      emit(
        state.copyWith(
          status: SellerRegisterStatus.submitted,
          message: message,
        ),
      );
    } on SellerApiException catch (error) {
      emit(
        state.copyWith(
          status: SellerRegisterStatus.failed,
          errorMessage: error.message,
        ),
      );
    }
  }
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/marketplace_seller_register_cubit_test.dart`
Expected: PASS, 3 tests.

- [ ] **Step 6: Write the registration page**

Create `lib/marketplace/features/auth/presentation/pages/seller_register_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../bloc/seller_register_cubit.dart';

/// Seller sign-up. Fixed fields are fixed; everything else comes from
/// `sellerAttributes`, so admin-added requirements render without a code change.
class SellerRegisterPage extends StatefulWidget {
  const SellerRegisterPage({super.key});

  @override
  State<SellerRegisterPage> createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _slug = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _custom = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _slug,
      _phone,
      _password,
      _confirmPassword,
      ..._custom.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String code) =>
      _custom.putIfAbsent(code, TextEditingController.new);

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<SellerRegisterCubit>().submit(
          name: _name.text.trim(),
          email: _email.text.trim(),
          slug: _slug.text.trim(),
          password: _password.text,
          passwordConfirmation: _confirmPassword.text,
          phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          customValues: {
            for (final entry in _custom.entries)
              if (entry.value.text.trim().isNotEmpty)
                entry.key: entry.value.text.trim(),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerRegisterTitle)),
      body: BlocConsumer<SellerRegisterCubit, SellerRegisterState>(
        listener: (context, state) {
          if (state.status == SellerRegisterStatus.submitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? '')),
            );
            Navigator.of(context).pop();
          }
          if (state.status == SellerRegisterStatus.failed &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SellerRegisterStatus.initial ||
              state.status == SellerRegisterStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isBusy = state.status == SellerRegisterStatus.submitting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(_name, l10n.sellerNameLabel, required: true,
                      requiredMessage: l10n.sellerFieldRequired),
                  _field(_email, l10n.sellerEmailLabel, required: true,
                      requiredMessage: l10n.sellerFieldRequired,
                      keyboardType: TextInputType.emailAddress),
                  _field(_slug, l10n.sellerShopUrlLabel, required: true,
                      requiredMessage: l10n.sellerFieldRequired),
                  _field(_phone, l10n.sellerPhoneLabel,
                      keyboardType: TextInputType.phone),
                  for (final attribute in state.customAttributes)
                    _field(
                      _controllerFor(attribute.code),
                      attribute.name,
                      required: attribute.isRequired,
                      requiredMessage: l10n.sellerFieldRequired,
                    ),
                  _field(_password, l10n.sellerPasswordLabel,
                      required: true,
                      requiredMessage: l10n.sellerFieldRequired,
                      obscure: true),
                  _field(
                    _confirmPassword,
                    l10n.sellerConfirmPasswordLabel,
                    required: true,
                    requiredMessage: l10n.sellerFieldRequired,
                    obscure: true,
                    extraValidator: (value) => value == _password.text
                        ? null
                        : l10n.sellerPasswordMismatch,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    key: const Key('sellerRegisterSubmit'),
                    onPressed: isBusy ? null : _submit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.sellerRegisterAction),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = false,
    String requiredMessage = '',
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String value)? extraValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (required && text.isEmpty) return requiredMessage;
          if (extraValidator != null) return extraValidator(value ?? '');
          return null;
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Write the forgot-password page**

Create `lib/marketplace/features/auth/presentation/pages/seller_forgot_password_page.dart`:

```dart
import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/api/seller_error_mapper.dart';
import '../../data/repository/seller_auth_repository.dart';

/// Requests a reset link. The server answers the same way for known and
/// unknown emails, so the screen never reveals whether a shop exists.
class SellerForgotPasswordPage extends StatefulWidget {
  const SellerForgotPasswordPage({super.key, required this.repository});

  final SellerAuthRepository repository;

  @override
  State<SellerForgotPasswordPage> createState() =>
      _SellerForgotPasswordPageState();
}

class _SellerForgotPasswordPageState extends State<SellerForgotPasswordPage> {
  final _email = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send(AppLocalizations l10n) async {
    setState(() => _sending = true);
    String message = l10n.sellerForgotPasswordSent;
    try {
      await widget.repository.forgotPassword(_email.text.trim());
    } on SellerApiException catch (error) {
      message = error.message;
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerForgotPasswordTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.sellerEmailLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _sending ? null : () => _send(l10n),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l10n.sellerForgotPasswordAction),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 8: Link both from the login screen**

In `seller_login_page.dart`, add these imports:

```dart
import '../../../../../core/graphql/graphql_client.dart';
import '../../data/repository/seller_auth_repository.dart';
import '../bloc/seller_register_cubit.dart';
import 'seller_forgot_password_page.dart';
import 'seller_register_page.dart';
```

Then add these two buttons directly after the sign-in `FilledButton` in the form column:

```dart
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SellerForgotPasswordPage(
                          repository: SellerAuthRepository(
                            client: GraphQLClientProvider.buildSellerClient(),
                          ),
                        ),
                      ),
                    ),
                    child: Text(l10n.sellerForgotPasswordPrompt),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => SellerRegisterCubit(
                            repository: SellerAuthRepository(
                              client: GraphQLClientProvider.buildSellerClient(),
                            ),
                          )..loadAttributes(),
                          child: const SellerRegisterPage(),
                        ),
                      ),
                    ),
                    child: Text(l10n.sellerNoAccountPrompt),
                  ),
```

- [ ] **Step 9: Run the suite and the analyzer**

Run: `flutter test` — expected: all pass, including the Task 10 login test, which still finds its three keyed widgets.
Run: `flutter analyze lib/marketplace` — expected: `No issues found!`.

- [ ] **Step 10: Verify registration against the live server**

Run:
```bash
curl -s -X POST 'http://192.168.15.239/theme/api-4.9/public/api/seller/graphql' \
  -H 'Content-Type: application/json' \
  -d '{"query":"query { sellerAttributes { code name type isRequired } }"}'
```
Expected: the attribute list the form renders. Any attribute whose `code` is outside `SellerAttribute.fixedCodes` must appear as a dynamic field on the registration screen.

- [ ] **Step 11: Commit**

```bash
git add lib/marketplace/features/auth/presentation \
        lib/l10n/app_en.arb lib/l10n/app_localizations*.dart \
        test/marketplace_seller_register_cubit_test.dart
git commit -m "feat: add seller registration and password reset"
```

---

## Roadmap — later plans

Each milestone from the spec gets its own plan file, written when its milestone starts so it reflects the code that exists by then:

Task 15 (seeding) and Task 16 (docs) run last in this plan. Later milestones each get their own plan file, written when that milestone starts so it matches the code that exists by then.

| Plan | Milestone | Covers |
|---|---|---|
| `2026-XX-XX-marketplace-products-read.md` | M3 | product list, filters, detail |
| `2026-XX-XX-marketplace-products-write.md` | M4 | create and edit all seven product types, categories, inventory sources |
| `2026-XX-XX-marketplace-assign-barcode-ai.md` | M5 | assign products, barcode, Magic AI |
| `2026-XX-XX-marketplace-orders.md` | M6 | orders, invoice, shipment, cancel, payment request, carriers |
| `2026-XX-XX-marketplace-rma-bookings.md` | M7 | RMA, bookings, customers, reviews |
| `2026-XX-XX-marketplace-money.md` | M8 | earnings, reporting, performance, plans |
| `2026-XX-XX-marketplace-growth.md` | M9 | marketing, bulk pricing and inventory, bulk upload |
| `2026-XX-XX-marketplace-settings-and-buyer.md` | M10 | settings, users, roles, buyer-side marketplace surfaces |
