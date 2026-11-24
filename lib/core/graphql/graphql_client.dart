import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../currency/currency_cubit.dart';
import '../constants/api_constants.dart';
import '../../features/auth/domain/services/auth_storage.dart';
import '../locale/locale_cubit.dart';

/// Custom HTTP client wrapper with timeout support
class TimeoutHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  TimeoutHttpClient({Duration? connectTimeout, Duration? receiveTimeout})
    : _inner = http.Client(),
      connectTimeout = connectTimeout ?? const Duration(seconds: 120),
      receiveTimeout = receiveTimeout ?? const Duration(seconds: 120);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final completer = Completer<http.StreamedResponse>();
    final timer = Timer(connectTimeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('Request timed out after $connectTimeout'),
        );
      }
    });

    try {
      final response = await _inner.send(request).timeout(receiveTimeout);
      timer.cancel();
      completer.complete(response);
    } catch (e) {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  LoggingHttpClient({required http.Client inner}) : _inner = inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await _attachDynamicHeaders(request);
    final stopwatch = Stopwatch()..start();
    final requestBody = _extractRequestBody(request);
    final requestJson = _tryParseJson(requestBody);
    final operationName = requestJson is Map<String, dynamic>
        ? requestJson['operationName']?.toString()
        : null;
    final isPaymentOperation =
        operationName?.toLowerCase().contains('payment') ?? false;
    final variables = requestJson is Map<String, dynamic>
        ? requestJson['variables']
        : null;

    _logApiMessage('═══════════════════════════════════════════');
    _logApiMessage('🌐 [API Request]');
    _logApiMessage('📝 API Name: ${operationName ?? 'unnamed'}');
    _logApiMessage('🔗 URL: ${request.url}');
    _logApiMessage('📨 Request Type: ${request.method}');
    if ((requestJson != null || variables != null) && !isPaymentOperation) {
      _logApiMessage('🧩 Payload attached');
      _logRequestPayload(requestJson, requestBody);
    } else if (isPaymentOperation) {
      _logApiMessage('🧩 Payment payload omitted from debug logs');
    }

    try {
      final response = await _inner.send(request);
      final responseBytes = await response.stream.toBytes();
      stopwatch.stop();

      final responseBody = utf8.decode(responseBytes, allowMalformed: true);
      _logApiMessage('✅ [API Response] (${stopwatch.elapsedMilliseconds}ms)');
      _logApiMessage('📝 API Name: ${operationName ?? 'unnamed'}');
      _logApiMessage('🔢 Status Code: ${response.statusCode}');
      _logApiMessage('📦 Response Length: ${responseBody.length} chars');
      if (isPaymentOperation) {
        _logApiMessage('📥 Payment response omitted from debug logs');
      } else {
        _logResponseBody(responseBody);
      }
      _logApiMessage('═══════════════════════════════════════════');

      return http.StreamedResponse(
        Stream<List<int>>.value(responseBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      stopwatch.stop();
      _logApiMessage('❌ [API Error] (${stopwatch.elapsedMilliseconds}ms)');
      _logApiMessage('📝 API Name: ${operationName ?? 'unnamed'}');
      _logApiMessage('⚠️ Error: $e');
      _logApiMessage('═══════════════════════════════════════════');
      rethrow;
    }
  }

  Future<void> _attachDynamicHeaders(http.BaseRequest request) async {
    // X-STOREFRONT-KEY already scopes requests to the configured channel.
    // Per Bagisto docs, X-Channel is optional to use the channel defaults.
    // Sending X-CHANNEL: default causes a backend join conflict in Bagisto
    // when sorting by NAME, causing it to fall back to ordering by product id.
    if (channelCode.isNotEmpty && channelCode != 'default') {
      request.headers['X-CHANNEL'] = channelCode;
    }

    // Locale and currency are preferences, not requirements. If the store is
    // unreachable — no plugin binding, first run — the request still goes out
    // with the channel header and the server falls back to its defaults.
    try {
      final prefs = await SharedPreferences.getInstance();
      final locale = prefs.getString(LocaleCubit.localeKey);
      final currency = prefs.getString(CurrencyCubit.currencyKey);

      // A request that already names a locale keeps it: the product editor
      // edits one language at a time, which is not the app's own language.
      if (locale != null &&
          locale.isNotEmpty &&
          !request.headers.containsKey('X-LOCALE')) {
        request.headers['X-LOCALE'] = locale;
      }
      if (currency != null && currency.isNotEmpty) {
        request.headers['X-CURRENCY'] = currency;
      }
    } catch (error) {
      _logApiMessage('⚠️ Locale/currency headers unavailable: $error');
    }
  }

  String _extractRequestBody(http.BaseRequest request) {
    if (request is http.Request) {
      return request.body;
    }

    return '';
  }

  dynamic _tryParseJson(String value) {
    if (value.isEmpty) return null;
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }

  void _logRequestPayload(dynamic requestJson, String requestBody) {
    if (requestJson is Map<String, dynamic>) {
      final query = requestJson['query'];
      final variables = requestJson['variables'];

      if (query is String && query.trim().isNotEmpty) {
        _logApiMessage('📄 Query:');
        _logApiMessage(query);
      }

      if (variables != null) {
        _logApiMessage('🔧 Variables:');
        _logApiMessage(_formatLogJson(variables));
      }
      return;
    }

    if (requestBody.trim().isEmpty) return;
    _logApiMessage('📦 Request Body:');
    _logApiMessage(requestBody);
  }

  void _logResponseBody(String responseBody) {
    if (responseBody.trim().isEmpty) return;
    _logApiMessage('📥 Response Body:');
    _logApiMessage(_formatLogBody(responseBody));
  }

  String _formatLogBody(String body) {
    final parsed = _tryParseJson(body);
    if (parsed == null) return body;
    return _formatLogJson(parsed);
  }

  String _formatLogJson(Object? value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

void _logApiMessage(String message) {
  if (!kDebugMode) return;
  debugPrint(message);
}

class GraphQLClientProvider {
  // ─── Constants ────────────────────────────────────────────────────────────

  /// All GraphQL clients use this timeout. Change here once — applies everywhere.
  static const _kTimeout = Duration(seconds: 120);

  // ─── Cache ────────────────────────────────────────────────────────────────

  /// Clears the GraphQL cache (HiveStore).
  /// Call this on logout to remove all cached user data.
  static Future<void> clearCache() async {
    try {
      final store = HiveStore();
      await store.reset();
      debugPrint('✅ GraphQL HiveStore cache cleared');
    } catch (e) {
      debugPrint('⚠️ Failed to clear HiveStore cache: $e');
    }
  }

  // ─── Central factory ─────────────────────────────────────────────────────

  /// **Use this everywhere** instead of constructing [GraphQLClient] manually.
  ///
  /// Automatically applies the 120-second [_kTimeout] so you never have to
  /// repeat it in individual repositories or pages.
  ///
  /// ```dart
  /// // No token (guest / unauthenticated)
  /// GraphQLClientProvider.buildClient()
  ///
  /// // With auth token
  /// GraphQLClientProvider.buildClient(token: accessToken)
  /// ```
  static GraphQLClient buildClient({String? token}) {
    final httpClient = LoggingHttpClient(
      inner: TimeoutHttpClient(
        connectTimeout: _kTimeout,
        receiveTimeout: _kTimeout,
      ),
    );

    final httpLink = HttpLink(
      bagistoEndpoint,
      httpClient: httpClient,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );

    final authLink = AuthLink(
      getToken: () async {
        if (token != null && token.isNotEmpty) return 'Bearer $token';
        try {
          final stored = await AuthStorage.getToken();
          if (stored != null && stored.isNotEmpty) return 'Bearer $stored';
        } catch (_) {}
        return null;
      },
    );
    final link = authLink.concat(httpLink);

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

  // ─── Logging link ─────────────────────────────────────────────────────────

  static Link _createLoggingLink({String label = 'GraphQL'}) {
    return Link.function((request, [forward]) {
      final stopwatch = Stopwatch()..start();
      _logApiMessage('═══════════════════════════════════════════');
      _logApiMessage('🔵 [$label Request]');
      _logApiMessage(
        '📝 Operation: ${request.operation.operationName ?? 'unnamed'}',
      );
      if (request.variables.isNotEmpty) {
        _logApiMessage('🔧 Variables attached');
      }
      _logApiMessage('───────────────────────────────────────────');

      return forward!(request).map((response) {
        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;
        final hasErrors =
            response.errors != null && response.errors!.isNotEmpty;
        if (hasErrors) {
          _logApiMessage('❌ [$label Error Response] (${duration}ms)');
          response.errors?.forEach((error) {
            _logApiMessage('⚠️ Error: ${error.message}');
          });
        } else {
          _logApiMessage('✅ [$label Success Response] (${duration}ms)');
        }
        _logApiMessage('═══════════════════════════════════════════');
        return response;
      });
    });
  }

  // ─── Named clients (for app-level providers) ──────────────────────────────

  /// Unauthenticated client wrapped in [ValueNotifier] for GraphQL widgets.
  static ValueNotifier<GraphQLClient> get client {
    final httpClient = LoggingHttpClient(
      inner: TimeoutHttpClient(
        connectTimeout: _kTimeout,
        receiveTimeout: _kTimeout,
      ),
    );

    final httpLink = HttpLink(
      bagistoEndpoint,
      httpClient: httpClient,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );

    final link = _createLoggingLink().concat(httpLink);

    Store store;
    try {
      store = HiveStore();
    } catch (_) {
      store = InMemoryStore();
    }

    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: store),
        link: link,
        queryRequestTimeout: _kTimeout,
        defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.networkOnly),
        ),
      ),
    );
  }

  /// Authenticated client wrapped in [ValueNotifier] for GraphQL widgets.
  static ValueNotifier<GraphQLClient> authenticatedClient(String accessToken) {
    final httpClient = LoggingHttpClient(
      inner: TimeoutHttpClient(
        connectTimeout: _kTimeout,
        receiveTimeout: _kTimeout,
      ),
    );

    final httpLink = HttpLink(
      bagistoEndpoint,
      httpClient: httpClient,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );

    final authLink = AuthLink(getToken: () async => 'Bearer $accessToken');
    final link = authLink.concat(
      _createLoggingLink(label: 'GraphQL Auth').concat(httpLink),
    );

    Store store;
    try {
      store = HiveStore();
    } catch (_) {
      store = InMemoryStore();
    }

    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: store),
        link: link,
        queryRequestTimeout: _kTimeout,
        defaultPolicies: DefaultPolicies(
          query: Policies(fetch: FetchPolicy.networkOnly),
        ),
      ),
    );
  }
}
