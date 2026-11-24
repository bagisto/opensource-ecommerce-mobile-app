# Customer RMA Image Upload Plan

## Goal

Attach evidence images to customer RMA creation using `createCustomerReturn.images`.

## Tasks

- [x] Add image selection, camera capture, preview, removal, and 5 MB per-image validation to the Create Return form.
- [x] Encode selected images as data URIs and pass the list through SubmitReturn and AccountRepository.
- [x] Add localized labels/messages.
- [x] Run Dart analysis.
- [ ] Refresh Graphify (attempted; blocked by repository graph visualization size limit).
