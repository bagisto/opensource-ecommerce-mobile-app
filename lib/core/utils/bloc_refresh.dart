import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Dispatches a reload through [dispatch] and completes once [bloc] emits a
/// state for which [isDone] is true, so a `RefreshIndicator` spinner stays
/// visible until fresh data (or an error) arrives.
///
/// Gives up after [timeout] so the spinner can never hang.
Future<void> refreshBloc<S>(
  BlocBase<S> bloc,
  void Function() dispatch,
  bool Function(S state) isDone, {
  Duration timeout = const Duration(seconds: 20),
}) {
  // Subscribe before dispatching so the finishing emission is not missed.
  final done = bloc.stream
      .firstWhere(isDone)
      .timeout(timeout, onTimeout: () => bloc.state);
  dispatch();
  return done.then((_) {});
}
