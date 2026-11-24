# Agent Guide

## Purpose

This file explains how to work safely in this Bagisto Flutter codebase while implementing or maintaining storefront behavior.

## Mandatory Graphify Rule

- Read `graphify-out/GRAPH_REPORT.md` before non-trivial codebase analysis.
- Use graphify communities and god nodes to choose which files to inspect first.
- Run `graphify update .` after meaningful code changes before final conclusions.
- Treat graphify as required workflow, not optional tooling.

## Project Summary

This app is a Bagisto storefront client built with Flutter. It boots store configuration, renders the home and category experience, supports product detail and cart flows, authenticates customers, exposes account screens, and handles FCM notification-driven navigation.

## Primary Runtime Flow

1. `main.dart` initializes Flutter bindings.
2. Firebase and background messaging are registered.
3. Hive cache initialization is attempted.
4. Shared preferences are loaded.
5. `ChannelBootstrapService` fetches channel data and establishes locale/currency defaults.
6. `FCMService` initializes foreground, background, and tap handlers.
7. The app builds repositories, blocs, and root navigation.
8. `AuthBloc` checks persisted auth state through `AuthStorage`.
9. `MainShell` hosts the primary tabs: Home, Categories, Cart, and Account.
10. Feature repositories fetch or mutate Bagisto GraphQL data and BLoCs translate those results into UI state.

## Codebase Map

### Bootstrap And Core

- `lib/main.dart`
  - composition root, startup initialization, notification routing
- `lib/core/constants/api_constants.dart`
  - endpoint, storefront key, channel code, channel id
- `lib/core/graphql/graphql_client.dart`
  - shared client construction, timeouts, request logging, dynamic headers
- `lib/core/channel/channel_bootstrap_service.dart`
  - locale/currency bootstrap from Bagisto channel data
- `lib/core/error/error_mapper.dart`
  - user-facing error translation

### Feature Data And State

- `lib/features/auth/**`
  - auth mutations, persistence, auth bloc
- `lib/features/home/**`
  - homepage section loading and orchestration
- `lib/features/category/**`
  - category listing, filters, product grids
- `lib/features/cart/**`
  - guest/auth cart lifecycle and mutations
- `lib/features/account/**`
  - account, orders, reviews, address book, compare, wishlist
- `lib/features/search/**`
  - text search plus image/ML-assisted search
- `lib/features/checkout/**`
  - checkout-specific data and presentation

### Navigation And Experience

- `lib/features/home/presentation/pages/main_shell.dart`
  - root tab shell and tab history
- `lib/core/navigation/**`
  - app-level navigation helpers and route observation
- `lib/core/widgets/app_update_gate.dart`
  - in-app update guard behavior

### Notifications And Platform Integration

- `lib/core/notifications/**`
  - Firebase setup, token handling, local notification behavior
- `android/**`, `ios/**`, `web/**`
  - platform configuration and runtime integration points

### Verification

- `test/**`
  - unit and widget coverage
- `maestro/**`
  - Android E2E flow coverage

## Source Of Truth Rules

### Endpoint And Headers

- `bagistoEndpoint` and `storefrontKey` come from `lib/core/constants/api_constants.dart`.
- `GraphQLClientProvider` owns default headers and client policy.
- Locale and currency request headers must reflect persisted user choice or channel defaults.

### Auth

- `AuthStorage` persists the customer auth token and basic profile fields.
- `AuthBloc` is the source of truth for current authenticated state inside the running app.
- Logout must clear auth storage and related device-token state through the existing auth and notification layers.

### Cart

- `CartRepository` owns guest-cart token handling and cart mutations.
- Guest session tokens and authenticated customer tokens are different credentials and must stay separate.
- New cart flows should keep token switching logic centralized instead of duplicating it in UI code.

### Locale And Currency

- `ChannelBootstrapService` seeds defaults from the Bagisto channel query.
- `SharedPreferences` persists the selected locale and currency.
- `CurrencyFormatter` and related cubits should remain aligned with stored preference values.

## Working Style

- Prefer the existing repository plus BLoC or Cubit pattern.
- Keep networking and mapping logic out of widgets when possible.
- Make small, reversible changes.
- Update docs when you change source-of-truth behavior.
