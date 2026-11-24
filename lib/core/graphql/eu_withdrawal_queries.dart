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

  /// A single withdrawal declaration by IRI.
  static const String getWithdrawal = r'''
    query euWithdrawal($id: ID!) {
      euWithdrawal(id: $id) {
        id
        _id
        uuid
        orderId
        orderIncrementId
        isGuest
        customerEmail
        status
        reasonText
        receivedAt
        confirmationSentAt
        declinedAt
        declinedReason
        refundedAt
        refundNote
        createdAt
        updatedAt
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
            uuid
            orderId
            orderIncrementId
            isGuest
            customerEmail
            status
            reasonText
            receivedAt
            confirmationSentAt
            declinedAt
            declinedReason
            refundedAt
            refundNote
            createdAt
            updatedAt
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
          uuid
          orderId
          orderIncrementId
          isGuest
          customerEmail
          status
          reasonText
          receivedAt
          confirmationSentAt
          declinedAt
          declinedReason
          refundedAt
          refundNote
          createdAt
          updatedAt
        }
      }
    }
  ''';

  /// Sends a guest an email link to withdraw from a contract.
  static const String createGuestWithdrawalLink = r'''
    mutation CreateGuestEuWithdrawalLink($input: createGuestEuWithdrawalLinkInput!) {
      createGuestEuWithdrawalLink(input: $input) {
        guestEuWithdrawalLink {
          success
          message
        }
      }
    }
  ''';
}
