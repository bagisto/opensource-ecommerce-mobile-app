import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/account_dashboard_bloc.dart';
import '../bloc/address_book_bloc.dart';
import '../bloc/review_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/quick_action_chips.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/wishlist_section.dart';
import '../widgets/default_addresses_section.dart';
import '../widgets/product_reviews_section.dart';
import 'account_menu_page.dart';
import 'address_book_page.dart';
import 'reviews_page.dart';

/// Account Dashboard Page — Figma node-id=220-6313
///
/// This is the main account dashboard that shows:
///   - Profile header with avatar, name, email
///   - Quick action chips (My Orders, Account, Settings)
///   - Recent Orders (horizontal scroll)
///   - Wishlist Items (horizontal scroll)
///   - Default Addresses (billing & shipping)
///   - Product Reviews
class AccountDashboardPage extends StatelessWidget {
  const AccountDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: BlocBuilder<AccountDashboardBloc, AccountDashboardState>(
        builder: (context, state) {
          if (state.status == AccountDashboardStatus.loading &&
              state.profile == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            );
          }

          if (state.status == AccountDashboardStatus.error &&
              state.profile == null) {
            return _buildErrorView(context, state.errorMessage);
          }

          return RefreshIndicator(
            color: AppColors.primary500,
            onRefresh: () async {
              context.read<AccountDashboardBloc>().add(
                const RefreshAccountDashboard(),
              );
            },
            child: CustomScrollView(
              slivers: [
                // Profile header
                SliverToBoxAdapter(
                  child: ProfileHeader(
                    profile: state.profile,
                    fallbackName:
                        context.read<AuthBloc>().state is AuthAuthenticated
                        ? (context.read<AuthBloc>().state as AuthAuthenticated)
                              .userName
                        : null,
                    fallbackEmail:
                        context.read<AuthBloc>().state is AuthAuthenticated
                        ? (context.read<AuthBloc>().state as AuthAuthenticated)
                              .userEmail
                        : null,
                    onSettingsTap: () {
                      final repository = context.read<AccountRepository>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<AuthBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<AccountDashboardBloc>(),
                                ),
                              ],
                              child: AccountMenuPage(profile: state.profile),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Quick action chips
                const SliverToBoxAdapter(child: QuickActionChips()),

                // Recent Orders
                SliverToBoxAdapter(
                  child: RecentOrdersSection(orders: state.recentOrders),
                ),

                // Wishlist Items
                SliverToBoxAdapter(
                  child: WishlistSection(
                    items: state.wishlistItems,
                    totalCount: state.wishlistTotalCount,
                  ),
                ),

                // Default Addresses
                SliverToBoxAdapter(
                  child: DefaultAddressesSection(
                    addresses: state.addresses,
                    onViewAll: () {
                      final repository = context.read<AccountRepository>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: BlocProvider(
                              create: (_) => AddressBookBloc(
                                repository: repository,
                              )..add(const LoadAddresses()),
                              child: const AddressBookPage(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Product Reviews
                SliverToBoxAdapter(
                  child: ProductReviewsSection(
                    reviews: state.reviews,
                    totalCount: state.reviewsTotalCount,
                    onViewAll: () {
                      final repository = context.read<AccountRepository>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: BlocProvider(
                              create: (_) => ReviewBloc(
                                repository: repository,
                              )..add(const LoadReviews()),
                              child: const ReviewsPage(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.neutral400),
            const SizedBox(height: 16),
            Text('Something went wrong', style: AppTextStyles.text3(context)),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Please try again later',
              style: AppTextStyles.text5(
                context,
              ).copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AccountDashboardBloc>().add(
                  const LoadAccountDashboard(),
                );
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
}
