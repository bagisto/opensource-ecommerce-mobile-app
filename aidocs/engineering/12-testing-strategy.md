# Testing Strategy

## Goal

Catch regressions in storefront logic without making the test suite so expensive that it stops being used.

## Current Testing Layers

### Unit And Widget Tests

The repo already contains Dart tests under `test/`.

Use these for:

- model mapping
- pure helper logic
- BLoC/Cubit behavior
- widget interaction where full app flows are unnecessary

### Maestro Flows

The repo already contains Android-focused Maestro flows under `maestro/`.

Use these for:

- authentication journeys
- catalog browsing
- cart and checkout flows
- end-to-end smoke coverage after UX or navigation changes

## What To Test

Add or update tests when you change:

- repository behavior or response mapping
- BLoC/Cubit transitions
- auth and cart token switching logic
- notification routing
- checkout or order flows
- navigation behavior in the main shell

## Preferred Verification Commands

Use the smallest command that proves the changed scope:

- `dart analyze`
- `flutter test`
- targeted `flutter test test/<file>.dart`
- relevant Maestro flow command for changed user journeys

If a command cannot run in the current environment, document the blocker clearly.

## Testing Priorities

1. pure logic and mapping first
2. state transitions second
3. widget behavior third
4. end-to-end flows when user-visible journeys change

## Avoid

- fragile tests that depend on unrelated live backend state
- duplicating one scenario across unit, widget, and Maestro layers without added value
- shipping behavior changes with no verification story

## Android Native Compatibility

The Android app selects AndroidX DataStore 1.2.1 over the 1.2.0 dependency
from shared_preferences_android. Its native shared-counter libraries correct
16 KB RELRO alignment without changing the DataStore API or app storage keys.
Keep this selection until the plugin supplies a verified compatible version.

For release AABs, inspect the packaged arm64-v8a and x86_64 libraries, not just
the NDK version configured for the app. Verify every LOAD segment has at least
0x4000 alignment and each GNU_RELRO segment satisfies
`(VirtAddr + MemSiz) % 0x4000 == 0`. An old embedded NDK label alone does not
prove incompatibility. Also check APK packaging alignment and test startup,
saved customer/seller sessions, settings persistence and upgrades on a 16 KB
device before publishing. Play Console validation is a separate release gate.
