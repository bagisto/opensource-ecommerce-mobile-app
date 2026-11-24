# Rental Daily and Hourly Value Design

## Goal

Make the Rental Booking “Both (Daily and Hourly Basis)” choice use the API's canonical `daily_hourly` value while preserving the existing editor behavior.

## Design

Keep `daily_and_hourly` as the editor's current UI value so the existing dropdown, pricing visibility, and validation behavior remain unchanged. Normalize API `daily_hourly` to that UI value when parsing saved booking data, and serialize the UI value as `daily_hourly` when building `rentalSlot.rentingType`. Other rental values (`daily`, `hourly`) pass through unchanged.

## Verification

Add model tests for both directions: existing UI value serializes to `daily_hourly`, and API `daily_hourly` loads as the UI's “Both” value. Run the focused booking payload test.
