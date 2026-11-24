import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';

/// Screen displaying the formal receipt of an EU Right of Withdrawal declaration.
///
/// Matches the web storefront's "Withdrawal Receipt" page, showing:
/// - Confirmation banner with durable medium notice
/// - Received At timestamp, Reference UUID, Order, Email, Status badge, Reason
/// - "What happens next" timeline (Declaration recorded -> Email sent -> Refund window)
/// - Reference copy and receipt sharing
class EuWithdrawalReceiptPage extends StatelessWidget {
  final EuWithdrawal withdrawal;
  final String? customerEmail;

  const EuWithdrawalReceiptPage({
    super.key,
    required this.withdrawal,
    this.customerEmail,
  });

  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '—';
    try {
      final parsed = DateTime.parse(raw).toUtc();
      return '${DateFormat('d MMM yyyy, HH:mm').format(parsed)} UTC';
    } catch (_) {
      return raw;
    }
  }

  void _copyReference(BuildContext context, String reference) {
    Clipboard.setData(ClipboardData(text: reference));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.accountEuWithdrawReferenceCopied),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }


  Color _statusBg(String status, bool isDark) {
    final s = status.toLowerCase();
    if (s == 'received') {
      return isDark
          ? const Color(0xFFEAB308).withValues(alpha: 0.18)
          : const Color(0xFFFEF9C3);
    }
    if (s == 'confirmed' || s == 'refunded') {
      return isDark
          ? const Color(0xFF22C55E).withValues(alpha: 0.18)
          : const Color(0xFFDCFCE7);
    }
    if (s == 'declined') {
      return isDark
          ? const Color(0xFFEF4444).withValues(alpha: 0.18)
          : const Color(0xFFFEE2E2);
    }
    return isDark ? AppColors.neutral800 : AppColors.neutral100;
  }

  Color _statusTextColor(String status, bool isDark) {
    final s = status.toLowerCase();
    if (s == 'received') {
      return isDark ? const Color(0xFFFDE047) : const Color(0xFF713F12);
    }
    if (s == 'confirmed' || s == 'refunded') {
      return isDark ? const Color(0xFF86EFAC) : const Color(0xFF14532D);
    }
    if (s == 'declined') {
      return isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B);
    }
    return isDark ? AppColors.neutral200 : AppColors.neutral800;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final receivedDateText = _formatDate(
      withdrawal.receivedAt ?? withdrawal.createdAt,
    );
    final referenceUuid = withdrawal.uuid ?? '—';
    final orderNumber =
        '#${withdrawal.orderIncrementId ?? withdrawal.orderId ?? ''}';
    final email =
        (withdrawal.customerEmail ?? customerEmail ?? '').trim().isEmpty
            ? '—'
            : (withdrawal.customerEmail ?? customerEmail)!;
    final reason = (withdrawal.reasonText ?? '').trim().isEmpty
        ? '—'
        : withdrawal.reasonText!;

    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final cardBg = isDark ? AppColors.neutral800 : AppColors.neutral50;
    final isDeclined = withdrawal.status.toLowerCase() == 'declined';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.accountEuWithdrawReceiptTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top notification banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral800 : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDeclined
                          ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                          : const Color(0xFF22C55E).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDeclined ? Icons.close : Icons.check,
                      color: isDeclined
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDeclined
                              ? l10n.accountEuWithdrawDeclinedTitle
                              : l10n.accountEuWithdrawReceivedTitle,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: isDark
                                ? AppColors.neutral100
                                : AppColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isDeclined
                              ? l10n.accountEuWithdrawDeclinedSubtitle
                              : l10n.accountEuWithdrawReceivedSubtitle,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            height: 1.4,
                            color: isDark
                                ? AppColors.neutral300
                                : AppColors.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Information card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: l10n.accountEuWithdrawReceivedAt,
                    valueWidget: Text(
                      receivedDateText,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral100
                            : AppColors.neutral900,
                      ),
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    label: l10n.accountEuWithdrawReference,
                    valueWidget: Row(
                      children: [
                        Expanded(
                          child: Text(
                            referenceUuid,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.neutral100
                                  : AppColors.neutral900,
                            ),
                          ),
                        ),
                        if (withdrawal.uuid != null)
                          InkWell(
                            onTap: () => _copyReference(context, referenceUuid),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.neutral400
                                    : AppColors.neutral600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    label: l10n.accountEuWithdrawOrder,
                    valueWidget: Text(
                      orderNumber,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral100
                            : AppColors.neutral900,
                      ),
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    label: l10n.accountEuWithdrawEmailLabel,
                    valueWidget: Text(
                      email,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral100
                            : AppColors.neutral900,
                      ),
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    label: l10n.accountEuWithdrawStatusLabel,
                    valueWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBg(withdrawal.status, isDark),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          withdrawal.status.isEmpty
                              ? '—'
                              : '${withdrawal.status[0].toUpperCase()}${withdrawal.status.substring(1)}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _statusTextColor(withdrawal.status, isDark),
                          ),
                        ),
                      ),
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    label: l10n.accountEuWithdrawReasonLabel,
                    valueWidget: Text(
                      reason,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral100
                            : AppColors.neutral900,
                      ),
                    ),
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // "What happens next" Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral800 : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountEuWithdrawWhatNext,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark
                          ? AppColors.neutral100
                          : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TimelineStep(
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF16A34A),
                    title: l10n.accountEuWithdrawNextRecorded,
                    subtitle: receivedDateText,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _TimelineStep(
                    icon: Icons.check_circle,
                    iconColor: const Color(0xFF16A34A),
                    title: l10n.accountEuWithdrawNextEmail,
                    subtitle: l10n.accountEuWithdrawNextEmailDesc,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  if (isDeclined) ...[
                    _TimelineStep(
                      icon: Icons.cancel,
                      iconColor: const Color(0xFFDC2626),
                      title: l10n.accountEuWithdrawNextDeclined,
                      subtitle: '',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 28),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF7F1D1D).withValues(alpha: 0.25)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF991B1B).withValues(alpha: 0.4)
                              : const Color(0xFFFECACA),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountEuWithdrawMerchantReasonLabel,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFFDC2626),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (withdrawal.declinedReason ?? '').trim().isEmpty
                                ? '—'
                                : withdrawal.declinedReason!,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.neutral100
                                  : AppColors.neutral900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(
                        l10n.accountEuWithdrawDeclinedLegalNotice,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          height: 1.35,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                        ),
                      ),
                    ),
                  ] else ...[
                    _TimelineStep(
                      icon: withdrawal.status.toLowerCase() == 'refunded'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      iconColor: withdrawal.status.toLowerCase() == 'refunded'
                          ? const Color(0xFF16A34A)
                          : (isDark ? AppColors.neutral500 : AppColors.neutral400),
                      title: l10n.accountEuWithdrawNextRefund,
                      subtitle: l10n.accountEuWithdrawNextRefundDesc,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Footer note
            Center(
              child: Text(
                l10n.accountEuWithdrawReceiptFooter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Back to Orders button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isDark ? AppColors.neutral200 : AppColors.neutral800,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(54),
                  ),
                ),
                child: Text(
                  l10n.accountOrders,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final Widget valueWidget;
  final bool isDark;

  const _InfoRow({
    required this.label,
    required this.valueWidget,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: 0.5,
            color: isDark ? AppColors.neutral400 : AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 4),
        valueWidget,
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;

  const _TimelineStep({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral100 : AppColors.neutral900,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.5,
                    height: 1.3,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
