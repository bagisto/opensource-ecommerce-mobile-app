# Product Badges and Placeholder Implementation Plan

**Goal:** Align Sale/New badges across home, search, and recent product cards, use supplied placeholder asset on product image fallbacks, and hide only detail discount percentage text.

**Architecture:** Reuse existing product model flags and card rendering. Persist `isNew` in the already serialized recently viewed `HomeProduct`; point affected UI fallbacks at one new `AppAssets` constant. Keep networking and price calculations unchanged.

**Tech Stack:** Flutter, Dart, `HomeProduct`, `ProductModel`, `CachedNetworkImage`.

## Global Constraints

- No API or repository contract changes.
- Preserve current sale price and crossed-out original price on detail.
- Preserve existing behavior outside product card and detail image fallbacks.
- Do not add or run tests unless requested.

### Task 1: Share badges and placeholder across product surfaces

**Files:**
- Create: `assets/images/large-product-placeholder.webp`
- Modify: `lib/core/constants/asset_constants.dart`
- Modify: `lib/features/home/presentation/widgets/product_card_large.dart`
- Modify: `lib/features/home/presentation/widgets/product_card_small.dart`
- Modify: `lib/features/search/presentation/pages/search_page.dart`
- Modify: `lib/core/recently_viewed/recently_viewed_products_service.dart`
- Modify: `lib/features/product/presentation/widgets/product_image_carousel.dart`
- Modify: `lib/features/product/presentation/widgets/product_info_section.dart`

- [ ] Copy supplied placeholder asset and add its path to `AppAssets`.
- [ ] Use it for empty, loading, and failed product images in large, small, search, and detail views.
- [ ] Add home-equivalent Sale/New badge to search cards and persist `isNew` for recent views.
- [ ] Remove detail percentage label only; keep sale and original prices.
- [ ] Format and analyze touched Dart files; refresh Graphify.
