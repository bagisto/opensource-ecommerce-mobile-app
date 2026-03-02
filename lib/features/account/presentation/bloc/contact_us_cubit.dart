import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/graphql/account_queries.dart';
import '../../data/models/account_models.dart';

/// State for the Contact Us form.
/// Manages form submission and response.
class ContactUsState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final String? successMessage;
  final String? errorMessage;

  const ContactUsState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
  });

  ContactUsState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
  }) {
    return ContactUsState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, isSuccess, successMessage, errorMessage];
}

/// Cubit to manage Contact Us form submission.
class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(const ContactUsState());

  /// Submit contact us form
  Future<void> submitContactForm({
    required String name,
    required String email,
    required String contact,
    required String message,
  }) async {
    emit(state.copyWith(
      isSubmitting: true,
      isSuccess: false,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final submission = ContactUsSubmission(
        name: name,
        email: email,
        contact: contact,
        message: message,
      );

      final client = GraphQLClientProvider.client.value;

      final result = await client.mutate(
        MutationOptions(
          document: gql(AccountQueries.createContactUs),
          variables: {
            'input': submission.toJson(),
          },
          errorPolicy: ErrorPolicy.all,
        ),
      );

      if (result.hasException) {
        final errorMessage = _parseGraphQLError(result.exception);
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: errorMessage,
        ));
        return;
      }

      final data = result.data?['createContactUs'] as Map<String, dynamic>?;
      final contactUsData = data?['contactUs'] as Map<String, dynamic>?;

      if (contactUsData == null) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Invalid response from server',
        ));
        return;
      }

      final response = ContactUsResponse.fromJson(contactUsData);

      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: response.success,
        successMessage: response.success ? response.message : null,
        errorMessage: !response.success ? response.message : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Reset form state
  void reset() {
    emit(const ContactUsState());
  }

  /// Parse GraphQL error message
  String _parseGraphQLError(dynamic exception) {
    final error = exception.toString();
    
    // Check for common GraphQL errors
    if (error.contains('Unknown type')) {
      return 'Contact Us API is not available. Please try again later.';
    }
    if (error.contains('Network')) {
      return 'Network error. Please check your connection.';
    }
    if (error.contains('Unauthorized')) {
      return 'Authentication required.';
    }
    
    return error;
  }
}
