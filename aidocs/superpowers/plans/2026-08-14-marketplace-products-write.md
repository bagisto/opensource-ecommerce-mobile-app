# Marketplace Products (Write) Implementation Plan — M4a

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans or superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax.

**Goal:** A seller can create a product, fill it in, manage its stock locations, and delete products — all from the app.

**Scope split:** M4a (this plan) covers the create skeleton, the simple/virtual editor, categories, inventory sources CRUD, and delete/bulk delete. M4b covers the type-specific editors: configurable variants, grouped links, bundle options, downloadable links/samples, and the five booking modes.

**Architecture:** Same layering as M3. Write operations join `SellerProductRepository`; a separate `SellerInventorySourceRepository` owns stock locations. Editors are form widgets driven by a `SellerProductEditorCubit` that assembles a partial update payload.

## Global Constraints

- All constraints from the M3 plan apply.
- **Creation is two steps, as in the seller panel:** `createSellerProduct` makes the skeleton (`type`, `attributeFamilyId`, `sku`, `isDraft`); everything else goes through `updateSellerProduct`.
- **`updateSellerProduct` is partial, but any list you send replaces that whole set.** The editor loads the current product and resubmits every image and inventory row it means to keep.
- Uploads travel as `data:` base64 URIs or public URLs; there is no multipart endpoint.
- `deleteSellerProduct` removes an owned product but only un-assigns a listing the seller does not own — surface which will happen using `isOwner`.

## Verified schema (live, 2026-08-14)

`createSellerProductInput`: `type`, `attributeFamilyId`, `sku`, `superAttributes`, `isDraft`.

`updateSellerProductInput`: `id`, `name`, `sku`, `urlKey`, `slug`, `price`, `specialPrice`, `specialPriceFrom`, `specialPriceTo`, `weight`, `shortDescription`, `description`, `metaTitle`, `metaKeywords`, `metaDescription`, `status`, `visibleIndividually`, `new`, `featured`, `guestCheckout`, `categories`, `inventories`, `images`, `videos`, `customAttributes`, `variants`, `links`, `downloadableLinks`, `downloadableSamples`, `bundleOptions`, `booking`, `condition`, `sellerDescription`, `isDraft`.

`createSellerInventorySourceInput` / `updateSellerInventorySourceInput`: `code`, `name`, `description`, `contactName`, `contactEmail`, `contactNumber`, `contactFax`, `street`, `country`, `state`, `city`, `postcode`, `priority`, `latitude`, `longitude`, `status` (update also takes `id`).

**Two gaps the UI must absorb:**

1. **There is no attribute-family query.** The create screen therefore offers a family id field defaulting to `1` (Bagisto's Default family) rather than a picker, and explains that the admin's family ids come from the panel.
2. **`sellerProductCategories` returns an empty list for a seller the admin has restricted.** The category picker renders an explanatory empty state instead of looking broken.

---

### Task 1: Write documents and the update payload builder

**Files:**
- Modify: `lib/marketplace/graphql/seller_products.dart`
- Create: `lib/marketplace/features/products/data/models/seller_product_draft.dart`
- Test: `test/marketplace_seller_product_draft_test.dart`

**Produces:** `SellerProductDocuments.create`, `.update`, `.delete`, `.deleteBatch`, `.categories`;
`SellerProductDraft` holding the editable fields with `toInput()` that emits only the keys that changed against the loaded product, plus the lists it was told to replace.

- [ ] **Step 1:** Failing test — `toInput()` on an untouched draft is empty except `id`; changing the name emits `{id, name}`; images and inventories are emitted whole when touched and omitted when not; `isDraft` round-trips; empty strings clear a field rather than being dropped.
- [ ] **Step 2:** Run, watch it fail.
- [ ] **Step 3:** Add the documents (create/update/delete/deleteBatch/categories) matching the verified inputs.
- [ ] **Step 4:** Write `SellerProductDraft` with `fromDetail`, `copyWith`, and the diffing `toInput()`.
- [ ] **Step 5:** Green, analyze, commit `feat: add seller product write documents and draft payload`.

---

### Task 2: Repository write methods

**Files:** modify `seller_product_repository.dart`; test `test/marketplace_seller_product_write_test.dart`.

**Produces:** `create({required String type, required int attributeFamilyId, required String sku, bool isDraft, List<Map<String,dynamic>>? superAttributes})` → `SellerProductListItem`;
`update(SellerProductDraft draft)` → `SellerProductDetail`;
`delete(SellerIri iri)`; `deleteBatch(List<int> catalogueIds)` → `{requested, deleted, unassigned, skipped}`;
`assignableCategories()` → `List<SellerProductCategoryNode>` (flat, with `parentId`, `level`, `path`).

- [ ] **Step 1:** Failing tests with the recording link: create sends exactly the five create fields; update sends the diffed payload under `input`; delete sends the IRI; bulk delete sends catalogue ids; a validation error surfaces its message.
- [ ] **Step 2–4:** Run, implement, green.
- [ ] **Step 5:** Verify live — create a throwaway product, update its name, delete it, and confirm the count returns to its starting value.
- [ ] **Step 6:** Commit `feat: add seller product create, update and delete`.

---

### Task 3: Inventory sources

**Files:** `lib/marketplace/graphql/seller_inventory_sources.dart`; `features/inventory_sources/data/{models,repository}`; `presentation/{bloc,pages}`; tests.

**Produces:** `SellerInventorySource` model; `SellerInventorySourceRepository` with `list()`, `detail()`, `create()`, `update()`, `delete()`; `SellerInventorySourcesCubit`; a list screen with create/edit form and delete, reached from the More tab.

- [ ] **Step 1:** Failing tests — list maps `productsCount` and `status`; create sends every required field; deleting the last active source surfaces the server's 422 message.
- [ ] **Step 2–4:** Run, implement, green.
- [ ] **Step 5:** Commit `feat: add seller inventory source management`.

---

### Task 4: Create product flow

**Files:** `presentation/pages/seller_product_create_page.dart`; `presentation/bloc/seller_product_create_cubit.dart`; ARB strings; tests.

Screen: product type (the seven types), SKU, attribute family id (default 1, with the explanation above), "save as draft" switch. On success it pushes the editor for the new product.

- [ ] **Step 1:** ARB strings, `flutter gen-l10n`.
- [ ] **Step 2:** Failing tests — a blank SKU is refused before any call; success carries the new IRI; a duplicate SKU surfaces the server message.
- [ ] **Step 3–4:** Implement, green.
- [ ] **Step 5:** Commit `feat: add seller product creation`.

---

### Task 5: Product editor (simple and virtual)

**Files:** `presentation/bloc/seller_product_editor_cubit.dart`; `presentation/pages/seller_product_editor_page.dart`; `presentation/widgets/{seller_image_picker_field,seller_category_picker,seller_inventory_editor}.dart`; ARB strings; tests.

Sections: identity (name, SKU, url key), pricing (price, special price + window, weight), descriptions, SEO, flags (status, visible individually, new, featured, guest checkout), categories (picker over `sellerProductCategories`, empty-state when restricted), stock per inventory source, images (device pick → base64 data URI, or paste a URL), custom attributes rendered from the product's own `attributes`, and a draft toggle. Save sends only what changed.

- [ ] **Step 1:** ARB strings, `flutter gen-l10n`.
- [ ] **Step 2:** Failing tests — editing the name and saving sends `{id, name}` only; adding an image resends the whole image list; clearing stock for a source sends that source with qty 0; a server validation error keeps the form and shows the message.
- [ ] **Step 3–4:** Implement, green.
- [ ] **Step 5:** Wire "edit" from the detail screen and a "+" action on the list.
- [ ] **Step 6:** Commit `feat: add seller product editor`.

---

### Task 6: Delete and bulk delete

**Files:** modify the list page and detail page; tests.

- [ ] **Step 1:** Failing tests — the confirm dialog names the outcome (`delete` for owned, `unassign` otherwise); confirming dispatches to the repository; the row disappears from state.
- [ ] **Step 2–4:** Implement selection mode on the list, the confirm dialog, and the batch call; green.
- [ ] **Step 5:** Commit `feat: add seller product delete and bulk delete`.

---

### Task 7: Live verification, docs, graph

- [ ] **Step 1:** Extend the live smoke test: create → update name and price → read back → delete, all against the real server, still behind `--tags live`.
- [ ] **Step 2:** Run it; expect the product count to return to its starting value.
- [ ] **Step 3:** `flutter analyze`, `flutter test`, `graphify update .`
- [ ] **Step 4:** Commit `chore: verify seller product writes against the live API`.
