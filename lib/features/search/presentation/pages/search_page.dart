import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../category/data/models/product_model.dart';
import '../../../category/data/models/category_model.dart';
import '../../../category/data/repository/category_repository.dart';
import '../../../category/presentation/pages/category_products_grid_page.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../bloc/search_bloc.dart';
import 'image_search_screen.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/image_picker_service.dart';
import '../../data/services/mlkit_vision_service.dart';
import '../../data/repository/image_search_repository.dart';
import '../bloc/image_search_bloc.dart';

/// Search page matching Figma design
/// Light: node 113-7830 | Dark: node 113-7857
///
/// Layout:
///  ┌──────────────────────────────┐
///  │  ← Back | Search TextField  │ ← navigation-bar/search
///  ├──────────────────────────────┤
///  │  [Image Search] [Text Search]│ ← secondary buttons
///  ├──────────────────────────────┤
///  │  Recent Searches             │ ← neutral/100 chips, 20px radius
///  ├──────────────────────────────┤
///  │  Top Categories              │ ← circular images + labels
///  ├──────────────────────────────┤
///  │  Recently Viewed Products    │ ← horizontal scrollable cards
///  └──────────────────────────────┘
///  — OR on search results: —
///  ┌──────────────────────────────┐
///  │  Product grid (2-column)     │
///  └──────────────────────────────┘
class SearchPage extends StatelessWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final bloc = SearchBloc(
          repository: ctx.read<CategoryRepository>(),
        )..add(InitSearch());
        
        // If initialQuery is provided, submit search automatically
        if (initialQuery != null && initialQuery!.isNotEmpty) {
          bloc.add(SubmitSearch(initialQuery!));
        }
        
        return bloc;
      },
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  // Speech to text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    // Get initial query from parent SearchPage
    final searchPage = context.findAncestorWidgetOfExactType<SearchPage>();
    final initialQuery = searchPage?.initialQuery;
    
    // Auto-focus on the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _initSpeech();
      
      // Set initial query in controller and perform search
      if (initialQuery != null && initialQuery.isNotEmpty) {
        _searchController.text = initialQuery;
      }
    });
  }

  /// Initialize speech to text
  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          debugPrint('Speech error: $error');
          if (mounted && error.toString().contains('error_permission')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Microphone permission denied. Please enable it in settings.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        onStatus: (status) => debugPrint('Speech status: $status'),
      );
    } catch (e) {
      debugPrint('Error initializing speech: $e');
      _speechEnabled = false;
    }
    setState(() {});
  }

  /// Start speech recognition
  void _startListening() async {
    if (!_speechEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition not available. Please check permissions in Settings > Apps > Bagisto > Microphone.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
        ),
      );
      setState(() {
        _isListening = true;
      });
    } catch (e) {
      debugPrint('Error starting listening: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start voice search: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        _isListening = false;
      });
    }
  }

  /// Stop speech recognition
  void _stopListening() async {
    try {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    } catch (e) {
      debugPrint('Error stopping listening: $e');
      setState(() {
        _isListening = false;
      });
    }
  }

  /// Handle speech recognition result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchController.text = result.recognizedWords;
    });
    
    if (result.finalResult) {
      _onSearchSubmitted(result.recognizedWords);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    _speechToText.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }

  void _onSearchSubmitted(String query) {
    _debounce?.cancel();
    context.read<SearchBloc>().add(SubmitSearch(query));
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<SearchBloc>().add(SubmitSearch(query));
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ClearSearch());
    _focusNode.requestFocus();
  }

  /// Navigate to Category Products grid for a given [CategoryModel].
  void _openCategoryProducts(BuildContext context, CategoryModel category) {
    final categoryId = category.numericId ?? 0;
    if (categoryId <= 0) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RepositoryProvider.value(
          value: RepositoryProvider.of<CategoryRepository>(context),
          child: CategoryProductsGridPage(
            categoryId: categoryId,
            categoryName: category.name,
            categorySlug: category.slug,
          ),
        ),
      ),
    );
  }

  /// Navigate to Image Search screen
  void _navigateToImageSearch(BuildContext context) {
    // Create repository instances
    final permissionService = PermissionService();
    final imagePickerService = ImagePickerService();
    // On-device ML Kit for real object detection (no API key needed)
    final visionAIService = MLKitVisionService();
    final imageSearchRepository = ImageSearchRepository(
      permissionService: permissionService,
      imagePickerService: imagePickerService,
      visionAIService: visionAIService,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ImageSearchBloc(repository: imageSearchRepository),
          child: const ImageSearchScreen(),
        ),
      ),
    ).then((selectedLabel) {
      // If a label was selected, perform search
      if (selectedLabel != null && selectedLabel is String) {
        _searchController.text = selectedLabel;
        context.read<SearchBloc>().add(SubmitSearch(selectedLabel));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ──
            _buildSearchBar(context, isDark),

            const SizedBox(height: 8),

            // ── Content ──
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state.status == SearchStatus.results) {
                    return _buildSearchResults(context, state, isDark);
                  }
                  if (state.status == SearchStatus.searching) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary500,
                      ),
                    );
                  }
                  if (state.status == SearchStatus.empty) {
                    return _buildEmptyResults(context, isDark);
                  }
                  if (state.status == SearchStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: AppColors.neutral400),
                          const SizedBox(height: 12),
                          Text('Search failed',
                              style: AppTextStyles.text4(context)),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ?? '',
                            style: AppTextStyles.text6(context),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  // Initial state
                  return _buildInitialContent(context, state, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search bar matching Figma navigation-bar/search
  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button - large tap area (60x60)
          AppBackButton(
            onTap: () => Navigator.of(context).pop(),
            tapAreaSize: 60,
            size: 24,
          ),

          const SizedBox(width: 8),

          // Search text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.neutral700 : AppColors.neutral200,
                ),
                borderRadius: BorderRadius.circular(10),
                color: isDark ? AppColors.neutral800 : AppColors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.neutral200
                            : AppColors.neutral900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Product',
                        hintStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.neutral500
                              : AppColors.neutral400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  // Clear / Mic icon
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state.query.isNotEmpty) {
                        return GestureDetector(
                          onTap: _onClearSearch,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: isDark
                                  ? AppColors.neutral300
                                  : AppColors.neutral500,
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: _isListening ? _stopListening : _startListening,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 20,
                            color: _isListening
                                ? AppColors.primary500
                                : (isDark
                                    ? AppColors.neutral300
                                    : AppColors.neutral500),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Initial content: buttons, recent searches, categories
  Widget _buildInitialContent(
      BuildContext context, SearchState state, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ── Image Search / Text Search buttons ──
          Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  isDark,
                  icon: Icons.image_outlined,
                  label: 'Image Search',
                  onPressed: () {
                    _navigateToImageSearch(context);
                  },
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: _buildSecondaryButton(
              //     context,
              //     isDark,
              //     icon: Icons.text_fields,
              //     label: 'Text Search',
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Recent Searches ──
          if (state.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: AppTextStyles.text5(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<SearchBloc>().add(ClearAllRecentSearches()),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.recentSearches.map(
              (search) => _buildRecentSearchItem(context, search, isDark),
            ),
            const SizedBox(height: 32),
          ],

          // ── Top Categories ──
          if (state.topCategories.isNotEmpty) ...[
            Text(
              'Top Categories',
              style: AppTextStyles.text5(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.topCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 2),
                itemBuilder: (context, index) {
                  final cat = state.topCategories[index];
                  return _buildCategoryCircle(context, cat, isDark);
                },
              ),
            ),
            const SizedBox(height: 32),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Secondary button (Image Search / Text Search)
  /// Figma: button/secondary — border neutral/200, 54px radius, primary/500 text
  Widget _buildSecondaryButton(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    final buttonChild = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
        borderRadius: BorderRadius.circular(54),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: AppColors.primary500),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
    
    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        child: buttonChild,
      );
    }
    return buttonChild;
  }

  /// Recent search item — Figma: search-list component
  /// neutral/100 bg, 20px radius, search icon + text
  Widget _buildRecentSearchItem(
      BuildContext context, String search, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () => _onRecentSearchTap(search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.neutral800 : AppColors.neutral100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 24,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  search,
                  style: AppTextStyles.text5(context).copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<SearchBloc>().add(RemoveRecentSearch(search)),
                child: Icon(
                  Icons.north_west,
                  size: 16,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Category circle — Figma: 51px circle image + label
  Widget _buildCategoryCircle(
      BuildContext context, CategoryModel category, bool isDark) {
    return GestureDetector(
      onTap: () => _openCategoryProducts(context, category),
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.neutral800 : AppColors.neutral100,
              ),
              clipBehavior: Clip.antiAlias,
              child: category.logoUrl != null && category.logoUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: category.logoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const SizedBox.shrink(),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.category_outlined,
                        size: 24,
                        color: AppColors.neutral400,
                      ),
                    )
                  : Icon(
                      Icons.category_outlined,
                      size: 24,
                      color: AppColors.neutral400,
                    ),
            ),
            const SizedBox(height: 7),
            Text(
              category.name ?? '',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.17,
                color: isDark ? AppColors.neutral300 : AppColors.neutral800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Search results grid
  Widget _buildSearchResults(
      BuildContext context, SearchState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${state.totalCount} results found',
            style: AppTextStyles.text6(context).copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              return _buildProductCard(
                  context, state.searchResults[index], isDark);
            },
          ),
        ),
      ],
    );
  }

  /// Product card matching Figma product-image-scroller component
  Widget _buildProductCard(
      BuildContext context, ProductModel product, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (product.urlKey != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                urlKey: product.urlKey!,
                productName: product.name,
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.5),
                    color: isDark ? AppColors.neutral800 : AppColors.neutral100,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: product.baseImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product.baseImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (_, __) => Container(
                            color: isDark
                                ? AppColors.neutral800
                                : AppColors.neutral100,
                          ),
                          errorWidget: (_, __, ___) => Center(
                            child: Icon(Icons.image_outlined,
                                size: 40, color: AppColors.neutral400),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.image_outlined,
                              size: 40, color: AppColors.neutral400),
                        ),
                ),
                // Wishlist icon
                Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(
                    Icons.favorite_border,
                    size: 24,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Product name
          Text(
            product.name ?? '',
            style: AppTextStyles.text5(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 7),

          // Price
          Row(
            children: [
              Text(
                '\$${product.displayPrice.toStringAsFixed(2)}',
                style: AppTextStyles.text5(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.neutral900,
                ),
              ),
              if (product.originalPrice != null) ...[
                const SizedBox(width: 3),
                Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutral500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              if (product.discountPercent != null) ...[
                const SizedBox(width: 3),
                Text(
                  '${product.discountPercent}% off',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary500,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 7),

          // Rating
          if (product.reviewCount > 0)
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.white),
                      const SizedBox(width: 1),
                      Text(
                        product.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '${product.reviewCount}',
                  style: AppTextStyles.text5(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Empty results state
  Widget _buildEmptyResults(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: AppTextStyles.text4(context),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: AppTextStyles.text6(context).copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
