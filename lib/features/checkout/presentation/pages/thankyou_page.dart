import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../account/data/repository/account_repository.dart';
import '../../../account/presentation/pages/order_detail_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'dart:math' as math;

/// Thank You page — Figma node-id=206:7578
///
/// Displayed after a successful order placement.
/// Shows a success illustration, order number, and two action buttons:
///   - "View Order" (primary, navigates to OrderDetailPage)
///   - "Continue Shopping" (text link, pops back to home)
class ThankyouPage extends StatelessWidget {
  final String? orderId;
  final String? orderIncrementId;

  const ThankyouPage({super.key, this.orderId, this.orderIncrementId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.read<AuthBloc>().state;
    final showViewOrderButton = authState is AuthAuthenticated;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Navigation Bar ──
            _buildNavBar(context, isDark),

            // ── Content ──
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Success Illustration ──
                      _buildSuccessIllustration(),

                      const SizedBox(height: 32),

                      // ── Title ──
                      Text(
                        'Thank you for your order!',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.0,
                          color: isDark
                              ? AppColors.neutral100
                              : AppColors.neutral900,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // ── Subtitle ──
                      Text(
                        'We will email you, your order details\nand tracking information',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.4,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // ── Order Number ──
                      if (orderIncrementId != null || orderId != null)
                        Text(
                          'Your order No. #${orderIncrementId ?? orderId}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.0,
                            color: isDark
                                ? AppColors.neutral200
                                : AppColors.neutral900,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 32),

                      // ── View Order Button (only for logged-in users) ──
                      if (showViewOrderButton) ...[
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => _onViewOrder(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(54),
                              ),
                            ),
                            child: const Text(
                              'View Order',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ── Continue Shopping ──
                      GestureDetector(
                        onTap: () => _onContinueShopping(context),
                        child: Text(
                          'Continue Shopping',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigation bar with back arrow — Figma: px-16, min-h 48
  Widget _buildNavBar(BuildContext context, bool isDark) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onContinueShopping(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: isDark ? AppColors.neutral200 : AppColors.neutral900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Success illustration — layered green circles with checkmark
  /// Figma: Three concentric circles in green shades + white check icon
  Widget _buildSuccessIllustration() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer starburst / blob shape
          CustomPaint(
            size: const Size(120, 120),
            painter: _SuccessBlobPainter(),
          ),
          // Middle circle
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C950).withAlpha(180),
            ),
          ),
          // Inner circle with check
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00C950),
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 28),
          ),
        ],
      ),
    );
  }

  void _onViewOrder(BuildContext context) {
    // Reload cart
    context.read<CartBloc>().add(LoadCart());

    final orderIdNum = int.tryParse(orderId ?? '');
    if (orderIdNum != null) {
      // Pop checkout and navigate to order detail
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Get or create AccountRepository
      AccountRepository repository;
      try {
        repository = context.read<AccountRepository>();
      } catch (_) {
        // Fall back to creating a new repository from auth token
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          final client =
              GraphQLClientProvider.authenticatedClient(authState.token);
          repository = AccountRepository(client: client.value);
        } else {
          // If not authenticated, can't navigate to order details
          return;
        }
      }

      // Navigate to order details page using the static navigate method
      // which properly wraps with BlocProvider
      OrderDetailPage.navigate(
        context,
        orderId: orderIdNum,
        orderNumber: orderIncrementId != null ? '#$orderIncrementId' : '#$orderId',
        repository: repository,
      );
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _onContinueShopping(BuildContext context) {
    // Reload cart
    context.read<CartBloc>().add(LoadCart());
    // Pop back to MainShell
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Use AppNavigator to switch to home tab
    AppNavigator.navigateToCart(context);
  }
}

/// Custom painter for the green starburst/blob shape behind the checkmark
class _SuccessBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF00C950).withAlpha(60)
      ..style = PaintingStyle.fill;

    // Draw a wavy circle (starburst effect)
    final path = Path();
    const points = 12;
    const outerRadius = 58.0;
    const innerRadius = 48.0;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle - math.pi / 2);
      final y = center.dy + radius * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic bezier for smooth curves
        final prevAngle = ((i - 1) * math.pi) / points;
        final prevRadius = (i - 1).isEven ? outerRadius : innerRadius;
        final midAngle = (prevAngle + angle) / 2;
        final midRadius = (prevRadius + radius) / 2 + 4;
        final cx = center.dx + midRadius * math.cos(midAngle - math.pi / 2);
        final cy = center.dy + midRadius * math.sin(midAngle - math.pi / 2);
        path.quadraticBezierTo(cx, cy, x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
