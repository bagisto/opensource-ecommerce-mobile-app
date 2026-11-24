# Marketplace Product Types Implementation Plan — M4b

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** The editor can compose the type-specific data every product type needs — configurable variants, grouped links, bundle options, downloadable files and booking configuration — and the list can delete in bulk.

**Architecture:** Each type gets a section widget under `features/products/presentation/widgets/types/`, all feeding the existing `SellerProductDraft`. The draft grows one field per structure, each emitted whole because the API replaces these lists wholesale.

## Verified constraints (live, 2026-08-14)

These were confirmed by probing the running server, and they shape every decision below.

1. **The type-specific structures are write-only.** `SellerProductItem` exposes no `variants`, `links`, `bundleOptions`, `downloadableLinks`, `downloadableSamples` or `booking` field. The app can send them; it cannot read them back. Editors therefore state that saving replaces the whole set, and they never pretend to show server state they do not have.
2. **Configurable variants become their own catalogue rows.** Creating `cfg-x` with `color:[1,2]` and `size:[6,7]` produced four extra listings named `cfg-x-variant-<colorId>-<sizeId>`, each with its own listing id and core `productId`. The variant editor finds them by searching the catalogue for the parent SKU, which is the only discovery route the API offers.
3. **Attribute option labels are not exposed.** Both transports return the options as IRIs with `label: null`, so a colour or size picker can only show the option id. The UI shows `#<id>` and lets the seller type the ids they know from the panel, rather than inventing names.
4. **Attribute families are not queryable, and ids differ per install** — family `3` does not exist here while `1` does. The create screen already takes the id as a number with an explanation.
5. **`variants[].variantId` is the variant's core product id**, not its catalogue id — the same two-id trap as everywhere else.

---

### Task 1: Draft support for the type-specific lists

**Files:** modify `seller_product_draft.dart`; test `test/marketplace_seller_product_type_payload_test.dart`.

**Produces:** on `SellerProductDraft` — `variants`, `links`, `bundleOptions`, `downloadableLinks`, `downloadableSamples`, `booking`; each null when untouched and emitted whole when set. New value types: `SellerVariantEdit`, `SellerGroupedLink`, `SellerBundleOption`, `SellerBundleOptionProduct`, `SellerDownloadableLink`, `SellerDownloadableSample`, `SellerBookingConfig`, `SellerBookingSlot`, `SellerBookingTicket`.

- [ ] **Step 1:** Failing tests — each structure serialises to the documented shape; untouched structures stay out of the payload; `variantId` carries the core product id; booking emits only the sub-object its type uses (`rentalSlot` for rental, `tableSlot` for table, `tickets` for event, `slots` otherwise).
- [ ] **Step 2:** Run, watch fail.
- [ ] **Step 3:** Implement the value types and extend `toInput()`.
- [ ] **Step 4:** Green, analyze, commit `feat: add product type payloads to the seller draft`.

---

### Task 2: Variant discovery and editing

**Files:** `features/products/data/repository/seller_product_repository.dart` (add `variantsOf`), `presentation/widgets/types/seller_variant_section.dart`; tests.

**Produces:** `variantsOf(String parentSku)` → `List<SellerProductListItem>`, implemented as a catalogue search for `"$parentSku-variant-"` because no parent→variant link is exposed; a section that lists each variant with editable SKU, name, price, weight, status and stock, writing into `draft.variants`.

- [ ] **Step 1:** Failing tests — `variantsOf` searches on the parent SKU and drops the parent row itself; editing one variant emits every variant in the payload with its `variantId`.
- [ ] **Step 2–3:** Run, implement, green.
- [ ] **Step 4:** Commit `feat: add configurable variant editing`.

---

### Task 3: Grouped and bundle sections

**Files:** `presentation/widgets/types/seller_grouped_section.dart`, `seller_bundle_section.dart`, plus a shared `seller_product_picker.dart` that reuses the catalogue listing as the picker; ARB strings; tests.

The picker is the product list with `exclude_customizable=1` for bundles, which the API documents as the only difference from the ordinary listing.

- [ ] **Step 1:** ARB strings, `flutter gen-l10n`.
- [ ] **Step 2:** Failing tests — grouped links emit `associatedProductId`, `qty`, `sortOrder`; bundle options emit locales, type, required flag and their products.
- [ ] **Step 3–4:** Implement, green.
- [ ] **Step 5:** Commit `feat: add grouped and bundle product editing`.

---

### Task 4: Downloadable and booking sections

**Files:** `presentation/widgets/types/seller_downloadable_section.dart`, `seller_booking_section.dart`; ARB strings; tests.

Downloadable: purchasable links and free samples, each `url` or `file` (device pick → base64 data URI), with price and download limit.
Booking: the five modes — default (slots, `bookingType` one/many), appointment (per-day slots), event (tickets), rental (renting type and prices), table (guest limit, duration, slots).

- [ ] **Step 1:** ARB strings, `flutter gen-l10n`.
- [ ] **Step 2:** Failing tests — a downloadable file emits `type: file`, `fileName` and the data URI; each booking mode emits only its own sub-object.
- [ ] **Step 3–4:** Implement, green.
- [ ] **Step 5:** Commit `feat: add downloadable and booking product editing`.

---

### Task 5: Wire the sections into the editor by type

**Files:** modify `seller_product_editor_page.dart`; test.

The editor shows exactly the section its product type needs, with a note that the section replaces the whole set on save because the API returns nothing to pre-fill it with.

- [ ] **Step 1:** Failing widget tests — a simple product shows no type section; a configurable shows variants; a bundle shows bundle options.
- [ ] **Step 2–3:** Implement, green.
- [ ] **Step 4:** Commit `feat: show the type-specific editor section per product type`.

---

### Task 6: Bulk delete from the list

**Files:** modify `seller_products_page.dart` and `seller_products_bloc.dart`; ARB strings; tests.

Long-press starts selection, the app bar counts the selection, and confirming calls `deleteBatch` with catalogue ids, then reports `removed` and `skipped` from the server's own tally.

- [ ] **Step 1:** ARB strings, `flutter gen-l10n`.
- [ ] **Step 2:** Failing tests — selecting and confirming sends the catalogue ids; the result message reflects the server counts; the list refreshes.
- [ ] **Step 3–4:** Implement, green.
- [ ] **Step 5:** Commit `feat: add bulk product delete`.

---

### Task 7: Live verification, docs, graph

- [ ] **Step 1:** Fill in the configurable already created on the server (`cfg-…`) with a name and per-variant prices through the app's repository, and confirm the variant rows update.
- [ ] **Step 2:** Extend the live smoke test with a grouped product: create, link two existing products, delete.
- [ ] **Step 3:** `flutter analyze`, `flutter test`, `graphify update .`
- [ ] **Step 4:** Record the write-only and label gaps in `AGENTS.md`.
- [ ] **Step 5:** Commit `chore: verify product type writes against the live API`.
