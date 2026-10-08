import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../l10n/app_localizations.dart';

/// Centralized error mapper that converts raw API / network exceptions
/// into clear, user-friendly messages suitable for display on the UI.
///
/// Usage:
///   catch (e) {
///     final friendlyMessage = ErrorMapper.getUserMessage(e);
///     emit(state.copyWith(errorMessage: friendlyMessage));
///   }
class ErrorMapper {
  ErrorMapper._(); // prevent instantiation

  static String _localeCode = 'en';

  /// Update locale code so error messages are localized even outside widget tree.
  static void updateLocale(Locale? locale) {
    _localeCode = locale?.languageCode ?? 'en';
  }

  static AppLocalizations _l10n() {
    try {
      return lookupAppLocalizations(Locale(_localeCode));
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  //  Public API
  // ──────────────────────────────────────────────────────────────────────

  /// Returns a user-friendly error message for the given [error].
  ///
  /// Optional [context] gives a short hint about what operation was
  /// being performed (e.g. "loading products", "placing your order")
  /// so the message can be more specific.
  static String getUserMessage(Object error, {String? context}) {
    final l10n = _l10n();
    final raw = error.toString();

    // ── 1. GraphQL OperationException ───────────────────────────────
    if (error is OperationException) {
      return _mapOperationException(error, context: context);
    }

    // ── 2. Timeout ─────────────────────────────────────────────────
    if (error is TimeoutException ||
        raw.contains('TimeoutException') ||
        raw.contains('No stream event')) {
      return l10n.commonTimeoutError;
    }

    // ── 3. Socket / connectivity errors ────────────────────────────
    if (error is SocketException || raw.contains('SocketException')) {
      return l10n.commonUnableToReachServer;
    }

    // ── 4. Network-related catch-alls ──────────────────────────────
    if (raw.contains('Network error') ||
        raw.contains('NetworkException') ||
        raw.contains('linkException') ||
        raw.contains('Failed host lookup') ||
        raw.contains('Connection refused') ||
        raw.contains('Connection reset') ||
        raw.contains('HandshakeException')) {
      return l10n.commonNetworkError;
    }

    // ── 5. Format / parsing errors (should never reach the user) ──
    if (error is FormatException ||
        raw.contains('FormatException') ||
        raw.contains('type \'Null\' is not a subtype') ||
        raw.contains('NoSuchMethodError')) {
      debugPrint('⚠️ ErrorMapper — unexpected format error: $raw');
      return l10n.commonProcessingError;
    }

    // ── 6. Known domain exceptions (AuthException, AccountException)
    // They already carry user-friendly messages set at the repo layer.
    if (raw.contains('AccountException:')) {
      return raw.replaceFirst('AccountException: ', '');
    }
    if (raw.contains('AuthException:')) {
      return raw.replaceFirst('AuthException: ', '');
    }

    // ── 7. Generic Exception("...") messages from repos ───────────
    // e.g. Exception: Failed to merge cart
    if (raw.startsWith('Exception:')) {
      final cleaned = raw.replaceFirst('Exception: ', '').trim();
      return _humanize(cleaned, context: context);
    }

    // ── 8. Fallback ───────────────────────────────────────────────
    if (context != null && context.isNotEmpty) {
      return l10n.commonGenericErrorWithContext(context);
    }
    return l10n.commonGenericError;
  }

  /// A convenience wrapper that extracts a user-friendly message
  /// specifically from a [QueryResult] that has an exception.
  static String fromQueryResult(QueryResult result, {String? context}) {
    if (result.exception != null) {
      return _mapOperationException(result.exception!, context: context);
    }
    if (context != null) {
      return 'Something went wrong while $context. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  // ──────────────────────────────────────────────────────────────────────
  //  Internals
  // ──────────────────────────────────────────────────────────────────────

  /// Map [OperationException] (graphql_flutter) to user-friendly text.
  static String _mapOperationException(
    OperationException exception, {
    String? context,
  }) {
    final l10n = _l10n();

    // GraphQL-level errors (server returned errors in the response body)
    if (exception.graphqlErrors.isNotEmpty) {
      final msg = exception.graphqlErrors.first.message;
      return _mapGraphQLErrorMessage(msg, context: context);
    }

    // Link-level errors (transport / HTTP issues)
    final linkEx = exception.linkException;
    if (linkEx != null) {
      return _mapLinkException(linkEx, context: context);
    }

    // Generic fallback
    if (context != null) {
      return l10n.commonGenericErrorWithContext(context);
    }
    return l10n.commonGenericError;
  }

  /// Map the raw `message` from a GraphQL error into something user-facing.
  ///
  /// Bagisto sometimes returns semi-technical messages like
  /// "Variable \"$input\" of required type ... was not provided." or
  /// "Internal server error". We map the most common ones here.
  static String _mapGraphQLErrorMessage(String message, {String? context}) {
    final l10n = _l10n();
    final lower = message.toLowerCase();

    // ── Auth / credential errors ──
    if (lower.contains('invalid credentials') ||
        lower.contains('invalid email or password') ||
        lower.contains('these credentials do not match')) {
      return l10n.authInvalidCredentials;
    }
    if (lower.contains('unauthenticated') ||
        lower.contains('not authenticated')) {
      return l10n.authSessionExpired;
    }
    if (lower.contains('token') && lower.contains('invalid')) {
      return l10n.authSessionInvalid;
    }

    // ── Validation / input errors ──
    if (lower.contains('variable') && lower.contains('was not provided')) {
      return l10n.commonMissingInformation;
    }
    if (lower.contains('validation') ||
        lower.contains('the given data was invalid')) {
      return message; // validation messages are usually readable
    }

    // ── Resource not found ──
    if (lower.contains('not found') || lower.contains('does not exist')) {
      return message; // "Order not found", "Product not found" etc. are fine
    }

    // ── Cart specific ──
    if (lower.contains('cart not found') || lower.contains('no cart')) {
      return l10n.commonCartSessionExpired;
    }
    if (lower.contains('out of stock') || lower.contains('not available')) {
      return message; // already user-friendly
    }
    if (lower.contains('quantity') && lower.contains('exceed')) {
      return message; // "Requested quantity exceeds available stock"
    }

    // ── Coupon / discount ──
    if (lower.contains('coupon') || lower.contains('discount')) {
      return message; // Usually already readable
    }

    // ── Rate limiting ──
    if (lower.contains('too many') || lower.contains('rate limit')) {
      return l10n.commonTooManyRequests;
    }

    // ── Internal server errors ──
    if (lower.contains('internal server error') ||
        lower.contains('server error') ||
        lower.contains('500')) {
      return l10n.commonServerError;
    }

    // ── Permission / access ──
    if (lower.contains('forbidden') ||
        lower.contains('not authorized') ||
        lower.contains('access denied')) {
      return l10n.commonPermissionDenied;
    }

    // ── Default: if the message looks reasonably friendly, use it ──
    if (_looksUserFriendly(message)) {
      return message;
    }

    // Otherwise, generic fallback
    debugPrint('⚠️ ErrorMapper — unmapped GraphQL error: $message');
    // Say which step failed instead of a bare "Something went wrong".
    if (context != null && context.isNotEmpty) {
      return l10n.commonGenericErrorWithContext(context);
    }
    return l10n.commonGenericError;
  }

  /// Map link-level (transport) exceptions.
  static String _mapLinkException(LinkException linkEx, {String? context}) {
    final l10n = _l10n();
    final str = linkEx.toString();

    if (str.contains('TimeoutException') || str.contains('No stream event')) {
      return l10n.commonTimeoutError;
    }
    if (str.contains('SocketException') ||
        str.contains('Failed host lookup') ||
        str.contains('Connection refused')) {
      return l10n.commonUnableToReachServer;
    }
    if (str.contains('HandshakeException') ||
        str.contains('CERTIFICATE_VERIFY_FAILED')) {
      return l10n.commonSecureConnectionError;
    }

    return l10n.commonNetworkError;
  }

  /// Simple heuristic: does the message look like it was written for
  /// a human (starts with capitals, no class names or stack traces)?
  static bool _looksUserFriendly(String message) {
    if (message.isEmpty) return false;
    // If it contains typical code artefacts, it's probably not user-friendly
    if (message.contains('Exception') ||
        message.contains('Error:') ||
        // Untranslated server keys, e.g. `bagistoapi::app.graphql.x.y`.
        message.contains('::') ||
        message.contains('null') ||
        message.contains('type \'') ||
        message.contains('Stack Trace') ||
        message.contains('package:')) {
      return false;
    }
    // Messages shorter than ~120 chars and starting with uppercase are likely ok
    if (message.length < 200 && RegExp(r'^[A-Z]').hasMatch(message)) {
      return true;
    }
    return message.length < 120;
  }

  /// Cleans up an already semi-friendly message and optionally adds context.
  static String _humanize(String message, {String? context}) {
    final l10n = _l10n();
    // Remove "Failed to load/fetch ..." prefix duplications
    var result = message
        .replaceAll(RegExp(r'^Failed to (load|fetch) '), '')
        .trim();

    if (result.isEmpty) {
      if (context != null) {
        return l10n.commonGenericErrorWithContext(context);
      }
      return l10n.commonGenericError;
    }

    // Capitalize first letter
    result = result[0].toUpperCase() + result.substring(1);

    // Add period if missing
    if (!result.endsWith('.') &&
        !result.endsWith('!') &&
        !result.endsWith('?')) {
      result = '$result. Please try again.';
    }
    return result;
  }

  /// Helper: detect if an error is a network/connectivity error.
  /// Useful in blocs to decide whether to show a retry button.
  static bool isNetworkError(Object error) {
    final raw = error.toString();
    return error is SocketException ||
        error is TimeoutException ||
        raw.contains('TimeoutException') ||
        raw.contains('SocketException') ||
        raw.contains('Network error') ||
        raw.contains('NetworkException') ||
        raw.contains('linkException') ||
        raw.contains('No stream event') ||
        raw.contains('Failed host lookup') ||
        raw.contains('Connection refused') ||
        raw.contains('Connection reset');
  }
}
