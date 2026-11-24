# Rental Daily and Hourly Mapping Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the rental “Both” option send and load the API value `daily_hourly`.

**Architecture:** Keep the current presentation value `daily_and_hourly` to avoid changing UI conditions. Normalize between that presentation value and API `daily_hourly` in `SellerBookingConfig` parsing and serialization.

**Tech Stack:** Dart, Flutter model tests.

## Global Constraints

- Preserve the existing rental UI and validation behavior.
- Keep API changes limited to the `rentalSlot.rentingType` value mapping.
- Do not change unrelated booking or GraphQL behavior.

---

### Task 1: Normalize rental type in the booking model

**Files:**
- Modify: `lib/marketplace/features/products/data/models/seller_product_types.dart`
- Test: `test/marketplace_seller_product_type_payload_test.dart`

**Interfaces:**
- `SellerBookingConfig.fromJson` reads `slotSettings.renting_type`.
- `SellerBookingConfig.toInput` emits `rentalSlot.rentingType`.

- [ ] Map API `daily_hourly` to the existing editor value `daily_and_hourly` while parsing.
- [ ] Map editor value `daily_and_hourly` to API value `daily_hourly` while serializing.
- [ ] Test the serializer and parser for this round trip; verify `daily` and `hourly` remain unchanged.
- [ ] Run `flutter test test/marketplace_seller_product_type_payload_test.dart`.
