import 'package:flutter/material.dart';

/// Shared route observer for page-level visibility callbacks.
///
/// Pages can subscribe with [RouteAware] to refresh themselves when another
/// page above them is popped and they become visible again.
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
