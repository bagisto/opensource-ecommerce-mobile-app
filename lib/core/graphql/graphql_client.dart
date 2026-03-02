import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Custom HTTP client wrapper with timeout support
class TimeoutHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  TimeoutHttpClient({
    Duration? connectTimeout,
    Duration? receiveTimeout,
  })  : _inner = http.Client(),
        connectTimeout = connectTimeout ?? const Duration(seconds: 30),
        receiveTimeout = receiveTimeout ?? const Duration(seconds: 30);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Set up timeout
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

/// Safe substring helper to avoid RangeError
String _truncate(String text, int maxLength) {
  final cleaned = text.replaceAll('\n', ' ');
  if (cleaned.length <= maxLength) return cleaned;
  return '${cleaned.substring(0, maxLength)}...';
}

class GraphQLClientProvider {
  /// Clears the GraphQL cache (HiveStore)
  /// Call this on logout to remove all cached user data
  static Future<void> clearCache() async {
    try {
      final store = HiveStore();
      await store.reset();
      debugPrint('✅ GraphQL HiveStore cache cleared');
    } catch (e) {
      debugPrint('⚠️ Failed to clear HiveStore cache: $e');
    }
  }

  /// Creates a logging link that logs request & response details
  static Link _createLoggingLink({String label = 'GraphQL'}) {
    return Link.function((request, [forward]) {
      final stopwatch = Stopwatch()..start();
      debugPrint('═══════════════════════════════════════════');
      debugPrint('🔵 [$label Request]');
      debugPrint('📝 Operation: ${request.operation.operationName ?? 'unnamed'}');
      debugPrint('📋 Query: ${_truncate(request.operation.document.toString(), 300)}');
      if (request.variables.isNotEmpty) {
        debugPrint('🔧 Variables: ${request.variables}');
      }
      debugPrint('───────────────────────────────────────────');

      return forward!(request).map((response) {
        stopwatch.stop();
        final duration = stopwatch.elapsedMilliseconds;
        final hasErrors = response.errors != null && response.errors!.isNotEmpty;
        if (hasErrors) {
          debugPrint('❌ [$label Error Response] (${duration}ms)');
          response.errors?.forEach((error) {
            debugPrint('⚠️ Error: ${error.message}');
          });
        } else {
          debugPrint('✅ [$label Success Response] (${duration}ms)');
          final dataStr = response.data?.toString() ?? 'null';
          debugPrint('📦 Data: ${_truncate(dataStr, 500)}');
        }
        debugPrint('═══════════════════════════════════════════');
        return response;
      });
    });
  }

  static ValueNotifier<GraphQLClient> get client {
    // Create HTTP client with timeout configuration (30 seconds)
    final httpClient = TimeoutHttpClient(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    final httpLink = HttpLink(
      bagistoEndpoint,
      httpClient: httpClient,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'X-STOREFRONT-KEY': storefrontKey,
      },
    );

    // Chain logging link with http link
    final link = _createLoggingLink().concat(httpLink);

    // Use HiveStore if available, fallback to InMemoryStore
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
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.networkOnly,
          ),
        ),
      ),
    );
  }

  /// Returns a client with user auth token for authenticated requests
  static ValueNotifier<GraphQLClient> authenticatedClient(String accessToken) {
    // Create HTTP client with timeout configuration (30 seconds)
    final httpClient = TimeoutHttpClient(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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
      getToken: () async => 'Bearer $accessToken',
    );

    // Chain: auth -> logging -> http
    final link = authLink.concat(_createLoggingLink(label: 'GraphQL Auth').concat(httpLink));

    // Use HiveStore if available, fallback to InMemoryStore
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
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.networkOnly,
          ),
        ),
      ),
    );
  }
}
