# Bagisto Mobile App Working Plan

## Objective

Keep this Bagisto mobile storefront stable, customizable, and backend-aligned across catalog, cart, checkout, account, search, and notification flows.

## Current Code Map

- `lib/main.dart`
  - startup orchestration for Firebase, Hive, preferences, channel bootstrap, and notifications
- `lib/core/**`
  - shared config, GraphQL client setup, navigation, theme, locale, currency, notifications, utilities
- `lib/features/auth/**`
  - login, register, forgot-password, logout, auth persistence
- `lib/features/home/**`
  - homepage composition driven by theme customization and catalog queries
- `lib/features/category/**`
  - categories, sorting, filtering, product grids
- `lib/features/product/**`
  - product detail experience
- `lib/features/cart/**`
  - guest and authenticated cart behavior
- `lib/features/checkout/**`
  - checkout-specific data and presentation flows
- `lib/features/account/**`
  - orders, wishlist, reviews, preferences, settings, addresses
- `lib/features/search/**`
  - text and image-assisted search
- `lib/marketplace/**`
  - seller panel and buyer-facing marketplace: its own GraphQL endpoint
    (`ApiEnv.sellerGraphql`), its own session storage (`seller_*` keys), an ACL
    gate, and a bottom-tab shell reached from the account menu
- `tool/marketplace_seed/**`
  - seeds demo sellers, stock and products through the live API
- `test/**`
  - unit and widget verification
- `maestro/**`
  - end-to-end Android flows

## Architecture Pillars

### 1. Bootstrap And Configuration

- `main.dart` is the composition root.
- `api_constants.dart` owns endpoint and storefront metadata.
- `ChannelBootstrapService` sets locale and currency defaults early.

### 2. GraphQL Access

- `GraphQLClientProvider` is the shared entry point for GraphQL clients.
- Request logging, timeouts, and dynamic storefront headers live in the shared client layer.
- Repositories own queries and mutations.

### 3. State Management

- BLoCs and Cubits drive presentation state.
- Widgets dispatch events and render states instead of owning request logic.
- Persisted auth, locale, and currency state flow through dedicated storage/services.
- Seller reports open on the web's Last 30 Days range across Sales, Products
  and Customers, sending device-local dates from 30 days before today through
  today. Other presets remain available: Daily is today, Monthly is
  month-to-date, and Yearly is year-to-date. Refresh recalculates dates; API
  responses remain the source for displayed ranges, figures and export links.
- The dashboard has its own date selector above the payout card. It preserves
  the initial API default (null dates), supports the web presets and custom
  ranges, and sends only `start`/`end`. Refresh and product-edit return retain
  the selection; relative presets recalculate local calendar dates. Older
  responses cannot replace a newer selection. Reports remain independent.
- Seller profile country/state options load independently through the existing
  seller account repository and profile Cubit. Lookup failures preserve manual
  fields and do not block other profile edits. New selections send codes;
  untouched legacy names remain unchanged in partial saves.

### 4. Navigation And Shell

- Sellers who require a subscription but have no plan land on the existing
  Manage Profile form within the seller shell; Plans remains available in the
  drawer. Sellers with a plan and marketplaces without subscriptions retain
  the dashboard and existing permission gates.

- `MainShell` owns the primary tab container.
- Notification-driven navigation should use the established app navigation structure.

- The seller drawer groups All products and Sell an existing product under
  Products, retaining their existing tab/route handlers and permission gates.
- Reviews groups Product reviews and Shop reviews; each route shows only its
  selected review list without tabs, using the existing repository and cubit.
- Dashboard Running low rows open the existing product editor after resolving
  their core product ID and exact SKU to a seller catalogue IRI. Catalogue and
  edit permissions are required; successful saves refresh the dashboard.
- Seller configurable variant bulk actions stay local until the editor's main
  Save. Save parent fields first, submit queued mass-update calls sequentially,
  stop on first failure with remaining actions retained, then reload product.

### 5. Storefront Configuration & Returns (Customer Side)

- `StoreConfig` (`storeConfig` query) drives admin storefront feature toggles dynamically:
  - `showCartPage`, `showWishlist`, `showCompare`, `showSocialShare`, `showImageSearch`, `showNewsletter`, `showReorder`, `showBuyNow`.
  - `allowGuestCheckout`, `customerReviewEnabled`, `guestReviewEnabled`, `censorReviewerName`.
  - Minimum order enforcement (`minimumOrderAmount`, `minimumOrderMessage`).
  - Login/signup redirects (`loginRedirectTo`).
  - Homepage sections query (`SectionQueries.getSections` with fallback to `ThemeQueries.getThemeCustomization`).
- Customer RMA/Returns:
  - Backed by `ReturnsQueries` via `AccountRepository`.
  - Managed by `ReturnsBloc`, `CreateReturnBloc`, `ReturnDetailBloc`.
  - UI in `ReturnsPage`, `CreateReturnPage`, and `ReturnDetailPage`.
- Category Display Mode:
  - Backed by Bagisto admin `displayMode` ('description_only', 'products_only', 'products_and_description').
  - `description_only`: Shows banner and description in a scrollable view; suppresses products, filter chips, count row, and bottom sort/filter bar.
  - `products_only`: Shows banner and products; suppresses description.
  - `products_and_description`: Default/complete view showing banner, description, filters, and products.
- Cart, Checkout, Order & Invoice Tax Display Parity:
  - Aligned with Bagisto channel settings (`taxCartDisplayPrices`, `taxCartDisplaySubtotal`, `taxCartDisplayShipping`, `taxCartShowBreakdown`, `taxOrderDisplayPrices`, `taxOrderDisplaySubtotal`, `taxOrderDisplayShipping`).
  - Item prices support `excluding_tax`, `including_tax`, and `both` (with `Excl. Tax: <amount>` sub-values).
  - Subtotal and shipping support `excluding_tax`, `including_tax`, and `both` (with `Excl. Tax: <amount>` sub-values).
  - Tapping Tax row expands per-rate breakdown accordion using `appliedTaxes`.
  - Order Detail and Invoice Detail reflect customer order tax configuration.
- Checkout online payment launch:
  - `CheckoutRepository` saves the selected method and requests
    `createCheckoutPaymentInitiation` for online methods.
  - The checkout payment page launches redirect responses and POSTs form
    responses inside the existing `flutter_inappwebview` dependency.
  - Razorpay `sdk` responses launch the native Razorpay Flutter SDK with the
    server-created order, then send its payment id and signature to
    `createCheckoutPaymentConfirmation`; checkout completes only after Bagisto
    confirms the order.
  - PayPal Standard uses the shop REST initiation endpoint, submits the
    returned form in the WebView, then intercepts its success/failure URL and
    confirms with the server-issued reference. Pending confirmations with an
    order ID are retried every four seconds for up to 60 seconds. If still
    pending, checkout stops the spinner and shows an order-placed/payment-
    confirmation-in-progress notice with a link to the order; only verified
    success opens the success screen.
  - Stripe uses `POST /api/shop/checkout-payments/initiate` and
    `/api/shop/checkout-payments/confirm` with a server-issued reference.
    The WebView intercepts its returned success/failure URLs; only a confirmed
    `paymentStatus: success` with an order ID opens the app success screen.
    This REST path is limited to Stripe; other gateways keep their existing
    integration paths.
  - Cash on Delivery and Money Transfer retain the immediate order path.
  - Closing a provider page does not itself count as payment success. PayPal
    Standard is verified by Bagisto after the WebView closes; redirect/form
    gateways still need their own tested server verification/status contract.
- Cart Estimate Shipping & "More Choices" Cross-Sell:
  - Admin toggles `estimateShippingEnabled` and `cartCrossSellEnabled` on `StoreConfig`.
  - Leaving Cart screen (tab switch, back button, checkout/continue shopping, dispose) cleanly empties Estimate Shipping destination fields and rates via `ResetEstimateShippingEvent`.
  - Country state loading retains fixed-height input field styling with subtle trailing spinner to eliminate layout jump.
  - Tax row matches Web parity: expandable breakdown is hidden when tax is zero.
  - "More Choices" cross-sell products reuse the exact Home screen product card UI (`ProductCardLarge`) with wishlist integration and responsive layout.
- Product Price Label Rules (Web Parity):
  - Encapsulated centrally in `ProductPriceDisplay` (`lib/core/currency/product_price_display.dart`).
  - `Grouped`: Label "Starting at", Price: `formattedMinimumPrice`, never show strikethrough.
  - `Booking (event/rental)`: Label "Starting from", Price: `bookingProducts[0].formattedStartingPrice`, strikethrough `formattedStartingRegularPrice` if `startingRegularPrice > startingPrice`.
  - `Booking (default/appointment/table)`: No label, Price: `formattedMinimumPrice`, strikethrough `formattedRegularMinimumPrice` if `regularMinimumPrice > minimumPrice`.
  - `Configurable`: Label "As low as", Price: `formattedMinimumPrice`, strikethrough `formattedRegularMinimumPrice` if `regularMinimumPrice > minimumPrice`.
  - `Bundle`: No label, From-To range (`formattedMinimumPrice To formattedMaximumPrice` when min != max), compares regular and current prices separately for min and max.
  - `Simple/Virtual/Downloadable`: No label, Price: `formattedMinimumPrice`, strikethrough `formattedRegularMinimumPrice` if `regularMinimumPrice > minimumPrice`.
  - Displayed consistently across `ProductCardLarge`, `ProductCardSmall`, Category grid/list, Search, and Product Detail.
- Marketplace isolation:
  - All seller panel and buyer marketplace routes (`lib/marketplace/**`) remain completely intact and independent.

### 6. Verification

- Logic changes should bring matching unit or widget tests where practical.
- User journey changes should consider Maestro flow updates.
- Non-trivial reasoning should start from graphify output.

## Working Rules

1. Read `graphify-out/GRAPH_REPORT.md` before broad codebase analysis.
2. Keep guest cart token handling separate from authenticated customer token handling.
3. Do not duplicate GraphQL client creation across features.
4. Keep feature work aligned with existing repository and BLoC boundaries.
5. Update `aidocs/engineering/**` when architecture or workflow rules change.
6. Run `graphify update .` after meaningful changes (note: graphify HTML visualization cap is 5000 nodes; the repo graph has 8102 nodes).

