# Marketplace Seller API Reference

Generated from the live OpenAPI document at
`http://192.168.15.239/theme/apis_v2.4.9/public/api/seller/docs?format=json` on 2026-08-14.

**What this file is for.** It answers "what does this endpoint do and when do I call it".
It is the reference we read while designing screens. The Postman collection
(`MarketplaceApi.graphql.postman_collection.json`) is what we copy request shapes from
while implementing.

## Transport

| | |
|---|---|
| REST base | `http://192.168.15.239/theme/apis_v2.4.9/public/api/seller` |
| GraphQL | `http://192.168.15.239/theme/apis_v2.4.9/public/api/seller/graphql` — single POST endpoint, 77 queries / 62 mutations |
| Auth | `Authorization: Bearer <sellerToken>` from `createSellerLogin` |
| Storefront key | **Not used here.** Sending `X-STOREFRONT-KEY` is wrong for seller routes; the server scopes keys to the shop API |
| Errors | REST returns real status codes (401 / 403 / 404 / 422). GraphQL returns `200` with an `errors[]` array carrying the same messages |
| Files | GraphQL cannot return a file. Endpoints hand back `downloadUrl` / `exportUrl`; fetch those with the same Bearer token |

Both transports expose the same resources, so this reference is transport-neutral:
a REST path maps to the GraphQL field of the same resource
(`GET /orders` ↔ `sellerOrders`, `POST /orders/{id}/invoices` ↔ `createSellerInvoice`).

## Conventions that apply to every endpoint

- **Collections** return `{ collection, paginationInfo }` over GraphQL and `{ data, meta }` over REST. Paging is `?page=`.
- **IRIs, not integers.** GraphQL mutations take the resource IRI (`/api/seller/products/26`) and the server returns it **prefixed with the install path**, so echo back what you received instead of building it.
- **Two product ids.** `id` is the seller catalogue id used in URLs and IRIs; `productId` is the core catalog id used inside bodies (`variants[].variantId`, `links[].associatedProductId`, `bundleOptions[].products[].productId`, and `productId` when assigning). They are not interchangeable.
- **Updates are partial** for products, profile and settings; **full replacements** for marketing rules and for any nested list you send (`images`, `variants`, `links`, `bundleOptions`, `downloadableLinks`, `booking`, `tickets`).
- **Permissions** are ACL keys from `GET /acl`; a role with `permissionType: all` bypasses the list.
- **Uploads** travel as `data:` base64 URIs or public URLs; there is no multipart endpoint.

128 operations across 22 groups.

- [Seller Authentication](#seller-authentication) — 4 endpoints
- [Seller Session](#seller-session) — 1 endpoint
- [Seller Attributes](#seller-attributes) — 1 endpoint
- [Seller Dashboard](#seller-dashboard) — 1 endpoint
- [Seller Profile](#seller-profile) — 2 endpoints
- [Seller Catalog](#seller-catalog) — 20 endpoints
- [Seller Inventories](#seller-inventories) — 2 endpoints
- [Seller Pricing](#seller-pricing) — 1 endpoint
- [Seller Bulk Upload](#seller-bulk-upload) — 17 endpoints
- [Seller Marketing](#seller-marketing) — 18 endpoints
- [Seller Orders](#seller-orders) — 12 endpoints
- [Seller Fulfilment](#seller-fulfilment) — 5 endpoints
- [Seller Sales](#seller-sales) — 8 endpoints
- [Seller Customers](#seller-customers) — 1 endpoint
- [Seller Reviews](#seller-reviews) — 2 endpoints
- [Seller Communication](#seller-communication) — 7 endpoints
- [Seller Transactions](#seller-transactions) — 2 endpoints
- [Seller Earnings](#seller-earnings) — 1 endpoint
- [Seller Reporting](#seller-reporting) — 2 endpoints
- [Seller Performance](#seller-performance) — 2 endpoints
- [Seller Plans](#seller-plans) — 6 endpoints
- [Seller Settings](#seller-settings) — 13 endpoints

---

## Seller Authentication

### `POST /forgot-password` — Request a password reset link

Request a password reset link

### `POST /login` — Seller login

Authenticate a seller with email and password. Returns a Bearer token for subsequent /api/seller calls.

### `POST /logout` — Seller logout

Revokes the seller access token used on this request. The token cannot be reused afterwards.

### `POST /register` — Register a seller

Create a new seller account. Depending on marketplace settings the account may need admin approval before it can log in. Required sign-up attributes vary per install — fetch them from GET /api/seller/attributes; send them as flat top-level fields (REST) or in the `attributes` list.

## Seller Session

### `POST /reset-password` — Reset a forgotten password

Sets a new password using the token emailed by `POST /forgot-password`. No authentication — the token is the credential.

## Seller Attributes

### `GET /attributes` — List seller sign-up / profile attributes

The attribute definitions a client renders on the registration and profile forms. Public — no token required.

## Seller Dashboard

### `GET /dashboard` — Get the seller dashboard

Everything the panel's home screen shows, in one call: headline figures, the sales graph, recent orders by status, low-stock products, and the top products, customers and categories. Each figure carries its previous-period value and the percentage change, so a client can render the up/down arrows without a second request. The window defaults to the **last 30 days** — set it with `start` / `end`.

**Permission:** `dashboard` · **Filters:** `section`, `start`, `end`, `channel`

The app's `sellerDashboard(id:, start:, end:)` GraphQL request has no `period`
argument. The dashboard date selector uses the existing request, independently
of Reports. Default range sends null dates; Today, Last 7 Days, Last 30 Days,
This Month, Last Month, Last 6 Months, This Year, Last Year and Custom range
send calendar dates in `yyyy-MM-dd`. Relative ranges use the device's local
date and are recalculated on refresh; custom ranges remain fixed. Last 7/30
Days include today, and Last 6 Months clamps to the target month's last day.
The header uses the API's `startDate`/`endDate` without shifting their timezone,
falling back to `dateRange` if dates are absent.

Verified on demo-mp-api on 2026-09-11: null dates returned Aug 12-Sep 11
(31 daily points), while explicit Last 30 Days returned Aug 13-Sep 11
(30 points). They are intentionally separate menu choices. Year-to-date
returned monthly points automatically. Sales, orders and top rankings changed
with the range; todo counts and stock-threshold rows remained current in the
tested ranges. No panel values are recomputed or filtered locally by the app.

## Seller Profile

### `GET /profile` — Get the authenticated seller's profile

Returns the profile of the seller identified by the bearer token. Requires a `seller-api` token.

### `PUT /profile` — Update the authenticated seller's profile

Include only the fields you want to change. Mirrors the seller panel (PUT). Custom / admin-created attributes go in the `attributes` list as `{ code, value }`.

### Profile Country And State Options (GraphQL)

`sellerProfile` returns saved `country` / `state` strings, not option lists.
The profile editor loads `sellerCountries { _id code name states { _id code name } }`
through the existing seller client. This query is documented under Seller >
Catalog > Inventory Sources > Countries & States in the Postman collection.
The live lookup returned 255 countries on 2026-09-11, including US / United
States with CO / Colorado. No profile mutation was performed during verification.

The profile-update collection example sends country/state codes (`IN`, `MH`).
New dropdown selections therefore send codes through the existing partial update.
Preselection matches stored codes or names without normalizing untouched values
(the demo profile stores `US` and `Colorado`). Unknown saved values are retained.
Changing country clears the old state; countries without listed states use manual
entry. Loading blocks only the location inputs temporarily, while failed/empty
lookups keep editable text fields and offer retry. Lookup state is independent
of profile save status and cannot reset other pending edits.

## Seller Catalog

### `GET /inventory-sources` — List stock locations

The seller's own inventory sources, newest first, each with the number of products holding stock there. Use `id` for `inventories[].inventorySourceId` on `PUT /products/{id}`. Requires the `inventories.inventory_sources` permission.

**Permission:** `inventories.inventory_sources` · **Filters:** `search`, `status`, `per_page`

### `POST /inventory-sources` — Create a stock location

Adds a stock location under the seller. `code` must be unique across **all** inventory sources, not just this seller's, and may only contain letters, digits, hyphens and underscores. The contact and address fields are all required, mirroring the seller panel. Requires the `inventories.inventory_sources.create` permission.

**Permission:** `inventories.inventory_sources.create`

### `DELETE /inventory-sources/{id}` — Delete a stock location

Removes the stock location. Refused when it is the seller's only **active** one, so a seller can never be left with nowhere to hold stock. Requires the `inventories.inventory_sources.delete` permission.

**Permission:** `inventories.inventory_sources.delete`

### `GET /inventory-sources/{id}` — Get one stock location

A single inventory source belonging to this seller, with its full address and contact details. Requires the `inventories.inventory_sources` permission.

**Permission:** `inventories.inventory_sources`

### `PUT /inventory-sources/{id}` — Update a stock location

Partial: only the fields present in the request are written. `PUT` mirrors the seller panel. Requires the `inventories.inventory_sources.edit` permission.

**Permission:** `inventories.inventory_sources.edit`

### `GET /products` — List the seller's products

Paginated list of the products in this seller's catalogue for the current locale, newest first. Requires the `catalog.products` permission. `price` and the images come from the seller's own listing when `isOwner` is true, and from the marketplace listing when it is false. `quantity` is the stock held at this seller's own inventory sources.

**Permission:** `catalog.products` · **Filters:** `search`, `type`, `status`, `is_approved`, `approval_state`, `is_draft`, `exclude_customizable`, `per_page`

### `POST /products` — Create a product

Creates the product **skeleton** only — type, attribute family and SKU — mirroring the seller panel, which then opens the edit screen. Populate name, price, description, images and inventory with `PUT /products/{id}`.

**Permission:** `catalog.list_your_product`

### `POST /products/assign` — Sell an existing catalogue product

Starts selling a product that already exists in the marketplace — the panel's "Sell Yours" / Assign action. `productId` is the **core** product id (the `productId` field, not the seller catalogue `id`). The listing is created with `isOwner: false`, so the seller's own price, condition, description, photos and stock live on their listing and the shared product is never touched.

**Permission:** `catalog.products.assign`

### `GET /products/assignable` — Search products you could sell

Products already in the marketplace that this seller could start selling, newest first. `id` is the **core product id** — pass it straight to `POST /products/assign` as `productId`. Anything the seller already sells is excluded, as is any type their plan does not allow, so every row here is assignable.

**Permission:** `catalog.products.assign` · **Filters:** `search`, `type`, `per_page`

### `POST /products/barcodes` — Generate barcodes in bulk

Generates or regenerates barcodes for several products in one call — the products grid's Generate mass action. `ids` are seller catalogue ids (`marketplace_products.id`), the same ones the grid selects. `type` is optional and defaults to the marketplace's configured symbology.

**Permission:** `catalog.products.barcode.generate`

### `GET /products/categories` — List assignable categories

Every category this seller may put a product in — active, under the current channel's root, and with the categories the admin has restricted for this seller removed.

**Permission:** `catalog.products`

### `POST /products/delete` — Delete products in bulk

Removes several products in one call. `ids` are **seller catalogue ids** (`marketplace_products.id`) — the same ones the grid selects and the same `id` the product list returns, not core product ids.

**Permission:** `catalog.products.delete`

### `DELETE /products/{id}` — Remove a product from the seller's catalogue

**Two different outcomes, decided by `isOwner`.** When the seller owns the listing (`isOwner: true`) the product is deleted from the marketplace entirely. When they were assigned someone else's product (`isOwner: false`) only their listing is removed and the product survives for everyone else. Check `isOwner` first and warn the seller accordingly. `{id}` is the seller catalogue id.

**Permission:** `catalog.products.delete`

### `GET /products/{id}` — Get one of the seller's products

A single catalogue entry with its descriptions, SEO fields, images, per-source stock and categories. `{id}` is the seller catalogue id (`marketplace_products.id`) returned as `id` by the list — not the core `productId`. Requires the `catalog.products` permission.

**Permission:** `catalog.products`

### `PUT /products/{id}` — Update a product

Fills in a product created by `POST /products`, and edits it thereafter. **Partial — send only the fields you want to change**; anything omitted is left untouched, including categories, inventories and images. `{id}` is the seller catalogue id. `categories` REPLACES the current set when sent. `inventories` is `{ sourceId: qty }` and only the seller's own inventory sources are accepted.

For configurable products, the seller GraphQL `updateSellerProduct` mutation can add variants with entries containing `superAttributes` (attribute code to option id), `sku`, `name`, `price`, `weight`, `status`, and `inventories` (`inventorySourceId` plus `qty`). New entries omit `variantId`; entries with `variantId` update existing variants. The variants list replaces the set, so retain existing variants in the request when adding more. Configurable creation may send selected attribute codes with empty `values`; option combinations are added after the parent is saved.

For table booking, `booking.qty` carries guest capacity and `booking.tableSlot.guestLimit` carries the guest limit per table. The server's accepted `tableSlot.priceType` values are `guest` and `table` (per server developer confirmation); the Postman example currently says `per_guest`, so treat that example as stale. The app maps those wire values to its internal `per_guest` / `per_table` dropdown values when reading a product, and maps them back to `guest` / `table` when saving.

**Permission:** `catalog.products.edit`

### `createSellerProductVariantMassUpdate` — Bulk edit selected variants

Seller GraphQL mutation at `/api/seller/graphql`. Send `createSellerProductVariantMassUpdateInput!` with `productId` set to the configurable parent's **seller catalogue id** (the numeric tail of its server-issued seller IRI) and `variantIds` set to the selected variants' **core product ids** from `sellerProduct.variants[].variantId`. The mutation touches only selected variants. Re-read `sellerProduct` after success because the response contains a count and message, not updated variant rows.

Actions and fields: `editName` (`name`), `editSku` (`values` keyed by variant ID), `editPrices` (`price`), `editInventories` (`inventories` keyed by source ID), `editWeight` (`weight`), `editStatus` (`status` boolean), `addImages` (`images` list), `removeImages`, and `removeVariants`. Actions with a shared value may also take per-variant `values`, where an entry overrides the shared value. `addImages` appends; `removeImages` removes all images from selected variants. Unspecified inventory sources retain stock. This mutation does not use the full replacement semantics of `updateSellerProduct.variants` above.

Live same-value checks on the `Bagisto-Api/mp-app` install passed for shared and per-variant `values` on name, SKU, price, weight, status, and inventory, plus `removeImages` on an empty-image variant. `addImages` and `removeVariants` are documented in `MarketplaceApi.graphql.postman_collection (2).json` but were not exercised on shared data.

**Permission:** `catalog.products.edit`

### `GET /products/{id}/attributes` — List a product's editable attributes

Every attribute on this product's attribute family, with its definition and current value — the product equivalent of `GET /attributes`. Use it to discover the **extra / custom attributes** beyond the fixed fields `PUT /products/{id}` accepts, and to render an edit form dynamically. `{id}` is the seller catalogue id.

**Permission:** `catalog.products`

### `GET /products/{id}/barcode` — Get a product's barcode

The barcode currently stored on the product: its value, symbology, the stored image and a self-contained PNG data URI for previewing. `{id}` is the seller catalogue id. `value` is empty until a barcode has been generated. Requires the `catalog.products.barcode` permission.

**Permission:** `catalog.products.barcode`

### `POST /products/{id}/barcode` — Generate a product barcode

Generates (or regenerates) the barcode image for one product, exactly like the grid's Generate mass action. `type` picks the symbology and defaults to the marketplace's configured default.

**Permission:** `catalog.products.barcode.generate`

### `GET /products/{id}/magic-ai` — Get Magic AI context for a product

Everything a client needs to render the generate form for one product.

**Permission:** `catalog.products.magic_ai`

### `POST /products/{id}/magic-ai/generate` — Generate product content with Magic AI

Asks the configured AI provider to propose attribute values for one of the seller's products from a description they write.

**Permission:** `catalog.products.magic_ai`

## Seller Inventories

### `POST /inventories/mass-save` — Save stock for many products

Writes per-source quantities for several products in one call — the Manage Inventory grid's bulk save.

**Permission:** `inventories.manage_inventory.save_inventories`

### `POST /inventories/mass-update-status` — Activate or disable products in bulk

Turns several products on or off at once — the Manage Inventory grid's status action.

**Permission:** `inventories.manage_inventory.update`

## Seller Pricing

### `POST /pricing/mass-save` — Reprice many products

Sets price, sale price and customer-group tiers for several products in one call — the Manage Pricing grid's bulk save.

**Permission:** `pricing.manage_pricing.save_prices`

## Seller Bulk Upload

### `GET /imports` — List imports

This seller's bulk uploads, newest first. `stats` is null here — fetch an import's detail for progress. Requires the `catalog.bulk_upload.imports` permission.

**Permission:** `catalog.bulk_upload.imports` · **Filters:** `state`, `per_page`

### `POST /imports` — Create an import

Uploads the file and creates the job in `pending`. **Nothing is imported yet** — call `validate` next, then follow `next_action`.

**Permission:** `catalog.bulk_upload.imports.create`

### `POST /imports/delete` — Delete several imports

Removes several imports and everything each one owns — its uploaded file, unpacked images and generated reports.

**Permission:** `catalog.bulk_upload.imports.delete`

### `GET /imports/samples` — Where to download the import sample files

Links to the starter spreadsheet and the sample product-images zip, one row per configured importer. Requires the `catalog.bulk_upload.imports` permission.

### `DELETE /imports/{id}` — Delete an import

Removes the import along with its uploaded file, error report and any unpacked images. Products already created by a completed run are **not** touched. Requires the `catalog.bulk_upload.imports.delete` permission.

**Permission:** `catalog.bulk_upload.imports.delete`

### `GET /imports/{id}` — Get one import

The import with its current `state`, row counts, validation `errors`, `is_valid`, and — most usefully — **`next_action`**, the exact call to make next. `stats` reports progress for the phase that action belongs to. Requires the `catalog.bulk_upload.imports` permission.

**Permission:** `catalog.bulk_upload.imports`

### `PUT /imports/{id}` — Update an import

Partial: only the fields sent are written. **Any update resets the job** — state back to `pending`, all row counts and errors cleared, the old error report deleted — because changed settings invalidate whatever was already processed. That is the panel's behaviour too. Sending a new `file` replaces the old one. Requires the `catalog.bulk_upload.imports.edit` permission.

**Permission:** `catalog.bulk_upload.imports.edit`

### `GET /imports/{id}/images` — Image pre-fetch progress

How far the image pre-fetch has got, without advancing it.

**Permission:** `catalog.bulk_upload.imports`

### `POST /imports/{id}/images` — Pre-fetch an import's remote images

Downloads the next wave of the import's remote product images and records each outcome, so the creation phase later runs with **no network calls at all**.

**Permission:** `catalog.bulk_upload.imports.import`

### `POST /imports/{id}/index` — Index the next batch

Rebuilds the flat and price tables so the imported products become searchable and visible on the storefront — **one batch per call**. The last phase; when it drains, the import moves to `completed` and `next_action` becomes null. Requires the `catalog.bulk_upload.imports.import` permission.

**Permission:** `catalog.bulk_upload.imports.import`

### `POST /imports/{id}/link` — Link the next batch

Resolves relationships the imported rows refer to — configurable variants, cross-sells and the like — **one batch per call**, like `start`. Only needed when `next_action` says so; plenty of imports skip straight to `index` or finish. Requires the `catalog.bulk_upload.imports.import` permission.

**Permission:** `catalog.bulk_upload.imports.import`

### `GET /imports/{id}/queued-validation` — Queued validation progress

How far queued validation has got, without dispatching anything.

**Permission:** `catalog.bulk_upload.imports`

### `POST /imports/{id}/queued-validation` — Validate a large sheet on the queue

Fans the import's validation out across queue workers and returns immediately.

**Permission:** `catalog.bulk_upload.imports.import`

### `GET /imports/{id}/report` — Get an import's run summary

What the import did, once it has run.

**Permission:** `catalog.bulk_upload.imports`

### `POST /imports/{id}/start` — Process the next batch

Imports **one batch** of rows and returns the updated `stats`. Call it again while `stats.remaining_batches` is above zero; when it hits zero, `next_action` moves you to `link`, `index`, or null. With `processInQueue: true` a single call hands the whole run to the queue instead — then just poll `stats`. Requires the `catalog.bulk_upload.imports.import` permission.

**Permission:** `catalog.bulk_upload.imports.import`

### `GET /imports/{id}/stats` — Poll import progress

Progress without advancing anything — the endpoint to poll while a queued run works through its batches. `?state=` picks which phase to measure, defaulting to the one the import is currently in. Requires the `catalog.bulk_upload.imports` permission.

**Permission:** `catalog.bulk_upload.imports` · **Filters:** `state`

### `POST /imports/{id}/validate` — Validate an import

Parses the file, checks every row and splits it into batches. Always the first step after upload. Afterwards `processed_rows_count`, `invalid_rows_count`, `errors` and `is_valid` are populated; `is_valid: false` means the run cannot start — read `errors`, or download the error report. This is **not** an error: a file with bad rows validates successfully and reports them.

**Permission:** `catalog.bulk_upload.imports.import`

## Seller Marketing

### `GET /marketing/checkout-deals` — List checkout deals

The seller's own cart rules, newest first, in a `{ data, meta }` envelope.

**Permission:** `marketing.checkout_deals` · **Filters:** `search`, `status`, `coupon_type`, `per_page`

### `POST /marketing/checkout-deals` — Create a checkout deal

Creates a cart rule owned by this seller.

**Permission:** `marketing.checkout_deals.create`

### `DELETE /marketing/checkout-deals/coupons/{id}` — Delete a coupon code

Removes one coupon code. `{id}` here is the **coupon** id, not the deal id — the one place in this section where that is so.

**Permission:** `marketing.checkout_deals.coupons`

### `DELETE /marketing/checkout-deals/{id}` — Delete a checkout deal

Removes the deal and, with it, every coupon code generated for it.

**Permission:** `marketing.checkout_deals.delete`

### `GET /marketing/checkout-deals/{id}` — Get one checkout deal

One of the seller's own deals, with its conditions, channels, customer groups and — when it uses a single code — that `couponCode`.

**Permission:** `marketing.checkout_deals`

### `PUT /marketing/checkout-deals/{id}` — Update a checkout deal

Replaces the deal's settings.

**Permission:** `marketing.checkout_deals.edit`

### `POST /marketing/checkout-deals/{id}/copy` — Duplicate a checkout deal

Copies one of the seller's deals into a **new, inactive** deal named "Copy of <original>", with the same channels and customer groups, and returns it.

**Permission:** `marketing.checkout_deals.copy`

### `GET /marketing/checkout-deals/{id}/coupons` — List a deal's coupon codes

Every coupon code attached to one of the seller's deals, newest first, in a `{ data, meta }` envelope. `{id}` here is the **deal** id.

**Permission:** `marketing.checkout_deals.coupons` · **Filters:** `search`, `per_page`

### `POST /marketing/checkout-deals/{id}/coupons` — Generate coupon codes

Generates a batch of unique codes for one of the seller's deals. `{id}` is the **deal** id.

**Permission:** `marketing.checkout_deals.coupons`

### `GET /marketing/product-discounts` — List product discounts

The seller's own catalog rules, newest first, in a `{ data, meta }` envelope.

**Permission:** `marketing.product_discounts` · **Filters:** `search`, `status`, `per_page`

### `POST /marketing/product-discounts` — Create a product discount

Creates a catalog rule owned by this seller and reindexes so the discount takes effect on the storefront.

**Permission:** `marketing.product_discounts.create`

### `GET /marketing/product-discounts/join` — List joinable admin discounts

Admin catalog rules open for participation, newest first, in a `{ data, meta }` envelope.

**Permission:** `marketing.product_discounts.join` · **Filters:** `search`, `status`, `participation`, `per_page`

### `POST /marketing/product-discounts/join/enroll` — Join admin discounts

Requests participation in one or more admin catalog rules, then rebuilds each rule's price index so the discount starts applying to this seller's products.

**Permission:** `marketing.product_discounts.join.enroll`

### `POST /marketing/product-discounts/join/withdraw` — Leave admin discounts

Drops this seller's participation in one or more admin catalog rules and rebuilds each rule's price index, so the discount stops applying to their products.

**Permission:** `marketing.product_discounts.join.withdraw`

### `GET /marketing/product-discounts/join/{id}` — Get one joinable admin discount

The read-only detail the panel's Join → View page shows: the admin rule's terms — discount, dates, conditions, channels and customer groups — plus this seller's `participation`.

**Permission:** `marketing.product_discounts.join.view`

### `DELETE /marketing/product-discounts/{id}` — Delete a product discount

Removes the rule and cleans its index, so the discount stops applying immediately.

**Permission:** `marketing.product_discounts.delete`

### `GET /marketing/product-discounts/{id}` — Get one product discount

One of the seller's own discounts, with its conditions, channels and customer groups.

**Permission:** `marketing.product_discounts`

### `PUT /marketing/product-discounts/{id}` — Update a product discount

Replaces the rule's settings and reindexes.

**Permission:** `marketing.product_discounts.edit`

## Seller Orders

### `GET /invoices/{id}` — Get one seller invoice

One invoice by its id, scoped to the seller through its order. `{id}` is the marketplace invoice id — the `id` returned by `GET /orders/{id}/invoices`, and the one in `downloadUrl`. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

### `GET /orders` — List the seller's orders

Paginated list of the authenticated seller's orders. `?per_page` (max 50), `?page`. Filter by payout state with `?payout_status=` — use `pending` to find the orders that can still be sent to `POST /orders/{id}/payment-request`.

**Filters:** `search`, `payout_status`, `per_page`

### `GET /orders/{id}` — Get one seller order

Get one seller order

### `POST /orders/{id}/cancel` — Cancel a seller order

Cancels the seller's cancellable items on the order, mirroring the seller panel. Requires the `sales.orders.cancel` permission and the "sellers can cancel orders" setting.

**Permission:** `sales.orders.cancel`

### `GET /orders/{id}/invoices` — List a seller order's invoices

The invoices raised on one of the seller's orders. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

### `POST /orders/{id}/invoices` — Create an invoice on a seller order

Creates an invoice for the given quantities of the order's items, mirroring the seller panel's "Create Invoice" action. Requires the `sales.orders.invoice` permission, and the order must have items still to invoice. Items omitted (or sent with qty 0) are not invoiced.

**Permission:** `sales.orders.invoice`

### `GET /orders/{id}/items` — List a seller order's items

The line items on one of the seller's orders. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

### `POST /orders/{id}/payment-request` — Request payment for an order

Marks the order as awaiting payout and emails the marketplace admin, mirroring the seller panel's "Request Payment" action. `{id}` is the marketplace order id, the same one `GET /orders` returns. No body is needed. Refused when the order is already `requested`, `paid` or `refunded` — check `sellerPayoutStatus` on the order, or list eligible orders with `GET /orders?payout_status=pending`.

**Permission:** `sales.orders.payment_request`

### `GET /orders/{id}/refunds` — List a seller order's refunds

The refunds raised on one of the seller's orders. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

### `GET /orders/{id}/shipments` — List a seller order's shipments

The shipments raised on one of the seller's orders. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

### `POST /orders/{id}/shipments` — Create a shipment on a seller order

Ships the given quantities of the order's items from an inventory source — the seller panel's "Create Shipment" action.

**Permission:** `sales.orders.shipment`

### `GET /shipments/{id}` — Get one seller shipment

One shipment by its id, scoped to the seller through its order. `{id}` is the marketplace shipment id — the `id` returned by `GET /orders/{id}/shipments`. Requires the `sales.orders.view` permission.

**Permission:** `sales.orders.view`

## Seller Fulfilment

### `GET /fulfilment/carriers` — List available fulfilment carriers

Every carrier this seller may ship with — registered, switched on by the operator, and fully configured. A carrier the operator has not finished setting up is omitted rather than offered and then failed at booking time.

**Permission:** `sales.orders.shipment`

### `GET /fulfilment/carriers/{code}` — Get one fulfilment carrier

One carrier by its registry code, e.g. `manual`.

**Permission:** `sales.orders.shipment`

### `GET /fulfilment/carriers/{code}/pickup-slots` — Get a carrier's collection options for a date

The collection windows a carrier will make from one of the seller's inventory sources on a date.

**Permission:** `sales.orders.shipment` · **Filters:** `inventory_source_id`, `date`

### `GET /fulfilment/pickups` — List booked courier collections

The seller's courier collections, newest window first, in a `{ data, meta }` envelope.

**Permission:** `sales.orders.shipment` · **Filters:** `status`, `carrier_code`, `inventory_source_id`, `per_page`

### `GET /fulfilment/pickups/{id}` — Get one courier collection

One of the seller's collections, with the shipments it covers.

**Permission:** `sales.orders.shipment`

## Seller Sales

### `GET /bookings` — List bookings

Slots customers have booked against this seller's booking products, soonest first. Each row carries the slot, the product, the order and the customer who booked it — everything the panel's grid and calendar show. `from` / `to` bound the slot, so `?from=`/`?to=` gives the calendar view for a week or a month. Requires the `sales.bookings` permission.

**Permission:** `sales.bookings` · **Filters:** `from`, `to`, `order_id`, `product_id`, `per_page`

### `GET /bookings/{id}` — Get one booking

A single booking, with the customer's contact details and billing address — what a seller needs to actually honour the slot. The panel has no detail screen; it only shows a calendar tooltip, so this exposes the same fields as a proper record. Requires the `sales.bookings` permission.

**Permission:** `sales.bookings`

### `GET /rma` — List return requests

Return requests raised against this seller's order items, newest first. `messages`, `images` and `additional_fields` are empty here — fetch the detail for those. Requires the `sales.rma` permission.

**Permission:** `sales.rma` · **Filters:** `search`, `rma_status_id`, `order_id`, `resolution`, `from`, `to`, `per_page`

### `GET /rma/statuses` — List RMA statuses

Every active RMA status with its id, title and display colour — the values `rmaStatusId` accepts. Two of them carry side effects when set: `5` refunds the item, `8` cancels it. Requires the `sales.rma` permission.

**Permission:** `sales.rma`

### `GET /rma/{id}` — Get one return request

The full request: the item and why it came back, the customer's photos, any custom fields the admin defined, the whole conversation oldest-first, and — most usefully — `allowed_statuses`, the exact set of statuses this request may move to next, so a client never has to reimplement the transition rules. Requires the `sales.rma.view` permission.

**Permission:** `sales.rma.view`

### `POST /rma/{id}/messages` — Reply on a return request

Adds a message to the conversation. One of `message` or `attachment` is required; the attachment is a URL or `data:` base64 URI (jpeg, png, pdf, doc, docx), the same shape every other media field in this API takes. The customer is emailed. Requires the `sales.rma.view` permission.

**Permission:** `sales.rma.view`

### `POST /rma/{id}/reopen` — Reopen a declined return request

Puts a declined request back to Pending Review and the order back to `pending`, and notes it in the conversation. Only possible while `can_reopen` is true — the request must be declined and the admin must have switched on "allow new RMA request for declined request". Requires the `sales.rma.view` permission.

**Permission:** `sales.rma.view`

### `POST /rma/{id}/status` — Change the status of a return request

Moves the request to `rmaStatusId`, which must be one of the ids in `allowed_statuses` on the detail — anything else is refused rather than silently applied. A note is added to the conversation and the customer is emailed.

**Permission:** `sales.rma.view`

## Seller Customers

### `GET /customers` — List customers who bought from the seller

Paginated list of customers who have placed an order with this seller. `revenue` and `orderCount` are **this seller's** figures only, not the customer's marketplace-wide totals; revenue sums invoiced totals and excludes cancelled and closed orders. Requires the `customers` permission. The email is masked unless the marketplace has "sellers can view customers" enabled.

**Permission:** `customers` · **Filters:** `search`, `status`, `per_page`

## Seller Reviews

### `GET /product-reviews` — List reviews on the seller's products

Paginated list of reviews customers left on the seller's products, newest first, for the current channel and locale. Requires the `performance.product_reviews` permission. The customer email is masked unless the marketplace has "sellers can view customers" enabled.

**Permission:** `performance.product_reviews` · **Filters:** `status`, `product_id`, `per_page`

### `GET /reviews` — List the seller's shop reviews

Paginated list of reviews customers left on the seller's shop, newest first. Requires the `performance.seller_reviews` permission. The customer email is masked unless the marketplace has "sellers can view customers" enabled.

**Permission:** `performance.seller_reviews` · **Filters:** `status`, `per_page`

## Seller Communication

### `GET /communications/admin` — Get the conversation with the admin

The seller's single thread with the marketplace admin, oldest message first. Opening it **marks the admin's messages as read**, exactly as the panel's screen does. `isBlocked` is set by the admin and is read-only here — when true the seller can still read but sending returns 422, so a client should disable its composer. `?days=` narrows the history to the panel's own windows.

**Permission:** `communication.admin` · **Filters:** `days`

### `POST /communications/admin` — Message the admin

Sends a message to the marketplace admin, creating the thread on first use. Send `message`, `attachment`, or both — one of the two is required. The attachment is a URL or `data:` base64 URI (jpeg, png, pdf, doc, docx), the same shape product media takes; the panel uses a multipart upload, but this keeps the field usable over GraphQL. Refused with 422 when the admin has blocked the thread.

**Permission:** `communication.admin`

### `GET /communications/customers` — List customer conversations

Customers this seller has a thread with, most recently active first, each with its last message and unread count — the inbox list. `id` is the **customer id**, which every other endpoint in this group takes. Requires the `communication.customers` permission.

**Permission:** `communication.customers` · **Filters:** `search`, `per_page`

### `GET /communications/customers/{id}` — Get one customer conversation

The thread with one customer, oldest message first. `{id}` is the customer id. Unlike the admin thread this does **not** mark anything read — the panel has a separate action for that, so a client can decide when the messages were actually seen. `?days=` narrows the history. Requires the `communication.customers` permission.

**Permission:** `communication.customers` · **Filters:** `days`

### `POST /communications/customers/{id}` — Message a customer

Sends a message to the customer, starting the thread on first use. One of `message` or `attachment` is required; the attachment is a URL or `data:` base64 URI (jpeg, png, pdf, doc, docx). The customer is **emailed**, unless they have turned that off in their own communication settings. `{id}` is the customer id. Requires the `communication.customers` permission.

**Permission:** `communication.customers`

### `POST /communications/customers/{id}/block` — Block or unblock a customer

Stops or resumes messages on this thread. `{id}` is the customer id — the panel takes the communication row's id, which a client has no other reason to hold. Requires the `communication.customers` permission.

**Permission:** `communication.customers`

### `POST /communications/customers/{id}/read` — Mark a conversation as read

Marks the customer's messages in this thread as read. The panel uses `PATCH`; this is `POST` because it is an action on a sub-path, matching the other action endpoints in this API. Requires the `communication.customers` permission.

**Permission:** `communication.customers`

## Seller Transactions

### `GET /transactions` — List the seller's transactions

Paginated list of the authenticated seller's payout transactions, newest first. `?per_page` (max 50), `?page`. Requires the `sales.transactions` permission.

**Permission:** `sales.transactions` · **Filters:** `per_page`

### `GET /transactions/{id}` — Get one seller transaction

A single payout transaction belonging to the seller. Requires the `sales.transactions.view` permission.

**Permission:** `sales.transactions.view`

## Seller Earnings

### `GET /transactions/statistics` — Get payout totals

The five figures the panel shows above the transaction list, for the requested window.

**Permission:** `sales.transactions` · **Filters:** `start`, `end`

## Seller Reporting

### `GET /reporting` — Get a sales, product or customer report

Runs one of the seller panel's reports. `type` is required — see `GET /reporting/types` for the list and the permission each needs. `format: graph` (the default) returns the panel's chart payload, comparing the selected period against the one before it; `format: table` returns `{ columns, records }` ready to render as a grid. The window defaults to the **last 30 days** and is set with `start` / `end`.

**Filters:** `type`, `format`, `start`, `end`, `period`, `channel`

The app's report dropdown sends explicit `yyyy-MM-dd` dates, using the device's
local calendar: `day` requests today through today, `month` requests the first
day of this month through today, and `year` requests January 1 through today.
These presets apply to Sales, Products and Customers and are recalculated on
refresh. Changing the period clears any custom range. Labels, statistics and
export URLs remain sourced from the matching API response; superseded requests
cannot overwrite the latest selection. The server's omitted-date default above
is unchanged.

### `GET /reporting/types` — List available reports

Every value `GET /reporting?type=` accepts, with the entity it belongs to and the permission it needs. Only types the seller actually has permission for are listed, so an app can render its reporting menu straight from this. Requires the `reporting` permission.

**Permission:** `reporting`

## Seller Performance

### `GET /account-health` — Get the account-health scorecard

Everything the panel's Account Health screen shows: a composite `score` out of 100, an `overall` verdict, and the three metrics behind them.

**Permission:** `performance.account_health`

### `POST /account-health/refresh` — Recalculate the scorecard

Recomputes the three raw inputs from live data and stores them, then returns the freshly built scorecard — the same shape `GET /account-health` returns, so a client can swap it straight into the view without a second call.

**Permission:** `performance.account_health.refresh`

## Seller Plans

### `GET /plans` — List available plans

Every active plan, in the order the admin arranged them, with its limits, commission, unlocked permissions and allowed product types. `is_current` marks the one this seller is on. A plain array, not a `{ data, meta }` envelope. Requires the `plans.available` permission — which an unsubscribed seller still holds, so this is reachable before subscribing.

**Permission:** `plans.available`

### `POST /subscribe` — Subscribe to a plan

Subscribes the seller to `planId` and returns the new subscription, already active.

**Permission:** `plans.available`

### `GET /subscription` — Get the current subscription

The seller's active subscription — the one the permission gate reads. `days_remaining` counts down to `ends_at`; a null `ends_at` means it never expires. 404 when the seller has never subscribed or their last subscription lapsed, which is the signal to send them to the plan list. Requires the `plans` permission.

**Permission:** `plans`

### `GET /subscription-history` — List past subscriptions

Every subscription this seller has ever had, newest first, in a `{ data, meta }` envelope — the panel's Plans → History. Requires the `plans.history` permission.

**Permission:** `plans.history` · **Filters:** `status`, `per_page`

### `GET /subscription/{id}` — Get one past subscription

A single subscription of this seller's by id, active or not — the detail behind a history row. Requires the `plans.history` permission.

**Permission:** `plans.history`

### `POST /subscription/{id}/cancel` — Cancel a pending subscription

Cancels a subscription that is still `pending` — one started in the panel whose payment was never completed. An `active` subscription cannot be cancelled: Marketplace has no such feature, it simply runs to `ends_at` and expires. Requires the `plans` permission.

**Permission:** `plans`

## Seller Settings

### `GET /acl` — List assignable permissions

Every permission key a `custom` role may grant, in the panel's own order, with its label and its parent. Use `key` values in `permissions` on `POST /roles`. Granting a child key without its parent has no effect — the permission check walks up the tree — so send both. Requires the `settings.roles` permission.

**Permission:** `settings.roles`

### `GET /roles` — List roles

The seller's own roles, newest first, each with the number of staff currently holding it. Requires the `settings.roles` permission.

**Permission:** `settings.roles` · **Filters:** `search`, `permission_type`, `per_page`

### `POST /roles` — Create a role

Adds a role under the seller. `permissionType: all` grants every permission and ignores `permissions`; `custom` requires at least one key from `GET /acl`. Unknown keys are rejected rather than stored. Requires the `settings.roles.create` permission.

**Permission:** `settings.roles.create`

### `DELETE /roles/{id}` — Delete a role

Removes the role. Refused while any staff member still holds it, and refused when it is the seller's only role. Requires the `settings.roles.delete` permission.

**Permission:** `settings.roles.delete`

### `GET /roles/{id}` — Get one role

A single role belonging to this seller, with its permission list. Requires the `settings.roles` permission.

**Permission:** `settings.roles`

### `PUT /roles/{id}` — Update a role

Partial: only the fields present in the request are written. Narrowing the seller's **last** `all` role to `custom` is refused, so a team can never lock itself out. `PUT` mirrors the seller panel. Requires the `settings.roles.edit` permission.

**Permission:** `settings.roles.edit`

### `GET /settings` — Get my settings

Preferred locale, the communication-email preference, and the list of locales that may be chosen — so a client can render the whole form in one call. `currency` is the marketplace's base currency and is read-only; the panel shows it disabled. Requires the `settings.general` permission.

**Permission:** `settings.general`

### `PUT /settings` — Update my settings, or change my password

Partial: only the fields present in the request are written, so a client can flip one preference without restating the rest. The panel's form always posts every field and marks `preferred_locale` required; that would be hostile here, so it is optional.

**Permission:** `settings.general`

### `GET /users` — List staff members

The seller's staff accounts, newest first, with the role each one holds. Requires the `settings.users` permission. Only the owner's own staff are listed — the owner account itself is not a member of this collection.

**Permission:** `settings.users` · **Filters:** `search`, `role_id`, `is_suspended`, `per_page`

### `POST /users` — Create a staff member

Adds a staff account under the seller. `marketplaceRoleId` must be one of the seller's own roles, `email` and `phone` must be unique across all sellers, and the password needs `passwordConfirmation` to match. The new account inherits the owner's channels and is created approved. Requires the `settings.users.create` permission; when subscriptions are enabled the plan's `max_staff` cap is enforced.

**Permission:** `settings.users.create`

### `DELETE /users/{id}` — Delete a staff member

Removes the staff account. You cannot delete your own account. Requires the `settings.users.delete` permission.

**Permission:** `settings.users.delete`

### `GET /users/{id}` — Get one staff member

A single staff account belonging to this seller. Requires the `settings.users` permission.

**Permission:** `settings.users`

### `PUT /users/{id}` — Update a staff member

Partial: only the fields present in the request are written. Omit `password` to leave it unchanged; send it with a matching `passwordConfirmation` to reset it. `PUT` mirrors the seller panel, which uses `Route::put`. You cannot edit your own account here — use `PUT /profile`. Requires the `settings.users.edit` permission.

**Permission:** `settings.users.edit`
