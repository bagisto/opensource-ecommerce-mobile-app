# AI memory: QA issue fixes (2026-09-30)

Context for AI agents and developers who pick up this work later. It records
what was fixed for the QA issue export of 2026-09-30, why, where the code
lives, and what is still open. Read it before changing any of the areas below.

- Branch: `core/issue-fixes` (changes are uncommitted; the user commits
  manually).
- Source: GitLab export `bagisto-mobile-marketplace-app-flutter_issues_2026-09-30.csv`
  (52 open issues, #15 to #120).
- Backend used for checks: `https://api-demo.bagisto.com/api/graphql`.
- Result: 37 fixed in the app, 3 partly fixed, 12 blocked on the backend.
  `flutter test` passed 286 of 286 (before: 204 passed, 11 failed).
  `flutter analyze` stayed at the 48 pre-existing issues.

## Rules that shaped these fixes

1. **No hardcoded data.** The user asked that every value come from the API.
   If the API has no field for an admin setting, the issue is reported as
   backend-blocked. Do not add app-side constants or build flags to fake
   admin toggles. UI-only mappings (icon class to Material icon, layout
   sizes) are fine.
2. **The GraphQL API exposes no core-config query.** There is no way to read
   admin settings such as wishlist on/off, Buy Now, compare, image search,
   social share, guest checkout (global), cart summary mode, redirect after
   login, or header offer text. Check the schema again before assuming this
   changed.
3. **Never commit or push.** The user commits manually.

## Gotchas learned

- **`FetchPolicy.cacheAndNetwork` gives stale data.** With graphql 5.x,
  `client.query()` returns the cached result first; the network result only
  updates the cache. Admin edits then appear only on the second load. Home
  repository queries now use `networkOnly`
  (`lib/features/home/data/repository/home_repository.dart`). Other
  repositories still use `cacheAndNetwork`; apply the same fix if QA reports
  "admin change not reflected".
- **Test fixtures must include every queried field.** The normalizing cache
  throws `PartialDataException` when a mock response lacks a field the query
  selects. After adding a field to a query, add it to the fixtures
  (see `test/category_status_filter_test.dart`,
  `test/category_tab_categories_test.dart`).
- **`ErrorMapper` hides long GraphQL errors.** Unreadable server messages
  (long, containing `null`, `Exception`, or `::` translation keys) become the
  generic text. The step context is now kept ("Something went wrong while
  saving your address book"), see `lib/core/error/error_mapper.dart`.
- **Validate query strings against the live schema.** Validation errors come
  back even without auth, so a query can be checked with a plain `curl`
  without side effects. That check found three broken queries (see "Other
  fixes").
- **Locale codes from the API can be upper case** (`AR`). Compare locale
  codes case-insensitively.
- **Bagisto weekday numbering is 0 = Sunday to 6 = Saturday.** Dart's
  `DateTime.weekday` is 1 = Monday to 7 = Sunday; convert with
  `weekday % 7`.
- **Tooling:**
  - graphify's AST cache lands in `lib/graphify-out/` if `cache_root` is
    `lib`. Move it out; it must not live in `lib/`.
  - `dart format` on large existing files creates unrelated diff noise, so
    edit without reformatting whole files.
- **l10n:** new keys go into all 10 arb files, appended at the end
  (`app_ru.arb` and `app_uk.arb` use compact one-line metadata; do not
  re-serialize them). Run `flutter gen-l10n` afterwards.

## Fixed issues

### Home and category

- **#19 Services Content not shown.** The `services_content` theme type was
  ignored. Added `HomeService.listFromOptions` and
  `ServicesContentSection` (`lib/features/home/presentation/widgets/services_content_section.dart`).
- **#33 / #46 Category carousel empty or shows child categories.** The home
  categories query had no `first` and no `parent`. It now requests `first: 100`
  and `parent { _id }`, keeps only direct children of the carousel's
  `parent_id` filter, and applies its `limit` (`HomeRepository.fetchHomeCategories`,
  `HomeBloc._doLoad`).
- **#32 Home category tap used a different flow.** A new `ShowCategory` event
  in `CategoryBloc` selects the category in the Categories tab; home taps call
  it and switch tabs.
- **#44 Banner tap did nothing.** `ImageCarousel.onBannerTap`,
  `BannerImage.linkSlug` / `homeLinkSlug`, and `HomePage._openLink` resolve
  the slug in this order: top-level category, then sub-category, then
  product URL key.
- **#26 / #27 Bold Collection and Game Container links.** `StaticContentWidget`
  now follows `<a href>` links in admin HTML (`firstHref`, `imageLinks`,
  `onLinkTap`). The Game Container HTML (`collection-card-wrapper`) is
  rendered like Top Collections. The demo HTML has no links; the admin must
  add them.
- **#66 Product rows looked unscrollable.** Card width is now
  `(w - 64) / 2.3`, so part of the third card shows.
- **#23 / #31 Category description missing.** `description` is now in
  `getCategoryTabCategories`; `CategoryModel.plainDescription` strips the
  HTML, and `CategoryPage` shows it. The hardcoded "Up to 50% off" text was
  already removed before this work.
- **Theme locale.** `ThemeCustomization.fromJson` matches locale codes
  case-insensitively.

### Checkout and cart

- **#40 (critical) "Something went wrong" after saving the address.**
  - Root cause: the address-book save (`createAddUpdateCustomerAddress`) sent
    `useForShipping`, which is not in the input type. The server rejected it
    with a long validation message, `ErrorMapper` turned that into the
    generic text, and the bloc still marked the address as saved.
  - Commit f2faac9 had already removed the field; QA tested an older build.
  - Hardening added:
    - `ErrorMapper` keeps the step context.
    - `CheckoutBloc` keeps the shipping rates when auto-saving the first
      method fails.
    - `test/checkout_address_sheet_test.dart` now asserts the field is
      absent.
- **#43 Coupon text cleared while applying.**
  - The cart page clears the field only after a failed apply, or when an
    applied coupon is removed.
  - Checkout clears it only after a failed coupon attempt
    (`_couponApplyPending`).
- **#45 Guest checkout.** Before a guest checks out, `CartRepository.guestCheckoutAllowed`
  reads `Product.guestCheckout` for each cart product. Only an explicit `0`
  blocks; an empty value means "not set". A blocked guest is sent to
  `LoginPage`. The global admin toggle is not in the API.
- **#53 Suspended customer can check out.** `CheckoutRepository.isCustomerSuspended`
  reads `readCustomerProfile.isSuspended`. `CheckoutState.isAccountSuspended`
  blocks the checkout steps and Place Order, and a notice is shown instead.
- **#87 Order uses the typed email.** `applyCustomerEmail` replaces
  `billingEmail` / `shippingEmail` with the account email for logged-in
  customers, and the form is prefilled with it. The backend should also set
  `customer_email` from the logged-in customer.
- **#84 Booking quantity showed "N/A".** Cart and checkout now show
  `item.quantity` (new key `cartQtyValue`).
- **#118 Over-quantity booking reported as added.**
  - `CartRepository.parseAddToCartPayload` throws the server message when
    `addProductInCart.success` is false.
  - The event-ticket stepper is capped at `ticket.qty`.
- **#120 No strikethrough price.** `ProductModel` and `HomeProduct` now strike
  through `regularMinimumPrice` when it is above `minimumPrice`. This covers
  configurable products, bundles, catalog rules and special prices.
  `ProductCore` now fetches `regularMinimumPrice` and
  `formattedRegularMinimumPrice`.

### Orders, returns, account

- **#35 Shipment details not visible.**
  - `getCustomerOrderShipment` declared `$id: Int!`; the API needs `ID!` (the
    IRI `/api/shop/customer-order-shipments/{id}`).
  - The Shipments tab header used the "Invoiced" string; it now uses the new
    key `accountShippedCount`.
- **#36 / #59 Return option non-functional or missing.**
  - The return order picker now uses `returnableOrders`, keeping only orders
    with `returnableQty > 0` (`AccountRepository.getReturnableOrders`).
  - Items with nothing left to return are hidden.
  - The order detail page shows "Request a Return" when the order is
    returnable (`OrderDetailState.returnableOrder`), and
    `CreateReturnPage.navigate(order:)` opens with that order selected.
- **#37 Cart badge stale after Reorder.** The order detail listener
  dispatches `LoadCart` on reorder success.
- **#56 Cancel failure hid the order.** Failed reorder or cancel now keeps
  `status: loaded` and shows the message as a snackbar
  (`OrderDetailBloc._afterActionStatus`).
- **#58 Pull-to-refresh.**
  - Added on the profile menu and dashboard (`RefreshAccountDashboard.completer`),
    and on orders, wishlist, reviews and downloadable products.
  - Uses the shared helper `lib/core/utils/bloc_refresh.dart` and
    `AlwaysScrollableScrollPhysics`.
- **#65 Refund breakdown.** The order query now fetches the subtotal,
  shipping, tax and discount refunded amounts. The price section shows a
  "Refund Breakdown", and item cards show refunded and canceled quantities.
  Per-refund (credit memo) lists are not in the API.
- **#88 Booking cancellation note.** Order items now fetch `type`,
  `productType` and `productId`. For booking items the bloc reads
  `BookingProduct.allowCancellation`. When it is off, a note shows in the
  details tab and in the cancel dialog.
- **#34 / #38 EU withdrawal.**
  - Queries: `lib/core/graphql/eu_withdrawal_queries.dart`.
  - Repository methods live in `AccountRepository`.
  - Logged-in: the order detail page has a "Withdraw from Contract" action,
    or shows the existing request's status.
  - Guest: `GuestEuWithdrawalPage` with `GuestEuWithdrawalCubit`, linked from
    the logged-out account screen.
  - Everything is shown only when `euWithdrawalStatus.enabled` is true
    (currently false on api-demo). Eligibility is decided by the server.
- **#67 Review card not clickable.** `openReviewedProduct` opens the product
  from the dashboard reviews and `ReviewsPage`.
- **#54 Phone and gender not enforced.** The edit profile page marks both
  required and validates them (`FormField` for gender).
- **#89 / #90 Contact Us and phone validation.**
  - Contact Us now matches the web: contact is optional, and the minimum
    lengths are removed.
  - Phones use the storefront rule `^\+?\d+$` in
    `lib/core/utils/phone_validation.dart`, which is also applied to the
    address and checkout forms.
- **#51 Logo.** `ChannelBootstrapService` caches `channel.logoUrl`, and the
  `ChannelLogo` widget uses it with the bundled SVG as fallback. The favicon
  does not apply to a native app.

### Booking product page

- **#85 Cancellation Not Allowed.** `allowCancellation` is fetched and parsed
  into `BookingProductData`, and a row is shown when it is false.
- **#86 View on Map.** The default booking type now uses the location row
  with the map link.
- **#83 Irrelevant availability visuals.** The Available From/To rows are
  removed to match the web.

## Partly fixed

- **#82 Dates without slots.** `BookingProductData.bookableWeekdays` and
  `isBookableOn` feed `selectableDayPredicate`. Fully booked dates
  (`disabled_dates` on the web) are not in the GraphQL API.
- **#48 / #49 Channel locale and currency.**
  - Preferences sheets now re-run `ChannelBootstrapService` when opened
    (`PreferencesCubit.refreshChannel`).
  - `resolveAppLocale` maps codes case-insensitively and falls back to
    English. Before, an unknown language switched the UI to Arabic.
  - QA still needs to say which backend, channel and language they tested.
- **#61 Header offer title.** It comes from core config, which the API does
  not expose.

## Blocked on the backend (no API data)

- **No core-config query in the API:**
  - #29 image search / compare toggle
  - #30 Buy Now toggle
  - #47 wishlist toggle
  - #63 / #64 social share options
  - #39 cart summary mode
  - #41 mini cart offer
  - #42 cart page toggle
  - #52 redirect after login
- **#60 Censored reviewer name.** The web REST API censors names; GraphQL
  `productReviews` returns full names.
- **#15 Offer Information.** No active `home-offer` theme row on api-demo.
  The app already renders it when present.
- **#55 Cash on Delivery.** Not returned by `collectionPaymentMethods`. Check
  COD config, or retest with a physical product in the cart.
- **#57 / #115 Seller messages and product reporting.** Marketplace features
  that are not in this API.
- **#62 Review images.** No review on the demo has attachments. The app
  already renders them.
- **#50 Social login.** `createSocialLogin` exists, but it needs the
  Google, Facebook and Apple SDKs, app credentials, and an API field listing
  the enabled providers.

## Other fixes found along the way

- `deleteCustomerAccount` selected fields that do not exist, so account
  deletion always failed; it now selects `id`.
- `getCountryStatesByCode` used an invalid `countryCode` argument; it was
  removed. The fallback now resolves the country id from `getCountries()`.
- `test/add_review_page_test.dart` now provides `AuthBloc`; nine tests had
  been failing since commit 054e0c1.

## Reported to the backend team

- `customerOrderShipment(id)` returns shipment data without authentication.
- Registration sends `status`, `isVerified` and `isSuspended` from the
  client (`auth_repository.dart`); the server should own these.
- Logged-in orders should take `customer_email` from the authenticated
  customer (#87).
- A core-config query (or channel fields) is needed for the blocked issues
  above.

## Tests added

`home_theme_fixes`, `category_show_category`, `static_content_offer` (links),
`image_carousel_ratio` (banner tap), `category_tab_categories` (description),
`review_card_navigation`, `error_mapper_context`, `cart_page` (coupon),
`order_shipment_query`, `cancel_order_bloc` (cancel failure, returns, booking
note, EU withdrawal), `returnable_orders_repository`, `create_return_bloc`,
`order_detail_page` (refunds), `account_dashboard_refresh`, `bloc_refresh`,
`account_pull_to_refresh`, `booking_availability`, `add_to_cart_response`,
`strikethrough_price`, `checkout_suspended_customer`,
`checkout_customer_email`, `guest_checkout_check`, `phone_validation`,
`contact_us_page`, `edit_account_required_fields`, `channel_locale_refresh`,
`channel_logo`, `eu_withdrawal_repository`, `guest_eu_withdrawal`.

## Verify

```bash
flutter pub get
flutter gen-l10n
flutter analyze   # expect the 48 pre-existing infos/warnings only
flutter test      # expect all tests to pass
```

These fixes were checked with unit and widget tests and read-only API calls
only. The following still need a device run with a logged-in QA account:

- checkout (#40, #53, #87)
- returns (#36, #59)
- EU withdrawal on a backend where it is enabled (#34, #38)
- booking add-to-cart (#118)

## Follow-up (2026-10-14): out-of-stock products on the product page

- Request: on the product page, show out-of-stock products dimmed like the
  web and do not allow adding them to the cart.
- `ProductDetailState.isOutOfStock` is true when the API's `isSaleable` is
  not `1`/`true`. It checks the selected variant first, then the product.
  The live API returns `""` for out-of-stock products (for example product
  22). A missing value (`null`) is not treated as out of stock.
- `ProductActionBar` dims Add to Cart and Buy Now and disables both taps.
  As on the web, no extra "out of stock" label is shown.
- Only the product page changed. Quick-add buttons on product cards were
  not changed.
- Test: `test/product_out_of_stock_test.dart`.

## Follow-up (2026-10-14): product carousel with no filters missing from home

- Symptom: on the local server
  (`http://192.168.15.239/Bagisto-Api/new-setup/public/`) the web home page
  shows the "test" product carousel, but the app does not.
- Root cause: that section (`sections` id 15, `product_carousel`) was saved
  without filters, and the API returns `options` as
  `{"title": "test", "filters": []}`. The empty filters come back as a JSON
  list, not a map. `HomeBloc` cast it with `as Map<String, dynamic>?`, which
  threw. The per-section `catch` turned that into an empty product list,
  and the home page hides empty carousels.
- Fix: `ThemeCustomization.filters` returns an empty map for anything that
  is not a map. `ThemeCustomization.title` uses `options.title` (as the web
  does) and falls back to the section name. `HomeBloc` and `HomePage` use
  these instead of casting.
- Note: this server's API uses `sections` instead of `themeCustomizations`;
  the app already queries `SectionQueries.getSections` (commit 4eb3c77).
- Test: `test/home_product_carousel_filters_test.dart`.

## Follow-up (2026-10-14): category carousel shows fewer categories than the web

- Symptom: on the local server the web category carousel lists Root, Men
  and Shirt; the app showed only Men.
- Root cause, part 1: when a carousel had no `parent_id` filter, the app
  defaulted it to `1`. That kept only the direct children of Root. The
  storefront calls `/api/categories` with the carousel's own filters, so no
  filter means every active category. Both carousel sections on that server
  (ids 14 and 16) have no options.
- Root cause, part 2: the app loaded categories once (from the first
  carousel's filters) and reused that list for every carousel.
- Fix:
  - `HomeRepository.fetchHomeCategories({int? parentId, int? limit})`:
    no `parentId` returns all active categories, sorted by position, then
    by id.
  - `HomeBloc` loads each carousel with its own filters into
    `HomeState.categorySections`, keyed by section id. `HomePage` renders
    from that map.
  - Carousels that set `parent_id` (for example api-demo's carousel with
    `parent_id: 1`, which issue #46 relied on) still keep only that
    parent's children.
- Test: `test/home_category_carousel_test.dart`. The old
  `category_status_filter_test` expectation was updated to include Root.

## Follow-up (2026-10-14): where a home category tap goes

- Rule from the user: on home, tapping a category that has sub-categories
  opens the Categories tab. Tapping a category with no sub-categories opens
  its product catalog (`CategoryProductsGridPage`).
- `HomeCategory.hasChildren` comes from the API's flat `categories` list:
  a category has children when some active category's `parent._id` is its
  id (`HomeRepository.fetchHomeCategories`).
- `HomePage._openCategoryProducts` routes on `hasChildren`. Banner and
  collection links that resolve to a top-level category set it from
  `CategoryModel.children`.
- Known edge case: Root has children, but the Categories tab does not list
  Root. Tapping Root opens the tab with its current selection unchanged.
- Test: `test/home_category_carousel_test.dart` (`hasChildren`).

## Follow-up (2026-10-14): Refunds tab on order details

- Request: the order details page should have a Refunds tab, like the web's
  Information / Invoices / Shipments / Refunds tabs.
- API reality: there is no refund (credit memo) query or connection, either
  in the docs (`get-customer-order`) or in the local server schema. The
  order only has refunded totals (`grandTotalRefunded`, `subTotalRefunded`,
  `shippingRefunded`, `taxAmountRefunded`, `discountRefunded`) and per-item
  `qtyRefunded` / `amountRefunded`.
- Implementation (`order_detail_page.dart`, `_buildRefundsTab`):
  - The tab shows only when `grandTotalRefunded > 0`.
  - It lists refunded items (name, SKU, unit price, refunded quantity,
    subtotal from `amountRefunded`).
  - It then lists totals: subtotal, Shipping & Handling, tax and discount
    (each only when above 0), and the grand total refunded.
  - The old "Refund Breakdown" block in the Details tab was moved here, and
    its l10n keys were removed.
- Not possible without a backend change: separate "Refund #N" entries for
  orders with several refunds, and the "Adjustment Refund" / "Adjustment
  Fee" lines.
- Test: `test/order_detail_page_test.dart` (Refunds tab present and hidden).

## Follow-up (2026-10-14): Contact Us matches the web form (#89)

- Reference: `http://192.168.15.239/theme/api-4.9/public/contact-us`.
- The web form, from top to bottom:
  1. Title "Contact Us" and the subtitle "Jot us a note, and we’ll get back
     to you as quickly as possible".
  2. Name * (`required`).
  3. Email * (`required|email`).
  4. Phone Number, optional (`phone` rule, `^\+?\d+$`).
  5. "What’s on your mind?" * (`required`, placeholder "Describe Here",
     10 rows).
  6. A Submit button.
- The other placeholders repeat the field labels.
- App changes (`contact_us_page.dart`):
  - Added the subtitle.
  - Renamed the labels to "Phone Number" and "What’s on your mind?", and
    set the placeholders to match the web.
  - Made the message box taller (6 to 10 lines).
  - The button now says "Submit".
  - Validation was already aligned on 2026-09-30.
- New l10n keys: `accountContactUsDescription`, `accountPhoneNumber`,
  `accountWhatsOnYourMind`, `accountDescribeHere`, `accountSubmit`.
- Test: `test/contact_us_page_test.dart`.

## Follow-up (2026-10-14): Refunds tab now matches the web view

- The user pasted the web Refunds view:
  - Each refunded item shows SKU, Name, Price, "Item Status" and Subtotal.
    The status reads like "Ordered (1) Invoiced (1) Shipped (1)
    Refunded (1)".
  - Then the order summary: Subtotal, Shipping & Handling, Tax (shown even
    at $0.00), Grand Total, Total Paid, Total Refunded, Total Due.
- `_buildRefundsTab` was rewritten to that layout:
  - Items with `qtyRefunded > 0` are listed. Their status line always shows
    Ordered, plus Invoiced, Shipped, Refunded and Canceled when above 0.
    The item subtotal is `item.total`.
  - The summary uses the order totals (`subTotal`, `shippingAmount`,
    `taxAmount`, `discountAmount` when above 0, `grandTotal`, `totalPaid`,
    `totalRefunded`, `totalDue`). This replaces the refunded-only amounts
    used earlier the same day.
- New l10n keys: `accountItemOrderedCount`, `accountItemInvoicedCount`,
  `accountItemShippedCount`, `accountItemRefundedCount`,
  `accountItemCanceledCount`, `accountItemStatus`.
- Test: `test/order_detail_page_test.dart` ("Refunds tab matches the
  storefront view").

## Follow-up (2026-10-14): refund item card styled like invoice item cards

- The user asked for refunded items to use the same layout as invoice item
  cards.
- Each refunded item now shows name and SKU. On the left are the quantity
  rows `Ordered Qty`, `Shipped Qty`, `Invoiced Qty` and `Refunded Qty` (plus
  `Canceled` when above 0), each written as `Label : n`. On the right are
  `Unit Price:` and `Sub Total:`. The card background matches the invoice
  cards.
- This replaces the one-line "Ordered (1) Invoiced (1) …" status, and its
  l10n keys (`accountItem*Count`, `accountItemStatus`) were removed. New
  key: `accountRefundedQty`.
- All values come from the `customerOrder` API (item quantities, `price`,
  `total`, and the order totals). Nothing is hardcoded; the sample order in
  the tests is fixture data only.

