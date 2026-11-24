# Clearable Seller Product Selects

## Goal

Let sellers remove a selected value from a single-select attribute in the seller product editor, matching the clear cross shown by the web panel.

## Design

Add a clear (X) control to `select` attribute fields when a value is selected. Tapping it reports an empty string through the existing attribute change callback, which updates the editor's pending attribute map and is included in the existing `customAttributes` save payload. Keep the dropdown arrow and existing option list behavior. Hide the clear control when the field has no selected value or no available options.

This scope covers the dynamic single-select attributes rendered by `SellerAttributeField`, including tax category, color, size, and brand. It does not change booleans, text inputs, date fields, configurable variant selectors, or API contracts.

## Architecture and Data Flow

`SellerAttributeField` owns the clear affordance and invokes its existing `onChanged(code, '')` callback. `SellerProductEditorPage` stores that empty value in `_attributeEdits`; `_collectInto` merges it into `customAttributes`; `SellerProductDraft.toInput()` serializes that entry through the existing `updateSellerProduct` mutation. No repository, GraphQL client, or state-management boundary changes.

## Error Handling and Compatibility

The clear control is only available for a currently selected value. Clearing uses the same pending-edit path as choosing another option, so save and error handling remain unchanged. Required fields continue to follow existing server validation behavior.

## Verification

Check the clear control appears for selected values, clears the displayed selection, remains absent when empty, and preserves dropdown selection behavior. Follow repository guidance for graph refresh after the code change. Do not add or run tests unless requested.
