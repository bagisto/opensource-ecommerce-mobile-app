import 'package:bagisto_flutter/core/theme/app_theme.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/models/seller_bulk_ops.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/data/repository/seller_bulk_ops_repository.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/bloc/seller_bulk_ops_cubits.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_import_process_page.dart';
import 'package:bagisto_flutter/marketplace/features/marketing/presentation/pages/seller_import_wizard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

/// Running a bulk upload, the way the panel runs it.
///
/// The seller taps once and the file is validated, its images fetched, then
/// the rows created, linked and indexed. Two things stop it, both the panel's
/// own behaviour: a file that cannot be read, and a file that passes with rows
/// that would be silently dropped.
class _Imports implements SellerBulkOpsRepository {
  _Imports({required this.script, this.imagePhases = const []});

  /// What the job looks like after each phase, in order.
  final List<SellerImport> script;

  /// What each image wave answers.
  final List<SellerImportPhase> imagePhases;

  final ran = <String>[];
  int imageWaves = 0;
  int _step = 0;

  SellerImport get _current =>
      script[_step.clamp(0, script.length - 1).toInt()];

  @override
  Future<PaginatedResult<SellerImport>> imports({
    int page = 1,
    String? state,
  }) async => PaginatedResult(
    items: [_current],
    totalCount: 1,
    lastPage: 1,
    currentPage: 1,
  );

  @override
  Future<List<SellerImportSample>> importSamples() async => [
    SellerImportSample.fromJson(const {
      'type': 'seller_products',
      'csvUrl': 'http://example.test/sample.csv',
      'xmlUrl': 'http://example.test/sample.xml',
      'requiredColumns': [
        {
          'attribute_family_code': 'default',
          'columns': ['sku', 'name', 'short_description', 'guest_checkout'],
        },
      ],
    }),
  ];

  @override
  Future<SellerImport> advanceImport(SellerImport current) async {
    ran.add(current.nextAction ?? '');
    _step++;
    return _current;
  }

  @override
  Future<SellerImport> createImport({
    required String file,
    required String fileName,
    String type = 'seller_products',
    String action = 'append',
    String validationStrategy = 'skip-errors',
    int allowedErrors = 10,
    String fieldSeparator = ',',
    bool processInQueue = false,
    String? uploadImages,
    String? imagesDirectoryPath,
  }) async {
    ran.add('create:$fileName');
    return _current;
  }

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
    ran.add('update:$id');
    return _current;
  }

  @override
  Future<int> deleteImports(List<int> ids) async {
    ran.add('deleteMany:${ids.join(',')}');
    return ids.length;
  }

  @override
  Future<SellerImportPhase> prefetchImages(int id) async {
    final phase = imageWaves < imagePhases.length
        ? imagePhases[imageWaves]
        : const SellerImportPhase();
    imageWaves++;
    return phase;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

SellerImport _job({
  required String state,
  String? nextAction,
  bool? isValid,
  int errorsCount = 0,
  int invalidRows = 0,
  int processedRows = 0,
  String type = 'seller_products',
  String? completedAt,
  List<String> errors = const [],
  Map<String, dynamic> stats = const {},
  Map<String, dynamic> summary = const {},
}) {
  return SellerImport.fromJson({
    'id': 93,
    'type': type,
    'action': 'append',
    'state': state,
    'fileName': 'products.csv',
    'nextAction': nextAction,
    'isValid': isValid,
    'errorsCount': errorsCount,
    'invalidRowsCount': invalidRows,
    'processedRowsCount': processedRows,
    'errors': errors,
    'completedAt': completedAt,
    'stats': stats,
    'summary': summary,
  });
}

Future<SellerImportsCubit> _pump(
  WidgetTester tester,
  _Imports repo, {
  VoidCallback? onNavigateToProducts,
}) async {
  final cubit = SellerImportsCubit(repository: repo);
  await cubit.load();
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: SellerImportProcessPage(
          importId: 93,
          onNavigateToProducts: onNavigateToProducts,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}

void main() {
  testWidgets('upload opens the created import and starts validation', (
    tester,
  ) async {
    final repo = _Imports(
      script: [
        _job(state: 'pending', nextAction: 'validate'),
        _job(state: 'completed', completedAt: '2026-10-27'),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final id = await Navigator.of(context).push<int>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: SellerImportWizardPage(
                            kind: SellerImportKind.ownProducts,
                            initialStep: 2,
                            initialSheet: PlatformFile(
                              name: 'products.csv',
                              size: 3,
                              bytes: Uint8List.fromList([1, 2, 3]),
                            ),
                          ),
                        ),
                      ),
                    );
                    if (context.mounted && id != null) {
                      await openImportProcess(
                        context,
                        cubit: cubit,
                        importId: id,
                      );
                    }
                  },
                  child: const Text('Open wizard'),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open wizard'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sellerImportNext')));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure?'), findsOneWidget);
    expect(repo.ran, isEmpty);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(SellerImportWizardPage), findsOneWidget);
    expect(repo.ran, isEmpty);

    await tester.tap(find.byKey(const Key('sellerImportNext')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upload').last);
    await tester.pumpAndSettle();
    expect(repo.ran, ['create:products.csv', 'validate']);
    expect(find.byType(SellerImportProcessPage), findsOneWidget);
  });
  test('one tap carries a clean file all the way through', () async {
    // The panel validates, fetches images, then creates, links and indexes
    // without asking again. The app made the seller tap each phase.
    final repo = _Imports(
      script: [
        _job(state: 'pending', nextAction: 'validate'),
        _job(state: 'validated', nextAction: 'start', isValid: true),
        _job(state: 'processed', nextAction: 'link', isValid: true),
        _job(state: 'linked', nextAction: 'index', isValid: true),
        _job(
          state: 'completed',
          isValid: true,
          completedAt: '2026-08-19T10:00:00+05:30',
        ),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await cubit.run(cubit.state.imports.single);

    expect(repo.ran, ['validate', 'start', 'link', 'index']);
    expect(cubit.state.runningId, isNull);
  });

  test('the images are fetched before anything is written', () async {
    // Leave them to the create step and it pulls every URL inline, which is
    // what times a large import out.
    final repo = _Imports(
      script: [
        _job(state: 'pending', nextAction: 'validate'),
        _job(state: 'validated', nextAction: 'start', isValid: true),
        _job(
          state: 'completed',
          isValid: true,
          completedAt: '2026-08-19T10:00:00+05:30',
        ),
      ],
      imagePhases: const [
        SellerImportPhase(total: 4, processed: 2, done: false),
        SellerImportPhase(total: 4, processed: 4),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await cubit.run(cubit.state.imports.single);

    // Waves until the server says there are none left.
    expect(repo.imageWaves, 2);
    expect(repo.ran, ['validate', 'start']);
  });

  test('assigning catalogue products fetches no images', () async {
    // The listing already has them; only a seller's own upload brings any.
    final repo = _Imports(
      script: [
        _job(
          state: 'pending',
          nextAction: 'validate',
          type: 'seller_assign_products',
        ),
        _job(
          state: 'completed',
          isValid: true,
          type: 'seller_assign_products',
          completedAt: '2026-08-19T10:00:00+05:30',
        ),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await cubit.run(cubit.state.imports.single);

    expect(repo.imageWaves, 0);
  });

  test('a file whose rows would be dropped stops for the seller', () async {
    // Valid, but some rows failed and the strategy skips them. Importing the
    // remainder unasked loses products the seller thinks they uploaded.
    final repo = _Imports(
      script: [
        _job(state: 'pending', nextAction: 'validate'),
        _job(
          state: 'validated',
          nextAction: 'start',
          isValid: true,
          errorsCount: 3,
          invalidRows: 3,
          processedRows: 20,
        ),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await cubit.run(cubit.state.imports.single);

    expect(repo.ran, ['validate']);
    expect(cubit.state.isWorking, isFalse);
  });

  test('the seller can take the rows that passed', () async {
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          nextAction: 'start',
          isValid: true,
          errorsCount: 3,
        ),
        _job(
          state: 'completed',
          isValid: true,
          errorsCount: 3,
          completedAt: '2026-08-19T10:00:00+05:30',
        ),
      ],
    );
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await cubit.run(cubit.state.imports.single, force: true);

    expect(repo.ran, ['start']);
  });

  testWidgets('the screen says what the file is waiting for', (tester) async {
    final repo = _Imports(
      script: [_job(state: 'pending', nextAction: 'validate')],
    );
    await _pump(tester, repo);

    expect(find.text('Validate'), findsOneWidget);
    expect(
      find.text('Validate the file to check your import.'),
      findsOneWidget,
    );
  });

  testWidgets('a file that cannot be read shows what failed', (tester) async {
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          isValid: false,
          errorsCount: 2,
          invalidRows: 2,
          processedRows: 5,
          errors: const ['Row 2: SKU is required', 'Row 4: price is invalid'],
        ),
      ],
    );
    await _pump(tester, repo);

    expect(find.byKey(const Key('sellerImportProcessVerdict')), findsOneWidget);
    expect(find.text('Row 2: SKU is required'), findsOneWidget);
    // Nothing to carry on with — the sheet has to be corrected and sent again.
    expect(find.byKey(const Key('sellerImportProcessContinue')), findsNothing);
    // The three figures the panel prints under its verdict.
    expect(find.text('Rows read'), findsOneWidget);
    expect(find.text('Invalid rows'), findsOneWidget);
    expect(find.text('Errors'), findsOneWidget);
  });

  testWidgets('a partly good file offers to import the rest', (tester) async {
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          nextAction: 'start',
          isValid: true,
          errorsCount: 3,
          invalidRows: 3,
          processedRows: 20,
        ),
      ],
    );
    await _pump(tester, repo);

    expect(
      find.byKey(const Key('sellerImportProcessContinue')),
      findsOneWidget,
    );
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets('an already validated clean file waits for Start Import', (
    tester,
  ) async {
    // The panel shows the verdict and a Start Import button; it does not
    // import on open. Opening the screen used to run the whole import.
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          nextAction: 'start',
          isValid: true,
          processedRows: 2,
        ),
      ],
    );
    await _pump(tester, repo);

    expect(repo.ran, isEmpty);
    expect(
      find.text(
        'Your import is valid. Click on Import to start the import process.',
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('sellerImportProcessContinue')),
      findsOneWidget,
    );
  });

  testWidgets('the step track runs through the centre of the circles', (
    tester,
  ) async {
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          nextAction: 'start',
          isValid: true,
          processedRows: 2,
        ),
      ],
    );
    await _pump(tester, repo);

    final boxes = tester.widgetList<Container>(find.byType(Container)).toList();
    final circles = <double>[];
    final lines = <double>[];
    for (final element in find.byType(Container).evaluate()) {
      final box = element.renderObject! as RenderBox;
      final centre = box.localToGlobal(box.size.center(Offset.zero)).dy;
      if (box.size.height == 26 && box.size.width == 26) circles.add(centre);
      if (box.size.height == 2) lines.add(centre);
    }
    expect(boxes, isNotEmpty);
    expect(circles, hasLength(5));
    // Eight half-lines: one on the outer side of the first and last step is
    // transparent but still laid out.
    expect(lines, isNotEmpty);
    for (final line in lines) {
      expect(line, closeTo(circles.first, 0.5));
    }
    for (final circle in circles) {
      expect(circle, closeTo(circles.first, 0.5));
    }
  });

  testWidgets('a finished import says what it did', (tester) async {
    // `summary` arrives as an object; read as a string it printed
    // "{created: 2, updated: 0, deleted: 0}" at the seller.
    final job = SellerImport.fromJson(const {
      'id': 93,
      'type': 'seller_products',
      'action': 'append',
      'state': 'completed',
      'fileName': 'products.csv',
      'isValid': true,
      'processedRowsCount': 2,
      'completedAt': '2026-08-19T15:53:50+05:30',
      'summary': {'created': 2, 'updated': 0, 'deleted': 0},
    });
    final repo = _Imports(script: [job]);
    await _pump(tester, repo);

    expect(find.byKey(const Key('sellerImportProcessDone')), findsOneWidget);
    expect(job.summaryCreated, 2);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Updated'), findsOneWidget);
    // Shown at zero too, as on the panel.
    expect(find.text('Deleted'), findsOneWidget);
    expect(find.textContaining('{created'), findsNothing);
    expect(find.byKey(const Key('sellerImportProcessBack')), findsOneWidget);
  });

  testWidgets('tapping Back on a finished import navigates to products', (
    tester,
  ) async {
    var navigated = false;
    final job = SellerImport.fromJson(const {
      'id': 93,
      'type': 'seller_products',
      'action': 'append',
      'state': 'completed',
      'fileName': 'products.csv',
      'isValid': true,
      'processedRowsCount': 2,
      'completedAt': '2026-08-19T15:53:50+05:30',
      'summary': {'created': 2, 'updated': 0, 'deleted': 0},
    });
    final repo = _Imports(script: [job]);
    await _pump(tester, repo, onNavigateToProducts: () => navigated = true);

    final backButton = find.byKey(const Key('sellerImportProcessBack'));
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });
  testWidgets('opening the screen starts the run, as the panel does', (
    tester,
  ) async {
    // The panel begins the moment its process screen opens; the app made the
    // seller press a button the panel does not have. Checked live: the whole
    // pipeline is validate, start, link, index, index — five calls for a
    // two-row file, and the last one is what writes "completed".
    final repo = _Imports(
      script: [
        _job(state: 'pending', nextAction: 'validate'),
        _job(state: 'validated', nextAction: 'start', isValid: true),
        _job(state: 'processing', nextAction: 'link', isValid: true),
        _job(state: 'processing', nextAction: 'index', isValid: true),
        _job(
          state: 'completed',
          isValid: true,
          processedRows: 2,
          completedAt: '2026-08-20T13:00:00+05:30',
        ),
      ],
    );

    await _pump(tester, repo);

    expect(repo.ran, ['validate', 'start', 'link', 'index']);
    expect(find.byKey(const Key('sellerImportProcessValidate')), findsNothing);
  });

  testWidgets('a file that cannot be read is not run again', (tester) async {
    // Nothing to carry on with, so opening the screen must not start anything.
    final repo = _Imports(
      script: [
        _job(
          state: 'validated',
          isValid: false,
          errorsCount: 2,
          invalidRows: 2,
          processedRows: 2,
          errors: const ['Row(s) 1, 2: The guest checkout field is required.'],
        ),
      ],
    );

    await _pump(tester, repo);

    expect(repo.ran, isEmpty);
    // And it says why, rather than only counting the rows.
    expect(
      find.text('Row(s) 1, 2: The guest checkout field is required.'),
      findsOneWidget,
    );
  });
  testWidgets('the wizard says which columns a row must carry', (tester) async {
    // The starter sheet marks none of them, so a seller filled in the obvious
    // ones and the first upload failed on short_description, description and
    // guest_checkout — none of which a seller would guess. Checked live: the
    // same file imported cleanly once those three were filled.
    final repo = _Imports(script: [_job(state: 'pending')]);
    final cubit = SellerImportsCubit(repository: repo);
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const SellerImportWizardPage(
            kind: SellerImportKind.ownProducts,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sellerImportSheet')), findsOneWidget);
    expect(find.text('Accepted formats: CSV, XLS, XLSX, XML.'), findsOneWidget);
    expect(find.text('Every row must fill in these columns'), findsNothing);
  });
  testWidgets(
    'step 2 renders Image URLs card and Zip upload card matching web',
    (tester) async {
      final repo = _Imports(script: [_job(state: 'pending')]);
      final cubit = SellerImportsCubit(repository: repo);
      await cubit.load();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const SellerImportWizardPage(
              kind: SellerImportKind.ownProducts,
              initialStep: 1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Image URLs in the sheet'), findsOneWidget);
      expect(find.text('RECOMMENDED'), findsOneWidget);
      expect(find.text('Upload a ZIP of images'), findsOneWidget);
      expect(find.byKey(const Key('sellerImportImagesZip')), findsOneWidget);
      expect(
        find.byKey(const Key('sellerImportDownloadSampleImagesZip')),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'step 3 renders Settings dropdowns and textfields matching web while keeping background queue',
    (tester) async {
      final repo = _Imports(script: [_job(state: 'pending')]);
      final cubit = SellerImportsCubit(repository: repo);
      await cubit.load();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const SellerImportWizardPage(
              kind: SellerImportKind.ownProducts,
              initialStep: 2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Create/Update'), findsOneWidget);
      expect(find.text('Validation Strategy'), findsOneWidget);
      expect(find.text('Stop on Errors'), findsOneWidget);
      expect(
        find.byKey(const Key('sellerImportAllowedErrors')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('sellerImportSeparator')), findsOneWidget);
      expect(find.byKey(const Key('sellerImportQueue')), findsNothing);
    },
  );
  testWidgets(
    'the wizard renders Download Sample buttons and invokes onDownload',
    (tester) async {
      final downloaded = <String>[];
      final repo = _Imports(script: [_job(state: 'pending')]);
      final cubit = SellerImportsCubit(repository: repo);
      await cubit.load();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: SellerImportWizardPage(
              kind: SellerImportKind.ownProducts,
              onDownload: (_, url) => downloaded.add(url),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Download Sample:'), findsOneWidget);
      expect(
        find.byKey(const Key('sellerImportDownloadSample_csv')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('sellerImportDownloadSample_xls')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('sellerImportDownloadSample_xlsx')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('sellerImportDownloadSample_xml')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('sellerImportDownloadSample_csv')));
      await tester.pump();
      expect(downloaded, contains('http://example.test/sample.csv'));
    },
  );
  test(
    'a screen is not left busy after an upload, edit or delete succeeds',
    () async {
      // The busy flag was lowered only when something FAILED. After a
      // successful upload it stayed raised, and with it the whole screen: the
      // upload button kept spinning and Validate, Edit and Delete were disabled
      // on every row until the seller left and came back.
      final repo = _Imports(
        script: [_job(state: 'pending', nextAction: 'validate')],
      );
      final cubit = SellerImportsCubit(repository: repo);
      addTearDown(cubit.close);

      await cubit.load();
      expect(cubit.state.isWorking, isFalse);

      expect(
        await cubit.create(
          base64File: 'data:text/csv;base64,eA==',
          fileName: 'a.csv',
        ),
        isA<SellerImport>(),
      );
      expect(
        cubit.state.isWorking,
        isFalse,
        reason: 'upload left the screen busy',
      );

      expect(await cubit.updateSettings(93, allowedErrors: 25), isTrue);
      expect(
        cubit.state.isWorking,
        isFalse,
        reason: 'edit left the screen busy',
      );

      expect(await cubit.deleteMany([93]), isTrue);
      expect(
        cubit.state.isWorking,
        isFalse,
        reason: 'delete left the screen busy',
      );
    },
  );
  testWidgets('a sheet whose columns do not match stops, and says why', (
    tester,
  ) async {
    // Checked live: validate SUCCEEDS on such a file, names the problem on
    // errors, and leaves isValid null with nextAction still "validate". A
    // client following nextAction as the collection instructs would call it
    // for ever — the seller saw a "Next: validate" that never went away.
    final stuck = _job(
      state: 'validated',
      nextAction: 'validate',
      errorsCount: 2,
      errors: const ['Required columns not found: sku.'],
    );
    final repo = _Imports(script: [stuck, stuck, stuck]);
    final cubit = SellerImportsCubit(repository: repo);
    addTearDown(cubit.close);
    await cubit.load();

    final ok = await cubit.run(stuck);

    expect(ok, isFalse);
    // One attempt, not two hundred.
    expect(repo.ran, ['validate']);
    expect(cubit.state.errorMessage, 'Required columns not found: sku.');
    expect(cubit.state.isWorking, isFalse);
  });
  test(
    'indexing with unchanged processedRowsCount does not falsely stall and completes',
    () async {
      final repo = _Imports(
        script: [
          _job(
            state: 'indexed',
            nextAction: 'index',
            processedRows: 11,
            stats: const {'remainingBatches': 1, 'completedBatches': 0},
          ),
          _job(
            state: 'indexed',
            nextAction: 'index',
            processedRows: 11,
            stats: const {'remainingBatches': 0, 'completedBatches': 1},
          ),
          _job(
            state: 'completed',
            processedRows: 11,
            summary: const {'updated': 11},
          ),
        ],
      );
      final cubit = SellerImportsCubit(repository: repo);
      await cubit.load();
      addTearDown(cubit.close);

      final ok = await cubit.run(cubit.state.imports.single);

      expect(ok, isTrue);
      expect(repo.ran, ['index', 'index']);
      expect(cubit.state.imports.single.isFinished, isTrue);
    },
  );
  testWidgets(
    'completed import without completedAt renders congratulation success',
    (tester) async {
      final finished = _job(
        state: 'completed',
        processedRows: 11,
        summary: const {'created': 0, 'updated': 11, 'deleted': 0},
        completedAt: null,
      );
      await _pump(tester, _Imports(script: [finished]));

      expect(find.byKey(const Key('sellerImportProcessDone')), findsOneWidget);
      expect(
        find.text('Congratulations! Your import was successful.'),
        findsOneWidget,
      );
      expect(find.text('11'), findsOneWidget);
    },
  );
}
