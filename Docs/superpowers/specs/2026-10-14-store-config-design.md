# Store Config: Follow Admin Settings From the API

Date: 2026-10-14
Branch: `fix/storefront-configuration`

## Problem

Several admin settings were not readable through the Bagisto GraphQL API, so
the app could not follow them (see the v2.5.1 CHANGELOG note). The API now
exposes `storeConfig`, a public query that returns the channel's non-secret
store settings.

## Goal

Read `storeConfig` once at app start (and again when the language or currency
changes) and use it to show, hide or block features the same way the web
storefront does.

## Design

- `lib/core/store_config/store_config.dart`: `StoreConfig` model with a
  hand-written defensive `fromJson`. Every flag is nullable. `null` means the
  API did not answer, and the feature keeps today's behaviour. No value is
  invented in the app.
- `lib/core/store_config/store_config_repository.dart`:
  `StoreConfigRepository.fetch()` runs `StoreConfigQueries.getStoreConfig`
  with `FetchPolicy.networkOnly`.
- `lib/core/store_config/store_config_cubit.dart`: `StoreConfigCubit`
  (state `StoreConfig`, starts empty). `load()` keeps the old state on error.
  `StoreConfig.of(context)` returns the cubit state, or an empty config when no
  cubit is provided (keeps existing widget tests working).
- `main.dart` provides the cubit and reloads it in the existing locale and
  currency listeners.

## Behaviour per setting

| Field | Effect |
|---|---|
| `wishlistEnabled == false` | Hide every wishlist heart (home, category grid/list, search, product page), cart wishlist header button and move-to-wishlist, Account menu Wishlist item, dashboard wishlist section. |
| `compareEnabled == false` | Hide product page Compare action and Account menu Compare item. |
| `imageSearchEnabled == false` | Hide the Image Search button on the search page. |
| `socialShareEnabled == false` | Hide the product page Share action. |
| `customerReviewEnabled == false` | Hide "Write a review" / "Add review" for logged-in customers. |
| `guestReviewEnabled == false` | Guests tapping "Write a review" / "Add review" are sent to login. |
| `guestCheckoutEnabled == false` | Guests tapping Pay Now are sent to login (same snackbar as the per-product check). When enabled, the existing per-product check still runs. |
| `reorderEnabled == false` | Hide the Reorder button on order detail. |
| `newsletterEnabled == false` | Hide the newsletter checkbox on Edit Account. Sign-up no longer sends `subscribedToNewsLetter: true`. |
| `minimumOrderEnabled == true` | Cart shows the minimum-order message and Pay Now is blocked while the order total is below `minimumOrderAmount`. The compared total is `subtotal`, minus `discountAmount` when `minimumOrderIncludesDiscount`, plus `taxAmount` when `minimumOrderIncludesTax`. Message: `minimumOrderMessage` from the API, else the new l10n string `cartMinimumOrderAmount(amount)`. |
| `reviewerNameCensored == true` | Mask reviewer names. **Pending:** the web masking format is not documented; confirm with the user before building. |

## Out of scope

Tax display mode, social login providers, captcha, email verification,
`reviewSummary`, `productsPerPage`, `listingMode`, `defaultSortBy`. GDPR
requests are a separate design (job B).

## Testing

- Model: full payload, partial payload, wrong types.
- Cubit: success, failure keeps previous state.
- Widget tests per setting that hide/block the entry point.
- Full `flutter test` and `flutter analyze` (baseline about 48 issues).
