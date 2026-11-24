# Seller Create User Labels Design

## Goal

Align the seller mobile Users and Roles forms with the required-field cues in the supplied web reference, and call staff accounts users in the create flow.

## Scope

- Change the Users tab action and new-user sheet title from “Add staff member” to “Create User”. Keep the existing-user edit title distinct as “Edit User”.
- Mark required fields in the new-user form with an asterisk: name, email, phone, password, and role. Keep optional suspended status unmarked. In edit mode, password remains optional and must not be marked required.
- Mark role name as required in the role sheet. Description and permission selection remain optional/configurable as they are today.
- On save, show field-level required errors and red borders for missing name, email, phone, password, and role. Add a confirmation-password field to match the web create form; require it and verify it matches the password.
- Existing users can leave both password fields empty. If an existing user's password is changed, require confirmation and verify the values match.
- Preserve existing save behavior and API payloads. Keep fields in the web reference order; password confirmation is the only added input.

## UI approach

Keep the existing settings page and bottom-sheet widgets. Add the required marker to each field's displayed label or hint using localized strings, and use the existing user-related localization key for the create wording. Use the role-name label already shown by the field, adding a required marker there. Store per-field validation errors in the sheet and pass them through the existing input-decoration helper so Flutter displays inline errors with red borders. Keep payload and repository behavior unchanged.

## Verification

Add or update focused widget coverage for the create action, create sheet labels, required-field errors, password confirmation, role-name marker, and optional password behavior when editing. Run the targeted test and analyze the touched Dart scope. Refresh graphify after source changes.

## Self-review

- No API or repository behavior changes.
- Edit password remains optional unless user enters a new password; then confirmation is required.
- Suspended status, role description, and role permissions remain optional.
