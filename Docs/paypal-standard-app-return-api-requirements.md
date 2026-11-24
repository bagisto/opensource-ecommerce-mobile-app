# PayPal Standard: API contract for automatic app return

The server team reports PayPal Standard now uses the same reference-based
return flow as redirect gateways. The app must intercept the WebView return
and confirm payment without waiting for the customer to close the WebView.

The server contract is:

- `POST /api/shop/checkout-payments/initiate` returns `formAction`,
  `formFields`, `reference`, `successUrl`, and `failureUrl`.
- After either return URL loads, the app calls
  `POST /api/shop/checkout-payments/confirm` with the same Bearer token and
  `{ "reference": "<reference from initiation>" }`.
- `paymentStatus: success` with an order ID means the app may show success.
- `paymentStatus: pending` with an order ID means retry confirmation every few
  seconds. `pending` without an order ID means payment was cancelled or not
  completed. An empty confirmation body is no longer valid for this flow.

The app shows its success screen only after the API confirms payment and
returns the order. Failure, cancellation, or manually closing the WebView must
not be treated as success.
