# Server Configuration for Bagisto Flutter App

## Overview

The Bagisto Flutter app uses **GraphQL** for API communication. Server configuration is managed through constants and environment variables.

## Configuration Steps

### 1. Update API Constants

Go to `lib/core/constants/api_constants.dart` and configure the following:

```dart
/// Bagisto GraphQL endpoint (e.g., https://your-bagisto-server.com/graphql)
const String bagistoEndpoint = 'YOUR_BAGISTO_ENDPOINT_HERE';

/// Storefront key for Bagisto API
/// Get this from your Bagisto admin panel
const String storefrontKey = 'YOUR_STOREFRONT_KEY_HERE';

/// Company name (optional metadata)
const String companyName = 'Your Company Name';
```

## Configuration Details

### `bagistoEndpoint`
- **Type:** String (URL)
- **Example:** `https://bagisto.yourdomain.com/graphql`
- **Purpose:** GraphQL endpoint URL for all API calls
- **Required:** Yes

### `storefrontKey`
- **Type:** String  
- **Purpose:** API key for identifying your storefront in Bagisto
- **Location in Bagisto:** Admin Panel → Settings → Channels
- **Required:** Yes

## GraphQL Client Configuration

The GraphQL client is configured in `lib/core/graphql/graphql_client.dart` with:

- **HTTP Client:** Custom `TimeoutHttpClient` with 30-second timeout for both connection and receive
- **Headers:** 
  - `Content-Type: application/json`
  - `X-STOREFRONT-KEY: {storefrontKey}`
- **Logging:** Detailed request/response logging in debug mode
- **Caching:** HiveStore for offline data persistence

## Network Configuration

### Timeouts
- **Connection Timeout:** 30 seconds
- **Receive Timeout:** 30 seconds

### Cache Management
The app uses HiveStore for caching GraphQL responses. To clear cache on logout:
```dart
await GraphQLClientProvider.clearCache();
```

## Testing Configuration

Before deploying to production:
1. Verify your Bagisto endpoint is accessible
2. Confirm the storefront key is valid in Bagisto admin
3. Test API connectivity from your development environment
4. Check network logs in Flutter DevTools for request/response details
