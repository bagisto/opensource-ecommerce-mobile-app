# Stripe API contract used by the app success screen

The app should show its own order success screen only after Bagisto confirms
that Stripe payment succeeded and returns the created order. Returning from or
closing the WebView is not proof of payment.

## APIs used by the app

### `POST /api/shop/checkout-payments/initiate`

For Stripe, return:

- `redirectUrl`: Stripe checkout URL for the app's WebView.
- `reference`: unique server-generated payment reference tied to this checkout.
- `successUrl` and `failureUrl`: return URLs the app can detect in the WebView.

The app uses a return URL only as a signal to request confirmation. The URL
itself must not mean that payment succeeded. Please agree the URL format with
the app team and ensure Stripe redirects to it after processing the payment.

### `POST /api/shop/checkout-payments/confirm`

Accept the `reference` from initiation and return:

- `paymentStatus`: `success`, `pending`, or a documented failure status.
- `orderId` and `orderIncrementId` when the verified order exists.
- A useful message for pending or failed confirmation.

The server must verify the payment with Stripe and ensure the Bagisto order
exists before returning `paymentStatus: success`. Repeated confirmation calls
for one reference must be safe. If verification or order creation is still
pending, return `pending` without an order ID.

## App success-screen flow

1. App initiates Stripe and opens `redirectUrl` in its WebView.
2. App detects the agreed success/failure return URL and sends the returned
   `reference` to `createCheckoutPaymentConfirmation`.
3. App shows its success screen and order number only when confirmation returns
   `paymentStatus: success` with an order ID.
4. For pending, failed, or cancelled payments, the app does not show success
   and keeps the customer on a retry/checkout path.

The app sends `{ "reference": "<reference from initiation>" }` to confirmation
with the same Bearer token. The server verifies the payment and creates the
Bagisto order before reporting success. Never send Stripe secret keys or card
details to the app.

## Verified live response

On 2026-11-04, Stripe initiation returned `method`, `type`, `reference`,
`redirectUrl`, `successUrl`, `failureUrl`, `formAction`, `formFields`, and
`sdkData`. Confirmation for an unpaid session returned `paymentStatus: pending`
with null order IDs. A completed payment was not tested.

The app calls these REST endpoints for Stripe. Other payment methods retain
their existing request paths.
