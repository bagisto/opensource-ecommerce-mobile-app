// GraphQL queries and mutations for the Returns (RMA) feature.
// API reference: https://api-docs.bagisto.com/api/graphql-api/shop/returns/
//
// All operations require the authenticated customer client
// (Bearer token + storefront key). Single-entity operations expect
// IRI ids of the form `/api/shop/returns/{id}`.

class ReturnsQueries {
  /// Cursor-paginated list of the customer's return requests.
  static const String getCustomerReturns = r'''
    query customerReturns($first: Int, $after: String, $status: Int) {
      customerReturns(first: $first, after: $after, status: $status) {
        edges {
          cursor
          node {
            _id
            orderId
            orderIncrementId
            statusId
            statusTitle
            statusColor
            packageCondition
            information
            canClose
            canReopen
            isExpired
            item
            images
            messagesCount
            createdAt
            updatedAt
          }
        }
        pageInfo {
          startCursor
          endCursor
          hasNextPage
          hasPreviousPage
        }
        totalCount
      }
    }
  ''';

  /// Single return detail. `id` is an IRI: `/api/shop/returns/{id}`.
  static const String getCustomerReturn = r'''
    query customerReturn($id: ID!) {
      customerReturn(id: $id) {
        _id
        orderId
        orderIncrementId
        statusId
        statusTitle
        statusColor
        packageCondition
        information
        canClose
        canReopen
        isExpired
        item
        images
        messagesCount
        createdAt
        updatedAt
      }
    }
  ''';

  /// Items from an order that are still eligible for return/cancellation.
  /// Returns the full list; this field does not accept pagination arguments.
  static const String getReturnableItems = r'''
    query returnableItems($orderId: Int!) {
      returnableItems(orderId: $orderId) {
        orderItemId
        productId
        sku
        name
        type
        urlKey
        price
        baseImageUrl
        qtyOrdered
        currentQuantity
        forReturnQuantity
        forCancelQuantity
        rmaQuantity
        rmaReturnPeriod
      }
    }
  ''';

  /// Active return reasons for a resolution type: "return" | "cancel_items".
  static const String getReturnReasons = r'''
    query returnReasons($resolutionType: String!) {
      returnReasons(resolutionType: $resolutionType) {
        _id
        title
        position
      }
    }
  ''';

  /// Conversation thread for a return (newest first from the API).
  static const String getReturnMessages = r'''
    query customerReturnMessages($returnId: Int!) {
      customerReturnMessages(returnId: $returnId) {
        _id
        rmaId
        message
        isAdmin
        attachment
        attachmentUrl
        createdAt
      }
    }
  ''';

  /// Create a return request for one order item.
  static const String createCustomerReturn = r'''
    mutation createCustomerReturn($input: createCustomerReturnInput!) {
      createCustomerReturn(input: $input) {
        customerReturn {
          _id
          orderId
          orderIncrementId
          statusId
          statusTitle
          statusColor
          packageCondition
          information
          canClose
          canReopen
          isExpired
          item
          images
          messagesCount
          createdAt
          updatedAt
        }
      }
    }
  ''';

  /// Cancel the customer's own return request. `id` is an IRI.
  static const String cancelCustomerReturn = r'''
    mutation cancelCustomerReturn($id: ID!) {
      cancelCustomerReturn(input: { id: $id }) {
        customerReturn {
          _id
          orderId
          orderIncrementId
          statusId
          statusTitle
          statusColor
          packageCondition
          information
          canClose
          canReopen
          isExpired
          item
          images
          messagesCount
          createdAt
          updatedAt
        }
      }
    }
  ''';

  /// Reopen a canceled/declined return back to Pending. `id` is an IRI.
  static const String reopenCustomerReturn = r'''
    mutation reopenCustomerReturn($id: ID!) {
      reopenCustomerReturn(input: { id: $id }) {
        customerReturn {
          _id
          orderId
          orderIncrementId
          statusId
          statusTitle
          statusColor
          packageCondition
          information
          canClose
          canReopen
          isExpired
          item
          images
          messagesCount
          createdAt
          updatedAt
        }
      }
    }
  ''';

  /// Mark a return as solved. Requires `canClose`. `id` is an IRI.
  static const String closeCustomerReturn = r'''
    mutation closeCustomerReturn($id: ID!) {
      closeCustomerReturn(input: { id: $id }) {
        customerReturn {
          _id
          orderId
          orderIncrementId
          statusId
          statusTitle
          statusColor
          packageCondition
          information
          canClose
          canReopen
          isExpired
          item
          images
          messagesCount
          createdAt
          updatedAt
        }
      }
    }
  ''';

  /// Add a customer message to the return conversation thread.
  static const String createCustomerReturnMessage = r'''
    mutation createCustomerReturnMessage($returnId: Int!, $message: String!) {
      createCustomerReturnMessage(input: { returnId: $returnId, message: $message }) {
        customerReturnMessage {
          _id
          rmaId
          message
          isAdmin
          attachment
          attachmentUrl
          createdAt
        }
      }
    }
  ''';
}
