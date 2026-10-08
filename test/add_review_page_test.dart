import 'dart:async';
import 'dart:io';

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
    expect(find.text('Nick Name *', findRichText: true), findsOneWidget);
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
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Summary is required'), findsOneWidget);
      expect(find.text('Review is required'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(repository.createReviewCalls, 0);
    },
  );
  testWidgets('tapping outside a text field closes the keyboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text('Arctic Frost Winter Accessories Bundle'));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('scrolling the form keeps the keyboard open', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.drag(
      find.text('Arctic Frost Winter Accessories Bundle'),
      const Offset(0, -200),
    );
    await tester.pump();

    expect(tester.testTextInput.isVisible, isTrue);
  });

  group('media attachments', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('add_review_media'));
    tearDown(() => dir.deleteSync(recursive: true));

    File writeFile(String name) =>
        File('${dir.path}/$name')..writeAsBytesSync([1, 2, 3]);

    testWidgets('shows the section with an add tile when empty', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp());

      expect(
        find.text('Photos & Videos', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('add_review_media_add')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('add_review_media_tile_0')),
        findsNothing,
      );
    });

    testWidgets('renders image and video tiles and removes one', (
      tester,
    ) async {
      final photo = writeFile('p.png');
      final video = writeFile('v.mp4');

      await tester.pumpWidget(
        _buildTestApp(initialAttachments: [photo, video]),
      );

      expect(
        find.byKey(const ValueKey('add_review_media_tile_0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('add_review_media_tile_1')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const ValueKey('add_review_media_remove_0')),
      );
      await tester.tap(find.byKey(const ValueKey('add_review_media_remove_0')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('add_review_media_tile_1')),
        findsNothing,
      );
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
    });

    testWidgets('tapping a video tile opens the player', (tester) async {
      final photo = writeFile('p.png');
      final video = writeFile('v.mp4');

      await tester.pumpWidget(
        _buildTestApp(initialAttachments: [photo, video]),
      );

      expect(
        find.byKey(const ValueKey('add_review_media_open_0')),
        findsNothing,
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('add_review_media_open_1')),
      );
      await tester.tap(find.byKey(const ValueKey('add_review_media_open_1')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(ReviewVideoPlayerPage), findsOneWidget);
    });

    testWidgets('hides the add tile at 5 attachments', (tester) async {
      final files = List.generate(5, (i) => writeFile('p$i.png'));

      await tester.pumpWidget(_buildTestApp(initialAttachments: files));

      expect(
        find.byKey(const ValueKey('add_review_media_tile_4')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('add_review_media_add')), findsNothing);
    });

    testWidgets('submits selected attachments', (tester) async {
      final repository = _FakeAccountRepository()..neverComplete = true;
      final photo = writeFile('p.png');

      await tester.pumpWidget(
        _buildTestApp(repository: repository, initialAttachments: [photo]),
      );

      await tester.tap(find.byIcon(Icons.star_outline_rounded).at(4));
      await tester.enterText(find.byType(TextFormField).at(0), 'Ann');
      await tester.enterText(find.byType(TextFormField).at(1), 'Nice');
      await tester.enterText(find.byType(TextFormField).at(2), 'Good');
      await tester.tap(find.text('Submit Review'));
      await tester.pump();

      expect(repository.createReviewCalls, 1);
      expect(repository.lastAttachments!.single.path, photo.path);
    });
  });
}

Widget _buildTestApp({
  AccountRepository? repository,
  List<File> initialAttachments = const [],
}) {
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
        initialAttachments: initialAttachments,
      ),
    ),
  );
}

class _FakeAccountRepository extends AccountRepository {
  int createReviewCalls = 0;
  List<File>? lastAttachments;
  bool neverComplete = false;

  _FakeAccountRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  @override
  Future<ProductReview> createProductReview({
    required int productId,
    required String title,
    required String comment,
    required int rating,
    required String name,
    List<File> attachments = const [],
  }) async {
    createReviewCalls += 1;
    lastAttachments = attachments;
    if (neverComplete) {
      return Completer<ProductReview>().future;
    }
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
