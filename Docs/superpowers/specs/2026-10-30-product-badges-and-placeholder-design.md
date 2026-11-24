# Product Badges and Placeholder Design

## Goal

Match product badges across home, search, and recently viewed surfaces; use the supplied product placeholder in product cards and detail images; remove the discount percentage text from product details.

## Design

- Search product cards show the same badge rule as home cards: show `Sale` when the product has a discount, otherwise show `New` when `isNew` is true.
- Recently viewed snapshots retain `isNew` from the product being opened.
- The supplied large product placeholder is used for product card and detail image loading, missing-image, and failed-image states.
- Product details keep the current sale price and crossed-out original price, but omit the percentage-off label.

## Boundaries

No API, repository, cart, pricing, or navigation behavior changes. Existing product images and pricing values remain untouched. Existing placeholder usages outside storefront product cards and product detail remain unchanged.

## Verification

Format and analyze touched Dart files. Refresh Graphify after code changes. Do not add or run tests unless requested.
