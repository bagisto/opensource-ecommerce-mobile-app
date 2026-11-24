# Buy Now Direct Checkout Design

## Goal

When a customer taps Buy Now on product details, take them to Checkout after the selected product is added to cart. Do not show the Cart screen first.

## Design

- Keep the existing cart mutation and all product-specific payloads unchanged, including variants, grouped items, bundles, bookings, downloadable links, and customizable options.
- Wait for cart success before navigating. Cart errors and product validation errors stay on the product page.
- Reuse the guest checkout eligibility rule already used by Cart Pay Now.
- Select the Cart tab underneath Checkout so Back returns to the current cart. Keep Add to Cart behavior unchanged.

## Navigation And State

The product action bar observes the existing `CartBloc` success state. On success, it checks guest eligibility when needed, pops the product route to the shell, selects Cart, and pushes the existing `CheckoutPage` with the existing `CartBloc` and `AuthBloc` instances. `CheckoutPage` creates its own `CheckoutBloc` as it does when opened from Cart.

## Error Handling

Cart mutation errors remain handled by the existing listener. A guest who cannot check out follows the existing message and login flow. Buy Now does not navigate on validation failure or cart failure.

## Scope

No GraphQL operation, payload, token handling, or checkout form behavior changes.
