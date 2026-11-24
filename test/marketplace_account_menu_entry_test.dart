import 'package:bagisto_flutter/features/account/presentation/pages/account_menu_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the menu exposes a marketplace action', () {
    expect(
      AccountMenuAction.values.map((action) => action.name),
      contains('sellOnMarketplace'),
    );
  });
}
