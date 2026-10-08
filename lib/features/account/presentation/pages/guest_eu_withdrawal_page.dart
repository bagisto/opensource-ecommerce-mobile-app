import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/guest_eu_withdrawal_cubit.dart';

/// Guest EU contract withdrawal: order number, order email and an optional
/// reason (`createGuestEuWithdrawal`).
class GuestEuWithdrawalPage extends StatefulWidget {
  const GuestEuWithdrawalPage({super.key});

  static Future<void> navigate(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => GuestEuWithdrawalCubit(
            repository: AccountRepository(
              client: GraphQLClientProvider.buildClient(),
            ),
          ),
          child: const GuestEuWithdrawalPage(),
        ),
      ),
    );
  }

  @override
  State<GuestEuWithdrawalPage> createState() => _GuestEuWithdrawalPageState();
}

class _GuestEuWithdrawalPageState extends State<GuestEuWithdrawalPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _orderController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<GuestEuWithdrawalCubit>().submit(
      orderIncrementId: _orderController.text.trim(),
      email: _emailController.text.trim(),
      reasonText: _reasonController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    String? required(String? value) => (value?.trim().isEmpty ?? true)
        ? l10n.accountEuWithdrawFieldRequired
        : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: AppBackButton(),
        leadingWidth: 60,
        titleSpacing: 0,
        title: Text(
          l10n.accountEuWithdraw,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<GuestEuWithdrawalCubit, GuestEuWithdrawalState>(
        builder: (context, state) {
          if (state.withdrawal != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.accountEuWithdrawSubmitted,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.accountEuWithdrawGuestDescription,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral300
                          : AppColors.neutral700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _orderController,
                    decoration: InputDecoration(
                      labelText: l10n.accountEuWithdrawOrderNumber,
                    ),
                    validator: required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.accountEuWithdrawEmail,
                    ),
                    validator: required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reasonController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: l10n.accountEuWithdrawReason,
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: const ValueKey('guest_eu_withdraw_submit'),
                      onPressed: state.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(54),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(l10n.accountEuWithdrawSubmit),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
