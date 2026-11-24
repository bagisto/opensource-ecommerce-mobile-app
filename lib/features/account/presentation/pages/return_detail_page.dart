import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/account_models.dart';
import '../../data/models/returns_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/return_detail_bloc.dart';
import 'order_detail_page.dart';
import 'returns_page.dart';

/// Return Detail Page — single RMA request
///
/// Displays:
///   - AppBar: "RMA ID #{id}"
///   - Section: "RMA Details" (Request On, Order ID link, Additional Information, RMA Status pill)
///   - Section: "Item Requested for RMA" (Product Name, SKU, RMA Qty, Resolution Type, Reason)
///   - Section: Attached images (if present)
///   - Section: "Conversations *" with store messages, timestamps, attachment previews
///   - Composer: "Enter your message here", "+ Add Attachments", "Send Message"
///   - Bottom bar: Cancel Request / Mark as Solved / Reopen (per API flags)
class ReturnDetailPage extends StatelessWidget {
  final int returnId;
  final AccountRepository? repository;

  const ReturnDetailPage({super.key, required this.returnId, this.repository});

  /// Navigate to this page from any context.
  static Future<void> navigate(
    BuildContext context, {
    required int returnId,
    required AccountRepository repository,
  }) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => ReturnDetailBloc(repository: repository)
            ..add(LoadReturnDetail(returnId))
            ..add(LoadReturnMessages(returnId)),
          child: ReturnDetailPage(returnId: returnId, repository: repository),
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
          'RMA ID #$returnId',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
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

          return _ReturnDetailBody(
            returnId: returnId,
            detail: detail,
            repository: repository,
          );
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
                style: const TextStyle(
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
  final AccountRepository? repository;

  const _ReturnDetailBody({
    required this.returnId,
    required this.detail,
    this.repository,
  });

  @override
  State<_ReturnDetailBody> createState() => _ReturnDetailBodyState();
}

class _ReturnDetailBodyState extends State<_ReturnDetailBody> {
  final TextEditingController _messageController = TextEditingController();
  String? _attachment;
  String? _attachmentName;
  String? _messageError;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (bytes.lengthInBytes > 10 * 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File is too large (max 10MB)')),
        );
        return;
      }

      final name = picked.name;
      final lower = name.toLowerCase();
      final mime = lower.endsWith('.png')
          ? 'image/png'
          : lower.endsWith('.webp')
          ? 'image/webp'
          : lower.endsWith('.gif')
          ? 'image/gif'
          : 'image/jpeg';

      setState(() {
        _attachment = 'data:$mime;base64,${base64Encode(bytes)}';
        _attachmentName = name;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not attach image: $error')));
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo Gallery'),
              onTap: () {
                Navigator.pop(modalContext);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(modalContext);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detail = widget.detail;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('RMA Details', isDark),
                const SizedBox(height: 8),
                _buildRmaDetailsCard(isDark, detail),
                const SizedBox(height: 16),
                _buildSectionTitle('Item Requested for RMA', isDark),
                const SizedBox(height: 8),
                _buildItemCard(isDark, detail),
                if (detail.images.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildImagesRow(detail),
                ],
                const SizedBox(height: 20),
                _buildMessagesSection(isDark),
                const SizedBox(height: 16),
                _buildMessageComposer(isDark),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        _buildBottomBar(isDark, detail),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
      ),
    );
  }

  // ─── RMA Details Card ───

  Widget _buildRmaDetailsCard(bool isDark, CustomerReturn detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRmaDetailRow(
            label: 'Request On :',
            isDark: isDark,
            child: Text(
              detail.formattedDateTime.isNotEmpty
                  ? detail.formattedDateTime
                  : detail.formattedDate,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildRmaDetailRow(
            label: 'Order ID :',
            isDark: isDark,
            child: GestureDetector(
              onTap: () {
                if (detail.orderId != null && widget.repository != null) {
                  OrderDetailPage.navigate(
                    context,
                    orderId: detail.orderId!,
                    orderNumber: detail.orderNumber,
                    repository: widget.repository!,
                  );
                }
              },
              child: Text(
                detail.orderNumber,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary500,
                ),
              ),
            ),
          ),
          if (detail.information != null &&
              detail.information!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildRmaDetailRow(
              label: 'Additional Information :',
              isDark: isDark,
              child: Text(
                detail.information!.trim(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark
                      ? AppColors.neutral200
                      : const Color(0xFF171717),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          _buildRmaDetailRow(
            label: 'RMA Status :',
            isDark: isDark,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ReturnStatusChip(
                statusTitle: detail.statusTitle,
                statusColor: detail.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRmaDetailRow({
    required String label,
    required Widget child,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 155,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }

  // ─── Item card ───

  Widget _buildItemCard(bool isDark, CustomerReturn detail) {
    final l10n = AppLocalizations.of(context)!;
    final item = detail.item;
    final orderDetail = context.watch<ReturnDetailBloc>().state.orderDetail;

    OrderItem? orderItem;
    if (orderDetail != null && item != null) {
      for (final oi in orderDetail.items) {
        if (oi.numericId == item.orderItemId ||
            (oi.sku != null && oi.sku == item.sku)) {
          orderItem = oi;
          break;
        }
      }
    }

    final currencySymbol = orderDetail?.currencySymbol ?? '\$';
    final priceStr = orderItem != null
        ? '$currencySymbol${orderItem.price.toStringAsFixed(2)}'
        : null;

    final rmaQtyStr = orderItem != null && orderItem.qtyOrdered > 0
        ? '${item?.quantity ?? 1} / ${orderItem.qtyOrdered}'
        : '${item?.quantity ?? 1}';

    final imageUrl = orderItem?.productImageUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.neutral700
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? AppColors.neutral600
                        : const Color(0xFFE5E5E5),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                        errorBuilder: (_, _, _) => _buildNoImageBox(isDark),
                      )
                    : _buildNoImageBox(isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.name ?? '',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDark ? AppColors.neutral700 : const Color(0xFFEEEEEE),
          ),
          const SizedBox(height: 12),
          if (item?.sku != null && item!.sku!.isNotEmpty) ...[
            _buildItemLine(isDark: isDark, label: 'SKU', value: item.sku!),
            const SizedBox(height: 8),
          ],
          if (priceStr != null) ...[
            _buildItemLine(isDark: isDark, label: 'Price', value: priceStr),
            const SizedBox(height: 8),
          ],
          _buildItemLine(isDark: isDark, label: 'RMA Qty', value: rmaQtyStr),
          const SizedBox(height: 8),
          _buildItemLine(
            isDark: isDark,
            label: 'Resolution Type',
            value: item != null
                ? (item.isCancelResolution
                      ? 'Cancel Items'
                      : l10n.accountReturnResolutionReturn)
                : 'N/A',
          ),
          if (item?.reason != null && item!.reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildItemLine(
              isDark: isDark,
              label: 'Reason',
              value: item.reason!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoImageBox(bool isDark) {
    return Image.asset(
      AppAssets.mediumProductPlaceholder,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
    );
  }

  Widget _buildItemLine({
    required bool isDark,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isDark ? AppColors.neutral400 : const Color(0xFF525252),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
            ),
          ),
        ),
      ],
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

  // ─── Messages Section ───

  Widget _buildMessagesSection(bool isDark) {
    return BlocBuilder<ReturnDetailBloc, ReturnDetailState>(
      buildWhen: (prev, curr) =>
          prev.messages != curr.messages ||
          prev.messagesLoading != curr.messagesLoading ||
          prev.customerName != curr.customerName,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversations *',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? AppColors.neutral200 : const Color(0xFF171717),
              ),
            ),
            const SizedBox(height: 12),
            if (state.messagesLoading && state.messages.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (state.messages.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.neutral800
                      : const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? AppColors.neutral700
                        : const Color(0xFFEEEEEE),
                  ),
                ),
                child: Text(
                  'No messages yet. Send a message below to start the conversation.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.neutral500,
                  ),
                ),
              )
            else
              ...state.messages.map(
                (message) => _MessageBubble(
                  message: message,
                  customerName: state.customerName,
                ),
              ),
          ],
        );
      },
    );
  }

  // ─── Message Composer ───

  Widget _buildMessageComposer(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _messageController,
            minLines: 2,
            maxLines: 4,
            onChanged: (val) {
              if (_messageError != null && val.trim().isNotEmpty) {
                setState(() {
                  _messageError = null;
                });
              }
            },
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your message here',
              hintStyle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
              isDense: true,
              filled: true,
              fillColor: isDark ? AppColors.neutral900 : AppColors.white,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _messageError != null
                      ? const Color(0xFFEF4444)
                      : (isDark
                            ? AppColors.neutral700
                            : const Color(0xFFD4D4D4)),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _messageError != null
                      ? const Color(0xFFEF4444)
                      : (isDark
                            ? AppColors.neutral700
                            : const Color(0xFFD4D4D4)),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _messageError != null
                      ? const Color(0xFFEF4444)
                      : AppColors.primary500,
                ),
              ),
            ),
          ),
          if (_messageError != null) ...[
            const SizedBox(height: 6),
            Text(
              _messageError!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _showAttachmentOptions,
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'Add Attachments',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark
                    ? AppColors.neutral200
                    : const Color(0xFF0F172A),
                side: BorderSide(
                  color: isDark
                      ? AppColors.neutral500
                      : const Color(0xFF0F172A),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ),
          if (_attachmentName != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? AppColors.neutral700
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _attachmentName!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral200
                            : const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    key: const Key('removeRmaAttachmentButton'),
                    onTap: () {
                      setState(() {
                        _attachment = null;
                        _attachmentName = null;
                      });
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<ReturnDetailBloc, ReturnDetailState>(
              buildWhen: (prev, curr) =>
                  prev.sendingMessage != curr.sendingMessage,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.sendingMessage ? null : _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                  ),
                  child: state.sendingMessage
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Send Message',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _messageError = 'The message field is required';
      });
      return;
    }
    context.read<ReturnDetailBloc>().add(
      SendReturnMessage(
        returnId: widget.returnId,
        message: text,
        attachment: _attachment,
        attachmentName: _attachmentName,
      ),
    );
    _messageController.clear();
    setState(() {
      _attachment = null;
      _attachmentName = null;
      _messageError = null;
    });
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
          onPressed: () => context.read<ReturnDetailBloc>().add(
            ReopenReturn(widget.returnId),
          ),
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
// Message Bubble — Admin left (neutral), Customer right (soft blue tint)
// Includes support for attachments and image zoom preview.
// ──────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ReturnMessage message;
  final String? customerName;

  const _MessageBubble({required this.message, this.customerName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCustomer = !message.isAdmin;

    final senderTitle = message.isAdmin
        ? 'Admin'
        : (customerName != null && customerName!.isNotEmpty
              ? customerName!
              : 'You');

    final dateStr = message.formattedDateTime.isNotEmpty
        ? message.formattedDateTime
        : message.formattedDate;

    // Matching Web styling:
    // Admin: neutral background on left
    // Customer: soft light blue tint on right
    final bubbleColor = isCustomer
        ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F6FF))
        : (isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5));

    final borderColor = isCustomer
        ? (isDark ? const Color(0xFF334155) : const Color(0xFFD6E4FF))
        : (isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5));

    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sender name + timestamp
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  senderTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isDark
                        ? AppColors.neutral200
                        : const Color(0xFF171717),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '· $dateStr',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.35,
                color: isDark ? AppColors.neutral200 : const Color(0xFF262626),
              ),
            ),
            if (message.hasAttachment) ...[
              const SizedBox(height: 8),
              _buildAttachment(context, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachment(BuildContext context, bool isDark) {
    final url = message.attachmentUrl;
    final filename = message.attachment ?? 'attachment';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isImageAttachment && url != null && url.isNotEmpty) ...[
            GestureDetector(
              onTap: () => _openFullscreenImage(context, url, filename),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  width: double.infinity,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 18,
                            color: AppColors.neutral400,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Image preview unavailable',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          InkWell(
            onTap: () {
              if (url != null && url.isNotEmpty) {
                _openFullscreenImage(context, url, filename);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  size: 16,
                  color: AppColors.primary500,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    filename,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.primary500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreenImage(BuildContext context, String url, String filename) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: Colors.white70,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image could not be loaded',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Text(
                  filename,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
