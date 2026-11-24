import 'package:bagisto_flutter/features/account/data/models/account_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/add_review_bloc.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/add_review_page.dart';
import 'package:bagisto_flutter/features/account/presentation/pages/review_video_player_page.dart';
import 'package:bagisto_flutter/features/auth/data/repository/auth_repository.dart';
import 'package:bagisto_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('required review fields are marked before submission', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    expect(find.text('Rating *', findRichText: true), findsOneWidget);
    expect(find.text('Nick Name *', findRichText: true), findsNothing);
    expect(find.text('Summary *', findRichText: true), findsOneWidget);
    expect(find.text('Review *', findRichText: true), findsOneWidget);
  });

  testWidgets(
    'submitting an empty review shows inline required errors and does not submit',
    (WidgetTester tester) async {
      final repository = _FakeAccountRepository();

      await tester.pumpWidget(_buildTestApp(repository: repository));

      await tester.tap(find.text('Submit Review'));
      await tester.pump();

      expect(find.text('Please select a rating'), findsOneWidget);
      expect(find.text('Name is required'), findsNothing);
      expect(find.text('Summary is required'), findsOneWidget);
      expect(find.text('Review is required'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(repository.createReviewCalls, 0);
    },
  );

  testWidgets(
    'a valid submission sends the signed-in customer\'s own name, not a typed one',
    (WidgetTester tester) async {
      final repository = _FakeAccountRepository();

      await tester.pumpWidget(_buildTestApp(repository: repository));

      await tester.tap(find.byIcon(Icons.star_outline_rounded).first);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Great fit and warm',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Kept me warm all winter, would buy again.',
      );

      await tester.tap(find.text('Submit Review'));
      await tester.pump();

      expect(repository.createReviewCalls, 1);
      expect(repository.lastSubmittedName, 'Jamie Rivera');
    },
  );
}

Widget _buildTestApp({AccountRepository? repository}) {
  final accountRepository = repository ?? _FakeAccountRepository();

  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // The page reads AuthBloc to prefill the reviewer's name.
    home: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            repository: AuthRepository(
              client: GraphQLClient(
                link: HttpLink('https://example.com/graphql'),
                cache: GraphQLCache(store: InMemoryStore()),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => AddReviewBloc(repository: accountRepository),
        ),
      ],
      child: AddReviewPage(
        productId: 10,
        productName: 'Arctic Frost Winter Accessories Bundle',
      ),
    ),
  );
}

class _FakeAccountRepository extends AccountRepository {
  int createReviewCalls = 0;
  String? lastSubmittedName;

  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<CustomerProfile> getCustomerProfile() async {
    return const CustomerProfile(
      firstName: 'Jamie',
      lastName: 'Rivera',
      email: 'jamie@example.com',
    );
  }

  @override
  Future<ProductReview> createProductReview({
    required int productId,
    required String title,
    required String comment,
    required int rating,
    required String name,
    List<String>? attachmentPaths,
  }) async {
    createReviewCalls += 1;
    lastSubmittedName = name;
    return ProductReview(
      id: '1',
      name: name,
      title: title,
      comment: comment,
      rating: rating,
      createdAt: '2026-05-22T10:00:00.000Z',
    );
  }
}
