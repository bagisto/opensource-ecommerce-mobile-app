# Customer Social Login Implementation Plan

> **For agentic workers:** Implement each task in order. Keep GraphQL requests in the existing repository and use the existing customer auth state and storage.

**Goal:** Let customers sign in through providers listed by `storeConfig.socialLoginProviders`, and never display a provider absent from that configuration.

**Architecture:** Extend the existing public `StoreConfig` query/model with the provider list. A provider adapter obtains an ID token; `AuthRepository` exchanges it through `createSocialLogin`; `AuthBloc` persists the returned Bagisto customer token using `AuthStorage` and emits the existing authenticated state. Login and signup pages render only configured providers for which the app has an adapter.

**Tech Stack:** Flutter, `graphql_flutter`, `flutter_bloc`, existing `StoreConfigCubit`, `AuthRepository`, `AuthBloc`, `AuthStorage`, native provider SDKs.

## Global Constraints

- All GraphQL calls use the existing `GraphQLClientProvider` client and storefront headers.
- Provider tokens and Bagisto customer tokens remain separate; persist only the token returned by Bagisto.
- Never show a social provider unless it appears in `socialLoginProviders` and the app has an implemented adapter for it.
- Empty, missing, or not-yet-loaded provider configuration means show no social-login buttons.
- Do not commit provider secrets or private keys.
- API currently reports `google`, `facebook`, and `linkedin`; do not add other providers without API support.

---

## File Map

- Modify `lib/core/graphql/queries.dart` and `lib/core/store_config/store_config.dart` to fetch, parse, and expose configured social-login providers.
- Modify `lib/features/auth/data/repository/auth_repository.dart`, `lib/core/graphql/auth_mutations.dart`, and `lib/features/auth/data/models/auth_models.dart` for the Bagisto exchange and response mapping.
- Add `lib/features/auth/domain/services/social_auth_service.dart` for provider SDK token acquisition behind an injectable interface.
- Modify `lib/features/auth/presentation/bloc/auth_bloc.dart` and `lib/main.dart` to inject the provider service and orchestrate token acquisition, exchange, persistence, and authenticated state.
- Modify `lib/features/auth/presentation/widgets/social_login_icons.dart`, `lib/features/auth/presentation/pages/login_page.dart`, and `lib/features/auth/presentation/pages/sign_up_page.dart` to render and handle configured provider buttons.
- Modify `pubspec.yaml` and iOS/Android app configuration only for the provider SDKs and client identifiers selected for Google, Facebook, and LinkedIn.
- Add focused tests under `test/` for provider config parsing, API mapping, BLoC behavior, and button visibility.

## Task 1: Read and expose provider configuration

**Files:** `lib/core/graphql/queries.dart`, `lib/core/store_config/store_config.dart`, `test/store_config_social_login_test.dart`

- [ ] Add `socialLoginProviders` to `StoreConfigQueries.getStoreConfig`.
- [ ] Add nullable `List<String> socialLoginProviders` to `StoreConfig`; parse with the existing `_strings` helper so names are trimmed, lowercase, and deduplicated.
- [ ] Add a getter that returns an empty list when config is missing and otherwise returns configured providers supported by app adapters, preserving server order.
- [ ] Add tests for `['google', 'facebook']`, mixed case/whitespace, duplicates, empty list, null, and unknown provider values.
- [ ] Verify no social buttons can render while the list is null or empty.

## Task 2: Add provider-token exchange through existing auth repository

**Files:** `lib/core/graphql/auth_mutations.dart`, `lib/features/auth/data/models/auth_models.dart`, `lib/features/auth/data/repository/auth_repository.dart`, `test/auth_social_login_repository_test.dart`

- [ ] Add the `createSocialLogin(input: createSocialLoginInput!)` mutation requesting `id`, `_id`, `token`, `apiToken`, `firstName`, `lastName`, `email`, `phone`, `isNewCustomer`, `success`, `message`, and `code`.
- [ ] Add a social-login result model that maps nullable response fields and parses the `success` flag safely.
- [ ] Add `AuthRepository.socialLogin(provider, idToken)`; send only `provider` and the provider-issued `idToken`, use `FetchPolicy.noCache`, and preserve the existing shared client.
- [ ] Convert unsuccessful payloads such as `SOCIAL_TOKEN_INVALID` into `AuthException` using the API message; reject a missing customer payload or missing Bagisto token.
- [ ] Add repository tests for successful mapping, provider/token request variables, API failure payload, and malformed response.

## Task 3: Add provider token adapters

**Files:** `lib/features/auth/domain/services/social_auth_service.dart`, `pubspec.yaml`, `ios/Runner/Info.plist`, `ios/Runner/AppDelegate.swift` if required by the selected SDK, `android/app/src/main/AndroidManifest.xml`, `android/app/build.gradle`, and `test/social_auth_service_test.dart`

- [ ] Define an injectable `SocialAuthService` contract that returns a provider ID token for a supported provider, returns a cancellation result when the customer closes sign-in, and throws a typed error for provider failures.
- [ ] Implement adapters for Google, Facebook, and LinkedIn only. Use SDK/OIDC flows that provide the token format the Bagisto API verifies.
- [ ] Before implementation, confirm with server configuration that the `idToken` input accepts the credential returned by each provider SDK, especially Facebook’s native credential format.
- [ ] Configure platform client IDs, URL schemes, and redirect/callback settings from provider console values; keep private secrets outside source control.
- [ ] Add unit tests with fake provider adapters for valid token, cancellation, unsupported provider, and provider error.

## Task 4: Reuse existing customer auth state

**Files:** `lib/features/auth/presentation/bloc/auth_bloc.dart`, `lib/main.dart`, `test/auth_social_login_bloc_test.dart`

- [ ] Inject `SocialAuthService` into `AuthBloc` from `main.dart` alongside the existing `AuthRepository`.
- [ ] Add `AuthSocialLoginRequested` carrying the configured provider name; keep provider SDK calls out of widgets.
- [ ] In `AuthBloc`, get the provider ID token from `SocialAuthService`, then call `AuthRepository.socialLogin`; choose `token` then `apiToken` as existing customer login does; reject empty token.
- [ ] Persist only the Bagisto token and returned customer identity through `AuthStorage.saveToken` and `saveUserInfo`.
- [ ] Emit existing `AuthAuthenticated` so current cart merge, navigation, and account refresh listeners continue to run.
- [ ] Emit `AuthError` for rejected/expired provider tokens; cancellation must not emit an error or alter an existing session.
- [ ] Test successful auth state and persistence, server rejection, and cancellation.

## Task 5: Render and handle only configured providers

**Files:** `lib/features/auth/presentation/widgets/social_login_icons.dart`, `lib/features/auth/presentation/pages/login_page.dart`, `lib/features/auth/presentation/pages/sign_up_page.dart`, `test/social_login_config_visibility_test.dart`

- [ ] Change `SocialLoginIcons` to accept the configured provider list and a provider-tap callback; map only Google, Facebook, and LinkedIn to their correct assets and accessible labels.
- [ ] Replace the currently commented social-login sections in Login and Sign Up with the shared widget, using `StoreConfig.of(context)`.
- [ ] Preserve API order and render no divider, label, or buttons when the filtered provider list is empty.
- [ ] On tap, dispatch `AuthSocialLoginRequested` with the selected provider; leave existing email/password and registration paths unchanged.
- [ ] Add widget tests confirming configured providers appear, absent providers do not appear, empty/null config hides the whole social-login section, and tap dispatches the selected provider.

## Task 6: Verify platform flows and documentation

**Files:** `aidocs/engineering/06-api-contracts.md`, `aidocs/engineering/12-testing-strategy.md`, relevant tests and platform config files

- [ ] Document `socialLoginProviders`, the provider ID-token exchange, supported provider names, and the rule that an absent/empty list hides social login.
- [ ] Run targeted tests for store config, repository, BLoC, and login/signup visibility, then run `dart analyze` on touched files.
- [ ] Manually smoke-test iOS and Android with valid provider credentials: provider consent, Bagisto token exchange, authenticated state restoration, and guest-cart merge.
- [ ] Verify config variants: all three providers, one provider, empty list, API config failure, and an unrecognized provider.
- [ ] Run `graphify update .` after implementation; note the repo’s existing graph visualization size cap if refresh fails.

## Known prerequisite

The live configured API returned `socialLoginProviders: ["google", "facebook", "linkedin"]`. Its `createSocialLogin` mutation returned `SOCIAL_TOKEN_INVALID` for a deliberately invalid token, confirming that the operation is exposed and validates credentials. A valid-token login was not tested. Provider client IDs/callback configuration and the exact token type accepted for each SDK must be confirmed before platform sign-in can pass end to end.
