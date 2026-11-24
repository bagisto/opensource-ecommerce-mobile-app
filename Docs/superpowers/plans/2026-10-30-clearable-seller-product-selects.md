# Clearable Seller Product Selects Implementation Plan

**Goal:** Let seller clear selected single-select product attributes from product editor.

**Architecture:** Add clear action to the dropdown's existing trailing icon row in `SellerAttributeField`. Report empty string through existing callback so editor save flow remains unchanged.

**Tech Stack:** Flutter, Dart, existing seller editor Cubit and GraphQL mutation.

## Global Constraints

- Preserve existing editor state, save, validation, and API behavior.
- Limit UI change to dynamic `select` attributes.
- Do not add or run tests unless requested.

### Task 1: Add clear action to selected dropdowns

**Files:**
- Modify: `lib/marketplace/features/products/presentation/widgets/seller_attribute_field.dart`

- [ ] Add a clear icon before the existing dropdown arrow when a valid selection exists.
- [ ] On clear, call `onChanged(attribute.code, '')`; rebuild dropdown from that cleared pending value.
- [ ] Keep existing options, labels, and empty/unavailable-option handling intact.
- [ ] Review diff and refresh Graphify.
