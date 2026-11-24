# Marketplace Shop (Buyer-Side) API Reference

Generated from the live OpenAPI document at
`http://192.168.15.239/theme/apis_v2.4.9/public/api/shop/docs?format=json` on 2026-08-14 — the `Marketplace` tag of the storefront API.

**What this file is for.** The buyer-facing half of the marketplace: what a shopper sees and
does. Seller-panel endpoints are in `16-marketplace-seller-api-reference.md`.

## Transport

| | |
|---|---|
| REST base | `http://192.168.15.239/theme/apis_v2.4.9/public/api/shop` |
| GraphQL | `http://192.168.15.239/theme/apis_v2.4.9/public/api/shop/graphql` |
| App key | `X-STOREFRONT-KEY` on every request — this is the key the customer app already sends |
| Customer auth | `Authorization: Bearer <customerToken>` on the endpoints that act as a person (review, report, messages) |
| Public endpoints | directory, shop page, catalogue, offers, contact form and review reads need the key only |

## Buying from a specific seller

There is no marketplace-specific cart endpoint. The standard add-to-cart carries the seller:

```json
{ "productId": 221, "quantity": 1,
  "additional": { "seller_info": { "product_id": <listingId>, "seller_id": <sellerId>, "is_owner": 0 } } }
```

`product_id` here is the **listing** id from `shopProductOffers` / `shopSellerProducts`, not the core product id.

17 operations.

---

## Marketplace

### `GET /communication-preference` — Get my email preference

Whether this shopper receives an email when a seller replies. `true` for a shopper who has never changed it.

### `PUT /communication-preference` — Update my email preference

Turns seller-reply emails on or off. The storefront uses `PATCH`; this is `PUT` because the whole setting is one field and is replaced wholesale, matching `PUT /api/seller/profile`.

### `GET /communications` — List my conversations

Sellers this shopper has a thread with, most recently active first, each with its last message and how many seller replies are still unread — the inbox list.

**Filters:** `search`, `per_page`

### `GET /communications/{id}` — Get one conversation

The thread with one seller, oldest message first. `{id}` is the seller id. Reading does **not** mark anything read — use the read endpoint for that, so the client decides when messages were actually seen. `?days=` narrows the history. Returns an empty thread rather than 404 when the shopper has never messaged that seller, so a client can open a fresh conversation screen from a seller id alone.

**Filters:** `days`

### `POST /communications/{id}` — Message a seller

Sends a message to the seller, starting the thread on first use. One of `message` or `attachment` is required; the attachment is a URL or `data:` base64 URI (jpeg, png, pdf, doc, docx). The seller is emailed unless they have turned that off. Refused with 422 once the seller has blocked the thread. `{id}` is the seller id.

### `POST /communications/{id}/read` — Mark a conversation as read

Marks the seller's messages in this thread as read, zeroing `unread_count`. The storefront uses `PATCH`; this is `POST` because it is an action on a sub-path, matching every other action endpoint in this API.

### `GET /flag-reasons` — List report reasons

Active reasons a shopper may choose when reporting. `?type=seller` for the seller report form, `?type=product` for a product; omit it for both. Public. A plain array, not a `{ data, meta }` envelope.

**Filters:** `type`

### `POST /products/{id}/flag` — Report a product listing

Reports a specific seller's listing. **`{id}` is the listing id** (`marketplace_products.id`) — the `listing_id` from the offers endpoint, not the core product id, because the report is against one seller's offer rather than the product itself.

### `GET /products/{id}/offers` — List other sellers offering a product

Every seller offering this product, with their own price, condition and rating — the marketplace buy-box. `{id}` is the product's **url key** (its storefront slug); a numeric product id also works.

### `GET /sellers` — List sellers

The public seller directory. Returns a plain array with pagination in the response headers, the same shape as every other storefront collection.

**Filters:** `search`, `country`, `city`, `sort`, `per_page`

### `GET /sellers/{id}` — Get a seller shop page

Everything the storefront shop page renders for one seller: the banner and logo, the business description, the return, shipping and privacy policies, SEO meta, social links, and any admin-defined field marked visible on the storefront.

### `POST /sellers/{id}/contact` — Send a seller a message from the shop page

Emails the seller a question. `{id}` is the seller **slug**. Public — only the storefront key is required, as on the storefront. The message is **not stored**: it goes out as an email and leaves no thread. Use `/api/shop/communications` for a conversation the shopper can come back to.

### `POST /sellers/{id}/flag` — Report a seller

Reports a seller to the marketplace admin. `{id}` is the seller **slug**. Needs a **customer token** on top of the storefront key.

### `GET /sellers/{id}/products` — List a seller's products

The products on one seller's shop page. `{id}` is the seller **slug**, as everywhere else under `/sellers`; a numeric seller id also works. Public — only the storefront key is needed. Pagination is in the response headers.

**Filters:** `sort`, `price`, `type`, `name`, `limit`, `per_page`

### `GET /sellers/{id}/reviews` — List a seller's reviews

Approved reviews for one seller, newest first, with the reviewer's name. `{id}` is the seller **slug**, as on the shop page. Public — only the storefront key is needed. Pagination is in the response headers.

**Filters:** `per_page`

### `POST /sellers/{id}/reviews` — Review a seller

Leaves a review. Needs a **customer token** on top of the storefront key. One review per customer per seller — a second attempt is refused with 422. The review is created `pending` and only appears in the listing once an admin approves it.

### `GET /sellers/{id}/top-selling` — List a seller's best sellers

The seller's five best-selling products, **most units sold first**. `{id}` is the seller **slug**, as everywhere else under `/sellers`; a numeric seller id also works, which is what Marketplace's own route takes. Public — only the storefront key is needed.
