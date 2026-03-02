import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repository/auth_repository.dart';
import '../../domain/services/auth_storage.dart';
import '../../../../core/graphql/graphql_client.dart';

// ─── EVENTS ───

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    confirmPassword,
  ];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

// ─── STATES ───

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String token;
  final String? userName;
  final String? userEmail;
  final String? userId;

  const AuthAuthenticated({
    required this.token,
    this.userName,
    this.userEmail,
    this.userId,
  });

  @override
  List<Object?> get props => [token, userName, userEmail, userId];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthRegistrationSuccess extends AuthState {
  final String message;
  const AuthRegistrationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthForgotPasswordSuccess extends AuthState {
  final String message;
  const AuthForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLOC ───

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      final name = await AuthStorage.getUserName();
      final email = await AuthStorage.getUserEmail();
      final userId = await AuthStorage.getUserId();
      emit(AuthAuthenticated(
        token: token,
        userName: name,
        userEmail: email,
        userId: userId,
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final loginResult = await repository.login(
        email: event.email,
        password: event.password,
      );

      final token = loginResult.token ?? loginResult.apiToken ?? '';
      if (token.isEmpty) {
        emit(const AuthError(message: 'No token received from server'));
        return;
      } else {
        print("tpoken ===>${token.isEmpty} ");
      }

      final userId = loginResult.id;

      // Persist token and user info
      await AuthStorage.saveToken(token);
      await AuthStorage.saveUserInfo(
        name: event.email, // will be replaced with actual name
        email: event.email,
        userId: userId,
      );

      debugPrint('✅ Login successful — token: ${token.substring(0, 10)}..., userId: $userId');
      emit(
        AuthAuthenticated(
          token: token,
          userName: event.email,
          userEmail: event.email,
          userId: userId,
        ),
      );
    } on AuthException catch (e) {
      debugPrint('❌ Login failed: ${e.message}');
      emit(AuthError(message: e.message));
    } catch (e) {
      debugPrint('❌ Login error: $e');
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final customer = await repository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      debugPrint('✅ Registration successful — ${customer.displayName}');

      // If the API returns a token, auto-login
      final token = customer.token ?? customer.apiToken ?? '';
      if (token.isNotEmpty) {
        await AuthStorage.saveToken(token);
        await AuthStorage.saveUserInfo(
          name: customer.displayName,
          email: customer.email,
          userId: customer.id,
        );
        emit(
          AuthAuthenticated(
            token: token,
            userName: customer.displayName,
            userEmail: customer.email,
            userId: customer.id,
          ),
        );
      } else {
        emit(
          const AuthRegistrationSuccess(
            message: 'Account created successfully! Please login.',
          ),
        );
      }
    } on AuthException catch (e) {
      debugPrint('❌ Registration failed: ${e.message}');
      emit(AuthError(message: e.message));
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onForgotPassword(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final message = await repository.forgotPassword(email: event.email);
      debugPrint('✅ Forgot password email sent');
      emit(AuthForgotPasswordSuccess(message: message));
    } on AuthException catch (e) {
      debugPrint('❌ Forgot password failed: ${e.message}');
      emit(AuthError(message: e.message));
    } catch (e) {
      debugPrint('❌ Forgot password error: $e');
      emit(const AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await repository.logout();
    } catch (e) {
      debugPrint('Logout API error (clearing local data anyway): $e');
    }
    await AuthStorage.clearAuth();
    // Clear GraphQL HiveStore cache on logout
    await GraphQLClientProvider.clearCache();
    debugPrint('✅ Logged out');
    emit(const AuthUnauthenticated());
  }
}
