# 2026-10-15: Store config on the `new-setup` server

Follow-up to `2026-10-14-store-config.md`.

- `api_constants.dart` now points at `new-setup`. Its `StoreConfig` has many
  more fields than `bagisto_v2.5.0` (cartSummary, cartPageEnabled,
  miniCartEnabled, miniCartOfferInfo, headerOffer*, captcha, cookie consent,
  return policy, ...).
- Field names differ between servers: `new-setup` has `buyNowButtonEnabled`,
  `bagisto_v2.5.0` had `buyNowEnabled`. The query asks for
  `buyNowButtonEnabled`; `fromJson` accepts both. Asking for a field the
  server lacks fails the whole `storeConfig` query and every flag falls back
  to "on", so validate the query against the target server after any change.
- `cartSummary`: `display_item_quantity` (default, itemsQty, "N Units") or
  `display_number_of_items_in_cart` (itemsCount, "N Items"). Applied to the
  cart tab badge (`main_shell.dart`) and the cart header (`cart_page.dart`
  `_cartSummaryText`). Tests in `test/store_config_test.dart` and
  `test/store_config_cart_test.dart`.
- With `new-setup` configured, `test/home_theme_fixes_test.dart` passes
  (its 2 failures were only against `bagisto_v2.5.0`).

## Cart page toggle (`cartPageEnabled`)

- User decision: no mini cart. When the admin turns the cart page off, the
  app hides every way to put things in the cart or open it:
  - Cart tab (`main_shell.dart`). Tab requests are blocked in
    `resolveMainShellTabRequest(cartPageEnabled:)`, so `AppNavigator.goCart`
    and `navigateToCart` do nothing. If the cart tab was open, Home shows.
  - Header cart icons on category grid and product detail.
  - `ProductActionBar` (Add to Cart + Buy Now) on the product page.
  - Compare page Add to Cart, wishlist Move to Cart, order detail Reorder.
- Header cart badges now also follow `cartSummary`.
- Tests: `test/main_shell_navigation_helper_test.dart`,
  `test/store_config_buy_now_test.dart`, `test/order_detail_page_test.dart`.

## Reviewer name censoring (`reviewerNameCensored`)

- Matches the storefront, not a fixed word: every word but the last is kept,
  the last becomes its first letter + `***` ("H h Bukv" -> "H h B***").
  GraphQL `productReviews.name` is NOT masked by the server (REST
  `/api/product/{id}/reviews` is), so the app masks it with
  `censoredReviewerName()` in `store_config.dart`.
- Applied on product page review cards and the per-product review list
  (`reviews_page.dart`, where `productName` is null).
- Single-word names become "P***" (not verified on the web; no such review).
- Test: `test/store_config_reviewer_name_test.dart`.

## Home static content on `new-setup`

- Bold Collections button now uses the `<button>` text from the admin HTML
  ("View Collections"), falling back to l10n `homeViewAll` when empty.
- `new-setup` section images use `storage/...` paths (not `__media__/`).
  `sections/8` and `sections/12` images return 403 on the server itself, so
  they are blank on the web too: server file permission issue, not the app.

## Login redirect (`loginRedirectTo`)

- `home` -> Home tab, `account` -> Account tab after login or sign-up;
  missing/unknown keeps the current tab. `navigateAfterAuth()` in
  `lib/features/auth/presentation/auth_redirect.dart`, used by
  `login_page.dart` and `sign_up_page.dart`. Test `test/login_redirect_test.dart`.
- Applies even when login was opened from checkout (same as the admin rule).

## Order detail tabs

- Invoices / Shipments tabs show only when the order has some: loaded
  `state.invoices` / `state.shipments`, `order.invoices` / `order.shipments`,
  or an item with `qtyInvoiced` / `qtyShipped` > 0. Refunds stays on
  `totalRefunded > 0`.
- Tabs are an enum (`_OrderTab`), not list indexes, so hidden tabs don't
  shift which content shows. Tests in `test/order_detail_page_test.dart`.

## Refunds tab matches the storefront refund view

- Web refund view: per item Price / Qty / Subtotal (+ booking lines), totals
  Subtotal, Shipping & Handling, Adjustment Refund, Adjustment Fee, Grand Total.
- `new-setup` still has NO refund / credit memo query. App uses only live
  order fields: item `price`, `qtyRefunded`, `amountRefunded`, option lines
  from `additional`; totals `subTotalRefunded`, `shippingRefunded`,
  `taxAmountRefunded` / `discountRefunded` (only when > 0),
  `grandTotalRefunded`. Refund number and adjustments are backend-blocked.
- Removed order-level rows (ordered/shipped/invoiced qty, Total Paid/Due) and
  the unused l10n key `accountRefundedQty`. New keys `accountPrice`,
  `accountQty`.
