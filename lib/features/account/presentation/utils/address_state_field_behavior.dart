String resolveStateFieldText({
  required String savedStateText,
  String? matchedStateName,
}) {
  if (matchedStateName != null && matchedStateName.trim().isNotEmpty) {
    return matchedStateName;
  }

  return savedStateText;
}

bool shouldUseStateDropdown({required List<String> availableStateNames}) {
  return availableStateNames.isNotEmpty;
}
