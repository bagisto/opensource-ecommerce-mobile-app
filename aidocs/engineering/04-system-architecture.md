# System Architecture

## Goal

Keep the Bagisto mobile app easy to reason about by centering startup, networking, state management, and user journeys around a small set of shared boundaries.

## High-Level Shape

The Flutter layer in `lib/` is the primary source of truth for product behavior.

- `main.dart` composes the app
- `core/**` provides shared runtime services
- `features/**` encapsulates user-facing flows
- platform folders support configuration and native integration

## Bootstrap Architecture

Startup currently happens in a clear top-down order:

1. initialize Flutter bindings
2. initialize Firebase and background messaging
3. initialize Hive cache
4. load shared preferences
5. bootstrap Bagisto channel locale/currency metadata
6. initialize FCM foreground/background/tap handling
7. run the app with repositories and blocs

Why this matters:

- channel locale and currency defaults must exist before much of the storefront UI renders
- notification handlers need to exist before interactive flows depend on them
- failures in optional services should degrade gracefully instead of blocking app launch

## Shared Core Layers

### Configuration

- `lib/core/constants/api_constants.dart`
  - endpoint and store metadata

### Networking

- `lib/core/graphql/graphql_client.dart`
  - central GraphQL client factory
  - timeout behavior
  - request logging
  - dynamic header attachment

### Bootstrap

- `lib/core/channel/channel_bootstrap_service.dart`
  - fetches Bagisto channel data
  - persists locale and currency defaults

### Presentation Infrastructure

- `lib/core/navigation/**`
  - navigation helpers and observers
- `lib/core/theme/**`, `lib/core/locale/**`, `lib/core/currency/**`
  - cross-cutting presentation state
- `lib/core/error/error_mapper.dart`
  - converts transport and GraphQL failures into user-facing messages

## Feature Architecture

Each feature generally follows the same shape:

- `data/`
  - models and repositories
- `presentation/bloc/` or Cubits
  - event/state orchestration
- `presentation/pages/` and `widgets/`
  - screens and UI building blocks

Current major feature areas:

- auth
- home
- category
- product
- cart
- checkout
- account
- search
- splash

## State And Data Flow

Normal request flow should look like this:

1. widget dispatches an event or calls a Cubit method
2. BLoC/Cubit invokes a repository
3. repository executes a query or mutation through `GraphQLClientProvider`
4. repository maps response data into feature models
5. BLoC/Cubit emits the next UI state

This keeps transport details out of widgets and keeps repositories focused on API behavior.

## Navigation Architecture

`MainShell` is the main post-launch container.

- it owns the bottom navigation tabs
- it uses an `IndexedStack` to preserve tab state
- it tracks tab history so the back button returns to the previous tab before exiting

Notification routing should integrate with this shell rather than bypass it with duplicate navigation state.

## Token And Persistence Model

### Customer Auth

- `AuthStorage` persists the customer auth token and basic identity fields
- `AuthBloc` reconstructs authenticated state at startup

### Guest Cart

- `CartRepository` owns guest cart token creation and reuse
- guest tokens must not be treated as customer auth tokens

### Locale And Currency

- stored in shared preferences
- seeded from channel bootstrap when missing
- reflected into request headers by the shared GraphQL client

## Notification And Update Behavior

- Firebase and local notifications are optional integrations and should fail softly
- device token management belongs in auth/notification services, not random screens
- app update gating should remain a cross-cutting concern in shared widgets or app shell code

## Native Platform Surface

The app is primarily Flutter-driven, but native configuration still matters for:

- Firebase setup
- permissions
- platform manifests and plist values
- launcher and build configuration

Treat generated platform files as implementation noise unless a change specifically requires them.
