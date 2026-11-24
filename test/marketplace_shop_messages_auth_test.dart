import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/models/shop_marketplace.dart';
import 'package:bagisto_flutter/marketplace/features/shop/data/repository/shop_marketplace_repository.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/bloc/shop_marketplace_cubits.dart';
import 'package:bagisto_flutter/marketplace/core/ui/seller_message_attachment.dart';
import 'package:bagisto_flutter/marketplace/features/shop/presentation/pages/shop_messages_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opening "Messages from sellers".
///
/// These threads belong to a shopper, so `shopCommunications` refuses a
/// request carrying only the storefront key — verified live, "Unauthorized."
/// without a customer token and a real list with one. Both entry points
/// opened the screen without passing one, so it always showed the server's
/// own word over a Retry button that could only fail again.
class _Threads implements ShopMarketplaceRepository {
  _Threads({this.threads = const []});

  final List<ShopConversation> threads;
  int loads = 0;
  String? lastSearch;

  @override
  Future<PaginatedResult<ShopConversation>> conversations({
    int page = 1,
    String? search,
  }) async {
    loads++;
    lastSearch = search;
    return PaginatedResult(
      items: threads,
      totalCount: threads.length,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<ShopConversation> conversation(int sellerId, {String? days}) async {
    return threads.firstWhere((t) => t.id == sellerId);
  }

  @override
  Future<void> markRead(int sellerId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<ShopConversationsCubit> _pump(
  WidgetTester tester,
  _Threads repository, {
  required bool signedIn,
}) async {
  final cubit = ShopConversationsCubit(repository: repository);
  if (signedIn) await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: ShopMessagesPage(isSignedIn: signedIn),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

void main() {
  testWidgets('a signed-out shopper is asked to sign in', (tester) async {
    final repository = _Threads();
    await _pump(tester, repository, signedIn: false);

    expect(find.byKey(const Key('shopMessagesSignIn')), findsOneWidget);
    expect(find.text('Unauthorized.'), findsNothing);
    // Nothing is fetched either — the request could only come back refused.
    expect(repository.loads, 0);
  });

  testWidgets('a signed-in shopper gets their threads', (tester) async {
    // The shape the live list answered with after a message was sent.
    final repository = _Threads(
      threads: const [
        ShopConversation(
          id: 38,
          communicationId: 4,
          sellerName: 'Acme Store-2',
          subject: 'Hi — is the Studio Session available on Saturdays?',
        ),
      ],
    );
    await _pump(tester, repository, signedIn: true);

    expect(find.text('Acme Store-2'), findsOneWidget);
    expect(find.byKey(const Key('shopMessagesSignIn')), findsNothing);
    expect(repository.loads, 1);
  });

  testWidgets('a signed-in shopper sees Communications title and search field', (tester) async {
    final repository = _Threads(
      threads: const [
        ShopConversation(
          id: 38,
          communicationId: 4,
          sellerName: 'Acme Store-2',
          subject: 'Hi — is the Studio Session available on Saturdays?',
        ),
      ],
    );
    await _pump(tester, repository, signedIn: true);

    expect(find.text('Communications'), findsOneWidget);
    expect(find.byKey(const Key('shopMessagesSearch')), findsOneWidget);
    expect(find.text('Search sellers'), findsOneWidget);
  });

  testWidgets('searching sellers triggers conversations with query', (tester) async {
    final repository = _Threads();
    await _pump(tester, repository, signedIn: true);

    await tester.enterText(find.byKey(const Key('shopMessagesSearch')), 'Acme');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(repository.lastSearch, 'Acme');
  });

  testWidgets('tapping an uncontacted seller opens thread page with empty state', (tester) async {
    final repository = _Threads(
      threads: const [
        ShopConversation(
          id: 42,
          communicationId: null,
          sellerName: 'Fresh Seller',
        ),
      ],
    );
    await _pump(tester, repository, signedIn: true);

    expect(find.text('Fresh Seller'), findsOneWidget);
    await tester.tap(find.text('Fresh Seller'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Seller'), findsWidgets);
    expect(find.text('No messages yet.'), findsOneWidget);
    expect(find.byKey(const Key('shopThreadAttach')), findsOneWidget);
    expect(find.byKey(const Key('shopThreadSend')), findsOneWidget);
  });

  testWidgets('renders message bubble with attachment and timestamp', (tester) async {
    final repository = _Threads(
      threads: const [
        ShopConversation(
          id: 38,
          communicationId: 1,
          sellerName: 'Acme Store',
          messages: [
            ShopMessage(
              id: 10,
              senderType: 'customer',
              text: 'Here is the swatch',
              attachmentUrl: 'https://example.com/blue.png',
              attachmentName: 'blue.png',
              createdAt: '2026-10-22T11:48:00Z',
            ),
          ],
        ),
      ],
    );
    await _pump(tester, repository, signedIn: true);

    await tester.tap(find.text('Acme Store'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Here is the swatch'), findsOneWidget);
    expect(find.byType(SellerMessageAttachment), findsOneWidget);
    expect(find.byKey(const Key('shopThreadAttach')), findsOneWidget);
  });
}
