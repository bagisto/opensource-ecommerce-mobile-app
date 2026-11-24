# AGENTS.md

## Project Overview

This project is a Flutter storefront app for Bagisto GraphQL.

The app boots channel configuration, renders catalog and product journeys, supports guest and authenticated cart flows, handles customer account actions, and wires Firebase notifications into the shopping experience.

This repo follows a documentation-first AI workflow so humans and agents share the same source of truth before changing behavior.

---

## Core Objective

Keep the storefront experience reliable and backend-aligned while preserving:

- Bagisto GraphQL contract behavior
- storefront header semantics
- auth and guest-cart token separation
- feature-level repository and BLoC boundaries
- checkout, account, and notification flows

---

## Non-Negotiable Rules

1. Do not change GraphQL schema assumptions or request header semantics without updating docs.
2. Do not introduce new app GraphQL clients outside `GraphQLClientProvider` unless the repo adopts a new shared factory pattern.
3. Keep customer auth tokens and guest cart session tokens distinct.
4. Keep repositories responsible for queries and mutations, and keep BLoCs or Cubits responsible for UI state.
5. Preserve `X-STOREFRONT-KEY`, `X-CHANNEL`, `X-LOCALE`, and `X-CURRENCY` request semantics.
6. Do not move endpoint or key configuration outside `lib/core/constants/api_constants.dart` without documenting the new source of truth.
7. Update `plan.md` when workflow or architecture meaningfully changes.
8. Keep unit, widget, and Maestro coverage aligned with behavior changes.
9. Use graphify first for all non-trivial codebase reasoning.
10. Do not commit or fabricate secret config values such as Firebase service files.

---

## Documentation Reading Order

Before making non-trivial changes, read in this order:

1. `plan.md`
2. `AGENTS.md`
3. `graphify-out/GRAPH_REPORT.md`
4. `agent.md`
5. `aidocs/engineering/README.md`
6. `aidocs/engineering/04-system-architecture.md`
7. `aidocs/engineering/06-api-contracts.md`
8. `aidocs/engineering/12-testing-strategy.md`
9. `aidocs/engineering/13-ai-agent-workflow.md`

---

## Tech Stack

- Flutter
- Dart
- Bagisto GraphQL storefront APIs
- `graphql_flutter` and `graphql`
- `flutter_bloc` and Cubits
- `shared_preferences`
- Firebase Messaging and local notifications
- Maestro mobile E2E flows

---

## Allowed vs Restricted Scope

### Allowed

- `lib/**`
- `test/**`
- `maestro/**`
- `android/**`, `ios/**`, `web/**`, `linux/**`, `windows/**`, `macos/**` when configuration or integration work requires it
- root AI/docs files
- `aidocs/**`
- `graphify-out/**`

### Restricted

- generated plugin registrant files
- build outputs and caches
- large image/document binaries
- Firebase secret files
- destructive cleanup of user-facing config unless explicitly required

---

## Storefront Runtime Rules

### Configuration Source Of Truth

- `lib/core/constants/api_constants.dart` owns:
  - GraphQL endpoint
  - storefront key
  - channel code
  - channel id
  - company metadata
- `ChannelBootstrapService` is responsible for fetching the active channel and setting locale/currency defaults.

### Client And Header Rules

- All GraphQL traffic should go through `GraphQLClientProvider.buildClient(...)`.
- Dynamic storefront headers are attached centrally in the HTTP client layer.
- Authenticated flows use the stored customer Bearer token.
- Guest cart flows use the cart session token as the Bearer token.

### State Boundary Rules

- Repositories own GraphQL queries, mutations, and response mapping.
- BLoCs and Cubits translate repository calls into presentation state.
- `MainShell` owns bottom-tab navigation and tab history behavior.
- Shared preferences own persisted auth, locale, and currency selections unless a new documented storage layer replaces them.

### Notification Rules

- Firebase initialization failures must degrade gracefully.
- Device token handling belongs in notification/auth support code, not arbitrary UI widgets.
- Notification tap routing should preserve the current navigation architecture rather than creating ad hoc entrypoints.

---

## Marketplace Rules

The marketplace (seller panel plus the buyer-facing marketplace) lives in `lib/marketplace/**`.

1. `ApiEnv` in `lib/core/constants/api_constants.dart` owns the base URL, the shop endpoint, the seller endpoint and the storefront key. Nothing else hardcodes a URL. Override with `--dart-define=API_BASE=` and `--dart-define=STOREFRONT_KEY=`.
2. The host runs two independent installs. `theme/api-4.9` is the one this app targets; `theme/apis_v2.4.9` has its own database, key and sellers. A rejected key or credential usually means the wrong base path rather than a wrong secret.
3. Seller traffic goes through `GraphQLClientProvider.buildSellerClient` and never carries `X-STOREFRONT-KEY` — the server scopes that key to the shop API.
4. Seller session keys are prefixed `seller_` and are independent of the customer's `auth_token`. Both sessions may be active at once.
5. Server-issued IRIs are stored and echoed verbatim. They include the install path (`/theme/api-4.9/public/api/seller/products/26`), so they are never rebuilt from an integer. Use `SellerIri`.
6. On a product, `id` is the seller catalogue id used in URLs and IRIs; `productId` is the core catalog id used inside bodies (`variants[].variantId`, `links[].associatedProductId`, `bundleOptions[].products[].productId`, and `productId` when assigning). They are not interchangeable.
7. Product, profile and settings updates are partial, but any nested list you send replaces that whole set, and marketing rules replace wholesale.
8. Gate seller UI on `SellerPermissions.can(key)` before rendering an action, not only when handling its error.
9. Endpoint behaviour is documented in `aidocs/engineering/16-marketplace-seller-api-reference.md` and `17-marketplace-shop-api-reference.md`. Request shapes come from `MarketplaceApi.graphql.postman_collection.json`.
10. Demo data is seeded through the live API with `tool/marketplace_seed/seed.sh`. Never hardcode sample data in the app.
11. Seller product detail exposes the type-specific product structures (`variants`, `links`, `bundleOptions`, `downloadableLinks`, `downloadableSamples`, `booking`). Read the existing set before editing because updates replace any nested list sent.
12. A configurable's variants are separate catalogue rows named `<parentSku>-variant-<optionIds>`. Seller product detail returns the related variants; `variants[].variantId` is the variant's **core product id**. New variants are added through `updateSellerProduct` with `superAttributes` mapping attribute codes to option ids, plus SKU, name, price, weight, status and seller inventory entries; omit `variantId` for new variants and retain existing variant ids in the replacement list.
13. Attribute option labels are not exposed — both transports return options with `label: null`, so pickers show the option id rather than inventing a name.
14. Attribute family ids are not queryable and differ per install (family `1` exists here, `3` does not).

15. Orders take the marketplace **order id** (`_id` on the listing), not an IRI, on `createSellerInvoice` and `createSellerShipment`; `createSellerOrderCancel` takes it as a string; `createSellerPaymentRequest` takes the order **IRI**. Three shapes, one entity.
16. What a seller may still do on an order comes from the line quantities — `qtyOrdered`, `qtyInvoiced`, `qtyShipped`, `qtyCanceled` — not from the order status. Invoice needs uninvoiced quantity; shipping needs invoiced-but-undispatched quantity.
17. A carrier with empty `capabilities` (the built-in `manual`) books nothing: the seller types the carrier name and tracking number, and the shipment is still recorded. `bookingFailed` on the response means the carrier refused while the shipment exists.
18. The reporting API types the same figure two ways — `0` when it is zero, the decimal string `"39.9800"` when it is not — so every reporting number is read through a tolerant parser rather than an `as num?` cast.
19. `createSellerProductAssign` takes `inventories` as a **list** of `{inventorySourceId, qty}` records. A `{sourceId: qty}` map, which the product update accepts, is rejected here as *"Invalid inventory source."*
20. Magic AI's generate mutation takes the **core** product id, which its context query reports; the context query itself is addressed by the seller catalogue id in the IRI.
21. Whether Magic AI exists at all is the marketplace's decision. Ask `sellerProductMagicAi` first and show `disabledReason` — generating while it is off answers `Resource not found`.
22. Review approval belongs to the marketplace admin, so the seller's review screens are read-only and show where each review stands.
23. An RMA may only move to a status in the detail's `allowedStatuses`. Status `5` refunds the item and `8` cancels it, so both are confirmed before they are sent.
24. `createSellerPricingMassSave` and `createSellerInventoryMassSave` take their `products` payload **inlined into the document**, not as a variable — see the server defect below. Everything else in the app goes through variables.
25. The bulk saves address products by **core** product id, while the bulk status action takes **seller catalogue** ids. Same grid, two id spaces.
26. A checkout deal's coupon flags are ints on the wire: `couponType` and `useAutoGeneration` are `0`/`1`, not booleans. A fixed `couponCode` is only accepted when the deal is not auto-generating a batch.
27. Generated coupon codes must be at least 10 characters; the server refuses anything shorter outright.
28. Deleting a coupon takes the **coupon** id. Every other call in that section takes the **deal** id.
29. The buyer-facing marketplace lives in `lib/marketplace/features/shop/**` and goes through the **shop** endpoint with the storefront key — `GraphQLClientProvider.buildClient`, not `buildSellerClient`. It is the one part of `lib/marketplace` that does. `MarketplaceShopEntry` is the way in from the customer app.
30. A shop page is addressed by **slug** (`/api/shop/sellers/acme-store-2`), not by a numeric id.
31. The public contact form takes the sender's own `name` and `email`, and the message goes in `query`. Reporting a seller sends the reason's **text**, not its id, even though `shopFlagReasons` returns ids.
32. Messaging a seller takes `sellerId` as a field; marking the same thread read takes it in the IRI (`/api/shop/communications/{sellerId}/read`). On the seller side, customer conversation messages are marked read via `readSellerCustomerCommunication` taking `{id: "/api/seller/communications/customers/{customerId}"}`. Opening a thread marks messages read, zeroing `unreadCount`.
33. A seller password change goes through `updateSellerSetting` alongside locale and the email preference, and needs the current password.

**Demo-data prerequisite:** a seller product is only saleable when its inventory source is attached to the channel. Channel 1 currently lists source `1` only, while seller stock sits on the seller's own source, so add-to-cart answers *"The requested quantity is not available"*. Fix in Admin → Settings → Channels → Default → Inventory Sources. Products also need admin approval before the storefront lists them.

**Known server defects (theme/api-4.9, 2026-08-14).** Each was reproduced against the live install; the app is built to the documented contract in all three cases.

1. `updateSellerProduct` answers `Internal server error` for **any** configurable product, even for a lone `name` change, while simple products update normally. Variant editing therefore cannot be exercised end to end here. The server's own `variantId` validation runs before the failure, so the payload shape is right.
2. `sellerProductReviews` returns an empty collection even where approved reviews exist on the seller's own products. Verified: reviews 1–3 are `approved`, sit on products 56–58, and those products report `additional.seller_id: 38`, which is this seller; the shop API returns the same reviews; both the REST and GraphQL seller endpoints return nothing. The shop-review endpoint (`sellerReviews`) works, so the reviews screen has real data in one tab and an honest empty state in the other.
3. `returnableItems` returns an empty list for an order that is completed, fully invoiced and fully shipped, with RMA configured (7 allowed days, simple products permitted). No return request could therefore be raised to populate the RMA screens. The endpoints themselves answer correctly — `sellerRmaStatuses` returns all nine statuses with their colours.
4. The `Iterable` scalar loses nested objects on the **variable** path. `{products: [{productId: 41, price: 13.5}]}` answers *"No prices were saved"* as a variable but succeeds as an inline literal, and the identical JSON succeeds against the REST endpoint. Lists of plain scalars (`ids: [41]`) are unaffected. `SellerBulkOpsDocuments.inlineProductsLiteral` is the workaround, and the live smoke test covers it so a server fix will not go unnoticed.

---

## AI Workflow

1. Read `plan.md`.
2. Read `graphify-out/GRAPH_REPORT.md` before searching raw files.
3. Inspect current code after graphify identifies likely files.
4. Make the smallest architecture-safe change.
5. Add or update tests when logic changes.
6. Run analyze, test, or flow checks for touched scope.
7. Run `graphify update .` after meaningful code changes.
8. Update docs when source-of-truth workflow or architecture changes.

---

## Graphify Rule

Graphify is mandatory in this repo.

- always read `graphify-out/GRAPH_REPORT.md` before architecture analysis, refactor planning, code review, or repo-wide search
- use graphify hubs, god nodes, and communities to choose which files to read first
- prefer graph-guided navigation over blind `rg` across the repo
- after any meaningful code change, run `graphify update .` before final wrap-up
- if the graphify report is missing or stale, refresh it before deep codebase reasoning

---

## Quality Gates

Work is complete only when all are true:

1. Endpoint, token, and header semantics still match Bagisto expectations.
2. Repository, state, and UI boundaries remain clear.
3. Tests or flow checks cover the changed behavior when appropriate.
4. Verification commands succeed for the touched scope, or the blocker is explicitly documented.
5. Docs reflect any new workflow or architectural rule.

---

## Companion Files

- `plan.md`
  - project working plan and architecture summary
- `agent.md`
  - Bagisto runtime guide for agents
- `aidocs/engineering/**`
  - long-lived architecture and workflow memory
- `aidocs/superpowers/**`
  - local design and implementation history for AI-assisted changes

## graphify

This project has a graphify knowledge graph at `graphify-out/`.

Rules:
- Always read `graphify-out/GRAPH_REPORT.md` before answering architecture or codebase questions.
- If `graphify-out/wiki/index.md` exists, navigate it instead of reading raw files.
- After modifying code files in this session, run `graphify update .` to keep the graph current.
- Use raw file search only after graphify identifies the likely files or clusters.

## caveman

This project allows caveman response mode when the user explicitly asks.

Rules:
- keep responses short
- keep technical meaning exact
- drop fluff
- return to normal only when the user asks

### Seller API: attribute option labels are never populated

`sellerProduct(id:).attributes[].options[]` returns `label: null` and `_id:
null` for every option; only the IRI `id` carries the number. The singular
`sellerAttributeOption(id:)` answers 500 for any id. So the names a seller
picks a colour or size by are not readable from the seller API at all.

Worked around by reading the storefront's `attributes(first:)` list, which
carries the same options with `adminName` and marks `isConfigurable`. That
needs only the storefront key, which the app already holds.

### Seller API: the order carries no address, payment method or order totals

`sellerOrder(id:)` returns 18 fields. It has the customer's name and email,
the grand total, the seller's share and the commission -- and nothing else the
panel's order screen prints: no billing or shipping address, no shipping
method, no payment method, and no order-level sub total, shipping, tax,
discount, refunded, paid or due.

Tax and discount exist per line, so the totals block is summed from the items.
The addresses and the payment method have no seller-side source at all; the
panel reads them off the core order.

### Seller API: the shop logo and banner can be neither read nor set

`sellerProfile` exposes `logo`, `logoUrl`, `banner` and `bannerUrl`, and all
four come back null even for a seller whose panel shows both. The storefront's
`shopSeller` returns null for them too.

`updateSellerProfileInput` has no logo or banner field, and REST refuses as
well: multipart is answered 415 (`content-type not supported`) and a `data:`
URI in a JSON `PUT` is answered 422 (`No recognised fields were sent`). Product
images take a `data:` URI on their own mutation, so the profile is the
exception rather than the rule.

The panel's own images on this install are
`themes/marketplace/build/assets/default-banner-*.webp` and `default-logo-*.webp`
-- theme placeholders, not uploads. So a shop with no images looks furnished on
the web and bare in an app that only renders what it is given.
