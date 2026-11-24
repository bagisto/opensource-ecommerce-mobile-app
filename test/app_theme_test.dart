import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'brand colored controls use white foreground in light and dark themes',
    () {
      expect(AppTheme.lightTheme.colorScheme.onPrimary, AppColors.white);
      expect(AppTheme.lightTheme.colorScheme.onSecondary, AppColors.white);
      expect(AppTheme.darkTheme.colorScheme.onPrimary, AppColors.white);
      expect(AppTheme.darkTheme.colorScheme.onSecondary, AppColors.white);
    },
  );
}
