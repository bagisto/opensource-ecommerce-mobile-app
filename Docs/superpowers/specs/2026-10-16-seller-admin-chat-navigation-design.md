# Seller Admin Chat Navigation Design

## Goal

Open the seller's admin conversation directly from Communication → Admin.
Keep Communication → Customers opening the customer thread list.

## Design

Give the Admin drawer entry a dedicated route. It creates the existing seller inbox Cubit and opens the existing admin thread, then renders the existing conversation screen as soon as the thread loads. Loading and API errors stay on that route with a retry action. Customer drawer navigation and combined inbox entry points remain unchanged.

## Verification

Run Dart analysis for the route, drawer, and inbox page. Do not call the live seller API.
