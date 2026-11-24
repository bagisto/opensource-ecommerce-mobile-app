# Home Category Banner Implementation Plan

> **For agentic workers:** Inline execution in this session, as requested by the user.

**Goal:** Display the API-provided banner and description on category product lists opened from Home or the Categories tab.

**Architecture:** Extend the home and nested category GraphQL selections. Pass optional metadata through category models and navigation into `CategoryProductsGridPage`, which renders it with the existing banner widget and a left-aligned plain-text description.

**Tech Stack:** Flutter, Dart, `graphql_flutter`, existing category widgets.

## Global Constraints

- Keep all GraphQL traffic on the existing shared client.
- Preserve storefront header semantics and category/product navigation.
- Omit absent category metadata without blocking product loading.
- Do not add or run tests unless requested.

---

### Task 1: Carry category metadata to product list

**Files:**
- Modify: `lib/core/graphql/queries.dart`
- Modify: `lib/features/home/data/models/home_models.dart`
- Modify: `lib/features/home/presentation/pages/home_page.dart`
- Modify: `lib/features/category/presentation/pages/category_products_grid_page.dart`

- [x] Request category banner URL and translated description.
- [x] Map and pass optional metadata when opening category from Home.
- [x] Select nested subcategory descriptions and pass metadata from Categories tab.
- [x] Render supplied banner and left-aligned plain-text description above product filters.
- [x] Run `dart analyze` for touched scope; no errors, six existing style infos.
- [x] Run `graphify update .`; report refreshed, HTML visualization skipped because graph exceeds 5,000-node cap.
