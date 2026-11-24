# Marketplace demo seeding

`seed.sh` fills a seller account with demo data by calling the live seller
GraphQL API — the same endpoints the app uses. Nothing is hardcoded in the app;
the app renders whatever the backend holds.

## Requirements

`curl` and `jq`.

## Run

```bash
BASE=http://192.168.15.239/theme/api-4.9/public \
EMAIL=ashifwebkul@gmail.com PASSWORD=seller123 \
./tool/marketplace_seed/seed.sh
```

## What it creates

- an inventory source, if the seller has none
- six simple products with names, prices, stock and images

## Behaviour worth knowing

- **SKUs carry a run stamp** (`RUN_ID`, defaulting to the current epoch), so a
  repeat run adds a fresh batch instead of failing on duplicates. Set `RUN_ID`
  yourself for a predictable batch.
- **Images are probed before they are sent.** The server downloads image URLs
  itself and rejects the entire update when one fails, which would otherwise
  cost the product its name, price and stock. Unreachable URLs are dropped, and
  a server-side rejection triggers one retry without the image.
- **Categories are read from `sellerProductCategories`.** When the admin has
  restricted this seller to none, the list comes back empty and products are
  created without categories rather than failing.

## Not seeded here

Orders, invoices and transactions require a customer checkout, which runs
through the storefront API rather than the seller API. Place an order from the
customer side of the app to populate the dashboard's order and payout figures.
