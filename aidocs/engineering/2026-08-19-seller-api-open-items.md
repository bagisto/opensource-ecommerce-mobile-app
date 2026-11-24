# Seller API — open items for the server dev

Install: `http://192.168.15.239/theme/api-4.9/public`
Seller used: `ashifwebkul@gmail.com` (Acme Store-2, seller 38)
Checked: 2026-08-19. Everything below was reproduced live on that day.

**Re-checked 2026-08-20 against collection v10.** Item 1 is fixed and is struck through below.
Items 2 and 3 are unchanged on the live schema. One new note is added at the end.

**Re-checked again on 2026-08-20 against collection v11 — every open item is now
fixed.** Bookings take `id` and `qty`, `sellerCheckoutDealOptions` exists and returns
the cart attributes, and the import samples carry `xmlUrl` and `requiredColumns`. Each
one was verified live and is recorded under its own entry. Nothing here is outstanding.

---

## 1. Bookings carry no customer name and no created date — FIXED 2026-08-20

`sellerBookings` and `sellerBooking` both answer `customerName: null` and
`createdAt: null`. The order the booking belongs to carries the name, on the
same token, one call later — so the data exists and only this resource omits
it.

**Booking** (a real order placed through the storefront API):

```graphql
query {
  sellerBookings(page: 1) {
    collection { id from to qty productName orderId customerName customerEmail createdAt }
  }
}
```

```json
{
  "id": "/api/seller/bookings/1",
  "from": "2026-08-24T10:00:00+05:30",
  "to": "2026-08-24T11:00:00+05:30",
  "qty": 2,
  "productName": "Studio Session — 1 Hour",
  "orderId": 8,
  "customerName": null,      // <-- empty
  "customerEmail": "zz-booker-54290@example.com",
  "createdAt": null          // <-- empty
}
```

**The same order:**

```graphql
query { sellerOrder(id: "/api/seller/orders/8") { incrementId customerName } }
```

```json
{ "incrementId": "8", "customerName": "Zed Booker" }
```

`sellerBooking` (the detail) behaves the same: `customerPhone` and
`customerAddress` are filled in, `customerName` and `createdAt` are not.

**2026-08-20 — fixed.** The same booking now answers:

```json
{ "customerName": "Zed Booker", "createdAt": "2026-08-19T21:17:46+05:30" }
```

The detail agrees. v10 explains where each comes from: the name falls back to the
billing address because a cart made by a token client carries no customer, and
the date falls back to the order's because core leaves `bookings.created_at`
null. The app keeps its email fallback for the older case; it costs nothing and
answers a marketplace that has not updated yet.

**Expected**
- `customerName` — the customer on the order the booking came from
- `createdAt` — when the booking row was written

**Why it matters** — the diary lists who is coming at each slot; with no name
the slot reads as booked by nobody. `createdAt` is what a newest-first sort
and any "booked 2 days ago" line need.

*The app shows the email in the meantime. That is a stand-in, not the fix.*

---

## 2. The booking grid's ID and QTY filters have no arguments — FIXED 2026-08-20 (v11)

`sellerBookings` takes `page`, `from`, `to`, `order_id`, `product_id`. All
four were checked and each narrows correctly:

| filter | result |
|---|---|
| none | 1 |
| `from: 2026-08-01, to: 2026-08-31` | 1 |
| `from: 2026-09-01, to: 2026-09-30` | 0 |
| `order_id: 8` / `order_id: 999` | 1 / 0 |
| `product_id: 142` / `product_id: 1` | 1 / 0 |

The seller panel's own filter drawer additionally offers **ID** and **QTY**
boxes. The API takes neither.

**Expected** — either add `id` and `qty` arguments, or confirm those two are
panel-only and we leave them out of the app for good.

An app cannot fake them: filtering the page it happens to have loaded would
report a count for rows it never searched.

**v11 — both added, and both narrow.** Checked live against the one booking on
this seller:

| sent | rows |
|---|---|
| nothing | 1 |
| `id: 1` / `id: 999` | 1 / 0 |
| `qty: 2` / `qty: 99` | 1 / 0 |

The app's filter sheet now offers the two boxes beside Order and Product.

---

## 3. No options endpoint for checkout deals — FIXED 2026-08-20 (v11)

Product discounts have `sellerProductDiscountOptions`, which returns the
condition attributes with their operators and their value options — that is
what lets a client build the condition rows the panel builds.

Checkout deals (cart rules) have no equivalent. There is no
`sellerCheckoutDealOptions` in the schema, and the product-discount options
return **catalogue attributes only**:

```
product|category_ids, product|attribute_family_id, product|sku, product|name,
product|url_key, product|tax_category_id, product|new, product|featured,
product|visible_individually, product|status, product|price, product|cost …
```

No `cart|*` or `cart_item|*` key appears anywhere.

**Expected** — a `sellerCheckoutDealOptions` query in the shape of
`sellerProductDiscountOptions`, covering the cart-rule attributes.

**Why it matters** — a cart-rule condition on payment method, shipping
method, state or country needs the store's own list of those values. Without
it the app has to make the seller type the value by hand, and a typo simply
produces a deal that never applies.

**v11 — `sellerCheckoutDealOptions` is there, in the shape asked for.** Live it
returns the cart attributes and nothing else:

```
cart|base_sub_total, cart|items_qty, cart|payment_method, cart|shipping_method,
cart|postcode, cart|state, cart|country
cart_item|base_price, cart_item|quantity, cart_item|base_total_weight,
cart_item|base_total, cart_item|additional
```

`actionTypes` carries all four deal kinds with a plain-English label and an
`info` line each. The deal editor reads this query now and the discount editor
keeps the product one; neither can answer for the other, so they are two calls.

---

## Checked and fine — no action needed

- Every product type creates and fills through the API: simple, virtual,
  downloadable, grouped, bundle, booking and configurable, plus all five
  booking kinds (default, appointment, event, rental, table).
- `bookingSlots(id:)` takes the **booking** id, not the product id. That is
  what the storefront's own `bookingProducts._id` returns, so it is
  consistent — noting it only because it costs an afternoon to discover.
- `sellerProductCategories` returns `[]` for this seller because the install
  has only a Root category. Not an API fault.
- Barcode PDF, invoice and receipt PDFs, report exports and import files all
  download correctly with the seller token.

---

## 4. Clearing a sale price works on one endpoint and not the other

Not a defect, but the two endpoints disagree and only one is documented.

`createSellerPricingMassSave` with `specialPrice: null` clears the price and both
dates, exactly as v10 says under Mass Save Prices.

`updateSellerProduct` does not:

| sent | result |
|---|---|
| `specialPrice: null` | sale left in place |
| `specialPrice: ""` | schema error — the field is a `Float` |
| `specialPrice: 0` | price cleared, **dates left behind** |
| `specialPrice: 0` + `specialPriceFrom: ""` + `specialPriceTo: ""` | fully cleared |

All four checked live on 2026-08-20. A product editor screen uses the product
update, so the note under Mass Save Prices does not reach the client that needs
it. Either accept a null there too, or say in the product-update description
which values clear it. The app now sends the last row.

---

## 5. Bulk upload: two small gaps, found auditing the flow against the panel

The pipeline itself is right. Driven exactly as the collection documents it —
`validate` → `start` → `link` → `index` → `index` → `nextAction: null` — a
two-row sheet imported end to end and both products landed in the seller's
catalogue as `isOwner: true`. The image pre-fetch, queued validation and run
report are all there. What follows is the rest.

### 5.1 Nothing says which columns a row must carry — FIXED 2026-08-20 (v11)

The starter spreadsheet is the only guide to the file's shape, and it says
what the columns *are*, never which ones a row cannot omit. Every sheet a
seller hands us fails the same way on the first run:

```
Row(s) 1, 2: The short description field is required.
Row(s) 1, 2: The description field is required.
Row(s) 1, 2: The guest checkout field is required.
```

Filling those three made the identical file import cleanly, so the rule is
real — it is just undiscoverable until the file has been uploaded and
validated. `sellerImportSamples` returns download links only.

A `requiredColumns` (or the full column list with a required flag) on
`sellerImportSamples`, per `type`, would let a client mark the columns before
the seller starts filling anything in. The alternative is what the panel does:
let them find out by failing.

**v11 — `requiredColumns` is on `sellerImportSamples`, grouped per attribute
family.** Live, for both import types:

```json
[{ "attribute_family_id": 1, "attribute_family_code": "default",
   "columns": ["sku","url_key","type","attribute_family_code","locale",
               "short_description","description","name","price",
               "visible_individually","status","guest_checkout","weight"] }]
```

The wizard prints them on the Source step, so a seller sees the list before
filling the sheet rather than after uploading it.

### 5.2 The panel offers an XML sample; the API has no XML — FIXED 2026-08-20 (v11)

The panel's create wizard prints four formats — CSV, XLS, XLSX, **XML** — and
`sellerImportSamples` returns three:

| format | result |
|---|---|
| `csv` | 200, `text/csv` |
| `xls` | 200, `application/vnd.ms-excel` |
| `xlsx` | 200, spreadsheet |
| `xml` | **404** |

Either the sample exists and the query should carry an `xmlUrl`, or the panel
is offering a format the importer does not take and the wizard should drop it.
Whichever way, the two should agree.

**v11 — `xmlUrl` is on `sellerImportSamples` and the file downloads.**
`?format=xml` answers 200 `text/xml`, 29 KB, opening `<?xml version="1.0"?>
<products><product sku="SP-001" …`. The app's starter-sheet row offers XML
alongside CSV and XLSX now, matching the panel's four.

---

## 6. Customer returns (RMA): the published docs disagree with the schema

Building the shopper-side returns module against
`api-docs.bagisto.com/api/graphql-api/shop/returns/` does not work — the live
schema differs in four places. Every one below was read from
`__type` introspection on this install and then exercised live.

| the docs say | the schema takes |
|---|---|
| `createCustomerReturn(quantity, reasonId)` | `rmaQty`, `rmaReasonId` — plus `information`, `packageCondition`, `variant`, `agreement` |
| a return has `items` | one `item`, singular, as a loose map (`order_item_id`, `reason_id`, …) |
| `customerReturns(page, limit)` | a cursor connection: `first`, `after`, `status: Int` |
| `customerReturn(id: ID!)` | the resource **IRI** — a bare `"1"` resolves to a row of every field null, with no error |

Two more worth writing down, both correct behaviour but easy to lose an
afternoon to:

* `canClose`, `canReopen` and `isExpired` resolve on the **detail only**; the
  listing returns them null, so a client that renders actions from the list
  shows none.
* `agreement: true` is required — the storefront's form makes the shopper tick
  the return policy and the endpoint enforces it.

### Not an API fault: nothing is currently eligible for return

`returnableItems` answers `[]` for every order on this install, and
`createCustomerReturn` refuses with *"The selected item is not eligible for
return."*

**This is not an API defect** — the storefront's own form does exactly the
same. Its picker, `GET /customer/account/rma/get-order-items/{id}`, also
returns `[]` for every order, and posting to `/customer/account/rma/store`
answers *"The selected order item is invalid."* Same rule, same answer, both
surfaces.

Reproduced on a freshly seeded order: a simple product from Acme Store-2,
approved by the admin, bought by `pw-customer@example.com` (order **9**),
invoiced and shipped by the seller, order status `completed`, well inside the
7-day window in Configuration → Sales → RMA. Still not eligible.

So it is a rule or a data condition on the RMA extension, not something a
client can fix or work around. Worth the server dev's eye, since a shopper
cannot open a return anywhere on this install today. The app's form is built
and asks the server every time; while the answer stays empty it says so in
plain words, which is the same thing the storefront does.

---

## 7. A sheet that cannot be read validates into a dead end

`validateImport` on a spreadsheet whose columns do not match **succeeds**, and
names the problem properly:

```json
{ "state": "validated", "processedRowsCount": 0, "isValid": null,
  "errorsCount": 2,
  "errors": ["Required columns not found: sku.",
             "Invalid column names: \"order_id,shipping_method,tracking_number,tracking_url\"."],
  "nextAction": "validate" }
```

Two of those fields contradict what the collection tells a client to do.

**`nextAction` stays `validate`.** The Bulk Upload description says to drive
the run with

```
while (import.nextAction) POST /imports/{id}/{import.nextAction}
```

and that `nextAction` is `null` "when the job is done **or has failed
validation**". Here it never becomes null. Called five times in a row against
import 93 on this install, the answer was identical every time — state
`validated`, 0 rows, `nextAction: validate`. A client written to the
documented loop never terminates.

**`isValid` stays `null`.** Import Detail documents `isValid: null` as
"validation hasn't run yet" and `false` as "the file can't be imported". This
file has been validated and cannot be imported, and reports neither.

Between them, nothing in the response says the file is unusable except the
`errors` array, which a client would have to interpret by hand.

**Expected** — after a validate that finds the file unreadable:
`isValid: false` and `nextAction: null`, matching what Import Detail already
documents.

**What the seller saw.** A "Next: validate" button that never went away and
did nothing when pressed. The app now stops as soon as a phase runs without
moving anything — same action, same state, same row count — and shows the
server's own line, "Required columns not found: sku." That is a guard against
the symptom, not a fix: the API should end the run itself.

