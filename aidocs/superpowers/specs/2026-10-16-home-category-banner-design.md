# Home Category Banner and Description

## Goal

Show the configured category banner and description when a customer opens a category product list from Home or the Categories tab.

## Design

The existing `categories` GraphQL queries will request `bannerUrl` and `translation.description` for home categories and nested subcategories. Their models will pass these optional fields to `CategoryProductsGridPage`. The product list page will render the banner and left-aligned plain-text description above its filters, reusing the existing `CategoryBanner` widget. Product queries, headers, and category navigation behavior remain unchanged.

## Failure behavior

If either field is missing or empty, omit that part of the category header. A missing image must not block products from loading.

## Acceptance

- Home category request includes banner URL and translated description.
- Opening a category from Home or tapping a subcategory in the Categories tab displays supplied banner and description.
- Description starts at the left edge of its content area.
- Categories without either field retain current layout.
