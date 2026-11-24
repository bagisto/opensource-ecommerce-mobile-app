import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the non-cancelable booking flag is read from the order', () {
    expect(
      OrderDetail.fromJson({
        'status': 'completed',
        'hasNonCancelableBooking': true,
      }).hasNonCancelableBooking,
      isTrue,
    );
    expect(
      OrderDetail.fromJson({
        'status': 'pending',
        'hasNonCancelableBooking': false,
      }).hasNonCancelableBooking,
      isFalse,
    );
  });

  test('an older server that omits the flag shows no notice', () {
    expect(
      OrderDetail.fromJson({'status': 'pending'}).hasNonCancelableBooking,
      isFalse,
    );
  });
}
