import 'dart:typed_data';

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
import '../../data/utils/return_image_encoder.dart';
import '../bloc/create_return_bloc.dart';

/// Create Return Page — request a return/cancellation, matching the web
/// `customer/account/rma/create` flow:
///   Step 1: pick an order (order selector)
///   Step 2: pick item, resolution, quantity, reason, package condition,
///           information, agreement → submit (createCustomerReturn)
///
/// Reached from the Returns list page "Create Request" action (there is no
/// RMA entry on the order detail page, matching the web storefront).
class CreateReturnPage extends StatelessWidget {
  const CreateReturnPage({super.key});

  /// Returns true when a request was submitted so the caller can refresh.
  /// Pass [order] to skip the order picker and start with that order.
  static Future<bool?> navigate(
    BuildContext context, {
    required AccountRepository repository,
    CustomerOrder? order,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RepositoryProvider.value(
          value: repository,
          child: BlocProvider(
            create: (_) => CreateReturnBloc(repository: repository)
              ..add(
                order != null
                    ? SelectOrderForReturn(order)
                    : const LoadCreateReturn(),
              ),
            child: const CreateReturnPage(),
          ),
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
        titleSpacing: 0,
        title: Text(
          l10n.accountReturnRequest,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? AppColors.neutral200 : AppColors.black,
          ),
        ),
      ),
      body: BlocConsumer<CreateReturnBloc, CreateReturnState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status != CreateReturnStatus.error) {
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
            context.read<CreateReturnBloc>().add(
              const ClearCreateReturnMessage(),
            );
          }
          if (state.status == CreateReturnStatus.success) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: Text(l10n.accountReturnCreatedTitle),
                content: Text(l10n.accountReturnCreatedMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      l10n.accountOk,
                      style: const TextStyle(color: AppColors.primary500),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CreateReturnStatus.initial ||
              (state.status == CreateReturnStatus.loading &&
                  state.orders.isEmpty &&
                  state.phase == CreateReturnPhase.selectOrder)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CreateReturnStatus.error) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state.phase == CreateReturnPhase.selectOrder) {
            return _OrderPicker(state: state);
          }

          // Loading returnable items after picking an order
          if (state.status == CreateReturnStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return _buildNoItemsState(context);
          }

          return _CreateReturnForm(state: state);
        },
      ),
    );
  }

  Widget _buildNoItemsState(BuildContext context) {
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
              l10n.accountReturnNoReturnableItems,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountReturnNoReturnableItemsDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<CreateReturnBloc>().add(
                const BackToOrderPicker(),
              ),
              child: Text(
                l10n.accountReturnChooseAnotherOrder,
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
                  context.read<CreateReturnBloc>().add(const LoadCreateReturn()),
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
// Step 1 — Order picker
// ──────────────────────────────────────────────

class _OrderPicker extends StatefulWidget {
  final CreateReturnState state;
  const _OrderPicker({required this.state});

  @override
  State<_OrderPicker> createState() => _OrderPickerState();
}

class _OrderPickerState extends State<_OrderPicker> {
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
    if (!widget.state.hasNextPage || widget.state.isLoadingMoreOrders) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CreateReturnBloc>().add(const LoadMoreCreateReturnOrders());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final orders = widget.state.orders;

    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.neutral400,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.accountReturnNoEligibleOrders,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: isDark ? AppColors.neutral200 : AppColors.neutral800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount:
          orders.length + 1 + (widget.state.isLoadingMoreOrders ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              l10n.accountReturnSelectOrder,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          );
        }

        if (index == orders.length + 1) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final order = orders[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _OrderPickCard(order: order),
        );
      },
    );
  }
}

class _OrderPickCard extends StatelessWidget {
  final CustomerOrder order;
  const _OrderPickCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.read<CreateReturnBloc>().add(
        SelectOrderForReturn(order),
      ),
      child: Container(
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.orderNumber,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral200
                          : const Color(0xFF171717),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${order.statusLabel} · ${order.formattedDate}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : const Color(0xFF525252),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.accountOrderTotalItems(
                      order.formattedTotal,
                      order.totalItemCount,
                    ),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.neutral400
                          : const Color(0xFF525252),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Step 2 — Form body
// ──────────────────────────────────────────────

class _CreateReturnForm extends StatefulWidget {
  final CreateReturnState state;

  const _CreateReturnForm({required this.state});

  @override
  State<_CreateReturnForm> createState() => _CreateReturnFormState();
}

class _CreateReturnFormState extends State<_CreateReturnForm> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _images = [];
  final List<Uint8List> _imagePreviews = [];
  bool _preparingImages = false;
  int? _selectedOrderItemId;
  int _quantity = 1;
  int? _selectedReasonId;
  bool _agreed = false;
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();

  @override
  void dispose() {
    _conditionController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  ReturnableItem? get _selectedItem {
    for (final item in widget.state.items) {
      if (item.orderItemId == _selectedOrderItemId) return item;
    }
    return null;
  }

  int get _maxQuantity {
    final item = _selectedItem;
    if (item == null) return 1;
    final max = item.maxQuantityFor(widget.state.resolutionType);
    return max > 0 ? max : 1;
  }

  bool get _canSubmit =>
      _selectedOrderItemId != null &&
      _selectedReasonId != null &&
      _agreed &&
      !_preparingImages &&
      widget.state.status != CreateReturnStatus.submitting;

  void _clampQuantity() {
    if (_quantity > _maxQuantity) _quantity = _maxQuantity;
    if (_quantity < 1) _quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final state = widget.state;

    // Keep the selected reason valid when the reasons list changes
    // (resolution type switched).
    if (_selectedReasonId != null &&
        !state.reasons.any((r) => r.id == _selectedReasonId)) {
      _selectedReasonId = null;
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelectedOrderHeader(isDark, state, l10n),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.accountReturnSelectItem),
                const SizedBox(height: 8),
                ...state.items.map((item) => _buildItemCard(isDark, item)),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.accountReturnResolution),
                const SizedBox(height: 8),
                _buildResolutionToggle(isDark, state),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.productQuantity),
                const SizedBox(height: 8),
                _buildQuantityStepper(isDark, l10n),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.accountReturnReason),
                const SizedBox(height: 8),
                _buildReasonDropdown(isDark, state, l10n),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.accountReturnPackageCondition),
                const SizedBox(height: 8),
                _buildTextField(
                  isDark,
                  controller: _conditionController,
                  hint: l10n.accountReturnPackageConditionHint,
                ),
                const SizedBox(height: 16),
                _sectionLabel(isDark, l10n.accountReturnAdditionalInfo),
                const SizedBox(height: 8),
                _buildTextField(
                  isDark,
                  controller: _informationController,
                  hint: l10n.accountReturnAdditionalInfoHint,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildEvidenceImages(isDark, l10n),
                const SizedBox(height: 16),
                _buildAgreementCheckbox(isDark, l10n),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        _buildBottomBar(isDark, l10n, state),
      ],
    );
  }

  Widget _buildEvidenceImages(bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionLabel(isDark, l10n.accountReturnEvidenceImages),
            ),
            OutlinedButton.icon(
              onPressed: _showImageSourcePicker,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: Text(l10n.accountReturnAddImages),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary500,
                side: const BorderSide(color: AppColors.primary500),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) => SizedBox(
                width: 84,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _imagePreviews[index],
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => setState(() {
                            _images.removeAt(index);
                            _imagePreviews.removeAt(index);
                          }),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showImageSourcePicker() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.accountReviewChooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.accountReviewTakePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final List<XFile> picked;
    if (source == ImageSource.gallery) {
      picked = await _imagePicker.pickMultiImage(imageQuality: 85);
    } else {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      picked = image == null ? const [] : [image];
    }
    if (!mounted || picked.isEmpty) return;

    final l10nAfterPick = AppLocalizations.of(context)!;
    final validImages = <XFile>[];
    final previewBytes = <Uint8List>[];
    for (final image in picked) {
      final bytes = await image.readAsBytes();
      if (bytes.length > ReturnImageEncoder.maxFileBytes) {
        _showImageMessage(l10nAfterPick.accountReviewAttachmentTooLarge);
      } else {
        validImages.add(image);
        previewBytes.add(bytes);
      }
    }
    if (validImages.isNotEmpty && mounted) {
      setState(() {
        _images.addAll(validImages);
        _imagePreviews.addAll(previewBytes);
      });
    }
  }

  void _showImageMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Widget _buildSelectedOrderHeader(
    bool isDark,
    CreateReturnState state,
    AppLocalizations l10n,
  ) {
    final order = state.selectedOrder;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.accountReturnOrderLabel(order?.orderNumber ?? ''),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<CreateReturnBloc>().add(const BackToOrderPicker()),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.accountReturnChangeOrder,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(bool isDark, String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: isDark ? AppColors.neutral200 : AppColors.neutral900,
      ),
    );
  }

  // ─── Item picker ───

  Widget _buildItemCard(bool isDark, ReturnableItem item) {
    final l10n = AppLocalizations.of(context)!;
    final selected = item.orderItemId == _selectedOrderItemId;
    final maxQty = item.maxQuantityFor(widget.state.resolutionType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOrderItemId = item.orderItemId;
            _quantity = 1;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
            border: Border.all(
              color: selected
                  ? AppColors.primary500
                  : (isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5)),
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: item.baseImageUrl != null &&
                            item.baseImageUrl!.isNotEmpty
                        ? Image.network(
                            item.baseImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Image.asset(
                              AppAssets.productPlaceholder,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppAssets.productPlaceholder,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.neutral200
                            : const Color(0xFF171717),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.sku ?? ''} · ${l10n.accountReturnMaxQty(maxQty)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<int?>(
                value: item.orderItemId,
                // ignore: deprecated_member_use
                groupValue: _selectedOrderItemId,
                activeColor: AppColors.primary500,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  setState(() {
                    _selectedOrderItemId = value;
                    _quantity = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Resolution toggle ───

  Widget _buildResolutionToggle(bool isDark, CreateReturnState state) {
    final l10n = AppLocalizations.of(context)!;

    Widget chip(String label, String value) {
      final selected = state.resolutionType == value;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            context.read<CreateReturnBloc>().add(ChangeResolutionType(value));
            setState(() {
              _quantity = 1;
              _selectedReasonId = null;
            });
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary500
                  : (isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5)),
              border: Border.all(
                color: selected
                    ? AppColors.primary500
                    : (isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5)),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: selected
                    ? AppColors.white
                    : (isDark ? AppColors.neutral300 : AppColors.neutral700),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(l10n.accountReturnResolutionReturn, 'return'),
        const SizedBox(width: 8),
        chip(l10n.accountReturnResolutionCancel, 'cancel_items'),
      ],
    );
  }

  // ─── Quantity stepper ───

  Widget _buildQuantityStepper(bool isDark, AppLocalizations l10n) {
    _clampQuantity();

    Widget stepButton(IconData icon, VoidCallback? onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onTap == null
                ? AppColors.neutral400
                : (isDark ? AppColors.neutral200 : AppColors.neutral900),
          ),
        ),
      );
    }

    return Row(
      children: [
        stepButton(
          Icons.remove,
          _quantity > 1 ? () => setState(() => _quantity--) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$_quantity',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDark ? AppColors.neutral200 : AppColors.neutral900,
            ),
          ),
        ),
        stepButton(
          Icons.add,
          _quantity < _maxQuantity ? () => setState(() => _quantity++) : null,
        ),
        const SizedBox(width: 12),
        Text(
          l10n.accountReturnMaxQty(_maxQuantity),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.neutral500,
          ),
        ),
      ],
    );
  }

  // ─── Reason dropdown ───

  Widget _buildReasonDropdown(
    bool isDark,
    CreateReturnState state,
    AppLocalizations l10n,
  ) {
    if (state.reasonsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedReasonId,
          isExpanded: true,
          hint: Text(
            l10n.accountReturnSelectReason,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.neutral500,
            ),
          ),
          dropdownColor: isDark ? AppColors.neutral800 : AppColors.white,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.neutral200 : AppColors.neutral900,
          ),
          items: state.reasons
              .map(
                (reason) => DropdownMenuItem<int>(
                  value: reason.id,
                  child: Text(reason.title),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedReasonId = value),
        ),
      ),
    );
  }

  // ─── Text fields ───

  Widget _buildTextField(
    bool isDark, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: isDark ? AppColors.neutral200 : AppColors.neutral900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.neutral500,
        ),
        filled: true,
        fillColor: isDark ? AppColors.neutral800 : const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : const Color(0xFFE5E5E5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary500),
        ),
      ),
    );
  }

  // ─── Agreement ───

  Widget _buildAgreementCheckbox(bool isDark, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => setState(() => _agreed = !_agreed),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreed,
              activeColor: AppColors.primary500,
              onChanged: (value) => setState(() => _agreed = value ?? false),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.accountReturnAgreement,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: isDark ? AppColors.neutral300 : AppColors.neutral700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom bar — Submit ───

  Widget _buildBottomBar(
    bool isDark,
    AppLocalizations l10n,
    CreateReturnState state,
  ) {
    final submitting =
        state.status == CreateReturnStatus.submitting || _preparingImages;

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
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSubmit ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: isDark
                  ? AppColors.neutral700
                  : AppColors.neutral200,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(54),
              ),
            ),
            child: submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    l10n.accountReturnSubmit,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    _clampQuantity();
    setState(() => _preparingImages = true);
    final l10n = AppLocalizations.of(context)!;
    List<String> images;
    try {
      images = await ReturnImageEncoder.encode(_images);
    } on ReturnImageEncodingException catch (error) {
      if (!mounted) return;
      setState(() => _preparingImages = false);
      _showImageMessage(
        error.message == 'image_too_large'
            ? l10n.accountReviewAttachmentTooLarge
            : l10n.categorySomethingWentWrong,
      );
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _preparingImages = false);
      _showImageMessage(l10n.categorySomethingWentWrong);
      return;
    }
    if (!mounted) return;
    setState(() => _preparingImages = false);
    context.read<CreateReturnBloc>().add(
      SubmitReturn(
        orderItemId: _selectedOrderItemId!,
        rmaQty: _quantity,
        rmaReasonId: _selectedReasonId!,
        information: _informationController.text.trim(),
        packageCondition: _conditionController.text.trim(),
        images: images,
      ),
    );
  }
}
