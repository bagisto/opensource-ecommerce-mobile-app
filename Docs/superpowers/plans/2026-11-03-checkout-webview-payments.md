# Checkout WebView Payments Implementation Plan

> **For agentic workers:** Use the repository's approved implementation workflow and complete the tasks in order. Keep each gateway behind the shared checkout repository and BLoC boundaries.

**Goal:** Integrate Stripe, PayU, PhonePe, PayPal Standard, and PayGlocal checkout payments in the Flutter app using the gateway URL/form data returned by Bagisto, then show an order as placed only after server confirmation.

**Architecture:** Keep GraphQL calls in `CheckoutRepository`, payment progress in `CheckoutBloc`, and WebView lifecycle/UI in a dedicated checkout payment page/widget. The server remains authoritative for verification and order creation; the app must never infer successful payment only from a browser URL or user closing the WebView.

**Tech Stack:** Flutter/Dart, `graphql_flutter`, `flutter_bloc`, existing `flutter_inappwebview`, Bagisto GraphQL checkout mutations.

## Global Constraints

- Use `GraphQLClientProvider.buildClient(...)` and preserve the shared storefront key, channel, locale, currency, and cart/customer token behavior.
- Do not send gateway secret keys to the app.
- Preserve the existing COD and Money Transfer checkout behavior.
- For online methods, do not call `createCheckoutOrder` before the backend confirms payment.
- A WebView return/cancel URL is a navigation signal only; the server must verify payment before the app displays success.
- Do not enable a gateway in the app when the server reports initiation/configuration/currency errors.

---

## Current Checkout Touchpoints

- `lib/core/graphql/checkout_queries.dart`: currently defines `createCheckoutPaymentMethod` and `createCheckoutOrder`; add payment initiation and any confirmed status/confirmation documents here.
- `lib/features/checkout/data/models/checkout_model.dart`: currently parses `paymentGatewayUrl` and string `paymentData`; extend this to represent initiation modes and fields safely.
- `lib/features/checkout/data/repository/checkout_repository.dart`: owns payment selection and order mutations; add initiation and server confirmation/status calls.
- `lib/features/checkout/presentation/bloc/checkout_bloc.dart`: current Place Order saves the method then immediately creates the order; split this into offline and online paths with explicit payment states.
- `lib/features/checkout/presentation/pages/checkout_page.dart`: owns checkout UI and currently dispatches Place Order; route successful online initiation into the payment page.
- `lib/features/checkout/presentation/pages/`: add a dedicated payment WebView page (or a focused page under a new `payment/` subfolder).
- `pubspec.yaml`: `flutter_inappwebview` is already present; no dependency addition is planned unless implementation discovers a concrete missing capability.
- `test/features/checkout/`: add model, repository, and BLoC tests following existing checkout test conventions.
- `aidocs/engineering/06-api-contracts.md` and `plan.md`: document the confirmed payment lifecycle and API semantics after implementation.

## Backend Contract Gate

Before app implementation, confirm these details with the API owner. Current collection/live observations do not establish all completion contracts:

1. For each of Stripe, PayU, PhonePe, PayPal Standard, and PayGlocal, document the exact `createCheckoutPaymentInitiation` response shape and whether the client should navigate, submit a POST form, or use another mode.
2. Specify the trusted server callback/return URL for success, cancellation, and failure, and how the app can ask Bagisto whether payment is verified.
3. Specify which API creates the order after payment. In particular, confirm if `createCheckoutPaymentConfirmation` supports each gateway or if a server-side webhook/callback creates the order without a client confirmation mutation.
4. Confirm server-side payment verification (PayU hash, PhonePe/PayGlocal callback verification, PayPal transaction verification, Stripe webhook) and idempotency behavior for retries or duplicate callbacks.
5. Resolve current store setup blockers: PhonePe rejects the observed USD cart and requires INR; PayGlocal and PayPal Smart reported not configured; PayU returned form data but web checkout returned to cart.
6. Confirm all callbacks are reachable from a mobile device. The observed `192.168.15.90` host is LAN-only and cannot serve as a production/public callback origin.

Do not implement a speculative success detector if the backend cannot provide a verified result/status contract. The WebView can be integrated as a launch surface while waiting, but the app must not create an online order or show payment success on an unverified return.

## Tasks

### Task 1: Lock down payment API contract and gateway configuration

**Files:**
- Review: `lib/core/graphql/checkout_queries.dart`
- Review: `lib/features/checkout/data/repository/checkout_repository.dart`
- Review: `Bagisto-Shop-API.postman_collection.json` supplied by the user
- Document outcome in: `aidocs/engineering/06-api-contracts.md`

- [ ] Record the initiation mode and exact response keys for each of the five methods.
- [ ] Record how each method signals server-verified success, failure, and cancellation.
- [ ] Verify gateway sandbox credentials and accepted cart currencies on the server.
- [ ] Do not start implementation of a gateway lacking a confirmed launch and verification contract.

**Acceptance:** There is a written contract mapping each payment method to an initiation response, WebView action, return/callback signal, and authoritative server verification action.

### Task 2: Model initiation responses and repository operations

**Files:**
- Modify: `lib/core/graphql/checkout_queries.dart`
- Modify: `lib/features/checkout/data/models/checkout_model.dart`
- Modify: `lib/features/checkout/data/repository/checkout_repository.dart`
- Test: `test/features/checkout/data/models/`
- Test: `test/features/checkout/data/repository/`

- [ ] Add `createCheckoutPaymentInitiation` GraphQL document selecting `method`, `type`, `redirectUrl`, `formAction`, `formFields`, and `sdkData` as supported by the live schema.
- [ ] Replace loosely typed payment initiation parsing with a model that safely handles nulls and scalar/object JSON forms without logging secrets or payment payload values.
- [ ] Add repository methods to initiate payment and call the confirmed server-side verification/status API. Keep all requests on the existing GraphQL client and token/header path.
- [ ] Preserve `savePaymentMethod` as the selection step; do not treat its `paymentGatewayUrl` as proof of payment or as a substitute for initiation data.
- [ ] Add parsing tests for redirect, form, null/offline, and GraphQL error responses.

**Acceptance:** Repository returns typed launch instructions and typed verified payment outcomes, with tests covering the response variants seen in the collection and live API.

### Task 3: Add a reusable payment WebView surface

**Files:**
- Create: `lib/features/checkout/presentation/pages/checkout_payment_page.dart` (or the established checkout payment subfolder)
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Test: `test/features/checkout/presentation/`

- [ ] Use the existing `flutter_inappwebview` dependency to display the gateway flow.
- [ ] Support `redirect` by loading the server-returned redirect URL.
- [ ] Support `form` by submitting `formAction` with the returned `formFields` using the HTTP method/encoding specified by the backend contract; do not flatten form data into a GET URL.
- [ ] Restrict navigation handling to the gateway hosts and Bagisto callback hosts required by the flow; route external navigation only when the backend contract explicitly requires it.
- [ ] Show progress and a retry/close affordance. Treat back/close as cancellation pending server status verification, never as a successful payment.
- [ ] On a recognized callback URL, stop WebView navigation and pass the callback result to the BLoC/repository for server verification.

**Acceptance:** A mock redirect and form response can be launched in the WebView; an arbitrary URL containing words like `success` cannot mark an order paid.

### Task 4: Split offline order placement from online payment lifecycle

**Files:**
- Modify: `lib/features/checkout/presentation/bloc/checkout_bloc.dart`
- Modify: `lib/features/checkout/presentation/pages/checkout_page.dart`
- Modify: `lib/features/checkout/presentation/pages/thankyou_page.dart` only if verified order response data requires it
- Test: `test/features/checkout/presentation/bloc/`

- [ ] Keep COD and Money Transfer on the existing save-method → create-order path.
- [ ] For the five online methods, save selection → initiate payment → open WebView using typed launch data; do not call `createCheckoutOrder` at this stage.
- [ ] Add explicit BLoC states for initiating, waiting in WebView, verifying, placed, cancelled, and failed payment.
- [ ] After WebView return, query/confirm through the server contract. Navigate to the thank-you page only after verified order success.
- [ ] On cancellation or failure, preserve the cart and checkout selections, clear loading state, display a useful message, and allow retry without duplicate order creation.
- [ ] Make confirmation/order creation idempotent from the client perspective by guarding repeated taps and stale callbacks.
- [ ] Add BLoC tests for offline placement, online launch, verified success, cancellation, gateway error, and duplicate callback/tap cases.

**Acceptance:** Offline checkout remains unchanged; an online order is shown as successful only after the backend returns verified success and an order identifier.

### Task 5: Enable gateways by verified mode and resolve server blockers

**Files:**
- Modify only if required: checkout method presentation and payment mode mapping in `lib/features/checkout/**`
- Update: `aidocs/engineering/06-api-contracts.md`

- [ ] **Stripe:** use the initiation redirect; require server webhook/status verification before thank-you navigation.
- [ ] **PayU:** submit returned form fields to `formAction`; require server-side hash/callback verification. Resolve why the observed web flow returned to cart before enabling.
- [ ] **PhonePe:** test only after the store/cart currency matches the gateway's INR requirement; use redirect and verify callback/status on the server.
- [ ] **PayPal Standard:** submit the returned form; process the documented return/confirmation path and ensure the pending order becomes paid only after PayPal verification.
- [ ] **PayGlocal:** configure merchant/key values and accepted currencies on the server, then use redirect and verified callback/status.
- [ ] Keep a method disabled or show a clear server error when its initiation response is missing, unsupported, misconfigured, or currency-ineligible.

**Acceptance:** Each method is enabled only after a successful sandbox launch, verified callback/status, and exactly one resulting order. A method with failed prerequisites remains unavailable with a clear message.

### Task 6: Update documentation and complete checkout verification

**Files:**
- Modify: `aidocs/engineering/06-api-contracts.md`
- Modify: `plan.md`
- Add/update: checkout unit/widget tests and Maestro flow only where existing checkout coverage supports it

- [ ] Document the final GraphQL operations, response modes, callback verification path, token/header behavior, and gateway-specific constraints.
- [ ] Run focused checkout model/repository/BLoC tests, Flutter analyze for touched files, then relevant Maestro checkout flow if the environment and sandbox allow it.
- [ ] Verify COD/Money Transfer still place orders through the original path.
- [ ] Run `graphify update .` after implementation changes.
- [ ] Test online gateways in sandbox only; never complete a live charge as part of routine verification.

**Acceptance:** The docs match the implemented server contract; focused checks pass or remaining external gateway/server blockers are recorded with exact symptoms.

## Self-Review

- Covers the five requested online methods, including each observed blocker and launch mode.
- Keeps app success dependent on server verification and separates offline from online order creation.
- Identifies repository, BLoC, WebView, model, GraphQL, tests, and documentation touchpoints.
- No application code has been changed by creating this plan.
