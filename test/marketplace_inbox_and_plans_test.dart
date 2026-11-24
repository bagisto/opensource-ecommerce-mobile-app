import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:bagisto_flutter/marketplace/core/api/paginated_result.dart';
import 'package:bagisto_flutter/marketplace/core/api/seller_error_mapper.dart';
import 'package:bagisto_flutter/marketplace/features/communications/data/models/seller_communication.dart';
import 'package:bagisto_flutter/marketplace/features/communications/data/repository/seller_communication_repository.dart';
import 'package:bagisto_flutter/marketplace/features/communications/presentation/bloc/seller_inbox_cubit.dart';
import 'package:bagisto_flutter/marketplace/features/communications/presentation/pages/seller_inbox_page.dart';
import 'package:bagisto_flutter/marketplace/features/plans/data/models/seller_plan.dart';
import 'package:bagisto_flutter/marketplace/features/plans/data/repository/seller_plan_repository.dart';
import 'package:bagisto_flutter/marketplace/features/plans/presentation/bloc/seller_plan_cubits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeCommunicationRepository implements SellerCommunicationRepository {
  _FakeCommunicationRepository({
    this.admin,
    this.threads = const [],
    this.thread,
    this.adminFails = false,
    this.failWith,
  });

  SellerThread? admin;
  List<SellerThread> threads;
  SellerThread? thread;

  /// Standing in for a role without the admin-thread permission.
  final bool adminFails;
  final SellerApiException? failWith;

  String? lastAdminMessage;
  Map<String, dynamic>? lastCustomerMessage;
  Map<String, dynamic>? lastBlock;
  int? lastReadCustomerId;
  String? lastSearch;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<SellerThread> adminThread({String? days}) async {
    if (adminFails) {
      throw const SellerApiException('Forbidden', SellerApiFailure.forbidden);
    }
    if (failWith != null) throw failWith!;
    return admin ?? const SellerThread(id: 0);
  }

  @override
  Future<void> messageAdmin({
    required String message,
    String? attachment,
    String? attachmentName,
  }) async {
    if (failWith != null) throw failWith!;
    lastAdminMessage = message;
  }

  @override
  Future<PaginatedResult<SellerThread>> customerThreads({
    int page = 1,
    String? search,
  }) async {
    if (failWith != null) throw failWith!;
    lastSearch = search;
    return PaginatedResult(
      items: threads,
      totalCount: threads.length,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<SellerThread> customerThread(int customerId, {String? days}) async {
    if (failWith != null) throw failWith!;
    return thread ?? SellerThread(id: customerId);
  }

  @override
  Future<void> messageCustomer({
    required int customerId,
    required String message,
    String? attachment,
    String? attachmentName,
  }) async {
    if (failWith != null) throw failWith!;
    lastCustomerMessage = {'customerId': customerId, 'message': message};
  }

  @override
  Future<void> setBlocked(int customerId, {required bool blocked}) async {
    if (failWith != null) throw failWith!;
    lastBlock = {'customerId': customerId, 'blocked': blocked};
  }

  @override
  Future<void> markCustomerThreadRead(int customerId) async {
    if (failWith != null) throw failWith!;
    lastReadCustomerId = customerId;
  }
}

class _FakePlanRepository implements SellerPlanRepository {
  _FakePlanRepository({
    this.storedPlans = const [],
    this.current,
    this.history = const [],
    this.storedPickups = const [],
    this.failWith,
  });

  List<SellerPlan> storedPlans;
  SellerSubscription? current;
  List<SellerSubscription> history;
  List<SellerPickup> storedPickups;
  final SellerApiException? failWith;

  List<SellerPaymentMethod> storedPaymentMethods = const [
    SellerPaymentMethod(method: 'moneytransfer', title: 'Money Transfer'),
  ];

  int? subscribedTo;
  int? cancelled;
  Map<String, Object?>? checkedOut;

  @override
  GraphQLClient get client => throw UnimplementedError();

  @override
  Future<List<SellerPlan>> plans() async {
    if (failWith != null) throw failWith!;
    return storedPlans;
  }

  @override
  Future<SellerSubscription?> subscription() async {
    if (failWith != null) throw failWith!;
    return current;
  }

  @override
  Future<PaginatedResult<SellerSubscription>> subscriptionHistory({
    int page = 1,
  }) async {
    if (failWith != null) throw failWith!;
    return PaginatedResult(
      items: history,
      totalCount: history.length,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<SellerSubscription> subscribe(int planId) async {
    if (failWith != null) throw failWith!;
    subscribedTo = planId;
    current = SellerSubscription(id: 1, planId: planId, isActive: true);
    return current!;
  }

  @override
  Future<void> cancelSubscription(int subscriptionId) async {
    if (failWith != null) throw failWith!;
    cancelled = subscriptionId;
  }

  @override
  Future<List<SellerPaymentMethod>> paymentMethods() async {
    if (failWith != null) throw failWith!;
    return storedPaymentMethods;
  }

  @override
  Future<SellerPlanCheckout> startPlanCheckout({
    required int planId,
    required String paymentMethod,
  }) async {
    if (failWith != null) throw failWith!;
    checkedOut = {'planId': planId, 'paymentMethod': paymentMethod};
    return SellerPlanCheckout(
      id: 20,
      planId: planId,
      status: 'pending',
      paymentMethod: paymentMethod,
      checkoutUrl: 'https://example.com/checkout/20?signature=abc',
    );
  }

  @override
  Future<PaginatedResult<SellerPickup>> pickups({int page = 1}) async {
    if (failWith != null) throw failWith!;
    return PaginatedResult(
      items: storedPickups,
      totalCount: storedPickups.length,
      lastPage: 1,
      currentPage: 1,
    );
  }

  @override
  Future<SellerPickup> pickup(int id) async => storedPickups.first;

  @override
  Future<void> updateImport(
    int id, {
    String? action,
    String? validationStrategy,
    int? allowedErrors,
    String? fieldSeparator,
  }) async {}

  @override
  Future<void> deleteImports(List<int> ids) async {}

  @override
  Future<SellerImportPhase> downloadImages(int id) async =>
      const SellerImportPhase(phase: 'images');

  @override
  Future<SellerImportPhase> imageProgress(int id) async =>
      const SellerImportPhase(phase: 'images');

  @override
  Future<SellerImportPhase> queueValidation(int id) async =>
      const SellerImportPhase(phase: 'validation');

  @override
  Future<SellerImportPhase> queuedValidationProgress(int id) async =>
      const SellerImportPhase(phase: 'validation');

  @override
  Future<SellerImportReport> importReport(int id) async =>
      const SellerImportReport(id: 1);
}

void main() {
  group('communication models', () {
    test('a message knows whose side it is on', () {
      const mine = SellerMessage(id: 1, senderType: 'seller');
      const theirs = SellerMessage(id: 2, senderType: 'customer');

      expect(mine.isMine, isTrue);
      expect(theirs.isMine, isFalse);
    });

    test('a thread titles itself from whatever the server gave it', () {
      const customer = SellerThread(id: 3, customerName: 'Aarav Sharma');
      const admin = SellerThread(id: 0);
      const adminWithSubject = SellerThread(id: 0, subject: 'shhsdh');
      const adminWithName = SellerThread(id: 0, adminName: 'Example', adminRole: 'Admin');

      expect(customer.title, 'Aarav Sharma');
      expect(admin.title, 'Marketplace admin');
      expect(adminWithSubject.title, 'Marketplace admin');
      expect(adminWithName.title, 'Example');
    });

    test('admin thread parses adminName and adminRole', () {
      final thread = SellerThread.fromJson(const {
        'id': 0,
        'adminName': 'Example',
        'adminRole': 'Admin',
        'subject': 'shhsdh',
        'unreadCount': 0,
      });

      expect(thread.adminName, 'Example');
      expect(thread.adminRole, 'Admin');
      expect(thread.title, 'Example');
    });

    test('customer thread parses customerImageUrl', () {
      final thread = SellerThread.fromJson(const {
        'id': 5,
        'customerName': 'aman kumar',
        'customerImageUrl': 'https://example.com/avatar.webp',
      });

      expect(thread.customerImageUrl, 'https://example.com/avatar.webp');
    });

    test('nested messages parse whichever id key they carry', () {
      final thread = SellerThread.fromJson(const {
        'id': 3,
        'customerName': 'Aarav',
        'unreadCount': 2,
        'messages': [
          {'_id': 7, 'senderType': 'customer', 'text': 'Do you ship to Goa?'},
          {'id': 8, 'senderType': 'seller', 'text': 'We do.'},
        ],
      });

      expect(thread.messages.map((m) => m.id), [7, 8]);
      expect(thread.unreadCount, 2);
    });
  });

  group('SellerInboxCubit', () {
    test('load reads the admin thread and the customer threads', () async {
      final cubit = SellerInboxCubit(
        repository: _FakeCommunicationRepository(
          admin: const SellerThread(id: 0, unreadCount: 1),
          threads: const [
            SellerThread(id: 3, customerName: 'Aarav', unreadCount: 2),
          ],
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerInboxStatus.loaded);
      expect(cubit.state.adminThread?.unreadCount, 1);
      expect(cubit.state.customerThreads, hasLength(1));
      expect(cubit.state.totalUnread, 3);
    });

    test(
      'a role without the admin thread still gets the customer list',
      () async {
        final cubit = SellerInboxCubit(
          repository: _FakeCommunicationRepository(
            adminFails: true,
            threads: const [SellerThread(id: 3, customerName: 'Aarav')],
          ),
        );

        await cubit.load();

        expect(cubit.state.status, SellerInboxStatus.loaded);
        expect(cubit.state.adminThread, isNull);
        expect(cubit.state.customerThreads, hasLength(1));
      },
    );

    test('replying with no customer id goes to the admin', () async {
      final repository = _FakeCommunicationRepository();
      final cubit = SellerInboxCubit(repository: repository);

      final sent = await cubit.reply('  A question about payouts.  ');

      expect(sent, isTrue);
      expect(repository.lastAdminMessage, 'A question about payouts.');
      expect(repository.lastCustomerMessage, isNull);
    });

    test('replying with a customer id goes to that customer', () async {
      final repository = _FakeCommunicationRepository();
      final cubit = SellerInboxCubit(repository: repository);

      await cubit.reply('We ship to Goa.', customerId: 3);

      expect(repository.lastCustomerMessage?['customerId'], 3);
      expect(repository.lastCustomerMessage?['message'], 'We ship to Goa.');
      expect(repository.lastAdminMessage, isNull);
    });

    test('an empty reply is not worth sending', () async {
      final repository = _FakeCommunicationRepository();
      final cubit = SellerInboxCubit(repository: repository);

      final sent = await cubit.reply('   ');

      expect(sent, isFalse);
      expect(repository.lastAdminMessage, isNull);
    });

    test('blocking and unblocking send the action', () async {
      final repository = _FakeCommunicationRepository();
      final cubit = SellerInboxCubit(repository: repository);

      await cubit.setBlocked(3, blocked: true);
      expect(repository.lastBlock, {'customerId': 3, 'blocked': true});

      await cubit.setBlocked(3, blocked: false);
      expect(repository.lastBlock, {'customerId': 3, 'blocked': false});
    });

    test(
      'opening a customer thread reads its messages and marks them read',
      () async {
        final repository = _FakeCommunicationRepository(
          threads: const [
            SellerThread(id: 3, customerName: 'Aarav', unreadCount: 2),
          ],
          thread: const SellerThread(
            id: 3,
            customerName: 'Aarav',
            unreadCount: 2,
            messages: [
              SellerMessage(
                id: 7,
                senderType: 'customer',
                text: 'Ships to Goa?',
              ),
            ],
          ),
        );
        final cubit = SellerInboxCubit(repository: repository);
        await cubit.load();

        await cubit.openCustomerThread(3);

        expect(cubit.state.openThread?.messages, hasLength(1));
        expect(repository.lastReadCustomerId, 3);
        expect(cubit.state.openThread?.unreadCount, 0);
        expect(cubit.state.customerThreads.first.unreadCount, 0);
      },
    );

    test('a failed load surfaces the server message', () async {
      final cubit = SellerInboxCubit(
        repository: _FakeCommunicationRepository(
          failWith: const SellerApiException(
            'Forbidden',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerInboxStatus.failed);
      expect(cubit.state.errorMessage, 'Forbidden');
    });

    test('a search reaches the server', () async {
      final repository = _FakeCommunicationRepository();
      final cubit = SellerInboxCubit(repository: repository);

      await cubit.search('aarav');

      expect(repository.lastSearch, 'aarav');
    });

    testWidgets('SellerInboxPage displays Admin name, role caption, and preview', (tester) async {
      final cubit = SellerInboxCubit(
        repository: _FakeCommunicationRepository(
          admin: const SellerThread(
            id: 0,
            adminName: 'Example',
            adminRole: 'Admin',
            subject: 'shhsdh',
            updatedAt: '2026-09-22T15:06:41+05:30',
          ),
        ),
      );
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: cubit,
            child: const SellerInboxPage(section: 0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // App bar has 'Admin', card role caption has 'Admin'
      expect(find.text('Admin'), findsNWidgets(2));
      // Card title has 'Example'
      expect(find.text('Example'), findsOneWidget);
      // Message preview is shown separately
      expect(find.text('shhsdh'), findsOneWidget);
    });
  });

  group('plan models', () {
    test('a missing cap reads as unlimited', () {
      const plan = SellerPlan(id: 1, name: 'Free', maxProducts: 10);

      expect(plan.limitLabel(plan.maxProducts), '10');
      expect(plan.limitLabel(null), 'Unlimited');
      expect(plan.limitLabel(0), 'Unlimited');
    });

    test('only a subscription that has not started may be cancelled', () {
      const pending = SellerSubscription(id: 1, status: 'pending');
      const active = SellerSubscription(
        id: 2,
        status: 'active',
        isActive: true,
      );

      expect(pending.canCancel, isTrue);
      expect(active.canCancel, isFalse);
    });

    test('a pickup joins both ends of its window', () {
      const pickup = SellerPickup(
        id: 1,
        scheduledFrom: '2026-08-20 09:00',
        scheduledTo: '2026-08-20 12:00',
      );

      expect(pickup.window, '2026-08-20 09:00 — 2026-08-20 12:00');
    });

    test('an import phase reports a fraction whichever scale it uses', () {
      const percent = SellerImportPhase(phase: 'images', progress: 40);
      const fraction = SellerImportPhase(phase: 'images', progress: 0.4);

      expect(percent.fraction, closeTo(0.4, 0.001));
      expect(fraction.fraction, closeTo(0.4, 0.001));
    });

    test('an import report reads what the run did', () {
      final report = SellerImportReport.fromJson(const {
        'id': 1,
        'recordsProcessed': 20,
        'recordsSkipped': 2,
        'productsCreated': 15,
        'productsUpdated': 3,
        'durationSeconds': 12,
      });

      expect(report.recordsProcessed, 20);
      expect(report.productsCreated, 15);
      expect(report.durationSeconds, 12);
    });
  });

  group('SellerPlanCubit', () {
    test(
      'load reads plans, the current subscription and the history',
      () async {
        final cubit = SellerPlanCubit(
          repository: _FakePlanRepository(
            storedPlans: const [SellerPlan(id: 1, name: 'Free', isFree: true)],
            current: const SellerSubscription(
              id: 9,
              planName: 'Free',
              isActive: true,
            ),
            history: const [SellerSubscription(id: 8, planName: 'Trial')],
          ),
        );

        await cubit.load();

        expect(cubit.state.status, SellerPlanStatus.loaded);
        expect(cubit.state.plans, hasLength(1));
        expect(cubit.state.current?.planName, 'Free');
        expect(cubit.state.history, hasLength(1));
      },
    );

    test('a marketplace with plans switched off lands on unavailable, not '
        'an error', () async {
      final cubit = SellerPlanCubit(
        repository: _FakePlanRepository(
          failWith: const SellerApiException(
            'Subscriptions are not enabled for this marketplace.',
            SellerApiFailure.unknown,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerPlanStatus.unavailable);
    });

    test('any other failure is still a failure', () async {
      final cubit = SellerPlanCubit(
        repository: _FakePlanRepository(
          failWith: const SellerApiException(
            'Forbidden',
            SellerApiFailure.forbidden,
          ),
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerPlanStatus.failed);
      expect(cubit.state.errorMessage, 'Forbidden');
    });

    test('subscribing sends the plan id', () async {
      final repository = _FakePlanRepository(
        storedPlans: const [SellerPlan(id: 4, name: 'Pro')],
      );
      final cubit = SellerPlanCubit(repository: repository);

      final ok = await cubit.subscribe(4);

      expect(ok, isTrue);
      expect(repository.subscribedTo, 4);
    });

    test('cancelling sends the subscription id', () async {
      final repository = _FakePlanRepository();
      final cubit = SellerPlanCubit(repository: repository);

      await cubit.cancel(9);

      expect(repository.cancelled, 9);
    });
  });

  group('SellerPickupsCubit', () {
    test('load reads the collections', () async {
      final cubit = SellerPickupsCubit(
        repository: _FakePlanRepository(
          storedPickups: const [
            SellerPickup(
              id: 1,
              carrierTitle: 'DHL Express',
              confirmationNumber: 'PU-4471',
              packageCount: 3,
              status: 'scheduled',
            ),
          ],
        ),
      );

      await cubit.load();

      expect(cubit.state.status, SellerPickupsStatus.loaded);
      expect(cubit.state.pickups.single.confirmationNumber, 'PU-4471');
    });

    test('no collections is a loaded screen', () async {
      final cubit = SellerPickupsCubit(repository: _FakePlanRepository());

      await cubit.load();

      expect(cubit.state.status, SellerPickupsStatus.loaded);
      expect(cubit.state.pickups, isEmpty);
    });
  });
}
