# Seller Create User Labels Implementation Plan

> **For agentic workers:** Execute inline in this session. Preserve the repo's Graphify workflow.

**Goal:** Match the seller mobile user and role required-field cues to the supplied web reference and label new staff accounts as users.

**Architecture:** Keep all changes in the existing seller settings page and localization layer. Required markers are presentation-only; existing form validation and repository behavior remain unchanged.

**Tech Stack:** Flutter, Dart, Flutter gen-l10n, ARB localization files.

## Global Constraints

- Do not change GraphQL requests, API payloads, or seller settings state boundaries.
- Keep password optional during user edits; mark it required only for new users.
- Show required-field errors with red borders, add password confirmation, and verify match before saving.
- Keep fields in web reference order; password confirmation is the only added input.
- Refresh Graphify after source changes.

---

### Task 1: Update seller settings labels

**Files:**
- Modify: `lib/marketplace/features/settings/presentation/pages/seller_settings_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`

**Interfaces:**
- The Users tab action and new-user sheet title use “Create User”.
- Existing-user sheet title uses “Edit User”.
- Name, email, phone, role selection, and new-user password labels display `*`; edit password stays unmarked. Role name displays `*` in the role form.

- [ ] Change `sellerSettingsAddStaff` localization copy to “Create User” and add `sellerSettingsEditStaff` copy “Edit User”; translate Arabic and allow other generated locales to use existing English fallback behavior.
- [ ] Generate localization Dart files with `flutter gen-l10n`.
- [ ] Add an asterisk to required input hints in the settings page. Use create/edit context only for password optionality; leave suspended status unmarked.
- [ ] Use the edit localization only for existing users; use create localization for the tab action and new-user sheet title.
- [ ] Validate name, email, phone, password, confirmation, and role on save; put each error in its field decoration so inputs show inline red errors and borders.
- [ ] Add confirmation password input. Require it for new users, compare it with password, and require it for edits only when a new password is entered.
- [ ] Add an asterisk to the role-name field hint. Keep description optional.
- [ ] Review the diff to confirm validation and API calls are unchanged.
- [ ] Run `graphify update .` after source changes.
