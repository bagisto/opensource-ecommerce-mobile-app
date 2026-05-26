import 'package:bagisto_flutter/features/account/presentation/utils/address_state_field_behavior.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'resolveStateFieldText preserves saved state text when country has no states',
    () {
      final value = resolveStateFieldText(
        savedStateText: 'ghjgjgh',
        matchedStateName: null,
      );

      expect(value, 'ghjgjgh');
    },
  );

  test('shouldUseStateDropdown is false when country has no states', () {
    final useDropdown = shouldUseStateDropdown(availableStateNames: const []);

    expect(useDropdown, isFalse);
  });
}
