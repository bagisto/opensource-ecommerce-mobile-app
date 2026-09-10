import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/returns_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/return_detail_bloc.dart';
import 'returns_page.dart';

/// Return Detail Page — single RMA request
///
/// Displays:
///   - AppBar: "Return #{id}"
///   - Status chip + requested date (+ expired hint)
///   - Item card: name, SKU, qty, resolution, reason
///   - Information card: package condition + customer note
///   - Attached images (horizontal thumbnails)
///   - Conversation thread with the store + message composer
///   - Bottom bar: Cancel / Mark as Solved / Reopen (per API flags)
///
/// Architecture:
///   BlocProvider ReturnDetailBloc -> ReturnDetailPage -> Repository -> GraphQL
class ReturnDetailPage extends StatelessWidget {
  final int returnId;

  const ReturnDetailPage({super.key, required this.returnId});

  /// Navigate to this page from any context.
  static Future<void> navigate(
    BuildContext context, {
    required int returnId,
    required AccountRepository repository,
  }) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) =>
              ReturnDetailBloc(repository: repository)
                ..add(LoadReturnDetail(returnId))
                ..add(LoadReturnMessages(returnId)),
          child: ReturnDetailPage(returnId: returnId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const AppBackButton(),
        leadingWidth: 60,
        titleSpacing: 0,
        title: Text(
          l10n.accountReturnWithNumber('#$returnId'),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocConsumer<ReturnDetailBloc, ReturnDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != ReturnDetailStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            context.read<ReturnDetailBloc>().add(
              const ClearReturnDetailMessage(),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.accountReturnStatusUpdated(state.successMessage!),
                  ),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            context.read<ReturnDetailBloc>().add(
              const ClearReturnDetailMessage(),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ReturnDetailStatus.loading &&
              state.returnDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ReturnDetailStatus.error &&
              state.returnDetail == null) {
            return _buildErrorState(context, state.errorMessage);
          }

          final detail = state.returnDetail;
          if (detail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return _ReturnDetailBody(returnId: returnId, detail: detail);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? l10n.categorySomethingWentWrong,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<ReturnDetailBloc>()
                ..add(LoadReturnDetail(returnId))
                ..add(LoadReturnMessages(returnId)),
              child: Text(
                l10n.commonRetry,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Body — scrollable detail + composer + action bar
// ──────────────────────────────────────────────

class _ReturnDetailBody extends StatefulWidget {
  final int returnId;
  final CustomerReturn detail;

  const _ReturnDetailBody({required this.returnId, required this.detail});

  @override
  State<_ReturnDetailBody> createState() => _ReturnDetailBodyState();
}

class _ReturnDetailBodyState extends State<_ReturnDetailBody> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detail = widget.detail;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusRow(isDark, detail),
                const SizedBox(height: 12),
                _buildItemCard(isDark, detail),
                if (_hasInformation(detail)) ...[
                  const SizedBox(height: 12),
                  _buildInformationCard(isDark, detail),
                ],
                if (detail.images.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildImagesRow(detail),
                ],
                const SizedBox(height: 16),
                _buildMessagesSection(isDark),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        _buildMessageComposer(isDark),
        _buildBottomBar(isDark, detail),
      ],
    );
  }

  bool _hasInformation(CustomerReturn detail) {
    return (detail.packageCondition != null &&
            detail.packageCondition!.isNotEmpty) ||
        (detail.information != null && detail.information!.isNotEmpty);
  }

  // ─── Status row ───

  Widget _buildStatusRow(bool isDark, CustomerReturn detail) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        ReturnStatusChip(
          statusTitle: detail.statusTitle,
          statusColor: detail.statusColor,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            detail.isExpired
                ? '${detail.formattedDate} · ${l10n.accountReturnExpired}'
                : detail.formattedDate,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Item card ───

  Widget _buildItemCard(bool isDark, CustomerReturn detail) {
    final l10n = AppLocalizations.of(context)!;
    final item = detail.item;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.name ?? '',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
            ),
          ),
          if (item?.sku != null && item!.sku!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.sku!,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
          ],
          const SizedBox(height: 8),
          _buildDetailLine(
            isDark,
            l10n.accountReturnOrderLabel(detail.orderNumber),
          ),
          if (item != null) ...[
            const SizedBox(height: 4),
            _buildDetailLine(isDark, l10n.accountReturnQtyValue(item.quantity)),
            const SizedBox(height: 4),
            _buildDetailLine(
              isDark,
              '${l10n.accountReturnResolution}: ${item.isCancelResolution ? l10n.accountReturnResolutionCancel : l10n.accountReturnResolutionReturn}',
            ),
            if (item.reason != null && item.reason!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildDetailLine(
                isDark,
                '${l10n.accountReturnReason}: ${item.reason}',
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDetailLine(bool isDark, String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
      ),
    );
  }

  // ─── Information card ───

  Widget _buildInformationCard(bool isDark, CustomerReturn detail) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.accountReturnInformation,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
            ),
          ),
          if (detail.packageCondition != null &&
              detail.packageCondition!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildDetailLine(
              isDark,
              '${l10n.accountReturnPackageCondition}: ${detail.packageCondition}',
            ),
          ],
          if (detail.information != null &&
              detail.information!.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildDetailLine(isDark, detail.information!),
          ],
        ],
      ),
    );
  }

  // ─── Images ───

  Widget _buildImagesRow(CustomerReturn detail) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detail.images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final image = detail.images[index];
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 72,
              height: 72,
              color: isDark ? AppColors.neutral800 : AppColors.neutral100,
              child: image.url != null
                  ? Image.network(
                      image.url!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.neutral400,
                      ),
                    )
                  : Icon(Icons.image_outlined, color: AppColors.neutral400),
            ),
          );
        },
      ),
    );
  }

  // ─── Messages ───

  Widget _buildMessagesSection(bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ReturnDetailBloc, ReturnDetailState>(
      buildWhen: (prev, curr) =>
          prev.messages != curr.messages ||
          prev.messagesLoading != curr.messagesLoading,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.accountReturnMessages,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 8),
            if (state.messagesLoading && state.messages.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (state.messages.isEmpty)
              Text(
                l10n.accountReturnNoMessages,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.neutral500,
                ),
              )
            else
              ...state.messages.map(
                (message) => _MessageBubble(message: message),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMessageComposer(bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
              decoration: InputDecoration(
                hintText: l10n.accountReturnMessageHint,
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.neutral500,
                ),
                isDense: true,
                filled: true,
                fillColor: isDark ? AppColors.neutral900 : AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary500),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<ReturnDetailBloc, ReturnDetailState>(
            buildWhen: (prev, curr) =>
                prev.sendingMessage != curr.sendingMessage,
            builder: (context, state) {
              return SizedBox(
                width: 40,
                height: 40,
                child: state.sendingMessage
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: _sendMessage,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.primary500,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ReturnDetailBloc>().add(
      SendReturnMessage(returnId: widget.returnId, message: text),
    );
    _messageController.clear();
  }

  // ─── Bottom Bar — Cancel / Mark as Solved / Reopen ───

  Widget _buildBottomBar(bool isDark, CustomerReturn detail) {
    final l10n = AppLocalizations.of(context)!;
    final action = context.select<ReturnDetailBloc, ReturnAction>(
      (bloc) => bloc.state.action,
    );
    final busy = action != ReturnAction.none;

    final buttons = <Widget>[];

    if (detail.canCancel) {
      buttons.add(
        _actionButton(
          label: l10n.accountReturnCancelAction,
          outlined: true,
          busy: action == ReturnAction.canceling,
          enabled: !busy,
          onPressed: () => _confirmAction(
            message: l10n.accountReturnCancelConfirmation,
            event: CancelReturn(widget.returnId),
          ),
        ),
      );
    }
    if (detail.canReopen) {
      buttons.add(
        _actionButton(
          label: l10n.accountReturnReopenAction,
          outlined: false,
          busy: action == ReturnAction.reopening,
          enabled: !busy,
          onPressed: () =>
              context.read<ReturnDetailBloc>().add(ReopenReturn(widget.returnId)),
        ),
      );
    }
    if (detail.canClose) {
      buttons.add(
        _actionButton(
          label: l10n.accountReturnCloseAction,
          outlined: false,
          busy: action == ReturnAction.closing,
          enabled: !busy,
          onPressed: () => _confirmAction(
            message: l10n.accountReturnCloseConfirmation,
            event: CloseReturn(widget.returnId),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral50,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: buttons[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required bool outlined,
    required bool busy,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final child = busy
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          );

    if (outlined) {
      return SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary500,
            side: const BorderSide(color: AppColors.primary500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(54),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(54),
          ),
        ),
        child: child,
      ),
    );
  }

  void _confirmAction({
    required String message,
    required ReturnDetailEvent event,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<ReturnDetailBloc>();

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cartCancel,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral300 : AppColors.neutral600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                bloc.add(event);
              },
              child: Text(
                l10n.accountOk,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ──────────────────────────────────────────────
// Message Bubble — customer right/primary, admin left/neutral
// ──────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ReturnMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCustomer = !message.isAdmin;

    final bubbleColor = isCustomer
        ? AppColors.primary500.withValues(alpha: isDark ? 0.25 : 0.10)
        : (isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5));
    final borderColor = isCustomer
        ? AppColors.primary500.withValues(alpha: isDark ? 0.45 : 0.25)
        : (isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5));

    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Radius.circular(isCustomer ? 10 : 2),
            bottomRight: Radius.circular(isCustomer ? 2 : 10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.message,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.formattedDate,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
