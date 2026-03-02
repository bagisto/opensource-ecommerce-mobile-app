/// GraphQL mutations for authentication
/// Bagisto API: createCustomerLogin, createCustomer, createForgotPassword, createLogout

const String loginMutation = r'''
  mutation loginCustomer($input: createCustomerLoginInput!) {
    createCustomerLogin(input: $input) {
      customerLogin {
        id
        apiToken
        token
        message
        success
      }
    }
  }
''';

const String registerMutation = r'''
  mutation registerCustomer($input: createCustomerInput!) {
    createCustomer(input: $input) {
      customer {
        id
        firstName
        lastName
        email
        phone
        status
        apiToken
        customerGroupId
        subscribedToNewsLetter
        isVerified
        isSuspended
        token
        rememberToken
        name
      }
    }
  }
''';

const String forgotPasswordMutation = r'''
  mutation forgotPassword($email: String!) {
    createForgotPassword(input: { email: $email }) {
      forgotPassword {
        success
        message
      }
    }
  }
''';

const String logoutMutation = r'''
  mutation createLogout {
    createLogout(input: {}) {
      logout {
        success
        message
      }
    }
  }
''';
