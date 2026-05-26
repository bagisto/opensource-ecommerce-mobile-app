Future<void> refreshAddressBookAfterForm({
  required Future<bool?> Function() openForm,
  required void Function() onSaved,
}) async {
  final didSave = await openForm();
  if (didSave == true) {
    onSaved();
  }
}
