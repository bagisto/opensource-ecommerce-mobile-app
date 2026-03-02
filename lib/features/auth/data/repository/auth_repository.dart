import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/auth_mutations.dart';
import '../models/auth_models.dart';

/// Repository for authentication API calls via GraphQL.
/// Matches Bagisto API: createCustomerLogin, createCustomer,
/// createForgotPassword, createLogout.
class AuthRepository {
  final GraphQLClient client;

  AuthRepository({required this.client});

  /// Login with email + password
  /// Returns [CustomerLogin] with token on success.
  Future<CustomerLogin> login({
    required String email,
    required String password,
  }) async {
    debugPrint('🔐 AuthRepo.login — email: $email');

    final result = await client.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: {
          'input': {'email': email, 'password': password},
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

    debugPrint('🔐 AuthRepo.login — success, token: ${loginResult.token?.substring(0, 10)}...');
    return loginResult;
  }

  /// Register a new customer.
  /// Matches Next.js: firstName, lastName, email, password, confirmPassword
  Future<Customer> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    debugPrint('📝 AuthRepo.register — $firstName $lastName <$email>');

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
            'subscribedToNewsLetter': true,
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
    debugPrint('📝 AuthRepo.register — success: ${customer.displayName}, token: ${customer.token}');
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
  Future<bool> logout() async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(logoutMutation),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      final message = _extractErrorMessage(result.exception!);
      throw AuthException(message);
    }

    final data = result.data?['createLogout']?['logout'];
    return data?['success'] as bool? ?? false;
  }

  /// Extract a readable error message from GraphQL exceptions
  String _extractErrorMessage(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.first.message;
    }
    if (exception.linkException != null) {
      return 'Network error. Please check your connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}

/// Custom exception for auth errors
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
