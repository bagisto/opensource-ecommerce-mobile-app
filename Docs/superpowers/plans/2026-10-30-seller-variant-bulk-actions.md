# Seller Variant Bulk Actions Implementation Plan

> **For agentic workers:** Implement tasks in order. Keep checkbox status current. Use the existing seller GraphQL client and seller product editor architecture.

**Goal:** Match the web seller product editor's Select Variants and Select Action flow for configurable products.

**Architecture:** Keep variant selection and action forms in presentation widgets, queue saved-variant actions in `SellerProductEditorCubit`, and submit them through `SellerProductRepository` only when the main product Save is tapped. Save the parent draft first, then submit queued mass updates sequentially, stop on first failure while retaining failed and later actions, and reload detail after completion. Unsaved new variants remain in the product draft and are saved by the parent update.

**Tech Stack:** Flutter, Dart, `flutter_bloc`, `graphql_flutter`, existing seller API client, widget and repository tests.

## Global Constraints

- Scope: seller product edit screen, configurable Variations tab. Keep create, other product types, individual variant editing, and parent product Save working.
- Reuse `GraphQLClientProvider.buildSellerClient` through the injected repository client. Seller requests carry the existing seller Bearer token and no `X-STOREFRONT-KEY`.
- Keep server-issued product IRI unchanged. `SellerIri.numericId` is the seller catalogue ID for bulk `productId`; `SellerProductVariant.variantId` is the core ID for `variantIds`. Never use parent `productId` or variant `listingId` in these fields.
- Bulk mutation touches selected variants only. Never send the replacement-style `updateSellerProduct.variants` list for a bulk action.
- Gate the controls with `SellerPermissions.can('catalog.products.edit')`, following the editor's existing permission pattern.
- Use the action names and field types in `MarketplaceApi.graphql.postman_collection (2).json`, Seller / Catalog / Products / Bulk Edit Variants. `editStatus` takes a boolean even though product detail reports status as `0` or `1`.
- Existing live check on seller listing `1383` and variant `1819` passed for `editName`, `editSku`, `editPrices`, `editWeight`, `editStatus`, `editInventories`, and `removeImages`. `addImages` and `removeVariants` have collection examples but were not run against live data.
- Add no endpoint constants or new GraphQL clients. Keep generated localization files generated from ARB sources.

## Web Behavior To Match

1. Existing Color/Size option chips continue to control combinations. They are separate from bulk selection.
2. Each visible existing variant row has a checkbox. Header checkbox selects all displayed existing variants or clears selection. `Select Action` appears only when at least one variant is checked.
3. `Select Variants` lists *used* option values, for example Color: Green and Size: S. Tapping an option checks or unchecks all variant rows carrying that option; rows remain visible. Web check on this product showed Color: Green checking only variant `1821`.
4. Action menu order: Edit Name, Edit SKU, Edit Prices, Edit Inventories, Edit Weight, Edit Status, Add Images, Remove Images, Remove Variants.
5. Action sheet shows selected variant names/options and per-variant fields. Name, prices, inventories, weight, status, and images allow a common value with **Apply to All**. SKU is per variant because each SKU must be unique. Per-variant values override common values in the request.
6. Choosing an action updates the local form only. The main product Save submits pending product fields first, then each queued action in order using selected core variant IDs. Refresh product detail after all actions succeed. On failure, stop and retain the failed and later actions for retry. Confirm destructive Remove Images and Remove Variants before queueing.

## API Contract

```graphql
mutation CreateSellerProductVariantMassUpdate(
  $input: createSellerProductVariantMassUpdateInput!
) {
  createSellerProductVariantMassUpdate(input: $input) {
    sellerProductVariantMassUpdate {
      id: _id
      action
      variantIds
      updated
      message
    }
  }
}
```

Base input: `{productId: <seller catalogue id>, action: <name>, variantIds: <core variant ids>}`. Add one action payload:

| Action | Apply-to-all input | Per-variant input |
|---|---|---|
| `editName` | `name: String` | `values: {"<variantId>": String}` |
| `editSku` | none | `values: {"<variantId>": String}` |
| `editPrices` | `price: num` | `values: {"<variantId>": num}` |
| `editInventories` | `inventories: {"<sourceId>": qty}` | `values: {"<variantId>": {"<sourceId>": qty}}` |
| `editWeight` | `weight: num` | `values: {"<variantId>": num}` |
| `editStatus` | `status: bool` | `values: {"<variantId>": bool}` |
| `addImages` | `images: [URL or data URI]` | `values: {"<variantId>": [URL or data URI]}` |
| `removeImages` | none | none |
| `removeVariants` | none | none |

The collection documents `addImages` as a shared `images` list. The web UI also allows per-variant images and Apply to All; when variants differ, send their image arrays in `values` to override the shared list. Live verification covered shared values and one per-variant SKU. Before shipping per-variant nested inventory values, verify their exact server handling on disposable data or use a contract test. Inventory sources omitted from a payload retain their stock. `addImages` appends; `removeImages` clears all images of selected variants. Re-read `sellerProduct(id: <original IRI>)` after success; the mutation response has no updated variant objects.

## File Map

- `lib/marketplace/graphql/seller_products.dart`: mutation document beside current product queries and updates.
- `lib/marketplace/features/products/data/repository/seller_product_repository.dart`: typed bulk request submission, response/error mapping, and detail reread.
- `lib/marketplace/features/products/data/models/seller_variant_bulk_action.dart` (new): action enum, input validation, and payload builder; no transport code.
- `lib/marketplace/features/products/presentation/bloc/seller_product_editor_cubit.dart`: submission state and refreshed variant/draft reconciliation.
- `lib/marketplace/features/products/presentation/widgets/seller_variant_creator.dart`: checkbox and attribute-option selection, action trigger, selection reconciliation. Preserve existing combination creation and individual edit behavior.
- `lib/marketplace/features/products/presentation/widgets/seller_variant_bulk_action_sheet.dart` (new): common and per-variant form fields, Apply to All, image picker, confirmation, and error display.
- `lib/marketplace/features/products/presentation/pages/seller_product_editor_page.dart`: wire the existing Cubit and permission gate into the Variations tab.
- `lib/l10n/app_*.arb`: action titles, field labels, confirmation copy, validation messages. Generate localization output using the project's usual command.
- `test/marketplace_seller_product_repository_test.dart`, `test/marketplace_seller_product_editor_test.dart`, plus focused tests for selection and payload building.
- `aidocs/engineering/16-marketplace-seller-api-reference.md`: add the dedicated mass-update contract and distinguish it from replacement-style product updates.

## Tasks

### Task 1: Add a typed mass-update request and repository call

**Files:** GraphQL document, new bulk-action model, product repository, repository and payload tests.

- [ ] Define the nine action names exactly as above. Build input from `SellerIri.numericId`, a nonempty unique list of `variantId`, and only the field used by the chosen action. Reject missing IDs, blank SKU/name, duplicate entered SKUs, negative price/weight/quantity, and empty image lists before network submission.
- [ ] Add `createSellerProductVariantMassUpdate` document and `bulkUpdateVariants(...)` repository method. Parse `updated`, `message`, `variantIds`; route GraphQL and empty-payload failures through `SellerErrorMapper`/`SellerApiException` like other repository methods.
- [ ] Test exact variables for each action, especially `productId: 1383` versus core parent ID `1814`, `variantIds: [1819]` versus listing ID `1388`, `status: true`, `inventories: {'2': 5}`, and per-variant `values` keyed by string ID. Test error propagation and zero/empty response handling.

### Task 2: Make editor state safe across immediate bulk saves

**Files:** editor Cubit, product draft model if a rebase helper is needed, Cubit/draft tests.

- [ ] Add a bulk-submitting state/flag distinct from the parent Save, and a Cubit method taking the typed request. Prevent duplicate submissions and ensure configured edit permission is checked where current editor actions are gated.
- [ ] On success, re-read product detail through current locale's repository. Replace `state.variants` with the returned list. Rebase `SellerProductDraft` on that new detail while retaining unsaved non-variant edits. Replace selected variants' stale draft copies and remove deleted variants from draft; retain unrelated pending new variant edits only where their combination still exists.
- [ ] Ensure `SellerVariantCreator` refreshes its local `_variantEdits`, `_prices`, `_quantities`, and `_excludedCombinations` from the new server variants after a bulk result. A later parent Save must not replay old variant values or recreate deleted rows.
- [ ] On mutation failure, leave draft, selection, and sheet input intact. On mutation success but detail-reread failure, show a refresh error and retry detail load before allowing another bulk edit or parent Save.
- [ ] Test success rebase with an unsaved parent description, failure preservation, locale-specific repository use, duplicate-submit prevention, and later Save using refreshed variant values.

### Task 3: Add web-style variant selection

**Files:** variant creator widget and focused widget tests.

- [ ] Render row checkboxes for persisted variants. Exclude unsaved combinations without a core `variantId` from bulk selection; keep their current creation/edit UI.
- [ ] Add select-all control and `Select Variants` menu listing option values used by existing rows. Compute each menu item's checked state from matching rows. Selecting an option toggles every matching row, while rows stay visible. Keep manual checkbox selection independent of option-chip combination editing.
- [ ] Show `Select Action` only when selected IDs are nonempty. After refresh, drop deleted IDs and clear successfully processed selection.
- [ ] Widget-test manual selection, select all/clear all, Color: Green selecting only matching rows, overlapping Color/Size option selections, empty selection, and unsaved combinations.

### Task 4: Add action sheet and submit all nine actions

**Files:** new action-sheet widget, variant creator/page wiring, widget tests.

- [ ] Build action menu in web order. Open one bottom sheet headed by the action title. Show selected variant name/options and per-variant controls seeded from current detail; support Apply to All for the web actions listed above.
- [ ] Use stock locations already loaded in editor state for inventory fields. Keep quantities per source and send only sources explicitly edited/applied. Convert image selections to existing app `data:` URI format through the same `image_picker` pattern used by `SellerVariantEditSheet`.
- [ ] Validate numeric fields, unique/nonempty SKU, required name, selected status, and nonempty image input. Distinguish `0` from blank. Confirm Remove Images and Remove Variants with selected count before sending.
- [ ] Submit through Cubit; disable controls during request; show server message or mapped error. Refresh rows and close sheet only after confirmed success and detail reload.
- [ ] Widget-test action menu visibility/order, Apply to All plus one per-row override, validation, image picker cancellation, destructive confirmation cancellation, loading/error states, and success refresh.

### Task 5: Integration and documentation gate

**Files:** touched tests, seller API reference, `plan.md` only if architecture/workflow meaning changes.

- [ ] Update API reference with mutation, permission `catalog.products.edit`, seller/core ID mapping, all nine actions, response, and selected-only semantics. Note the two actions not yet live verified until a disposable-product check is run.
- [ ] Run targeted Dart tests for payload, repository, Cubit, and widget behavior; run analyzer for touched scope. Add or update a Maestro seller product edit flow if the available device/test account supports a configurable product without destroying shared data.
- [ ] On disposable seller product, verify `addImages` and `removeVariants` end to end, including detail reread and restoration/cleanup. Record any server mismatch before release.
- [ ] Run `graphify update .` after code changes, review the final diff, and confirm endpoint/header behavior and parent Save remain intact.

## Acceptance

- Selecting by checkbox, all rows, or an attribute option matches web selection; unselected variants stay unchanged.
- Every action sends the dedicated mutation with correct IDs and field shape. Common values and per-row overrides work where shown in web.
- The sheet shows clear validation/errors and refreshes the rows after success. Later parent Save cannot revert a bulk update.
- Existing variant creation, single-variant editing, locale handling, and other product types continue to work.
