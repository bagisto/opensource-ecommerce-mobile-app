import 'package:bagisto_flutter/core/graphql/account_queries.dart';
import 'package:flutter_test/flutter_test.dart';

/// Field names selected directly under `customerOrder` (not nested ones).
Set<String> _orderFields() {
  final query = AccountQueries.getCustomerOrder;
  final start = query.indexOf('{', query.indexOf('customerOrder('));
  final fields = <String>{};
  var depth = 0;
  for (final token in RegExp(r'[{}]|[A-Za-z_]\w*').allMatches(
    query.substring(start),
  )) {
    final value = token.group(0)!;
    if (value == '{') {
      depth++;
    } else if (value == '}') {
      depth--;
      if (depth == 0) break;
    } else if (depth == 1) {
      fields.add(value);
    }
  }
  return fields;
}

void main() {
  test('customerOrder query requests the order id', () {
    // The order detail page needs the numeric id for EU withdrawal and
    // return eligibility; without it both checks silently skip.
    expect(_orderFields(), containsAll(<String>['id', '_id', 'incrementId']));
  });
}
