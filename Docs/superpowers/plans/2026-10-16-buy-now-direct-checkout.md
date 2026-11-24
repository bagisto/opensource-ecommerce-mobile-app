# Buy Now Direct Checkout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Open Checkout after a successful Buy Now action without displaying Cart first.

**Architecture:** Keep product-to-cart mutation in `ProductActionBar`; extract the existing guest eligibility UI guard for reuse; centralize pop-to-shell, Cart-tab selection, and route push in `AppNavigator`. Reuse `CheckoutPage` and existing blocs.

**Tech Stack:** Flutter, Dart, `flutter_bloc`, existing Navigator 1.0 routes.

## Global Constraints

- Preserve cart mutation and product option payloads.
- Preserve guest and authenticated token separation.
- Reuse existing `CartBloc`, `AuthBloc`, and `CheckoutPage`.
- Keep Add to Cart navigation unchanged.

---

### Task 1: Share checkout eligibility and navigate directly after Buy Now

**Files:**
- Create `lib/features/checkout/presentation/helpers/checkout_access_guard.dart` for the existing guest validation/login behavior.
- Modify `lib/features/cart/presentation/pages/cart_page.dart` to call the shared guest guard.
- Modify `lib/core/navigation/app_navigator.dart` to pop to the shell, select a tab, then push a supplied page.
- Modify `lib/features/product/presentation/widgets/product_action_bar.dart` to observe Buy Now success, validate guest access, then push `CheckoutPage` with current blocs.

**Interfaces:**
- `CheckoutAccessGuard.ensureGuestCheckoutAllowed(BuildContext, CartBloc) -> Future<bool>` returns false and opens login flow when guest checkout is disallowed; lookup errors preserve existing allow-through behavior.
- `AppNavigator.navigateToTabPage(BuildContext, int, WidgetBuilder) -> void` returns to the shell, switches the requested tab, and pushes the supplied route.

- [x] Move Cart's guest checkout validation and login prompt into `CheckoutAccessGuard` without changing policy.
- [x] Add `AppNavigator.navigateToTabPage` while retaining `navigateToCart` behavior.
- [x] Make `_addToCart` report whether it dispatched a mutation; observe success/error before routing Buy Now.
- [x] On successful Buy Now, reuse guest guard and navigate to Checkout with Cart underneath.
- [x] Run Dart analysis for touched files and `graphify update .` (analysis passed; Graphify report refreshed, HTML rebuild warned that graph exceeds visualization limit).
