import 'package:flutter/material.dart';

import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/services/auth_storage.dart';
import '../../data/repository/newsletter_repository.dart';

/// The storefront footer's "Get Ready for our Fun Newsletter!" box, from
/// web. Shown to every visitor -- signed in or not, mirroring web: guests
/// subscribe an address of their own choosing, and a signed-in shopper's
/// token is attached too, so the subscription links back to their account
/// (see `createNewsletter`'s own notes on that).
class NewsletterSubscribeSection extends StatefulWidget {
  final double horizontalPadding;

  const NewsletterSubscribeSection({super.key, this.horizontalPadding = 20});

  @override
  State<NewsletterSubscribeSection> createState() =>
      _NewsletterSubscribeSectionState();
}

class _NewsletterSubscribeSectionState
    extends State<NewsletterSubscribeSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubscribe() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);

    try {
      // Signed-out shoppers use the plain storefront client; a signed-in
      // shopper's token rides along too, so the subscription links to
      // their account rather than sitting as a bare email address.
      final accessToken = await AuthStorage.getToken();
      final client = (accessToken != null && accessToken.isNotEmpty)
          ? GraphQLClientProvider.buildClient(token: accessToken)
          : GraphQLClientProvider.buildClient();

      final subscribedNow = await NewsletterRepository(
        client: client,
      ).subscribe(_emailController.text.trim());

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.successGreen,
          content: Text(
            subscribedNow
                ? l10n.homeNewsletterSubscribed
                : l10n.homeNewsletterAlreadySubscribed,
          ),
        ),
      );
      _emailController.clear();
    } on NewsletterSubscribeException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(l10n.homeNewsletterGenericError),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.neutral800
              : AppColors.primary500.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeNewsletterHeadline,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 1.25,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeNewsletterSubtitle,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: !_isSubmitting,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSubscribe(),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return l10n.homeNewsletterEmailRequired;
                  }
                  if (!RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(trimmed)) {
                    return l10n.homeNewsletterEmailInvalid;
                  }
                  return null;
                },
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                ),
                decoration: InputDecoration(
                  hintText: l10n.homeNewsletterEmailHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.neutral900 : AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.neutral700
                          : AppColors.neutral200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary500,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                      : Text(
                          l10n.homeNewsletterSubscribeAction,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
