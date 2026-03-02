import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/wishlist/wishlist_cubit.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';
import '../bloc/wishlist_bloc.dart';
import '../pages/wishlist_page.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import 'section_header.dart';

/// Wishlist items horizontal scroll section
/// Figma: node-id=220-7227
class WishlistSection extends StatelessWidget {
  final List<WishlistItem> items;
  final int totalCount;

  const WishlistSection({
    super.key,
    required this.items,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Wishlist Items ($totalCount)',
              onViewAll: items.isNotEmpty
                  ? () {
                      final repository = context.read<AccountRepository>();
                      final wishlistCubit = context.read<WishlistCubit>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repository,
                            child: BlocProvider(
                              create: (_) =>
                                  WishlistBloc(
                                    repository: repository,
                                    wishlistCubit: wishlistCubit,
                                  )
                                    ..add(const LoadWishlist()),
                              child: const WishlistPage(),
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 2),
          if (items.isEmpty)
            _buildEmptyState(context)
          else
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      if (item.urlKey != null && item.urlKey!.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              urlKey: item.urlKey!,
                              productName: item.name,
                            ),
                          ),
                        );
                      }
                    },
                    child: _buildWishlistCard(context, item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral200,
          ),
        ),
        child: Center(
          child: Text(
            'No wishlist items',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, WishlistItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 62,
              height: 62,
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
              child: item.baseImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.baseImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                      errorWidget: (_, _, _) => Icon(
                        Icons.favorite_outline,
                        color: isDark
                            ? AppColors.neutral500
                            : AppColors.neutral400,
                      ),
                    )
                  : Icon(
                      Icons.favorite_outline,
                      color: isDark
                          ? AppColors.neutral500
                          : AppColors.neutral400,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          // Product info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 130),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? AppColors.neutral200 : AppColors.neutral900,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.formattedPrice,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDark ? AppColors.neutral300 : AppColors.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
