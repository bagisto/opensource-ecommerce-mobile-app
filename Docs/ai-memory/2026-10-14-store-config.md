# 2026-10-14: Store config (admin settings from the API)

Branch: `fix/storefront-configuration`. Spec and plan:
`Docs/superpowers/specs/2026-10-14-store-config-design.md`,
`Docs/superpowers/plans/2026-10-14-store-config.md`.

## What changed

- Bagisto now exposes `storeConfig` (public GraphQL query, also
  `GET /api/shop/store-config`). Before this, admin toggles were treated as
  backend-blocked (see the v2.5.1 CHANGELOG note).
- `lib/core/store_config/`: `StoreConfig` (model + `StoreConfig.of(context)`),
  `StoreConfigRepository`, `StoreConfigCubit`. Provided in `main.dart` and
  reloaded in the locale and currency listeners.
- Every flag is nullable. `null` = the API did not answer, keep today's
  behaviour. `== false` hides a feature; `== true` turns on minimum order.
  Never invent a value in the app.
- `StoreConfig.of` returns an empty config when no cubit is provided, so
  widget tests that do not provide the cubit keep working.

## Where each flag is applied

- `wishlistEnabled`: home cards, category grid/list, product grid section,
  search results, product action row, cart header + item heart, Account menu,
  dashboard `WishlistSection`, compare page heart.
- `compareEnabled`, `socialShareEnabled`: product action row (whole row hides
  when wishlist, compare and share are all off); Compare in Account menu.
- `imageSearchEnabled`: search page Image Search button.
- `customerReviewEnabled` / `guestReviewEnabled`:
  `lib/features/product/presentation/widgets/review_entry.dart`
  (`reviewEntryFor`): customer off = hidden; guest off = sign-in prompt
  (hidden if customers can't review either).
- `guestCheckoutEnabled`: cart `_guestCheckoutAllowed` checks it before the
  per-product `guestCheckout` lookup.
- `minimumOrder*`: cart bottom bar shows `minimumOrderMessage` (or l10n
  `cartMinimumOrderAmount`) and dims Pay Now. Compared total = subtotal,
  minus discount / plus tax per the include flags.
- `reorderEnabled`: order detail bottom bar.
- `newsletterEnabled`: Edit Account checkbox; sign-up now sends
  `subscribedToNewsLetter` = `showNewsletter` (was always `true`).

## Not done

- `reviewerNameCensored`: the masking format is not documented (only a
  paid Webkul "Verified Reviews" extension mentions it) and the local server
  had no approved reviews to compare. Waiting on the user.
- Still not in the API: Buy Now toggle, cart summary mode, cart page toggle,
  redirect after login, header / mini cart offer texts.
- GDPR requests flow (job B): not built yet. EU withdrawal already exists.

## Gotchas

- `test/home_theme_fixes_test.dart` has 2 failures on a clean tree when
  `api_constants.dart` points at the local server (skip-worktree file).
- The `new-setup` server uses a different storefront key; the
  `bagisto_v2.5.0` key returns "Invalid API key" there.

## 2026-10-15: Recent Orders opened the wrong order

- Symptom: dashboard Recent Orders tap showed `Customer order with ID "2"
  not found`; the same order opened fine from My Orders.
- Root cause: `recent_orders_section.dart` passed `incrementId` (the order
  number) to `OrderDetailPage`, but `customerOrder` needs the database id
  (`_id`, IRI `/api/shop/customer-orders/{id}`).
- Fix: `RecentOrder.numericId` (from `_id`, else the IRI tail) is used for
  navigation. Tests: `test/recent_orders_section_test.dart`,
  `test/account_models_test.dart`.

## 2026-10-15: When store config reloads

- App start (from a killed state), language change, currency change, and
  home pull-to-refresh (`lib/features/home/presentation/home_refresh.dart`,
  test `test/home_refresh_test.dart`). Resuming from background does not
  reload; the user chose that.

## 2026-10-15: Home static content showed HTML tags and no images

- Raw `<a href="#active-wear">Our Collections</a>` on collection cards: the
  admin put a link inside the card `<h3>`, and the widget used the inner HTML
  as text. All section titles/descriptions now go through `_plainText`.
- Images: section HTML uses `data-src="__media__/themes/..."`. The web
  renders `__media__/` as `<public>/storage/`; `_getFullUrl` now does the
  same. Test: `test/static_content_sections_test.dart`.

## 2026-10-15: Order detail never showed Withdraw / Return

- `AccountQueries.getCustomerOrder` did not select the order `id` / `_id`,
  so `OrderDetail.numericId` was always null. `_checkEuWithdrawal` returned
  early (no "Withdraw from Contract" button) and the return eligibility
  match (`o.numericId == order.numericId`) never matched.
- Fix: query selects `id` and `_id`. Test `test/customer_order_query_test.dart`
  parses the query, because widget fixtures include `_id` and hid the bug.

## 2026-10-15: Buy Now toggle

- Backend added `storeConfig.buyNowEnabled` (admin "Allow Customer to
  Directly Buy Product"). The user quoted `buyNowButtonEnabled`; the server
  schema only has `buyNowEnabled`, so the GraphQL query asks for that.
  `StoreConfig.fromJson` accepts either key.
- `ProductActionBar` hides Buy Now when `showBuyNow` is false; Add to Cart
  then fills the row. Test: `test/store_config_buy_now_test.dart`.
- Cart summary mode (item qty vs item count) is still not in the API.
