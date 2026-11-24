import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/graphql/queries.dart';

/// Thrown when `createNewsletter` returns a GraphQL error (missing/malformed
/// address) -- not thrown for "already subscribed", which the mutation
/// answers with `success: false` rather than an error.
class NewsletterSubscribeException implements Exception {
  final String message;
  const NewsletterSubscribeException(this.message);

  @override
  String toString() => 'NewsletterSubscribeException: $message';
}

/// The storefront footer's newsletter subscribe box -- open to signed-out
/// shoppers, and also usable signed in (pass a token-bearing [client] to
/// link the subscription to the account).
class NewsletterRepository {
  final GraphQLClient client;

  const NewsletterRepository({required this.client});

  /// Subscribes [email]. Returns true when newly subscribed, false when
  /// the address was already on the list -- both are normal outcomes.
  /// Throws [NewsletterSubscribeException] only for an actual GraphQL
  /// error (missing/malformed address, network failure, etc.).
  Future<bool> subscribe(String email) async {
    debugPrint('📰 NewsletterRepo.subscribe');

    final result = await client.mutate(
      MutationOptions(
        document: gql(NewsletterQueries.subscribe),
        variables: {
          'input': {'customerEmail': email},
        },
      ),
    );

    if (result.hasException) {
      final message = ErrorMapper.getUserMessage(result.exception!);
      debugPrint('📰 NewsletterRepo.subscribe — error: $message');
      throw NewsletterSubscribeException(message);
    }

    final newsletter =
        result.data?['createNewsletter']?['newsletter']
            as Map<String, dynamic>?;
    if (newsletter == null) {
      throw const NewsletterSubscribeException(
        'Something went wrong. Please try again.',
      );
    }

    debugPrint(
      '📰 NewsletterRepo.subscribe — success=${newsletter['success']}',
    );
    return newsletter['success'] == true;
  }
}
