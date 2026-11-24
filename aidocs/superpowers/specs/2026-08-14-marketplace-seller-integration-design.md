# Marketplace Integration Design — Seller Panel + Buyer-Side Marketplace

Date: 2026-08-14
Status: Approved (design), pending implementation plan
Scope: Add the full Bagisto Marketplace 2.4.9 surface (seller panel + buyer-facing marketplace) to the existing customer storefront app `bagisto_flutter_app_grapghql`.

---

## 1. Goal

The app today is a single-vendor customer storefront. This work turns it into a marketplace client:

- A **seller** can log in with their own credentials and run their whole shop from the app: catalog, orders, fulfilment, returns, marketing, imports, earnings, reporting, staff, settings.
- A **buyer** sees the marketplace: seller directory, seller shop pages, competing offers on a product, buyer↔seller messaging, seller reviews and reports, and a "Become a seller" path.
- The existing customer flows keep working unchanged.

Non-goals: admin-panel features, web checkout for paid subscription plans (API refuses those by design), anything requiring server-side changes.

---

## 2. Verified backend facts

All of the following were confirmed against the live server, not inferred from the Postman collection.

| Fact | Value |
|---|---|
| Base URL | `http://192.168.15.239/theme/apis_v2.4.9/public` — the install behind the owner's swagger and admin panel |
| Storefront GraphQL | `{base}/api/graphql` |
| Seller GraphQL | `{base}/api/seller/graphql` |
| Seller account | `t@t.com` / `123456` → seller "jitendra" (`slug: odo`), `isApproved: true`, 0 products, 0 orders |
| Storefront key | **Outstanding.** `pk_storefront_6QKdh4o5lNaePydMNCbOa7T6sOLQluBA` is valid only on the other install; a key for this one must be generated |
| Seller schema size | 77 queries, 62 mutations (128 REST operations across 22 tags) |
| Storefront marketplace queries | 15 (`shopSellers`, `shopSeller`, `shopSellerProducts`, `shopSellerTopProducts`, `shopSellerReviews`, `shopProductOffers`, `shopCommunications`, `shopCommunication`, `shopCommunicationPreference`, `shopFlagReasons`, …) plus 7 mutations; 17 REST operations under the `Marketplace` tag |
| ACL permission keys | 81 returned by `sellerAclPermissions` |

Endpoint reference generated from the live OpenAPI documents:
`aidocs/engineering/16-marketplace-seller-api-reference.md` and
`aidocs/engineering/17-marketplace-shop-api-reference.md`.

Traps found during probing, encoded into the design below:

1. **Two installs share the host.** `{host}/theme/api-4.9/public` is an older, separate copy with its own database, its own storefront key, and a different seller (`ashifwebkul@gmail.com`). Data does not cross between them. Any "Invalid API key" or "Please check your credentials" almost certainly means the wrong base path rather than a wrong secret.
2. **Seller endpoint must not receive `X-STOREFRONT-KEY`.** The server scopes keys by `key_type: shop`. Seller auth is Bearer-only.
3. **IRIs are install-path-prefixed.** On the `api-4.9` install `sellerProducts` returned `id: "/theme/api-4.9/public/api/seller/products/26"`, not `/api/seller/products/26`. IRIs must be echoed back as received, never hand-built from an integer.
4. **Two different ids per product.** `id` (seller catalogue id, used in URLs/IRIs) vs `productId` (core catalog id, used inside bodies: `variants[].variantId`, `links[].associatedProductId`, `bundleOptions[].products[].productId`, `productId` when assigning). Mixing them is the most likely bug class in this integration.
5. **The app currently points at `https://api-demo.bagisto.com`,** which has no marketplace. Customer traffic moves to the marketplace base as part of M0.

---

## 3. Architecture

### 3.1 Configuration

`lib/core/constants/api_constants.dart` becomes environment-shaped, keeping the existing top-level constants as deprecated aliases so current imports keep compiling:

```dart
class ApiEnv {
  static const base = String.fromEnvironment('API_BASE',
      defaultValue: 'http://192.168.15.239/theme/apis_v2.4.9/public');
  static const shopGraphql   = '$base/api/graphql';
  static const sellerGraphql = '$base/api/seller/graphql';
  static const storefrontKey = String.fromEnvironment('STOREFRONT_KEY',
      defaultValue: '<key for this install — pending>');
}
```

`ApiEnv` is the single source of truth for endpoints and keys. Nothing else in the app hardcodes a URL.

### 3.2 Folder layout

All marketplace code lives under one root, with the internals mirroring the app's existing feature convention (`data/models`, `data/repository`, `presentation/{bloc,pages,widgets}`):

```
lib/marketplace/
  core/
    api/        seller_graphql_client.dart · seller_iri.dart · paginated_result.dart · seller_error_mapper.dart · data_uri_encoder.dart
    session/    seller_auth_storage.dart · seller_session_cubit.dart · seller_permissions.dart
    widgets/    seller_scaffold · seller_paged_list · seller_empty_state · seller_stat_tile · seller_form_field · seller_filter_sheet
    theme/      marketplace_theme_ext.dart          (consumes core/theme/app_theme.dart tokens)
  graphql/      one file per module (seller_auth.dart, seller_catalog.dart, seller_orders.dart, …)
  shell/        marketplace_shell.dart · seller_drawer.dart · marketplace_router.dart
  features/<module>/{data/models,data/repository,presentation/{bloc,pages,widgets}}
  shop/features/<module>/…       buyer-facing marketplace surfaces
```

Rationale: a separate root keeps ~25 seller modules from swamping `lib/features/`, gives the marketplace its own shell and session, and lets it be reviewed, tested, or removed as a unit. Reusing the inner layout means every existing pattern (repository owns GraphQL, bloc owns state) transfers unchanged.

### 3.3 GraphQL client

No new client class. `GraphQLClientProvider` gains one factory:

```dart
static GraphQLClient buildSellerClient({String? token})
```

It targets `ApiEnv.sellerGraphql`, sends `Authorization: Bearer <sellerToken>` and **no** storefront key, and reuses the existing timeout and logging links. This satisfies the standing rule that all GraphQL traffic goes through `GraphQLClientProvider`.

Buyer-side marketplace queries use the existing shop client unchanged — they are ordinary storefront operations that happen to be marketplace-flavoured.

### 3.4 Session and auth

`SellerAuthStorage` owns its own SharedPreferences keys and never reads or writes the customer's:

| Key | Holds |
|---|---|
| `seller_token` | Bearer token from `createSellerLogin` |
| `seller_id`, `seller_name`, `seller_email`, `seller_slug` | identity for the shell header |
| `seller_is_approved`, `seller_is_suspended` | gate state |
| `seller_permission_type`, `seller_permissions` | cached ACL |

Rules:

- Seller and customer sessions are independent. A seller may be logged in with no customer session, and both may be active at once.
- Logout calls `createSellerLogout` then clears only seller keys.
- Changing the password via `updateSellerSetting` revokes the account's *other* tokens; the current token survives. The app surfaces this as an explicit notice rather than a silent state.
- `createSellerResetPassword` revokes **every** token, so the app routes back to seller login afterwards.

`SellerSessionCubit` holds `{token, profile, permissions, subscription}` and emits: `unauthenticated`, `pendingApproval`, `suspended`, `noSubscription`, `active`.

### 3.5 Permissions and subscription gating

Every seller endpoint is ACL-guarded and some are plan-limited. On login the app fetches `sellerProfile`, `sellerAclPermissions` and `sellerSubscription` once, then:

- `SellerPermissions.can('sales.orders.invoice')` decides whether a menu entry, tab, or button renders at all. `permissionType: all` short-circuits to true.
- A `404` from `sellerSubscription` is a **normal** answer meaning "never subscribed" — it routes to the Plans screen, it is not an error.
- `isApproved == false` or `isSuspended == true` renders a state screen explaining the status instead of the shell.
- Paid plans cannot be purchased through the API (`422` by design). The Plans screen subscribes to free plans and explains that paid ones complete in the browser.

### 3.6 Shared primitives

Built once in `marketplace/core/api`, used by every module:

| Primitive | Purpose |
|---|---|
| `PaginatedResult<T>` | maps the universal `{ collection, paginationInfo }` envelope |
| `SellerIri` | stores and echoes server-issued IRIs verbatim; refuses to synthesise one from an int |
| `ListingId` / `CoreProductId` extension types | make the two-id trap a compile-time distinction rather than a runtime bug |
| `SellerFileLink` | fetches `downloadUrl` / `exportUrl` with the seller Bearer token, then hands off to the existing `FileDownloadHelper` |
| `DataUriEncoder` | encodes images, ZIPs and attachments as `data:` URIs, the only upload form these mutations accept |
| `SellerErrorMapper` | wraps the existing `ErrorMapper`; adds ACL denial, `Resource not found.`, and 422 validation-list handling |
| `SellerPagedList` | one infinite-scroll + filter + empty/error widget for ~20 list screens |

### 3.7 Navigation

Entry point: the customer Account menu gains **"Sell on marketplace"**.

- No seller session → seller login, with links to seller registration (form built dynamically from `sellerAttributes`, which returns the required set including admin-defined custom attributes) and forgot/reset password.
- Active session → `MarketplaceShell`.

`MarketplaceShell` owns a four-tab bottom bar — **Dashboard · Products · Orders · More** — matching the app's existing bottom-tab standard rather than the old app's drawer-first navigation. "More" is a grouped list covering the long tail. The app bar carries a switch back to the customer experience. Deep seller journeys (product editor, import pipeline, RMA thread) push onto the shell's own navigator so they never fight the customer tab bar.

---

## 4. Seller module map

Every one of the 77 queries and 62 mutations is claimed by exactly one module below.

| Module | Screens | Primary operations |
|---|---|---|
| Session | login, register, forgot password, reset password | `createSellerLogin`, `createSellerRegister`, `createSellerForgotPassword`, `createSellerResetPassword`, `createSellerLogout`, `sellerAttributes` |
| Dashboard | KPI tiles, sales graph, recent orders, low stock, top products/customers/categories; date range, section and channel filters | `sellerDashboard` |
| Profile | view and edit, logo/banner upload, policies, SEO, socials, custom attributes | `sellerProfile`, `sellerProfileAttribute`, `updateSellerProfile` |
| Products — browse | list with filters (type, status, approval state, draft, rejected), detail with images/inventories/categories/attributes | `sellerProducts`, `sellerProduct`, `sellerProductImage`, `sellerProductInventory`, `sellerProductAttributeItem`, `sellerProductCategories` |
| Products — write | create skeleton, then per-type editors: simple, virtual, downloadable, configurable (+ variants), grouped (+ links), bundle (+ options), booking (default, appointment, event, rental, table); delete; bulk delete | `createSellerProduct`, `updateSellerProduct`, `deleteSellerProduct`, `createSellerProductDeleteBatch` |
| Assign products | search assignable catalog, "sell yours", edit the assigned listing's own fields | `sellerAssignableProducts`, `createSellerProductAssign` |
| Barcode | view, generate, bulk generate, print label sheet | `sellerProductBarcode`, `generateSellerProductBarcode`, `createSellerProductBarcodeBatch`, `createSellerProductBarcodePrint` |
| Magic AI | eligibility/quota context, generate proposals, review-and-apply diff | `sellerProductMagicAi`, `createSellerProductMagicAiGeneration` |
| Inventory sources | stock location list, detail, create, update, delete | `sellerInventorySources`, `sellerInventorySource`, `createSellerInventorySource`, `updateSellerInventorySource`, `deleteSellerInventorySource` |
| Inventories | bulk per-source stock save, bulk status change | `createSellerInventoryMassSave`, `createSellerInventoryMassStatus` |
| Pricing | bulk reprice with customer-group tiers | `createSellerPricingMassSave` |
| Marketing — discounts | own product discounts CRUD; browse, join and leave admin promotions | `sellerProductDiscounts`, `sellerProductDiscount`, `createSellerProductDiscount`, `updateSellerProductDiscount`, `deleteSellerProductDiscount`, `sellerJoinableProductDiscounts`, `sellerJoinableProductDiscount`, `createSellerProductDiscountEnrollment`, `createSellerProductDiscountWithdrawal` |
| Marketing — checkout deals | deals CRUD, copy, coupon list, bulk coupon generation, coupon delete | `sellerCheckoutDeals`, `sellerCheckoutDeal`, `createSellerCheckoutDeal`, `updateSellerCheckoutDeal`, `copySellerCheckoutDeal`, `deleteSellerCheckoutDeal`, `sellerCheckoutDealCoupons`, `createSellerCheckoutDealCouponBatch`, `deleteSellerCheckoutDealCoupon` |
| Bulk upload | sample links, create import (ZIP images, URL images, or assign type), validate, image prefetch, the `start`/`link`/`index` batch loop driven by `nextAction`, progress polling, run report, delete | `sellerImportSamples`, `sellerImports`, `sellerImport`, `sellerImportStats`, `sellerImportReport`, `createSellerImport`, `updateSellerImport`, `validateSellerImport`, `startSellerImport`, `linkSellerImport`, `indexSellerImport`, `downloadImagesSellerImportPhase`, `imageProgressSellerImportPhase`, `queueValidationSellerImportPhase`, `queuedValidationProgressSellerImportPhase`, `deleteSellerImport`, `createSellerImportDeleteBatch` |
| Orders | list with search and payout filter, detail with items/invoices/shipments/refunds, invoice create and view, shipment create and view, cancel, request payment | `sellerOrders`, `sellerOrder`, `sellerOrderItem`, `sellerInvoice`, `sellerShipment`, `sellerRefund`, `createSellerInvoice`, `createSellerShipment`, `createSellerOrderCancel`, `createSellerPaymentRequest` |
| Fulfilment | carrier list and detail with capability-driven shipment fields, pickup slots, booked collections | `sellerFulfilmentCarriers`, `sellerFulfilmentCarrier`, `sellerCarrierPickupSlots`, `sellerPickups`, `sellerPickup` |
| Bookings | booked slots list with date/order/product filters, detail with customer contact | `sellerBookings`, `sellerBooking` |
| RMA | request list, detail, status transitions restricted to `allowedStatuses`, refund (status 5), cancel item (status 8), reopen, message thread with attachments | `sellerRmas`, `sellerRma`, `sellerRmaStatuses`, `sellerRmaStatus`, `sellerRmaAllowedStatus`, `sellerRmaField`, `sellerRmaImage`, `sellerRmaMessage`, `statusSellerRma`, `messageSellerRma`, `reopenSellerRma` |
| Plans | available plans, subscribe (free only), current subscription, history, cancel pending | `sellerPlans`, `sellerPlan`, `sellerSubscription`, `sellerSubscriptions`, `createSellerSubscription`, `cancelSellerSubscription` |
| Earnings | transaction list and detail with PDF link, payout statistics | `sellerTransactions`, `sellerTransaction`, `sellerTransactionStatistics` |
| Performance | account-health scorecard with metric breakdown, manual refresh honouring the one-hour cooldown | `sellerAccountHealth`, `refreshSellerAccountHealth` |
| Reviews | shop reviews, product reviews | `sellerReviews`, `sellerProductReviews` |
| Reporting | report type catalog, then any type in graph or table form with date, period and channel filters, plus export link | `sellerReportTypes`, `sellerReport` |
| Communication | admin thread, customer inbox and threads, send text and attachments, block a customer | `sellerAdminCommunication`, `sellerCustomerCommunications`, `sellerCustomerCommunication`, `sellerCommunicationMessage`, `createSellerAdminCommunication`, `createSellerCustomerCommunication`, `blockSellerCustomerCommunication` |
| Customers | customer list with search and status filter | `sellerCustomers` |
| Settings | account (locale, communication email, password change), staff users CRUD, roles CRUD with an ACL permission picker | `sellerSetting`, `sellerSettingLocale`, `updateSellerSetting`, `sellerUsers`, `sellerUser`, `createSellerUser`, `updateSellerUser`, `deleteSellerUser`, `sellerRoles`, `sellerRole`, `createSellerRole`, `updateSellerRole`, `deleteSellerRole`, `sellerAclPermissions` |

Behaviours the UI must respect rather than re-derive:

- **Update is partial for products and profile, but a full replace for marketing rules.** Omitting `status` on a discount or deal deactivates it. The marketing editors always submit the complete rule.
- **Sending `images`, `videos`, `variants`, `links`, `bundleOptions`, `downloadableLinks`, `booking` or `tickets` replaces that entire set.** Editors load the current set and resubmit everything the seller wants to keep.
- **The import pipeline is driven by `nextAction`,** never by a hardcoded step order. The loop is `while (nextAction != null) POST that action`, repeating a step while `stats.remainingBatches > 0`.
- **RMA transitions come from `allowedStatuses`,** so the status picker offers exactly what the server will accept.
- **Shipment form fields come from the carrier,** via `shipmentFields`, `capabilities`, `pickupMode` and `needsParcelDetails`.

---

## 5. Buyer-side marketplace

Added to the existing customer experience, using the existing shop client:

| Surface | Behaviour | Operations |
|---|---|---|
| Seller directory | searchable, filterable by country and city, sortable by orders/products/rating/sales/newest/name | `shopSellers` |
| Seller shop page | banner, logo, description, policies, rating, SEO, social links, custom fields | `shopSeller`, `shopSellerField`, `shopSellerLink` |
| Seller catalogue | the seller's own products with the standard storefront filters; plus a top-five best sellers strip | `shopSellerProducts`, `shopSellerTopProducts` |
| Product offers | an "Other sellers" sheet on the product page; choosing an offer adds to cart with `additional.seller_info { product_id, seller_id, is_owner }` so the order carries the seller | `shopProductOffers`, existing add-to-cart mutation |
| Messages | thread list, thread view, send text or attachment, mark read, email preference toggle | `shopCommunications`, `shopCommunication`, `createShopCommunication`, `readShopCommunication`, `shopCommunicationPreference`, `updateShopCommunicationPreference` |
| Reviews and reports | read and leave seller reviews, contact the seller, report a seller or a listing | `shopSellerReviews`, `createShopSellerReview`, `createShopSellerContact`, `shopFlagReasons`, `createShopSellerFlag`, `createShopProductFlag` |
| Become a seller | seller registration reached from the customer account menu | `createSellerRegister` |

Reporting a seller requires a customer token *and* a prior order with that seller; reporting a listing requires having bought that listing. The UI checks eligibility by attempting the action and surfacing the server's message rather than duplicating the rule.

---

## 6. Data flow

Unchanged from the app's existing convention:

```
Page → Bloc(event) → Repository(GraphQL via buildSellerClient) → Model.fromJson → State → Widgets
```

Repositories own documents, variables and response mapping. Blocs own state transitions and never build GraphQL documents. Widgets never call repositories. Errors pass through `SellerErrorMapper` on the way to state.

---

## 7. Testing

- **Unit:** one repository parsing test per module, against fixtures captured from the live server, so schema drift fails loudly.
- **Bloc:** state-machine tests for the branching flows — import pipeline, RMA transitions, per-type product editors, permission gating.
- **Maestro:** seller login → dashboard → create product → invoice and ship an order; buyer: seller shop page → offers → seller-aware add to cart.
- Existing customer tests must keep passing after the endpoint switch.

---

## 8. Documentation and agent memory

- `AGENTS.md` gains a Marketplace section covering: the correct base URL and the decoy install, no storefront key on the seller endpoint, seller-token isolation, all seller traffic through `buildSellerClient`, marketplace code confined to `lib/marketplace/**`, IRIs echoed not built, and the listing-id vs core-product-id rule.
- `aidocs/engineering/15-marketplace-architecture.md` and `16-marketplace-api-contracts.md` capture the module map and the operation contracts.
- Agent memory records the backend facts, the seller-auth isolation rule, and the two-id pitfall.
- `graphify update .` runs after each milestone.

---

## 9. Milestones

Each milestone ends in something demonstrable against the live server.

| ID | Milestone | Done when |
|---|---|---|
| M0 | Config, seller client, session, shared primitives, docs scaffold | app talks to the marketplace base; customer flows still pass |
| M1 | Seller auth: login, register, forgot and reset password | real seller logs in and the token persists |
| M2 | Shell, dashboard, profile | dashboard renders live KPIs; profile edits save |
| M3 | Products: list, filters, detail | seller's catalogue browses correctly |
| M4 | Products: create and edit all seven types, categories, inventory sources | a simple and a configurable product created from the app |
| M5 | Assign products, barcode, Magic AI | "sell yours" listing created; barcode generated |
| M6 | Orders, invoice, shipment, cancel, payment request, fulfilment carriers | an order invoiced and shipped from the app |
| M7 | RMA, bookings, customers, reviews | RMA moved through its allowed states |
| M8 | Earnings, reporting, performance, plans | statistics and a report render; a free plan subscribes |
| M9 | Marketing, bulk pricing and inventory, bulk upload | an import runs to `completed` |
| M10 | Settings, users, roles; buyer-side marketplace surfaces | staff user created; buyer buys from a chosen seller offer |

---

## 10. Risks

| Risk | Mitigation |
|---|---|
| Wrong install path silently rejects auth | base URL centralised in `ApiEnv`; a startup probe logs which install answered |
| Listing id vs core product id confusion | distinct types at compile time |
| Replace-not-merge semantics silently drop data | editors always load-then-resubmit the full set; covered by bloc tests |
| Endpoint switch regresses customer flows | M0 ends with the existing customer test suite green |
| ACL or plan gaps produce dead-end screens | permissions fetched once at login and gate rendering, not just error handling |
| Seller account is empty (0 products, 0 orders) | seed via the app itself during M4–M6; failures then reflect real API behaviour |
