# Product Detail Related and Upsell Sections

## Goal

Show related products and upsells below Reviews on the product detail screen, using the home screen's complete product card presentation.

## Approved behavior

- Show **Related Products** when the product has related products.
- Show **We found other products you might like!** when the product has upsells.
- Place both sections below Reviews; omit a section when its list is empty.
- Render cards with the home large-card details and interactions, including image/fallback, Sale/New badge, name, price, rating, wishlist, and add-to-cart actions where available.

## Data flow

- Extend the storefront product detail GraphQL selection to request `upSells` alongside `relatedProducts`.
- Parse upsells into the product model and expose them through product-detail state.
- Reuse the existing home large-card presentation in the product-detail sections; adapt data at the boundary rather than duplicate card UI.
- Keep GraphQL requests in the existing repository and keep UI state in the product detail BLoC.
- Keep storefront headers and client construction unchanged.

## Empty and failure behavior

- Hide either section when its product list is empty.
- Preserve current product detail behavior if the relation fields are empty or absent.
- Do not change grouped products, seller product editing, or unrelated product sections.

## Verification

- Run Dart analysis on touched files.
- Do not mutate live product data while checking the query.
- Refresh Graphify after code changes.
