#!/usr/bin/env bash
# Seeds demo data into the marketplace through the seller GraphQL API.
#
# Usage:
#   BASE=http://192.168.15.239/theme/api-4.9/public \
#   EMAIL=ashifwebkul@gmail.com PASSWORD=seller123 \
#   ./tool/marketplace_seed/seed.sh
#
# Idempotency: SKUs carry a run stamp, so a second run adds a second batch
# rather than failing on duplicate SKUs.
set -euo pipefail

BASE="${BASE:-http://192.168.15.239/theme/api-4.9/public}"
EMAIL="${EMAIL:-ashifwebkul@gmail.com}"
PASSWORD="${PASSWORD:-seller123}"
RUN_ID="${RUN_ID:-$(date +%s)}"
ENDPOINT="$BASE/api/seller/graphql"
TOKEN=""

gql() {
  # $1 = query, $2 = variables JSON
  curl -sS -X POST "$ENDPOINT" \
    -H 'Content-Type: application/json' \
    ${TOKEN:+-H "Authorization: Bearer $TOKEN"} \
    -d "$(jq -n --arg q "$1" --argjson v "$2" '{query:$q, variables:$v}')"
}

echo "==> Signing in as $EMAIL"
LOGIN=$(gql 'mutation($i: createSellerLoginInput!){ createSellerLogin(input:$i){ sellerLogin { token success message } } }' \
  "$(jq -n --arg e "$EMAIL" --arg p "$PASSWORD" '{i:{email:$e,password:$p}}')")
TOKEN=$(echo "$LOGIN" | jq -r '.data.createSellerLogin.sellerLogin.token // empty')
if [ -z "$TOKEN" ]; then
  echo "Login failed: $LOGIN" >&2
  exit 1
fi
echo "    token acquired"

echo "==> Ensuring an inventory source"
SOURCE_ID=$(gql 'query { sellerInventorySources(page:1){ collection { _id code } } }' '{}' \
  | jq -r '.data.sellerInventorySources.collection[0]._id // empty')

if [ -z "$SOURCE_ID" ]; then
  SOURCE=$(gql 'mutation($i: createSellerInventorySourceInput!){ createSellerInventorySource(input:$i){ sellerInventorySource { _id code name } } }' \
    "$(jq -n --arg c "warehouse_$RUN_ID" '{i:{
        code:$c, name:"Demo Warehouse", description:"Seeded by seed.sh",
        contactName:"Demo Contact", contactEmail:"warehouse@example.com",
        contactNumber:"9876543210", contactFax:"0112345678",
        street:"Plot 42, Sector 63", country:"IN", state:"UP",
        city:"Noida", postcode:"201301", priority:1,
        latitude:28.6139, longitude:77.209, status:true }}')")
  SOURCE_ID=$(echo "$SOURCE" | jq -r '.data.createSellerInventorySource.sellerInventorySource._id // empty')
fi
if [ -z "$SOURCE_ID" ]; then
  echo "No inventory source available; stock will be skipped." >&2
fi
echo "    inventory source: ${SOURCE_ID:-none}"

echo "==> Reading assignable categories"
CATEGORY_IDS=$(gql 'query { sellerProductCategories { _id name level } }' '{}' \
  | jq -c '[.data.sellerProductCategories[]? | select(.level > 0) | ._id] | .[0:2]')
CATEGORY_IDS="${CATEGORY_IDS:-[]}"
echo "    categories: $CATEGORY_IDS"

# The server downloads image URLs itself and rejects the whole update when one
# fails, so unreachable links are dropped before they are sent.
image_is_reachable() {
  [ -n "$1" ] && [ "$(curl -s -o /dev/null -m 12 -w '%{http_code}' "$1")" = "200" ]
}

# $1 product IRI · $2 sku · $3 name · $4 price · $5 qty · $6 image (may be empty)
product_details() {
  jq -n --arg id "$1" --arg s "$2" --arg n "$3" --arg img "$6" \
        --argjson p "$4" --argjson q "$5" \
        --argjson src "${SOURCE_ID:-null}" --argjson cats "$CATEGORY_IDS" '{i:{
      id:$id, sku:$s, name:$n, urlKey:$s,
      shortDescription:("<p>" + $n + "</p>"),
      description:("<p>" + $n + " — seeded demo product.</p>"),
      metaTitle:$n, price:$p, weight:1,
      status:1, visibleIndividually:1, new:1, featured:1, guestCheckout:1,
      categories:$cats,
      inventories:(if $src == null then [] else [{inventorySourceId:$src, qty:$q}] end),
      images:(if $img == "" then [] else [$img] end),
      isDraft:false }}'
}

create_simple_product() {
  local sku="$1" name="$2" price="$3" qty="$4" image="$5"

  local created
  created=$(gql 'mutation($i: createSellerProductInput!){ createSellerProduct(input:$i){ sellerProduct { id productId sku } } }' \
    "$(jq -n --arg s "$sku" '{i:{type:"simple", attributeFamilyId:1, sku:$s, isDraft:false}}')")

  local iri
  iri=$(echo "$created" | jq -r '.data.createSellerProduct.sellerProduct.id // empty')
  if [ -z "$iri" ]; then
    echo "    skipped $sku: $(echo "$created" | jq -r '.errors[0].message // "unknown error"')"
    return
  fi

  if ! image_is_reachable "$image"; then
    echo "    $sku: image unreachable, seeding without it"
    image=""
  fi

  local mutation='mutation($i: updateSellerProductInput!){ updateSellerProduct(input:$i){ sellerProduct { sku name price quantity } } }'
  local updated
  updated=$(gql "$mutation" "$(product_details "$iri" "$sku" "$name" "$price" "$qty" "$image")")

  # A rejected image must not cost the product its name, price and stock.
  if echo "$updated" | jq -e '.errors' > /dev/null 2>&1 && [ -n "$image" ]; then
    echo "    $sku: image rejected by server, retrying without it"
    updated=$(gql "$mutation" "$(product_details "$iri" "$sku" "$name" "$price" "$qty" "")")
  fi

  if echo "$updated" | jq -e '.errors' > /dev/null 2>&1; then
    echo "    created $sku (details failed: $(echo "$updated" | jq -r '.errors[0].message'))"
  else
    echo "    created $sku"
  fi
}

echo "==> Creating products"
create_simple_product "demo-tee-$RUN_ID"      "Classic Cotton Tee"   19.99 120 "https://cdn.pixabay.com/photo/2017/05/23/10/53/t-shirt-design-2336850_960_720.jpg"
create_simple_product "demo-phone-$RUN_ID"    "Smart Phone Case"     12.50  80 "https://cdn.pixabay.com/photo/2014/08/05/10/27/iphone-410311_960_720.jpg"
create_simple_product "demo-backpack-$RUN_ID" "Everyday Backpack"    59.00  40 "https://cdn.pixabay.com/photo/2017/08/06/12/06/people-2591874_960_720.jpg"
create_simple_product "demo-jacket-$RUN_ID"   "City Fashion Jacket"  89.90  25 "https://cdn.pixabay.com/photo/2016/03/27/22/16/fashion-1284496_960_720.jpg"
create_simple_product "demo-sneaker-$RUN_ID"  "Runner Sneakers"      74.00  60 "https://cdn.pixabay.com/photo/2016/11/19/18/06/feet-1840619_960_720.jpg"
create_simple_product "demo-lamp-$RUN_ID"     "Desk Lamp"            34.25  45 "https://cdn.pixabay.com/photo/2016/11/18/17/20/lamp-1835337_960_720.jpg"

echo "==> Result"
gql 'query { sellerProducts(page:1){ paginationInfo { totalCount } } }' '{}' \
  | jq -r '"    products now: " + (.data.sellerProducts.paginationInfo.totalCount|tostring)'
