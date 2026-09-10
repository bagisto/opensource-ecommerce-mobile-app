import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/returns_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/returns_bloc.dart';
import 'create_return_page.dart';
import 'return_detail_page.dart';

/// Returns Page — customer RMA request list
///
/// Displays a paginated list of the customer's return requests:
///   - AppBar: back arrow + "Returns" title
///   - Count header: "N Returns"
///   - Return cards with return #, status chip, date, order #, item name
///
/// Architecture:
///   `BlocProvider<ReturnsBloc> -> ReturnsPage -> Repository -> GraphQL`
class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});

  Future<void> _createReturn(BuildContext context) async {
    final created = await CreateReturnPage.navigate(
      context,
      repository: context.read<AccountRepository>(),
    );
    if (created == true && context.mounted) {
      context.read<ReturnsBloc>().add(const LoadReturns());
    }
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
        titleSpacing: 0,
        title: Text(
          l10n.accountReturns,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
        actions: [
          // Create Request — matches the web RMA list "Create" button
          Builder(
            builder: (innerContext) => IconButton(
              tooltip: l10n.accountReturnRequest,
              onPressed: () => _createReturn(innerContext),
              icon: const Icon(Icons.add, color: AppColors.primary500),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ReturnsBloc, ReturnsState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != ReturnsStatus.error) {
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
            context.read<ReturnsBloc>().add(const ClearReturnsMessage());
          }
        },
        builder: (context, state) {
          if (state.status == ReturnsStatus.loading && state.returns.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ReturnsStatus.error && state.returns.isEmpty) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.returns.isEmpty) {
            return _buildEmptyState(context);
          }

          return _ReturnList(
            returns: state.returns,
            totalCount: state.totalCount,
            hasNextPage: state.hasNextPage,
            isLoadingMore: state.isLoadingMore,
            cancelingReturnIds: state.cancelingReturnIds,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_return_outlined,
              size: 64,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.accountNoReturnsYet,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountReturnsEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 20),
            Builder(
              builder: (innerContext) => SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _createReturn(innerContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(54),
                    ),
                  ),
                  child: Text(
                    l10n.accountReturnRequest,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
              onPressed: () =>
                  context.read<ReturnsBloc>().add(const LoadReturns()),
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
// Return List — scrollable list with count header
// ──────────────────────────────────────────────

class _ReturnList extends StatefulWidget {
  final List<CustomerReturn> returns;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final Set<int> cancelingReturnIds;

  const _ReturnList({
    required this.returns,
    required this.totalCount,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.cancelingReturnIds,
  });

  @override
  State<_ReturnList> createState() => _ReturnListState();
}

class _ReturnListState extends State<_ReturnList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasNextPage || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<ReturnsBloc>().add(const LoadMoreReturns());
    }
  }

  Future<void> _openReturn(CustomerReturn customerReturn) async {
    final returnId = customerReturn.id;
    if (returnId == null || widget.cancelingReturnIds.contains(returnId)) return;
    await ReturnDetailPage.navigate(
      context,
      returnId: returnId,
      repository: context.read<AccountRepository>(),
    );
    if (mounted) context.read<ReturnsBloc>().add(const LoadReturns());
  }

  Future<void> _confirmCancel(CustomerReturn customerReturn) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.accountReturnCancelConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cartCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountOk),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted && customerReturn.id != null) {
      context.read<ReturnsBloc>().add(CancelListedReturn(customerReturn.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // +1 for header, +1 for loading indicator if loading more
      itemCount: widget.returns.length + 1 + (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // First item: count header row
        if (index == 0) {
          return _CountHeader(totalCount: widget.totalCount);
        }

        // Loading more indicator at the bottom
        if (index == widget.returns.length + 1) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final customerReturn = widget.returns[index - 1];
        final canceling = widget.cancelingReturnIds.contains(customerReturn.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: GestureDetector(
            onTap: canceling ? null : () => _openReturn(customerReturn),
            child: _ReturnCard(
              customerReturn: customerReturn,
              canceling: canceling,
              onView: customerReturn.id == null || canceling
                  ? null
                  : () => _openReturn(customerReturn),
              onCancel: canceling ? null : () => _confirmCancel(customerReturn),
            ),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────
// Count Header: "N Returns"
// ──────────────────────────────────────────────

class _CountHeader extends StatelessWidget {
  final int totalCount;
  const _CountHeader({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$totalCount ${totalCount == 1 ? l10n.accountReturnSingular : l10n.accountReturnPlural}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
          Icon(
            Icons.swap_vert_rounded,
            size: 20,
            color: isDark ? AppColors.neutral400 : AppColors.neutral700,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Return Card — same card style as order cards:
// bg #F5F5F5 (light) / neutral800 (dark), 1px border, rounded-10, p-12
// ──────────────────────────────────────────────

class _ReturnCard extends StatelessWidget {
  final CustomerReturn customerReturn;
  final bool canceling;
  final VoidCallback? onView;
  final VoidCallback? onCancel;
  const _ReturnCard({
    required this.customerReturn,
    required this.canceling,
    required this.onView,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Return number — Roboto Medium 14
          Text(
            customerReturn.returnNumber,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
            ),
          ),

          const SizedBox(height: 5),

          // Status chip + date row
          Row(
            children: [
              ReturnStatusChip(
                statusTitle: customerReturn.statusTitle,
                statusColor: customerReturn.statusColor,
              ),
              const SizedBox(width: 6),
              Text(
                customerReturn.formattedDate,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Order # + item name — Roboto Regular 14, #525252
          Text(
            customerReturn.item != null && customerReturn.item!.name.isNotEmpty
                ? '${l10n.accountReturnOrderLabel(customerReturn.orderNumber)} · ${customerReturn.item!.name}'
                : l10n.accountReturnOrderLabel(customerReturn.orderNumber),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              TextButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(l10n.accountReturnViewAction),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary500,
                ),
              ),
              if (customerReturn.canCancel || canceling)
                TextButton.icon(
                  onPressed: onCancel,
                  icon: canceling
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cancel_outlined, size: 18),
                  label: Text(l10n.accountReturnCancelAction),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Return Status Chip — shared by list + detail pages.
// Uses the admin-configured statusColor hex when parseable,
// otherwise falls back to the neutral chip palette.
// ──────────────────────────────────────────────

class ReturnStatusChip extends StatelessWidget {
  final String statusTitle;
  final String? statusColor;

  const ReturnStatusChip({
    super.key,
    required this.statusTitle,
    this.statusColor,
  });

  static Color? _parseHexColor(String? hex) {
    if (hex == null) return null;
    var value = hex.trim().replaceFirst('#', '');
    if (value.length == 3) {
      value = value.split('').map((c) => '$c$c').join();
    }
    if (value.length != 6) return null;
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(0xFF000000 | parsed);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _parseHexColor(statusColor);

    final Color bg;
    final Color border;
    final Color text;
    if (accent != null) {
      bg = accent.withValues(alpha: isDark ? 0.16 : 0.12);
      border = accent.withValues(alpha: isDark ? 0.35 : 0.30);
      text = accent;
    } else {
      bg = isDark
          ? AppColors.neutral700.withValues(alpha: 0.4)
          : const Color(0xFFF5F5F5);
      border = isDark
          ? AppColors.neutral600.withValues(alpha: 0.5)
          : const Color(0xFFE5E5E5);
      text = isDark ? AppColors.neutral300 : const Color(0xFF525252);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusTitle,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: text,
        ),
      ),
    );
  }
}
