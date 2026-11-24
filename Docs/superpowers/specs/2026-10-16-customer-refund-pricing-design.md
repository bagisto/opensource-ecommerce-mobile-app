# Customer Refund Pricing Design

## Goal

Make the Refunds tab pricing card show the same rows as the web customer order page.

## Design

Show Subtotal, Shipping & Handling, Adjustment Refund, Adjustment Fee, and Grand Total, in that order. Hide Tax, Discount, Total Paid, Total Refunded, and Total Due from this card. Keep refunded item cards and other order tabs unchanged.

The current customer order query does not request or expose adjustment amounts. For now, adjustment rows use the existing order amount formatter's zero fallback, matching the supplied order screenshot. No API query or mapping changes are included.
