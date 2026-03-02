import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/address_book_bloc.dart';
import '../widgets/address_card.dart';
import 'add_address_page.dart';

/// Address Book Page — Figma node-id=204-4487
///
/// Displays all saved customer addresses with:
///   - Navigation bar: back arrow + "Address Book" title
///   - List of address cards (scrollable, pull-to-refresh)
///   - Bottom sticky "Add New Address" button
///
/// Each card shows:
///   - Type tag (Home/Office) + optional "Default" badge
///   - Name (bold) with company
///   - Full formatted address
///   - Action buttons: Select Address, Set as Default, Edit
class AddressBookPage extends StatelessWidget {
  const AddressBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Navigation bar ──
            _buildNavBar(context, isDark),

            // ── Address list ──
            Expanded(
              child: BlocConsumer<AddressBookBloc, AddressBookState>(
                listenWhen: (prev, curr) =>
                    prev.actionMessage != curr.actionMessage &&
                    curr.actionMessage != null,
                listener: (context, state) {
                  if (state.actionMessage != null &&
                      state.actionMessage!.isNotEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.actionMessage!),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  // Initial + loading → full-screen spinner
                  if (state.status == AddressBookStatus.initial ||
                      state.status == AddressBookStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary500,
                      ),
                    );
                  }

                  if (state.status == AddressBookStatus.error) {
                    return _buildErrorView(context, state.errorMessage, isDark);
                  }

                  if (state.addresses.isEmpty &&
                      state.status == AddressBookStatus.loaded) {
                    return _buildEmptyView(context, isDark);
                  }

                  return _buildAddressList(context, state, isDark);
                },
              ),
            ),

            // ── Bottom "Add New Address" button ──
            _buildBottomButton(context, isDark),
          ],
        ),
      ),
    );
  }

  /// Address list with pull-to-refresh and mutation overlay.
  Widget _buildAddressList(
    BuildContext context,
    AddressBookState state,
    bool isDark,
  ) {
    return _AddressListWithScroll(
      isDark: isDark,
      state: state,
      context: context,
    );
  }

  /// Navigation bar — back arrow + "Address Book" title
  /// Figma: node-id=204:4667
  Widget _buildNavBar(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? AppColors.neutral900 : AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          // Back arrow with a11y
          Semantics(
            button: true,
            label: 'Go back',
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(10),
                child: Tooltip(
                  message: 'Back',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                      color: isDark
                          ? AppColors.neutral200
                          : AppColors.neutral900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Address Book',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? AppColors.neutral200 : AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom sticky "Add New Address" button
  /// Figma: node-id=204:4660
  Widget _buildBottomButton(BuildContext context, bool isDark) {
    // Capture providers from the outer context which has access to
    // RepositoryProvider<AccountRepository> — the BlocSelector's inner
    // context sits below it and may not resolve the provider.
    final repository = context.read<AccountRepository>();
    final bloc = context.read<AddressBookBloc>();

    return BlocSelector<AddressBookBloc, AddressBookState, bool>(
      selector: (state) => state.isPerformingAction,
      builder: (selectorContext, isPerforming) {
        return Container(
          color: isDark ? AppColors.neutral800 : AppColors.neutral50,
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            10 + MediaQuery.of(selectorContext).padding.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Disable button while a mutation is in progress
              onPressed: isPerforming
                  ? null
                  : () {
                      Navigator.of(selectorContext).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: BlocProvider.value(
                              value: bloc,
                              child: const AddAddressPage(),
                            ),
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.primary500.withAlpha(128),
                disabledForegroundColor: AppColors.white.withAlpha(180),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(54),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              child: const Text('Add New Address'),
            ),
          ),
        );
      },
    );
  }

  /// Error view with retry
  Widget _buildErrorView(
    BuildContext context,
    String? errorMessage,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text(
              'Could not load addresses',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? AppColors.neutral200 : AppColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Please try again',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AddressBookBloc>().add(const LoadAddresses());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state — wrapped in scrollable for pull-to-refresh
  Widget _buildEmptyView(BuildContext context, bool isDark) {
    return RefreshIndicator(
      color: AppColors.primary500,
      onRefresh: () {
        final completer = Completer<void>();
        context.read<AddressBookBloc>().add(
          RefreshAddresses(completer: completer),
        );
        return completer.future;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 64,
                        color: AppColors.neutral400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No addresses saved',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isDark
                              ? AppColors.neutral200
                              : AppColors.neutral800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a new address to get started',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Scroll navigation widget for address list
class _AddressListWithScroll extends StatefulWidget {
  final bool isDark;
  final AddressBookState state;
  final BuildContext context;

  const _AddressListWithScroll({
    required this.isDark,
    required this.state,
    required this.context,
  });

  @override
  State<_AddressListWithScroll> createState() => _AddressListWithScrollState();
}

class _AddressListWithScrollState extends State<_AddressListWithScroll> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final hasScrollableContent =
        _scrollController.position.maxScrollExtent > 0;
    final atTop = _scrollController.position.pixels <= 0;
    final atBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10;

    setState(() {
      _canScrollUp = hasScrollableContent && !atTop;
      _canScrollDown = hasScrollableContent && !atBottom;
    });
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 150,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 150,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Scroll navigation arrows
            if (widget.state.addresses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    // Previous arrow
                    Opacity(
                      opacity: _canScrollUp ? 1.0 : 0.3,
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _canScrollUp ? _scrollUp : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? AppColors.neutral800
                                    : AppColors.neutral100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: widget.isDark
                                      ? AppColors.neutral700
                                      : AppColors.neutral200,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 18,
                                  color: widget.isDark
                                      ? AppColors.neutral300
                                      : AppColors.neutral700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Next arrow
                    Opacity(
                      opacity: _canScrollDown ? 1.0 : 0.3,
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _canScrollDown ? _scrollDown : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.isDark
                                    ? AppColors.neutral800
                                    : AppColors.neutral100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: widget.isDark
                                      ? AppColors.neutral700
                                      : AppColors.neutral200,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 18,
                                  color: widget.isDark
                                      ? AppColors.neutral300
                                      : AppColors.neutral700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

            // Address list
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary500,
                onRefresh: () {
                  // Use completer so RefreshIndicator waits for BLoC to finish
                  final completer = Completer<void>();
                  context.read<AddressBookBloc>().add(
                    RefreshAddresses(completer: completer),
                  );
                  return completer.future;
                },
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  itemCount: widget.state.addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final address = widget.state.addresses[index];
                    return AddressCard(
                      key: ValueKey(address.id ?? index),
                      address: address,
                      onSelect: () {
                        Navigator.of(context).pop(address);
                      },
                      onSetDefault: address.isDefault
                          ? null
                          : () {
                              final numericId = address.numericId;
                              if (numericId != null && numericId > 0) {
                                context.read<AddressBookBloc>().add(
                                  SetDefaultAddress(
                                    addressId: numericId,
                                   
                                    useForShipping: address.useForShipping,
                                  ),
                                );
                              }
                            },
                      onEdit: () {
                        final repository =
                            context.read<AccountRepository>();
                        final bloc =
                            context.read<AddressBookBloc>();
                        Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => RepositoryProvider.value(
                              value: repository,
                              child: BlocProvider.value(
                                value: bloc,
                                child:
                                    AddAddressPage(editingAddress: address),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // Mutation overlay — blocks taps while performing action
        if (widget.state.isPerformingAction)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary500),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
