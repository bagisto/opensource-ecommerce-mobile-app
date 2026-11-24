import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_bulk_ops_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_bulk_ops_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_imports_page.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_import_process_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockImportsRepo implements SellerBulkOpsRepository {
  _MockImportsRepo(this.items);

  final List<SellerImport> items;
  int updateCalls = 0;

  @override
  Future<SellerImport> updateImport(
    int id, {
    String? action,
    String? validationStrategy,
    int? allowedErrors,
    String? fieldSeparator,
    bool? processInQueue,
    String? uploadImages,
    String? file,
    String? fileName,
  }) async {
    updateCalls++;
    return items.firstWhere((item) => item.id == id);
  }

  @override
  Future<PaginatedResult<SellerImport>> imports({
    int page = 1,
    String? state,
  }) async => PaginatedResult(
    items: items,
    totalCount: items.length,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<List<SellerImportSample>> importSamples() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final sampleJobs = [
    SellerImport.fromJson(const {
      'id': 111,
      'type': 'seller_products',
      'fileName': 'sample-as-given.csv',
      'state': 'validated',
      'isValid': true,
      'completedAt': null,
    }),
    SellerImport.fromJson(const {
      'id': 110,
      'type': 'seller_assign_products',
      'fileName': 'order_tracking.csv',
      'state': 'pending',
      'isValid': false,
      'completedAt': null,
    }),
  ];

  Future<void> pumpImportsPage(
    WidgetTester tester, {
    List<SellerImport>? jobs,
    _MockImportsRepo? repository,
  }) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final repo = repository ?? _MockImportsRepo(jobs ?? sampleJobs);
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const SellerImportsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Starter spreadsheet is NOT displayed on main imports landing page',
    (tester) async {
      await pumpImportsPage(tester);

      // Should NOT have "Starter spreadsheet"
      expect(find.text('Starter spreadsheet'), findsNothing);
      expect(find.text('Starter spreadsheets'), findsNothing);

      // Has entry cards
      expect(find.byKey(const Key('sellerImportOwn')), findsOneWidget);
      expect(find.byKey(const Key('sellerImportCatalogue')), findsOneWidget);
    },
  );

  testWidgets('Search filters past uploads list by file name', (tester) async {
    await pumpImportsPage(tester);

    expect(find.text('sample-as-given.csv'), findsOneWidget);
    expect(find.text('order_tracking.csv'), findsOneWidget);
    expect(find.text('2 Results'), findsOneWidget);

    // Search for sample
    await tester.enterText(find.byType(TextField).first, 'sample');
    await tester.pumpAndSettle();

    expect(find.text('sample-as-given.csv'), findsOneWidget);
    expect(find.text('order_tracking.csv'), findsNothing);
    expect(find.text('1 Results'), findsOneWidget);
  });

  testWidgets('Past uploads card displays Web fields and no extra pipeline', (
    tester,
  ) async {
    await pumpImportsPage(tester);

    // Displays file names
    expect(find.text('sample-as-given.csv'), findsOneWidget);
    // Displays type badge
    expect(find.text('New Products'), findsOneWidget);
    expect(find.text('Catalog Products'), findsOneWidget);
    // Displays IDs
    expect(find.text('#111'), findsOneWidget);
    expect(find.text('#110'), findsOneWidget);
    // Displays states
    expect(find.text('Validated'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    // Should NOT display old extra rows processed text on list card
    expect(find.textContaining('rows read'), findsNothing);
    expect(find.textContaining('invalid rows'), findsNothing);
  });

  testWidgets('Completed falls back to the start time and the summary shows', (
    tester,
  ) async {
    await pumpImportsPage(
      tester,
      jobs: [
        // Finished run: real completion time and a summary.
        SellerImport.fromJson(const {
          'id': 91,
          'fileName': 'bulk-demo.csv',
          'state': 'pending',
          'startedAt': '2026-08-15T05:19:59+05:30',
          'completedAt': '2026-08-15T05:20:03+05:30',
          'summary': {'created': 2, 'deleted': 0, 'updated': 0},
        }),
        // Mid-run: no completion time yet, only a start, and no summary.
        SellerImport.fromJson(const {
          'id': 90,
          'fileName': 'running.csv',
          'state': 'processing',
          'startedAt': '2026-08-15T05:19:39+05:30',
          'completedAt': null,
          'summary': [],
        }),
        // Never run.
        SellerImport.fromJson(const {
          'id': 89,
          'fileName': 'idle.csv',
          'state': 'validated',
          'summary': [],
        }),
      ],
    );

    // 91 and 90 both show a date; 89 keeps the dash.
    expect(find.textContaining('Aug 2026'), findsNWidgets(2));
    expect(find.text('—'), findsOneWidget);

    // Summary chips only on the run that reported one.
    expect(find.text('Created: 2'), findsOneWidget);
    expect(find.text('Deleted: 0'), findsOneWidget);
    expect(find.text('Updated: 0'), findsOneWidget);
    expect(find.byKey(const Key('sellerImportCreated_90')), findsNothing);
  });

  testWidgets('Process arrow shows on every upload, invalid and finished too', (
    tester,
  ) async {
    await pumpImportsPage(
      tester,
      jobs: [
        // Invalid: nothing left to run.
        SellerImport.fromJson(const {
          'id': 110,
          'fileName': 'bad.csv',
          'state': 'validated',
          'isValid': false,
          'nextAction': null,
        }),
        // Finished.
        SellerImport.fromJson(const {
          'id': 91,
          'fileName': 'done.csv',
          'state': 'completed',
          'isValid': true,
          'nextAction': null,
          'completedAt': '2026-08-15T05:20:03+05:30',
        }),
        // Still has a step to run.
        SellerImport.fromJson(const {
          'id': 90,
          'fileName': 'running.csv',
          'state': 'processing',
          'nextAction': 'start',
        }),
      ],
    );

    expect(find.byKey(const Key('sellerImportRun_110')), findsOneWidget);
    expect(find.byKey(const Key('sellerImportRun_91')), findsOneWidget);
    expect(find.byKey(const Key('sellerImportRun_90')), findsOneWidget);
  });

  testWidgets('Filter button opens Apply Filters sheet', (tester) async {
    await pumpImportsPage(tester);

    final filterBtn = find.text('Filter');
    expect(filterBtn, findsOneWidget);
    await tester.tap(filterBtn);
    await tester.pumpAndSettle();

    expect(find.text('Apply Filters'), findsNWidgets(2));
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);
  });

  testWidgets(
    'Apply Filters button dynamically changes color to primary500 when filter selected and no chips show below search',
    (tester) async {
      await pumpImportsPage(tester);

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      final applyBtnFinder = find.byKey(const Key('sellerImportsApplyFilters'));
      expect(applyBtnFinder, findsOneWidget);

      // Initially no filter is selected, so background is neutral gray
      var filledBtn = tester.widget<FilledButton>(applyBtnFinder);
      expect(
        filledBtn.style?.backgroundColor?.resolve({}),
        const Color(0xFF6B7280),
      );

      // Select 'Today' preset
      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();

      // Now filter is selected, so background is AppColors.primary500
      filledBtn = tester.widget<FilledButton>(applyBtnFinder);
      expect(
        filledBtn.style?.backgroundColor?.resolve({}),
        AppColors.primary500,
      );

      // Tap Apply Filters
      await tester.tap(applyBtnFinder);
      await tester.pumpAndSettle();

      // Bottom sheet is closed
      expect(find.text('Apply Filters'), findsNothing);

      // Filter button now shows badge with count '1'
      expect(find.text('1'), findsOneWidget);

      // Chips should NOT show below search (matching Order screen pattern)
      expect(find.text('Date: Today'), findsNothing);
      expect(find.text('Clear all'), findsNothing);
    },
  );

  testWidgets(
    'Filter sheet follows the orders filter: Clear all and a date chip',
    (tester) async {
      await pumpImportsPage(tester);

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      // Same header as the orders filter.
      expect(find.text('Clear all'), findsOneWidget);
      expect(find.byKey(const Key('sellerImportQuickSelected')), findsNothing);

      // Picking a quick range shows it as a chip with a cross.
      await tester.tap(find.byKey(const Key('sellerImportQuick_this_week')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('sellerImportQuickSelected')),
        findsOneWidget,
      );

      // The cross on the chip takes the range off again.
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('sellerImportQuickSelected')),
          matching: find.byIcon(Icons.close),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sellerImportQuickSelected')), findsNothing);

      // Clear all empties what was chosen in the sheet.
      await tester.tap(find.byKey(const Key('sellerImportQuick_today')));
      await tester.enterText(
        find
            .descendant(
              of: find.byType(BottomSheet),
              matching: find.byType(TextField),
            )
            .first,
        '111',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sellerImportsFilterClear')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sellerImportQuickSelected')), findsNothing);
      expect(find.text('111'), findsNothing);
    },
  );

  testWidgets(
    'Edit settings bottom sheet matches wizard setting screen till column separator',
    (tester) async {
      await pumpImportsPage(tester);

      // Tap Edit button on first import
      final editBtn = find.byKey(const Key('sellerImportEdit_111'));
      expect(editBtn, findsOneWidget);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Edit settings'), findsOneWidget);

      // Matches setting screen controls: Action dropdown, Validation Strategy dropdown, Allowed Errors textfield, Field Separator textfield
      expect(find.byKey(const Key('sellerImportEditAction')), findsOneWidget);
      expect(
        find.byKey(const Key('sellerImportEditValidation')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('sellerImportEditAllowed')), findsOneWidget);
      expect(
        find.byKey(const Key('sellerImportEditSeparator')),
        findsOneWidget,
      );

      // Remaining controls preserved
      expect(find.byKey(const Key('sellerImportEditQueue')), findsNothing);
      expect(find.byKey(const Key('sellerImportEditSheet')), findsOneWidget);
      expect(find.byKey(const Key('sellerImportEditImages')), findsOneWidget);
      expect(find.byKey(const Key('sellerImportEditSave')), findsOneWidget);
      expect(find.text('Current uploaded file'), findsOneWidget);
      expect(find.text('sample-as-given.csv'), findsNWidgets(2));
    },
  );

  testWidgets('Reimport asks for confirmation and opens its Import screen', (
    tester,
  ) async {
    final repo = _MockImportsRepo(sampleJobs);
    await pumpImportsPage(tester, repository: repo);
    await tester.tap(find.byKey(const Key('sellerImportEdit_111')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('sellerImportEditSave')));
    await tester.tap(find.byKey(const Key('sellerImportEditSave')));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    expect(
      find.text(
        'This will validate your file and start the import. Do you want to continue?',
      ),
      findsOneWidget,
    );
    expect(repo.updateCalls, 0);

    await tester.tap(find.text('Cancel').last);
    await tester.pumpAndSettle();
    expect(repo.updateCalls, 0);
    expect(find.text('Edit settings'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sellerImportEditSave')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reimport').last);
    await tester.pumpAndSettle();
    expect(repo.updateCalls, 1);
    expect(find.byType(SellerImportProcessPage), findsOneWidget);
    expect(
      tester
          .widget<SellerImportProcessPage>(find.byType(SellerImportProcessPage))
          .importId,
      111,
    );
  });
}
