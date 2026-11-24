# Seller Dashboard Health And Score Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Match web's uncalculated account-health state and color dashboard profile score by score range.

**Architecture:** Keep existing seller API, model, Cubits, and routes. Change only dashboard and Performance presentation, reusing the existing refresh action and localization setup.

**Tech Stack:** Flutter, Dart, generated `AppLocalizations`.

## Global Constraints

- Preserve seller GraphQL endpoint, auth, and request headers.
- Keep repository and Cubit boundaries unchanged.
- Use existing localized strings and generated localization workflow.

---

### Task 1: Update health and profile-score presentation

**Files:**
- Modify `lib/marketplace/features/dashboard/presentation/pages/seller_dashboard_page.dart`
- Modify `lib/marketplace/features/settings/presentation/pages/seller_account_health_page.dart`
- Modify `lib/l10n/app_*.arb` and generated localization Dart files only as needed for “Not calculated”.

- [x] Show “Not Calculated” on dashboard and hide score when `updatedAt == null`.
- [x] Show “Not calculated” and existing Refresh Now action on Performance page, hiding score and metrics when `updatedAt == null`.
- [x] Set circular Profile Score color: red below 25, orange 25–49, yellow 50–74, green 75+.
- [x] Run scoped Dart analysis and `graphify update .` (report regenerated; visualization rebuild warned that graph exceeds HTML limit).
