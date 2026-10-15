import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/store_config/store_config.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// What a "write a review" entry point does for the current shopper.
enum ReviewEntry {
  /// Open the review form.
  write,

  /// Guest reviews are off but customers may review: ask to sign in.
  login,

  /// Nobody in the shopper's role may review: hide the entry point.
  hidden,
}

/// Applies the admin review settings (`customerReviewEnabled`,
/// `guestReviewEnabled`) to a shopper.
ReviewEntry reviewEntryFor(StoreConfig config, {required bool isLoggedIn}) {
  if (isLoggedIn) {
    return config.allowCustomerReview ? ReviewEntry.write : ReviewEntry.hidden;
  }
  if (config.allowGuestReview) return ReviewEntry.write;
  return config.allowCustomerReview ? ReviewEntry.login : ReviewEntry.hidden;
}

/// [reviewEntryFor] for the shopper above [context]; rebuilds on changes.
ReviewEntry reviewEntryOf(BuildContext context) {
  final isLoggedIn = context.watch<AuthBloc>().state is AuthAuthenticated;
  return reviewEntryFor(StoreConfig.of(context), isLoggedIn: isLoggedIn);
}

/// Sends the shopper to sign in when [entry] asks for it.
/// Returns true when the caller should stop (login was opened).
bool openLoginForReview(BuildContext context, ReviewEntry entry) {
  if (entry != ReviewEntry.login) return false;
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
  return true;
}
