# Customer Refund Pricing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the customer Refunds tab pricing card match the rows shown on web.

**Architecture:** Change only refund-card presentation and localized labels. Keep order data mapping, refund item cards, and other order tabs intact.

**Tech Stack:** Flutter, Dart, generated `AppLocalizations`.

## Global Constraints

- Preserve Bagisto GraphQL fields and request behavior.
- Keep order data mapping in the existing model and repository.
- Do not alter invoice, shipment, or order-details pricing.

---

### Task 1: Match Refunds pricing rows

**Files:**
- Modify `lib/features/account/presentation/pages/order_detail_page.dart`.
- Modify `lib/l10n/app_en.arb`, `lib/l10n/app_localizations.dart`, and locale implementations for adjustment labels.

- [x] Add localized Adjustment Refund and Adjustment Fee labels.
- [x] Render only Subtotal, Shipping & Handling, Adjustment Refund, Adjustment Fee, and Grand Total in the Refunds pricing card.
- [x] Run Dart analysis for touched files.
