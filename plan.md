# Working plan and rules

Read this file before starting any task in this repo. It records the rules
the project owner has set and the features that are blocked on the backend,
so they are not missed or re-investigated.

## Rules (always follow)

1. **GraphQL only.** Check and build features against the Bagisto GraphQL API
   (`/api/graphql`). Introspect the schema to see what exists. Do not use or
   propose the REST endpoints (`/api/shop/...`), even when the API docs say a
   feature is REST-only.
2. **Live API data only.** No hardcoded or dummy values. If the GraphQL
   schema has no field for something, the feature is backend-blocked: list it
   below and tell the owner. Do not invent a value in the app.
3. **Validate every query against the configured server** before calling it
   done. A field the server does not have makes the whole query fail (for
   `storeConfig`, every setting then falls back to its default). Field names
   differ between servers (for example `buyNowButtonEnabled` on `new-setup`,
   `buyNowEnabled` on `bagisto_v2.5.0`).
4. **No git commit, push, merge or tag** unless the owner asks in that
   message. Never commit `lib/core/constants/api_constants.dart`.
5. Follow `CLAUDE.md` (skills, house style, tests, l10n in all 10 arb files).

## Backend-blocked (not in the GraphQL schema)

Checked on `new-setup`, 2026-10-15.

| Feature | What is missing |
|---|---|
| Return create: attach images / videos | `createCustomerReturnInput` has no file or image field; the schema has no `Upload` scalar |
| Return messages: attach a file | `createCustomerReturnMessageInput` has only `returnId` and `message` |
| Refunds tab: refund number ("Refund #2") | No refund / credit memo query |
| Refunds tab: Adjustment Refund, Adjustment Fee | No refund / credit memo query |

When the backend adds any of these, build it, then move the row to the
"Done" list in `Docs/ai-memory/`.

## Available in `storeConfig` but not built yet

`headerOfferTitle` / `headerOfferLinkTitle` / `headerOfferLink`,
`backordersEnabled`, `relatedProductsLimit` / `upSellProductsLimit` /
`crossSellProductsLimit`, `searchMinQueryLength` / `searchMaxQueryLength`,
`productsPerPage` / `listingMode` / `defaultSortBy`, `categoryView`,
`breadcrumbsEnabled`, `footerCopyright`, `captchaEnabled`,
`signupNewsletterEnabled`, `address*Required`, `addressStreetLines`,
`gdpr*`, `cookieConsent*`, `return*` (window, policy, file types),
tax display fields.

## Notes on built settings

- Cart page offer text uses `miniCartOfferInfo`, hidden when
  `miniCartEnabled` is false. The owner mentioned `miniCartOfferInfoEnabled`,
  but the schema has no such field; `fromJson` accepts it if it appears, the
  query must not ask for it.

## Server issues (not app bugs)

- `new-setup`: home "Top Collections" / "Game Container" images
  (`storage/themes/default/sections/8/...`, `/12/...`) return 403 on the
  server itself, so they are blank on the web too.

## Notes

Detailed history of each fix: `Docs/ai-memory/` (see
`2026-10-14-store-config.md` and `2026-10-15-store-config-new-server.md`).
