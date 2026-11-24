# Marketplace Products (Read) Implementation Plan — M3

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** The Products tab lists the seller's catalogue with working search, filters and paging, and each row opens a full product detail screen.

**Architecture:** Follows the M0–M2 shape exactly — documents in `lib/marketplace/graphql/`, models and repository under `features/products/data/`, a bloc under `presentation/bloc/`, pages under `presentation/pages/`. The list bloc owns paging and filter state; the repository owns GraphQL and mapping.

**Tech Stack:** Flutter, `graphql_flutter`, `flutter_bloc`, `equatable`, `flutter_test` with hand-written fakes.

## Global Constraints

- Base URL and key come from `ApiEnv`; seller traffic goes through `GraphQLClientProvider.buildSellerClient(token:)`.
- `id` is the seller catalogue IRI (`SellerIri`), `productId` is the core catalog id. Never swap them.
- IRIs are echoed verbatim; the server prefixes them with the install path.
- Collections map through `PaginatedResult`; errors through `SellerErrorMapper`.
- Gate the Products tab on `product_catalog.products` via `SellerPermissions.can`.
- Tests are flat in `test/`, named `marketplace_*_test.dart`, no mocking package.
- `flutter analyze lib/marketplace` must stay clean.

## Verified API shapes (live, 2026-08-14)

`sellerProducts(page, search, type, status, is_approved, approval_state, is_draft, exclude_customizable)` returns
`collection { id productId sku name type price quantity isOwner isApproved isDraft rejectionReason approvalState }`
and `paginationInfo { itemsPerPage lastPage totalCount currentPage hasNextPage }`.

`sellerProduct(id)` accepts the short IRI `/api/seller/products/50` and returns the list fields plus
`productNumber status categoryName baseImage imagesCount barcodeValue shortDescription description urlKey weight specialPrice specialPriceFrom specialPriceTo metaTitle metaKeywords metaDescription visibleIndividually featured new condition sellerDescription createdAt updatedAt`,
`images { url position }`, `inventories { sourceId sourceCode sourceName qty }`, `categories { id name }`,
`attributes { code name type value isRequired isUserDefined isFixedField options { id label } }`.

Field notes that shape the UI: `price` and `quantity` are numbers; `baseImage` may be null; `categories` is often empty
because the admin restricts a seller's categories; `approvalState` is one of `approved` / `pending` / `rejected`, and a
draft also reads `pending`, so the two filters combine.

---

## File Structure

**Created**

| File | Responsibility |
|---|---|
| `lib/marketplace/graphql/seller_products.dart` | list + detail documents |
| `lib/marketplace/features/products/data/models/seller_product.dart` | `SellerProductListItem`, `SellerProductDetail`, `SellerProductImage`, `SellerProductStock`, `SellerProductAttributeValue`, `SellerProductCategoryRef` |
| `lib/marketplace/features/products/data/models/seller_product_filters.dart` | `SellerProductFilters` value object |
| `lib/marketplace/features/products/data/repository/seller_product_repository.dart` | `list()` and `detail()` |
| `lib/marketplace/features/products/presentation/bloc/seller_products_bloc.dart` | search, filters, paging |
| `lib/marketplace/features/products/presentation/bloc/seller_product_detail_cubit.dart` | one product |
| `lib/marketplace/features/products/presentation/pages/seller_products_page.dart` | list screen |
| `lib/marketplace/features/products/presentation/pages/seller_product_detail_page.dart` | detail screen |
| `lib/marketplace/features/products/presentation/widgets/seller_product_card.dart` | row |
| `lib/marketplace/features/products/presentation/widgets/seller_product_filter_sheet.dart` | filter sheet |

**Modified**

| File | Change |
|---|---|
| `lib/marketplace/shell/marketplace_shell.dart` | mount the Products tab |
| `lib/l10n/app_en.arb` | product strings |

---

### Task 1: Product models and documents

**Files:**
- Create: `lib/marketplace/graphql/seller_products.dart`
- Create: `lib/marketplace/features/products/data/models/seller_product.dart`
- Create: `lib/marketplace/features/products/data/models/seller_product_filters.dart`
- Test: `test/marketplace_seller_product_models_test.dart`

**Interfaces:**
- Produces `SellerProductDocuments.list` / `.detail`; `SellerProductListItem` (`iri`, `productId`, `sku`, `name`, `type`, `price`, `quantity`, `isOwner`, `isApproved`, `isDraft`, `approvalState`, `rejectionReason`, `baseImage`); `SellerProductDetail` (list fields plus descriptions, SEO, pricing window, flags, `images`, `stocks`, `categories`, `attributes`); `SellerProductFilters` (`search`, `type`, `status`, `isApproved`, `approvalState`, `isDraft`) with `toVariables()` and `copyWith`.
- Status helper on both: `SellerProductApproval { approved, pending, rejected, draft }` derived from `isDraft` and `approvalState`, because a draft also reports `pending`.

- [ ] **Step 1: Write the failing test** covering: list item maps the install-prefixed IRI verbatim; `productId` stays distinct from the catalogue id; a draft resolves to `SellerProductApproval.draft` even though `approvalState` is `pending`; a rejected product carries its reason; detail maps images, stocks, categories and attributes; `SellerProductFilters.toVariables()` omits null and empty values.
- [ ] **Step 2: Run it and watch it fail.**
- [ ] **Step 3: Write the documents** — the two queries above, field-for-field with the verified shapes.
- [ ] **Step 4: Write the models** with `fromJson`, `Equatable` props, and the approval helper.
- [ ] **Step 5: Run the test to green, then `flutter analyze lib/marketplace`.**
- [ ] **Step 6: Commit** `feat: add seller product models and documents`.

---

### Task 2: Product repository

**Files:**
- Create: `lib/marketplace/features/products/data/repository/seller_product_repository.dart`
- Test: `test/marketplace_seller_product_repository_test.dart`

**Interfaces:**
- Consumes `SellerErrorMapper`, `PaginatedResult`, models from Task 1.
- Produces `SellerProductRepository({required GraphQLClient client})` with
  `Future<PaginatedResult<SellerProductListItem>> list({int page = 1, SellerProductFilters filters = const SellerProductFilters()})`
  and `Future<SellerProductDetail> detail(SellerIri iri)`.

- [ ] **Step 1: Write the failing test** with a `Link.function` client returning the live envelope: a page maps items and `paginationInfo`; filters reach the variables; `Resource not found.` surfaces as `SellerApiFailure.notFound`; detail maps nested lists.
- [ ] **Step 2: Run it and watch it fail.**
- [ ] **Step 3: Implement** — `client.query` with `FetchPolicy.noCache`, `PaginatedResult.fromJson(..., requestedPage: page)`, throw `SellerErrorMapper.fromResult` on exception, throw `SellerApiException(..., notFound)` when the payload is null.
- [ ] **Step 4: Green, analyze.**
- [ ] **Step 5: Verify against the live server:**
```bash
curl -s -X POST 'http://192.168.15.239/theme/api-4.9/public/api/seller/graphql' \
  -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" \
  -d '{"query":"{ sellerProducts(page:1){ collection { id productId sku name price quantity approvalState } paginationInfo { totalCount lastPage } } }"}'
```
- [ ] **Step 6: Commit** `feat: add seller product repository`.

---

### Task 3: Products list bloc

**Files:**
- Create: `lib/marketplace/features/products/presentation/bloc/seller_products_bloc.dart`
- Test: `test/marketplace_seller_products_bloc_test.dart`

**Interfaces:**
- Events: `LoadSellerProducts` (resets to page 1), `LoadMoreSellerProducts`, `SearchSellerProducts(String)`, `ApplySellerProductFilters(SellerProductFilters)`, `RefreshSellerProducts`.
- State: `SellerProductsState { status, items, filters, totalCount, currentPage, lastPage, isLoadingMore, errorMessage }` with `hasNextPage`.

- [ ] **Step 1: Write the failing test** covering: first load fills items and total; load-more appends the next page and does not re-request when already on the last page; a new search resets to page 1 and drops the previous items; applying filters carries them into the repository call; a repository failure lands in `failed` with the server message.
- [ ] **Step 2: Run it and watch it fail.**
- [ ] **Step 3: Implement** with a fake repository in tests and a `_loading` guard so a second load-more while one is in flight is ignored.
- [ ] **Step 4: Green, analyze.**
- [ ] **Step 5: Commit** `feat: add seller products list bloc`.

---

### Task 4: Products list screen

**Files:**
- Create: `lib/marketplace/features/products/presentation/pages/seller_products_page.dart`
- Create: `lib/marketplace/features/products/presentation/widgets/seller_product_card.dart`
- Create: `lib/marketplace/features/products/presentation/widgets/seller_product_filter_sheet.dart`
- Modify: `lib/marketplace/shell/marketplace_shell.dart`, `lib/l10n/app_en.arb`
- Test: `test/marketplace_seller_products_page_test.dart`

**Interfaces:**
- `SellerProductsPage({super.key})` expects a `SellerProductsBloc` above it.
- The shell mounts it exactly like the dashboard, with an injectable factory (`productsBlocFactory`) so widget tests never hit the network.

Screen: search field, filter button opening the sheet (type, status, approval state, draft), infinite-scroll list, empty state, error state with retry, pull-to-refresh. Each card shows image, name, SKU, price, stock and an approval badge (approved / pending / rejected / draft).

- [ ] **Step 1: Add the ARB strings** (`sellerProductsTitle`, `sellerProductsSearchHint`, `sellerProductsEmpty`, `sellerProductsFilters`, `sellerProductStatusApproved` / `Pending` / `Rejected` / `Draft`, `sellerProductStockLabel`, `sellerProductsRetry`, `sellerFiltersApply`, `sellerFiltersClear`, `sellerProductTypeLabel`), then `flutter gen-l10n`.
- [ ] **Step 2: Write the failing widget test** with a stub bloc: rows render for a loaded state; the empty state shows its message; typing in the search field dispatches `SearchSellerProducts`.
- [ ] **Step 3: Run it and watch it fail.**
- [ ] **Step 4: Build the card, the sheet and the page.**
- [ ] **Step 5: Mount the Products tab in the shell** behind `SellerPermissions.can('product_catalog.products')`, falling back to a "no permission" notice.
- [ ] **Step 6: Green, analyze, full `flutter test`.**
- [ ] **Step 7: Commit** `feat: add seller products list screen`.

---

### Task 5: Product detail screen

**Files:**
- Create: `lib/marketplace/features/products/presentation/bloc/seller_product_detail_cubit.dart`
- Create: `lib/marketplace/features/products/presentation/pages/seller_product_detail_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Test: `test/marketplace_seller_product_detail_test.dart`

**Interfaces:**
- `SellerProductDetailCubit({required SellerProductRepository repository, required SellerIri iri})` with `load()` and `SellerProductDetailState { status, product, errorMessage }`.
- `SellerProductDetailPage({super.key})`.

Screen sections: image gallery (falls back to a placeholder when `images` is empty), identity (name, SKU, type, approval badge, rejection reason when present), pricing (price, special price and its window), stock per inventory source, categories, descriptions rendered as HTML, SEO block, and the attribute list.

- [ ] **Step 1: Add the ARB strings** (`sellerProductDetailTitle`, `sellerProductPricing`, `sellerProductStockBySource`, `sellerProductCategoriesLabel`, `sellerProductAttributes`, `sellerProductSeo`, `sellerProductNoImages`, `sellerProductRejectionReason`), then `flutter gen-l10n`.
- [ ] **Step 2: Write the failing test** for the cubit: load maps the product; a `Resource not found.` failure surfaces its message.
- [ ] **Step 3: Run it and watch it fail.**
- [ ] **Step 4: Implement the cubit, then the page.**
- [ ] **Step 5: Wire the list row to push the detail** with a client built from the session token.
- [ ] **Step 6: Green, analyze, full `flutter test`.**
- [ ] **Step 7: Commit** `feat: add seller product detail screen`.

---

### Task 6: Live verification, docs and graph

- [ ] **Step 1: Extend the live smoke test** to list products and open the first one's detail, still behind `--tags live`.
- [ ] **Step 2: Run it** with `SELLER_EMAIL=... SELLER_PASSWORD=... flutter test --tags live test/marketplace_live_smoke_test.dart`. Expected: passes against the seeded catalogue.
- [ ] **Step 3: Run `flutter analyze` and `flutter test`** — no new issues, whole suite green.
- [ ] **Step 4: Run `graphify update .`**
- [ ] **Step 5: Commit** `chore: verify seller products against the live API and refresh the graph`.

---

## Out of scope

Creating and editing products is M4; assign, barcode and Magic AI are M5. This plan is read-only.
