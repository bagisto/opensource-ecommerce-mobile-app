# Seller Dashboard Score Display Design

## Goal

Match seller dashboard score display to the web behavior and requested score colors.

## Design

- Account Health already maps the API `updatedAt` field into `SellerAccountHealth`.
- When `updatedAt` is null, keep the Account Health card and its navigation, show `Not Calculated`, and hide the score number. This matches the supplied web screenshot.
- On Performance → Account Health, show `Not calculated` with the existing `Refresh now` action and hide the score and metric cards until `updatedAt` is populated.
- When `updatedAt` is non-null, preserve the current health label and score display.
- Profile Score keeps its current card, progress amount, and percentage. Set ring color by score: 0–24 red, 25–49 orange, 50–74 yellow, and 75–100 green. A score of 48 is orange.
- Use existing widgets, model, refresh Cubit action, and localization setup. Add presentation logic and localized copy only; API and state behavior stay unchanged.

## Data Flow

The seller settings repository fetches account health, and `SellerAccountHealth.fromJson` maps `updatedAt`. The dashboard fetches `profileScore` separately and clamps it to 0–100. Dashboard widgets render both values; API request shapes and session behavior remain unchanged.

## Verification

Run Dart analysis for touched files. Refresh Graphify after code changes.
