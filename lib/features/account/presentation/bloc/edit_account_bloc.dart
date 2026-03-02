import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class EditAccountEvent extends Equatable {
  const EditAccountEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current profile for editing — fetches fresh data from API
class LoadEditAccount extends EditAccountEvent {
  /// Optional fallback profile to show immediately while API loads
  final CustomerProfile? fallbackProfile;
  const LoadEditAccount({this.fallbackProfile});

  @override
  List<Object?> get props => [fallbackProfile];
}

/// Save profile changes (first name, last name, gender, phone, DOB, newsletter)
class SaveProfile extends EditAccountEvent {
  final String firstName;
  final String lastName;
  final String? gender;
  final String? phone;
  final String? dateOfBirth;
  final bool subscribedToNewsLetter;

  const SaveProfile({
    required this.firstName,
    required this.lastName,
    this.gender,
    this.phone,
    this.dateOfBirth,
    required this.subscribedToNewsLetter,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        gender,
        phone,
        dateOfBirth,
        subscribedToNewsLetter,
      ];
}

/// Change customer email — requires current password verification
class ChangeEmail extends EditAccountEvent {
  final String newEmail;
  final String currentPassword;

  const ChangeEmail({
    required this.newEmail,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [newEmail, currentPassword];
}

/// Change customer password
class ChangePassword extends EditAccountEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

/// Delete customer account — requires password verification
class DeleteAccount extends EditAccountEvent {
  final String password;

  const DeleteAccount({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Clear any success/error message (after showing snackbar)
class ClearEditAccountMessage extends EditAccountEvent {
  const ClearEditAccountMessage();
}

// ─── STATES ───

enum EditAccountStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  changingEmail,
  emailChanged,
  changingPassword,
  passwordChanged,
  deletingAccount,
  accountDeleted,
  error,
}

class EditAccountState extends Equatable {
  final EditAccountStatus status;
  final CustomerProfile? profile;
  final String? successMessage;
  final String? errorMessage;

  const EditAccountState({
    this.status = EditAccountStatus.initial,
    this.profile,
    this.successMessage,
    this.errorMessage,
  });

  EditAccountState copyWith({
    EditAccountStatus? status,
    CustomerProfile? profile,
    String? successMessage,
    String? errorMessage,
  }) {
    return EditAccountState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  /// Whether a blocking operation is in progress
  bool get isProcessing =>
      status == EditAccountStatus.saving ||
      status == EditAccountStatus.changingEmail ||
      status == EditAccountStatus.changingPassword ||
      status == EditAccountStatus.deletingAccount;

  @override
  List<Object?> get props => [status, profile, successMessage, errorMessage];
}

// ─── BLOC ───

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final AccountRepository repository;

  EditAccountBloc({required this.repository})
      : super(const EditAccountState()) {
    on<LoadEditAccount>(_onLoad);
    on<SaveProfile>(_onSaveProfile);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
    on<DeleteAccount>(_onDeleteAccount);
    on<ClearEditAccountMessage>(_onClearMessage);
  }

  Future<void> _onLoad(
    LoadEditAccount event,
    Emitter<EditAccountState> emit,
  ) async {
    // Show fallback profile immediately if available, with loading status
    if (event.fallbackProfile != null) {
      emit(state.copyWith(
        status: EditAccountStatus.loading,
        profile: event.fallbackProfile,
      ));
    } else {
      emit(state.copyWith(status: EditAccountStatus.loading));
    }

    // Always fetch fresh profile from API
    try {
      final freshProfile = await repository.getCustomerProfile();
      debugPrint('✅ EditAccount: Fresh profile loaded from API');
      emit(state.copyWith(
        status: EditAccountStatus.loaded,
        profile: freshProfile,
      ));
    } catch (e) {
      debugPrint('⚠️ EditAccount: Failed to fetch fresh profile: $e');
      // Fall back to the passed profile if API fails
      if (event.fallbackProfile != null) {
        emit(state.copyWith(
          status: EditAccountStatus.loaded,
          profile: event.fallbackProfile,
        ));
      } else {
        emit(state.copyWith(
          status: EditAccountStatus.error,
          errorMessage: 'Failed to load profile. Please try again.',
        ));
      }
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(status: EditAccountStatus.saving));
    try {
      final updatedProfile = await repository.updateCustomerProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        gender: event.gender,
        phone: event.phone,
        dateOfBirth: event.dateOfBirth,
        subscribedToNewsLetter: event.subscribedToNewsLetter,
      );

      debugPrint('✅ Profile saved successfully');
      emit(state.copyWith(
        status: EditAccountStatus.saved,
        profile: updatedProfile,
        successMessage: 'Profile updated successfully',
      ));
    } catch (e) {
      debugPrint('❌ Save profile error: $e');
      emit(state.copyWith(
        status: EditAccountStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to update profile. Please try again.',
      ));
    }
  }

  Future<void> _onChangeEmail(
    ChangeEmail event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(status: EditAccountStatus.changingEmail));
    try {
      final updatedProfile = await repository.changeEmail(
        email: event.newEmail,
        currentPassword: event.currentPassword,
      );

      debugPrint('✅ Email changed successfully');
      emit(state.copyWith(
        status: EditAccountStatus.emailChanged,
        profile: updatedProfile,
        successMessage: 'Email changed successfully',
      ));
    } catch (e) {
      debugPrint('❌ Change email error: $e');
      emit(state.copyWith(
        status: EditAccountStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to change email. Please try again.',
      ));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(status: EditAccountStatus.changingPassword));
    try {
      await repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      debugPrint('✅ Password changed successfully');
      emit(state.copyWith(
        status: EditAccountStatus.passwordChanged,
        successMessage: 'Password changed successfully',
      ));
    } catch (e) {
      debugPrint('❌ Change password error: $e');
      emit(state.copyWith(
        status: EditAccountStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to change password. Please try again.',
      ));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<EditAccountState> emit,
  ) async {
    emit(state.copyWith(status: EditAccountStatus.deletingAccount));
    try {
      await repository.deleteCustomerAccount(password: event.password);

      debugPrint('✅ Account deleted successfully');
      emit(state.copyWith(
        status: EditAccountStatus.accountDeleted,
        successMessage: 'Account deleted successfully',
      ));
    } catch (e) {
      debugPrint('❌ Delete account error: $e');
      emit(state.copyWith(
        status: EditAccountStatus.error,
        errorMessage: e is AccountException
            ? e.message
            : 'Failed to delete account. Please try again.',
      ));
    }
  }

  void _onClearMessage(
    ClearEditAccountMessage event,
    Emitter<EditAccountState> emit,
  ) {
    emit(state.copyWith(
      status: EditAccountStatus.loaded,
      successMessage: null,
      errorMessage: null,
    ));
  }
}
