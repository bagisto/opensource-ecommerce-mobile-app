# Customer RMA Image Upload Design

## Goal

Let customers attach evidence images while creating an RMA.

## Design

Add gallery multi-select and camera capture to the existing Create Return form. Show selected image previews and allow removal. Validate each file against the API's documented 5 MB limit. Videos are not offered because the server does not support them.

At submit time, encode selected images as `data:{mime};base64,...` URIs and pass them as the `images` list in the existing `createCustomerReturn` GraphQL input. Preserve the existing query, repository, BLoC, and auth/client boundaries. The server's allowed extensions remain authoritative; the app does not invent a fixed extension allowlist.

## Errors and Verification

Oversized or unreadable images show a form message and are not submitted. API validation errors continue through the existing repository and BLoC error handling. Run Dart analysis for touched files and existing targeted RMA tests if present; do not call the live API.
