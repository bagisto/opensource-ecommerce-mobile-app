/// GraphQL for EU contract withdrawal (right of withdrawal) requests.
class EuWithdrawalQueries {
  EuWithdrawalQueries._();

  /// Whether EU withdrawal is enabled for the current channel. No auth.
  static const String getStatus = r'''
    query euWithdrawalStatus {
      euWithdrawalStatus {
        id
        enabled
        channel
      }
    }
  ''';

  /// The logged-in customer's withdrawal requests.
  static const String getWithdrawals = r'''
    query euWithdrawals($first: Int, $after: String) {
      euWithdrawals(first: $first, after: $after) {
        edges {
          node {
            id
            _id
            orderId
            orderIncrementId
            status
            receivedAt
            declinedReason
          }
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  ''';

  /// Withdraw from the contract of one of the customer's orders.
  static const String createWithdrawal = r'''
    mutation createEuWithdrawal($input: createEuWithdrawalInput!) {
      createEuWithdrawal(input: $input) {
        euWithdrawal {
          id
          _id
          orderId
          orderIncrementId
          status
          receivedAt
          declinedReason
        }
      }
    }
  ''';

  /// Guest withdrawal, identified by order number and order email.
  static const String createGuestWithdrawal = r'''
    mutation createGuestEuWithdrawal($input: createGuestEuWithdrawalInput!) {
      createGuestEuWithdrawal(input: $input) {
        guestEuWithdrawal {
          id
          uuid
          orderIncrementId
          status
          receivedAt
        }
      }
    }
  ''';
}
