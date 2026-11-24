# API Contracts

## Goal

Document the application-level contracts that must remain stable even as individual queries, mutations, or screens evolve.

## Configuration Contract

`lib/core/constants/api_constants.dart` is the source of truth for:

- `bagistoEndpoint`
- `storefrontKey`
- `channelCode`
- `channelId`
- `companyName`

If configuration moves elsewhere, update this document and the root workflow docs together.

## Request Header Contract

All GraphQL requests should preserve these header rules:

- `Content-Type: application/json`
- `X-STOREFRONT-KEY`
  - always required
- `X-CHANNEL`
  - required for channel-aware storefront behavior
- `X-LOCALE`
  - send when a locale has been selected or bootstrapped
- `X-CURRENCY`
  - send when a currency has been selected or bootstrapped
- `Authorization: Bearer <token>`
  - token meaning depends on the current flow

These headers are attached centrally through the shared GraphQL client stack.

## Client Construction Contract

`GraphQLClientProvider.buildClient(...)` is the preferred application entry point for GraphQL clients.

Required behavior currently includes:

- consistent timeout handling
- a 120-second connection, response, and GraphQL query timeout for all shared clients
- consistent logging
- default no-cache query and mutation policies
- optional authenticated client creation

Do not scatter one-off client construction across repositories unless the repo formally adopts a new shared pattern.

## Auth Contract

Auth flows currently use Bagisto GraphQL mutations through `AuthRepository`.

Expectations:

- login returns a customer token or equivalent API token
- register may return a token and auto-authenticate
- forgot password returns a success message
- logout should clear remote and local token state through the auth workflow

The persisted local auth source of truth is `AuthStorage`.

## Cart Token Contract

Cart flows have a second credential model.

- guest users create and use a cart session token
- authenticated users use the customer auth token
- token switching must stay centralized in `CartRepository`

Do not collapse guest cart and authenticated customer tokens into one generic state without documenting the new model.

## Cart, Checkout, Order, and Invoice Tax Display Contract

- `StoreConfig` queries `taxCartDisplayPrices`, `taxCartDisplaySubtotal`, `taxCartDisplayShipping`, `taxCartShowBreakdown`, `taxOrderDisplayPrices`, `taxOrderDisplaySubtotal`, and `taxOrderDisplayShipping` from Bagisto channel settings.
- **Item Prices (`taxCartDisplayPrices` / `taxOrderDisplayPrices`):**
  - When `'excluding_tax'`: Displays unit price and line total exclusive of tax.
  - When `'including_tax'`: Displays unit price and line total inclusive of tax (`priceInclTax`, `totalInclTax`).
  - When `'both'`: Displays inclusive unit price and line total as primary values, with tax-exclusive amount formatted as `Excl. Tax: <amount>` below each.
- **Subtotal & Shipping (`taxCartDisplaySubtotal` / `taxOrderDisplaySubtotal`, `taxCartDisplayShipping` / `taxOrderDisplayShipping`):**
  - When `'both'`: Displays inclusive subtotal/shipping (`subTotalInclTax`, `shippingAmountInclTax`) as primary value with `Excl. Tax: <amount>` below.
  - When `'including_tax'`: Displays inclusive subtotal/shipping.
  - When `'excluding_tax'`: Displays tax-exclusive subtotal/shipping.
- **Tax Breakdown (`appliedTaxes` & `taxCartShowBreakdown`):**
  - Cart and checkout queries fetch `appliedTaxes` (map of tax name & percentage to formatted amount, e.g. `{"tax-in (20%)": "$42.45"}`).
  - In Cart and Checkout price break summaries, tapping the Tax row expands an accordion listing each applied tax rate and amount.
- **Order & Invoice Parity:**
  - `OrderDetailPage` and `InvoiceDetailPage` respect `taxOrderDisplayPrices`, `taxOrderDisplaySubtotal`, and `taxOrderDisplayShipping`, with full support for `both` and `including_tax`.
- When tax is included in product prices (`hasTaxIncluded`, where `subTotalInclTax > subtotal`), the Tax row indicates `(included)` alongside the tax total.

## Checkout Payment Launch Contract

- The app saves the selected method with `createCheckoutPaymentMethod`, then
  calls `createCheckoutPaymentInitiation` for online methods.
- Initiation `type: redirect` opens `redirectUrl` in the checkout WebView.
- Initiation `type: form` submits `formFields` to `formAction` as an
  `application/x-www-form-urlencoded` POST in the checkout WebView.
- PayPal Standard uses the form flow. The app saves the method, calls
  `createCheckoutPaymentInitiation` through the shared GraphQL client, and reads
  `formAction`, `formFields`, `reference`, `successUrl`, and `failureUrl`.
  After either return URL, it calls `createCheckoutPaymentConfirmation` through
  GraphQL with that reference. A `pending` response with an order ID is retried
  every three seconds; `pending` without an order ID is treated as failure.
  Only `paymentStatus: success` with an order ID opens the app success screen.
- Razorpay returns `type: sdk`; the app opens the native Razorpay checkout
  using the server-provided `sdkData` (`key`, `amount`, `currency`, `order_id`,
  and optional prefill/theme fields). The app does not contain the Razorpay
  secret.
- After Razorpay reports success, the app sends `razorpayOrderId`,
  `razorpayPaymentId`, and `razorpaySignature` to
  `createCheckoutPaymentConfirmation`. Only a successful Bagisto confirmation
  with an order id completes checkout. Cancelled/failed payments are never
  treated by the app as paid orders.
- Stripe uses the shop REST endpoints after saving the selected method:
  `POST /api/shop/checkout-payments/initiate` returns `redirectUrl`,
  `reference`, `successUrl`, and `failureUrl`. The app intercepts either
  return URL and calls `POST /api/shop/checkout-payments/confirm` with the
  same Bearer token and `{reference}`. Only `paymentStatus: success` with an
  `orderId` completes checkout. Pending, failed, or cancelled flows do not
  show success. The deployed API has no Stripe webhook; if the customer closes
  the app before the success return, server order creation may not complete.
- Cash on Delivery and Money Transfer continue to create an order immediately
  after saving the method. Online methods must not call `createCheckoutOrder`
  before server verification.
- For gateways other than PayPal Standard and Stripe, WebView close, provider return URLs,
  and URL text are not proof of payment. The app returns to checkout and asks
  the customer to check Orders; it does not mark those payments successful
  based on a browser event.
- End-to-end online order completion requires a server-confirmed result/status
  contract per gateway. Razorpay and PayPal Standard use GraphQL confirmation;
  Stripe uses reference-based REST confirmation.
  PayU, PhonePe, PayPal Smart Button, and PayGlocal still need a tested
  callback/return and server confirmation flow before the app can claim their
  orders are paid.
- Gateway configuration and currency eligibility remain server-owned. In the
  observed environment, PhonePe rejected the USD cart and PayGlocal returned a
  configuration error; failed initiation is surfaced to the shopper.


## Channel Bootstrap Contract

`ChannelBootstrapService` is responsible for:

- querying Bagisto channel metadata
- caching supported locales and currencies
- applying defaults when no user preference exists
- syncing currency symbols into formatting utilities

If channel bootstrap behavior changes, update both architecture and workflow docs.

## EU Contract Withdrawal Contract

- Logged-in customers use `createEuWithdrawal` to create a withdrawal request.
- Guests use `createGuestEuWithdrawalLink` with `orderIncrementId` and `email`.
- The guest mutation returns `success` and `message` under
  `guestEuWithdrawalLink`; it emails a withdrawal link when the order number
  and email match a guest order.
- Guest requests do not include a reason field.
- Do not substitute the older `createGuestEuWithdrawal` mutation: its input
  type does not accept the guest order number or email.

## Customer RMA Image Evidence Contract

- `createCustomerReturn` accepts evidence images through the `images` input
  list as `data:{mime};base64,...` data URIs.
- The documented maximum is 5 MB per image. Allowed extensions remain governed
  by Bagisto's Sales → RMA configuration.
- Video attachments are not supported by the API/core and must not be sent.

## Error Contract

Repositories may throw transport or GraphQL exceptions, but user-facing messaging should flow through `ErrorMapper` or a documented replacement.

This keeps UI messaging consistent across features.

## Notification Contract

Device-token handling is shared behavior, not a screen-specific responsibility.

- login and register may send the current device token
- logout should clear device-token state through the existing auth/notification workflow
- notification tap payloads should route into existing app navigation paths
