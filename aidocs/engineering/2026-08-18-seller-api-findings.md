# Seller API 2.4.9 — findings from the Flutter app

Written against `MarketplaceApi.graphql.postman_collection v4` on 2026-08-18, every point verified
live on `http://192.168.15.239/theme/api-4.9/public/api/seller/graphql` with the seller
`ashifwebkul@gmail.com`.

**Re-checked on 2026-08-20 against collection v10.** The three documentation notes in §3 are
closed: the inventories shape and `exclude_customizable` are now written up, and the variants rule
has changed behaviour — `{id, variants}` alone is written, checked live again, so the app's habit of
sending the SKU alongside is no longer needed. §5 is also closed: the app reads `sellerCapabilities`
and the dashboard's todo tile. What each check answered is recorded under its original entry.

**Re-checked on 2026-08-19 against collection v5.** Every bug below is fixed and the missing field
is there. What each check answered now is recorded under the original report, so the next person can
see what the behaviour is rather than what it was. Only the documentation notes in §3 are still open,
and §5 lists what the app has not taken up yet.

## 1. Bugs to fix — all fixed

### 1.1 A bundle option's last product can never be removed — fixed

`updateSellerProduct` with `bundleOptions[].products: []` answered OK and **left the existing rows in
place** — the empty list was ignored rather than treated as "delete them all".

```
write  {id, sku, bundleOptions:[{bundleOptionId:10, locales:[...], products:[]}]}   -> OK
read   bundleOptions[0].products -> [{bundleOptionProductId:20, productId:272, qty:2}]   (unchanged)
```

**2026-08-19:** the empty list now deletes the rows, and the option survives with no products in it.
The two sides match — a non-empty list still replaces the set, an empty one clears it.

### 1.2 The empty-option error names no option and drops the whole update — gone

The message `Each bundle option needs at least one product.` was returned for a payload carrying many
options and many parent fields, naming no option and discarding every other field with it.

**2026-08-19:** the validation is gone altogether. An option with no products is accepted and stored,
which is the right call — a seller adds the option first and fills it after. The app's save-blocking
guard was removed to match; the form now only says on screen that an empty option sells nothing.

### 1.3 Re-sending a customer-group price that already exists is a 500 — fixed

`createSellerPricingMassSave` saved a tier the first time and answered `Internal server error` when
the **same `customerGroupId` and `qty`** came back — which is what changing only that tier's value
looks like.

**2026-08-19:** re-sending updates the row in place and keeps its `tierId`. `customerGroupPrices: []`
still clears the set.

### 1.4 Nothing reads a product's customer-group prices back — fixed

There was no `customerGroupPrices` on `sellerProduct` and no customer-group query on the seller API,
so a client could write tiers but never show the ones a product already had.

**2026-08-19:** both are there —

```
sellerProduct.customerGroupPrices { tierId customerGroupId customerGroupName qty valueType value }
sellerCustomerGroups { _id code name isUserDefined }        -> Guest / General / Wholesale
```

`tierId` round-trips, so a tier edits in place instead of being deleted and recreated, and a tier
sent with `customerGroupId` omitted is stored as "All Groups" and reads back with a null group. The
app reads the tiers when the seller opens a product's drawer and no longer warns that saving may
lose tiers set in the panel.

## 2. Missing fields — added

### 2.1 `sellerProducts` does not return the sale price or its dates — added

The panel's pricing grid edits four values per product; the listing that feeds it returned only
`price`, so a client had to read every row's product separately — ten extra requests per page.

**2026-08-19:** `specialPrice`, `specialPriceFrom` and `specialPriceTo` are on the listing and come
back filled. Sending `null` for any of them now clears it, so a sale can be lifted from the grid.
The app dropped its per-row reads.

**2026-08-20:** the dates now arrive as the day — `specialPriceFrom` reads back `2026-09-01`, not a
timestamp — on both the listing and the detail. The app's trim is now a no-op it can keep for older
installs.

**Clearing a sale is not the same on both endpoints, and only one is documented.** v10's note lives
under Mass Save Prices and is right there: `createSellerPricingMassSave` with `specialPrice: null`
clears the price and both dates. `updateSellerProduct` does not — a null leaves the sale in place, an
empty string is a schema error against `Float`, and what actually clears it is `specialPrice: 0`
with `specialPriceFrom: ""` and `specialPriceTo: ""`. All four checked live. Worth a line in the
product-update description, since that is the endpoint an editor screen uses.

## 3. Documentation corrections for the collection — still open

1. **Inventory mass save, `inventories` shape.** The example shows a map,
   `"inventories": {"1": 40, "2": 5}`. That parses only when the payload travels as a JSON
   *variable*; written inline in a GraphQL document it is a syntax error, because `5` is not a valid
   GraphQL name:

   ```
   Syntax Error: Expected Name, found String "5"
   ```

   The record form `inventories: [{inventorySourceId: 5, qty: 7}]` works both ways. Worth saying
   which is which, or standardising on the record form.

2. **The `Iterable` variables problem is fixed.** Both `createSellerInventoryMassSave` and
   `createSellerPricingMassSave` used to lose nested objects passed as variables and answer "No
   inventories were saved" / "No prices were saved". Re-checked: variables work for both and the
   values read back. Any client still building GraphQL by hand can stop.

3. **A configurable's `variants` need a parent field beside them — fixed.** `{id, variants}` used to
   be answered OK and written nowhere.

   **2026-08-20:** variants alone are written. A variant-only save of `price: 77.77` read back as
   77.77 with no parent field in the payload. v10 documents it as working, and it does. The app's
   habit of sending the product's own SKU alongside is harmless but no longer required.

4. **`exclude_customizable` is missing from the collection's `sellerProducts` arguments.** It works
   (`exclude_customizable: 1`) and is what a bundle or grouped picker needs so a customer-option
   product cannot be put inside another product. Only the documentation is missing.

## 4. Confirmed working (no action needed)

- `sellerProduct` returns `variants`, `links`, `bundleOptions`, `downloadableLinks`,
  `downloadableSamples` and `booking`, in the shape the update takes them back.
- `bundleOptionId` / `bundleOptionProductId` / `linkId` / `ticketId` / `tierId` round-trip correctly
  and edit in place; omitting one deletes the row and creates a replacement, as documented.
- `booking.slots` needs `day` on every slot for all five booking types, including rental and table
  where the panel shows no weekday. A slot without one is a 500.
- Two id spaces, unchanged: the seller catalogue id addresses a product (`id`, `_id`, every IRI),
  and the core product id is what bodies carry (`variantId`, `associatedProductId`,
  `bundleOptions.products[].productId`, `productId` in the mass saves). The listing returns both.

## 5. In v5, not taken up by the app yet

- `sellerCapabilities` — menu flags, permissions and plan limits. The app draws its seller menu from
  a fixed list and would show only what the seller's plan allows if it read this.
- The dashboard `todo` tile.
