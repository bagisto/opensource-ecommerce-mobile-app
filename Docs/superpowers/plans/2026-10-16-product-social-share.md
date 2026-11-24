# Product Social Share Implementation Plan

> **For agentic workers:** Execute inline; the user authorized implementation.

**Goal:** Include admin configured share message, product name, and product URL in product sharing, and expose only configured providers.

**Architecture:** Extend existing `StoreConfig` mapping and `storeConfig` GraphQL selection for provider list/message. Keep sharing in the product presentation action: show configured destinations and launch provider share URLs, with the existing system share sheet as a backward-compatible fallback when provider config is absent.

**Tech Stack:** Flutter, Dart, GraphQL, `url_launcher`, `share_plus`.

## Global Constraints

- Preserve storefront request/header behavior and use the existing GraphQL client path.
- Keep GraphQL parsing in `StoreConfig`, UI actions in product presentation.
- Do not change unrelated working-tree files.

---

### Task 1: Map social share configuration

**Files:** `lib/core/graphql/queries.dart`, `lib/core/store_config/store_config.dart`, focused store config tests.

- [x] Fetch `socialShareProviders` and `socialShareMessage` from `storeConfig`.
- [x] Parse provider names and trimmed message into `StoreConfig`; add focused mapping coverage.

### Task 2: Apply config to product sharing

**Files:** `lib/features/product/presentation/widgets/product_attributes_section.dart`.

- [x] Show configured provider choices when the provider list is present.
- [x] Share admin message, product name, and product URL in provider-specific share actions; preserve native share fallback when provider config is absent.

### Task 3: Verify and refresh graph

- [x] Run focused test and analyzer for touched Dart files.
- [x] Run `graphify update .` after changes; AST and report updated. HTML visualization remains unavailable because repo graph exceeds the renderer's node limit.
