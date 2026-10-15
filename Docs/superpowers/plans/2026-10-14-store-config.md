# Store Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Read the Bagisto `storeConfig` query and use it to show, hide or block wishlist, compare, image search, share, reviews, guest checkout, reorder, newsletter and minimum order.

**Architecture:** One app-wide `StoreConfigCubit` (state `StoreConfig`) loaded at start and on locale/currency change. Widgets read it through `StoreConfig.of(context)`, which falls back to an empty config when no cubit is provided. An empty config (all flags `null`) means "keep today's behaviour".

**Tech Stack:** Flutter, flutter_bloc, equatable, graphql_flutter.

Spec: `Docs/superpowers/specs/2026-10-14-store-config-design.md`

## Global Constraints

- No git commit, push or merge (user commits). Never stage `lib/core/constants/api_constants.dart`.
- No hardcoded settings: a flag only changes behaviour when the API returns it (`== false` hides, `== true` enables minimum order / censoring).
- Every new user-facing string goes into all 10 `lib/l10n/app_*.arb` files, placeholder metadata only in `app_en.arb`, then `flutter gen-l10n`.
- Do not run `dart format` on whole large files.
- `flutter analyze` must stay at the baseline (about 48 issues).

---

### Task 1: StoreConfig model, query, repository, cubit

**Files:**
- Create: `lib/core/store_config/store_config.dart`
- Create: `lib/core/store_config/store_config_repository.dart`
- Create: `lib/core/store_config/store_config_cubit.dart`
- Modify: `lib/core/graphql/queries.dart` (add `getStoreConfig` to `StoreConfigQueries`)
- Test: `test/store_config_test.dart`

**Interfaces (produced):**
- `class StoreConfig extends Equatable` with nullable fields `wishlistEnabled`, `compareEnabled`, `imageSearchEnabled`, `socialShareEnabled`, `reviewerNameCensored`, `guestCheckoutEnabled`, `customerReviewEnabled`, `guestReviewEnabled`, `reorderEnabled`, `newsletterEnabled`, `minimumOrderEnabled` (`bool?`), `minimumOrderAmount` (`double?`), `minimumOrderIncludesDiscount`, `minimumOrderIncludesTax` (`bool?`), `minimumOrderMessage` (`String?`).
- Getters: `showWishlist`, `showCompare`, `showImageSearch`, `showSocialShare`, `showReorder`, `showNewsletter`, `allowGuestCheckout`, `allowCustomerReview`, `allowGuestReview` (all `flag != false`), `censorReviewerName` (`== true`), `bool hasMinimumOrder` (`minimumOrderEnabled == true && (minimumOrderAmount ?? 0) > 0`), `double minimumOrderTotal({required double subtotal, required double discount, required double tax})`, `bool meetsMinimumOrder({...same})`.
- `static StoreConfig of(BuildContext context, {bool listen = true})`.
- `StoreConfig.fromJson(Map<String, dynamic>)`.
- `StoreConfigRepository({required GraphQLClient client})`, `Future<StoreConfig> fetch()`.
- `StoreConfigCubit({required StoreConfigRepository repository})`, `Future<void> load()`.

- [ ] **Step 1: Write failing tests** for `fromJson` (full real payload from the local server, partial payload, string `"1"`/`"0"` and numeric amount strings), the getters (null = allowed, false = hidden), `minimumOrderTotal` with each include flag, `StoreConfig.of` without a provider returns empty config, and the cubit (`load` emits the fetched config; a throwing repository keeps the previous state).
- [ ] **Step 2: Run** `flutter test test/store_config_test.dart`. Expected: compile failure (types missing).
- [ ] **Step 3: Implement** the files listed above. Query:

```graphql
query storeConfig {
  storeConfig {
    id
    guestCheckoutEnabled
    reorderEnabled
    minimumOrderEnabled
    minimumOrderAmount
    minimumOrderIncludesDiscount
    minimumOrderIncludesTax
    minimumOrderMessage
    customerReviewEnabled
    guestReviewEnabled
    reviewerNameCensored
    compareEnabled
    wishlistEnabled
    imageSearchEnabled
    socialShareEnabled
    newsletterEnabled
  }
}
```

- [ ] **Step 4: Run** the test again. Expected: PASS.

### Task 2: Provide and reload the cubit

**Files:**
- Modify: `lib/main.dart` (`MultiBlocProvider` in `BagistoApp`; locale and currency `BlocListener`s in `_AppWithAuthCartSyncState`)

- [ ] **Step 1:** Add `BlocProvider(create: (_) => StoreConfigCubit(repository: StoreConfigRepository(client: clientNotifier.value))..load())`.
- [ ] **Step 2:** In both locale and currency listeners, after `clearCache()`, call `context.read<StoreConfigCubit>().load()` (read the cubit before the `await`).
- [ ] **Step 3:** `flutter analyze lib/main.dart`. Expected: no new issues.

### Task 3: Wishlist

**Files:**
- Modify: `lib/features/home/presentation/widgets/product_card_small.dart`, `product_card_large.dart`
- Modify: `lib/features/category/presentation/pages/category_products_grid_page.dart` (`_ProductCardGrid`, `_ProductCardList`)
- Modify: `lib/features/category/presentation/widgets/product_grid_section.dart`
- Modify: `lib/features/search/presentation/pages/search_page.dart`
- Modify: `lib/features/product/presentation/widgets/product_attributes_section.dart` (`_buildActionRow` wishlist item)
- Modify: `lib/features/cart/presentation/pages/cart_page.dart` (header heart, per-item move-to-wishlist)
- Modify: `lib/features/account/presentation/pages/account_menu_page.dart` (Wishlist item)
- Modify: `lib/features/account/presentation/pages/account_dashboard_page.dart` (`WishlistSection`)
- Modify: `lib/features/account/presentation/pages/compare_products_page.dart` (wishlist toggle)
- Modify: `lib/main.dart` (skip `loadWishlist()` is not needed; hidden UI is enough)
- Test: `test/store_config_wishlist_test.dart`

Pattern at each heart: `if (StoreConfig.of(context).showWishlist) <existing heart widget>`.

- [ ] **Step 1:** Failing widget tests: product card small and cart page with `StoreConfigCubit` seeded `wishlistEnabled: false` show no heart icon; with `null` the heart is shown.
- [ ] **Step 2:** Run, expect FAIL.
- [ ] **Step 3:** Apply the pattern at every location above.
- [ ] **Step 4:** Run the new test plus `test/cart_page_test.dart`. Expected: PASS.

### Task 4: Compare, share, image search

**Files:**
- Modify: `product_attributes_section.dart` (compare and share items in `_buildActionRow`)
- Modify: `account_menu_page.dart` (Compare item)
- Modify: `search_page.dart` (`_buildInitialContent` Image Search button)
- Test: `test/store_config_actions_test.dart`

- [ ] **Step 1:** Failing widget tests: action row hides compare and share when the flags are `false`; account menu hides Compare; search page hides Image Search.
- [ ] **Step 2:** Run, expect FAIL.
- [ ] **Step 3:** Wrap each entry in `if (config.showCompare)`, `if (config.showSocialShare)`, `if (config.showImageSearch)`.
- [ ] **Step 4:** Run, expect PASS.

### Task 5: Reviews

**Files:**
- Modify: `lib/features/product/presentation/widgets/product_reviews_section.dart` (`_buildWriteReviewButton`)
- Modify: `lib/features/product/presentation/widgets/product_info_section.dart` ("Add review" link)
- Test: `test/store_config_reviews_test.dart`

Rule: logged in and `!allowCustomerReview` → hide. Guest and `!allowGuestReview` → tapping pushes `LoginPage` instead of `AddReviewPage`.

- [ ] **Step 1:** Failing widget tests for both rules on `ProductInfoSection`.
- [ ] **Step 2:** Run, expect FAIL.
- [ ] **Step 3:** Implement in both widgets.
- [ ] **Step 4:** Run with `test/product_info_section_test.dart`, expect PASS.

### Task 6: Guest checkout and minimum order (cart)

**Files:**
- Modify: `lib/features/cart/presentation/pages/cart_page.dart` (`_guestCheckoutAllowed`, Pay Now, summary area)
- Modify: all 10 `lib/l10n/app_*.arb` (`cartMinimumOrderAmount` with `{amount}` String placeholder)
- Test: `test/store_config_cart_test.dart`

- [ ] **Step 1:** Failing tests: guest + `guestCheckoutEnabled: false` → Pay Now pushes `LoginPage` without calling the per-product lookup; `minimumOrderEnabled: true, minimumOrderAmount: 200` with subtotal 120 → message visible, Pay Now does not open checkout; API message used when present.
- [ ] **Step 2:** Run, expect FAIL.
- [ ] **Step 3:** In `_guestCheckoutAllowed`, return the login redirect first when `!config.allowGuestCheckout`. Add a minimum-order banner above the bottom bar and an early return in Pay Now when `!config.meetsMinimumOrder(...)`. Amount text uses `CurrencyFormatter.formatAmount(config.minimumOrderAmount)`.
- [ ] **Step 4:** Add the arb key in 10 files, run `flutter gen-l10n`.
- [ ] **Step 5:** Run new test + `test/cart_page_test.dart` + `test/guest_checkout_check_test.dart`, expect PASS.

### Task 7: Reorder and newsletter

**Files:**
- Modify: `lib/features/account/presentation/pages/order_detail_page.dart` (`_buildBottomBar` reorder button)
- Modify: `lib/features/account/presentation/pages/edit_account_page.dart` (newsletter checkbox)
- Modify: `lib/features/auth/data/repository/auth_repository.dart` + its caller (send `subscribedToNewsLetter` only when allowed)
- Test: `test/store_config_account_test.dart`

- [ ] **Step 1:** Failing tests: order detail hides Reorder when `reorderEnabled: false`; edit account hides the newsletter checkbox when `newsletterEnabled: false`.
- [ ] **Step 2:** Run, expect FAIL.
- [ ] **Step 3:** Implement.
- [ ] **Step 4:** Run with `test/order_detail_page_test.dart`, expect PASS.

### Task 8: Reviewer name censoring (blocked)

Blocked until the user confirms the web masking format. Not implemented in this round.

### Task 9: Verify and document

- [ ] `flutter test` (all), `flutter analyze` (baseline).
- [ ] Add `Docs/ai-memory/2026-10-14-store-config.md`.
- [ ] Update the graphify graph.
- [ ] Report changed files; no commit.
