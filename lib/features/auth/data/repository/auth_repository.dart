import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/graphql/auth_mutations.dart';
import '../../../../core/notifications/device_token_service.dart';
import '../models/auth_models.dart';

/// Repository for authentication API calls via GraphQL.
/// Matches Bagisto API: createCustomerLogin, createCustomer,
/// createForgotPassword, createLogout.
/// Also handles FCM device token management.
class AuthRepository {
  final GraphQLClient client;

  AuthRepository({required this.client});

  /// Login with email + password
  /// Returns [CustomerLogin] with token on success.
  /// Automatically includes FCM device token in the request if available.
  Future<CustomerLogin> login({
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    debugPrint('🔐 AuthRepo.login — email: $email');

    // Get device token if not provided
    final token = deviceToken ?? await DeviceTokenService.getDeviceToken();

    final result = await client.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: {
          'input': {
            'email': email,
            'password': password,
            if (token != null) 'deviceToken': token,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('🔐 AuthRepo.login — exception: $message');
      throw AuthException(message);
    }

    debugPrint('🔐 AuthRepo.login — raw data: ${result.data}');

    final data = result.data?['createCustomerLogin']?['customerLogin'];
    if (data == null) {
      debugPrint('🔐 AuthRepo.login — customerLogin is null');
      throw AuthException('Invalid response from server');
    }

    final loginResult = CustomerLogin.fromJson(data);
    if (!loginResult.success) {
      throw AuthException(loginResult.message ?? 'Login failed');
    }

    debugPrint(
      '🔐 AuthRepo.login — success, token: ${loginResult.token?.substring(0, 10)}...',
    );
    if (token != null) {
      debugPrint(
        '🔐 AuthRepo.login — device token sent: ${token.substring(0, 20)}...',
      );
    }
    return loginResult;
  }

  /// Register a new customer.
  /// Matches Bagisto API: firstName, lastName, email, password, confirmPassword
  /// Automatically includes FCM device token in the request if available.
  Future<Customer> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    String? deviceToken,
    bool subscribeToNewsletter = true,
  }) async {
    debugPrint('📝 AuthRepo.register — $firstName $lastName <$email>');

    // Get device token if not provided
    final token = deviceToken ?? await DeviceTokenService.getDeviceToken();

    final result = await client.mutate(
      MutationOptions(
        document: gql(registerMutation),
        variables: {
          'input': {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword,
            'status': '1',
            'isVerified': '1',
            'isSuspended': '0',
            'subscribedToNewsLetter': subscribeToNewsletter,
            if (token != null) 'deviceToken': token,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      debugPrint('📝 AuthRepo.register — exception: $message');
      throw AuthException(message);
    }

    debugPrint('📝 AuthRepo.register — raw data: ${result.data}');

    final data = result.data?['createCustomer']?['customer'];
    if (data == null) {
      debugPrint('📝 AuthRepo.register — customer is null in response');
      throw AuthException('Invalid response from server');
    }

    final customer = Customer.fromJson(data);
    debugPrint(
      '📝 AuthRepo.register — success: ${customer.displayName}, token: ${customer.token}',
    );
    if (token != null) {
      debugPrint(
        '📝 AuthRepo.register — device token sent: ${token.substring(0, 20)}...',
      );
    }
    return customer;
  }

  /// Send forgot-password email
  Future<String> forgotPassword({required String email}) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(forgotPasswordMutation),
        variables: {'email': email},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      throw AuthException(message);
    }

    final data = result.data?['createForgotPassword']?['forgotPassword'];
    if (data == null) {
      throw AuthException('Invalid response from server');
    }

    final success = data['success'] as bool? ?? false;
    final message = data['message'] as String? ?? '';

    if (!success) {
      throw AuthException(message.isNotEmpty ? message : 'Request failed');
    }

    return message;
  }

  /// Logout (requires authenticated client)
  /// Sends device token to API for cleanup.
  /// Clears device token from local storage after logout.
  Future<bool> logout() async {
    try {
      // Get device token to send to API
      final token = await DeviceTokenService.getDeviceToken();

      final result = await client.mutate(
        MutationOptions(
          document: gql(logoutMutation),
          variables: {
            'input': {if (token != null) 'deviceToken': token},
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      if (result.hasException) {
        final message = _extractErrorMessage(result.exception!);
        throw AuthException(message);
      }

      final data = result.data?['createLogout']?['logout'];

      // Clear device token on logout
      await DeviceTokenService.clearDeviceToken();
      debugPrint(
        '🔐 AuthRepo.logout — device token sent to API and cleared locally',
      );

      return data?['success'] as bool? ?? false;
    } catch (e) {
      debugPrint('❌ AuthRepo.logout — error: $e');
      // Still clear device token even if logout API fails
      await DeviceTokenService.clearDeviceToken();
      rethrow;
    }
  }

  /// Extract a readable error message from GraphQL exceptions
  String _extractErrorMessage(OperationException exception) {
    return ErrorMapper.getUserMessage(exception);
  }
}

/// Custom exception for auth errors
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
