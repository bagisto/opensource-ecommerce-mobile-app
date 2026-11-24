# Checkout Address Sheet Add Address Design

## Goal

Let a logged-in user add a new address directly from the checkout `Change` address bottom sheet, then use that new address immediately for the billing or shipping action that launched the sheet.

## Current Behavior

- Checkout address changes are opened from the `Change` action in [checkout_page.dart](/Users/jitendra/Documents/Demo_project/Bagisto_flutter_live_demo/bagisto_flutter_app_grapghql/lib/features/checkout/presentation/pages/checkout_page.dart).
- The bottom sheet only shows existing saved addresses.
- There is no add-address path inside the sheet.
- Billing address selection already auto-saves through `SelectSavedAddress`.
- Shipping address selection is mostly local UI state until checkout address save happens later.

## Decision

Use the existing checkout bottom sheet as the entry point and add a sticky `Add New Address` button at the bottom.

When the user saves a new address:

- refresh the checkout address list
- detect the newly created address from the refreshed set
- apply it to checkout based on which `Change` action launched the flow
- persist the shipping choice correctly when the user is changing shipping instead of billing

## Why This Flow

- It matches the current checkout UX instead of introducing a second address entry point.
- It reuses the existing [add_address_page.dart](/Users/jitendra/Documents/Demo_project/Bagisto_flutter_live_demo/bagisto_flutter_app_grapghql/lib/features/account/presentation/pages/add_address_page.dart) and `AddressBookBloc` create flow.
- It keeps repositories responsible for data fetch/mutation and keeps checkout UI state in checkout presentation code.
- It avoids guessing which address is new by using a before/after ID comparison.

## Detailed Behavior

### 1. Bottom Sheet

The existing address selection sheet will keep the address list and add:

- a sticky bottom action area
- a full-width `Add New Address` button

The sheet remains the same for both billing and shipping, but it receives the action context so the returned address can be applied correctly.

### 2. Add Address Navigation

Tapping `Add New Address` will:

- close the current sheet
- open the existing add-address page with the same `AccountRepository` and `AddressBookBloc` wiring used in account flows
- wait for the boolean success result already returned by `AddAddressPage`

### 3. Refresh And Detect New Address

Before opening add-address, checkout captures the current address IDs.

After the add page returns success:

- checkout fetches the latest customer/checkout addresses again
- checkout compares the refreshed address IDs against the original set
- the first new ID becomes the newly added address candidate

If no new ID is found, checkout still refreshes the list but does not auto-select an arbitrary address.

### 4. Apply By Action

If the user launched the flow from `Billing`:

- set the new address as the selected billing address
- save it to checkout immediately using the existing billing-save path

If the user launched the flow from `Shipping`:

- set the new address as the selected shipping address
- keep billing unchanged
- ensure the later checkout save payload includes the new shipping address when `use same address for shipping` is off

### 5. Shipping Persistence

Checkout currently treats billing selection as the auto-save trigger. This change will keep that intact, but it will also make the shipping-change action meaningful by ensuring the selected shipping address is included in the saved checkout input when separate shipping is enabled.

This keeps the action aligned with what the user selected instead of only changing the card visually.

## Implementation Shape

### Checkout Page

Update [checkout_page.dart](/Users/jitendra/Documents/Demo_project/Bagisto_flutter_live_demo/bagisto_flutter_app_grapghql/lib/features/checkout/presentation/pages/checkout_page.dart) to:

- add the bottom button to the address selection sheet
- extract the add-address launch flow into a helper
- capture existing address IDs before navigation
- refresh addresses after returning
- update billing or shipping local selection based on action context
- route billing selection through the existing `SelectSavedAddress` flow

### Checkout Bloc

Keep the existing `SelectSavedAddress` event for billing.

Add the smallest checkout-side support needed to refresh address data after address creation without reinitializing the whole checkout flow. This can be either:

- a small new event that refetches addresses only, or
- a page-level repository refresh if that remains simpler and does not duplicate state logic

Preference: use a small new bloc event so checkout remains the source of truth for saved addresses.

### Account Address Flow Reuse

Reuse:

- `AddressBookBloc`
- `CreateAddress`
- `AddAddressPage`

Do not duplicate address form logic inside checkout.

## Error Handling

- If add-address is cancelled, do nothing and keep checkout state unchanged.
- If address creation succeeds but refreshed addresses fail to load, show the existing checkout error feedback and leave the prior selection intact.
- If refresh succeeds but no new address can be identified, refresh the list only and let the user choose manually.

## Testing

Add focused widget tests for checkout address flow behavior:

- the selection sheet shows the `Add New Address` button
- returning success from add-address refreshes the saved address list
- billing-origin add flow selects the new billing address
- shipping-origin add flow selects the new shipping address

If widget coverage becomes too heavy for the current navigation stack, add the minimum targeted test coverage around the helper logic and verify the end-to-end behavior manually.

## Out Of Scope

- editing addresses inside the checkout sheet
- deleting addresses inside the checkout sheet
- redesigning the checkout address cards
- refactoring checkout billing/shipping architecture beyond what is necessary for this flow
