import 'package:bagisto_flutter/core/utils/bloc_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _Counter extends Cubit<int> {
  _Counter() : super(0);

  Future<void> reload() async {
    emit(-1); // loading
    await Future<void>.delayed(const Duration(milliseconds: 10));
    emit(5); // loaded
  }
}

void main() {
  test('refreshBloc waits for the finishing state', () async {
    final cubit = _Counter();
    addTearDown(cubit.close);

    await refreshBloc<int>(cubit, cubit.reload, (s) => s >= 0);

    expect(cubit.state, 5);
  });

  test('refreshBloc gives up after the timeout', () async {
    final cubit = _Counter();
    addTearDown(cubit.close);

    await refreshBloc<int>(
      cubit,
      () {},
      (s) => s == 99,
      timeout: const Duration(milliseconds: 20),
    );

    expect(cubit.state, 0);
  });
}
