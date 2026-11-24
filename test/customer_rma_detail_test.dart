import 'package:bagisto_flutter/features/account/data/models/returns_models.dart';
import 'package:bagisto_flutter/features/account/data/repository/account_repository.dart';
import 'package:bagisto_flutter/features/account/presentation/bloc/return_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  group('Customer RMA Detail & Message Models', () {
    test('CustomerReturn formats full datetime correctly', () {
      final ret = CustomerReturn.fromJson({
        'id': 1,
        'orderId': 17,
        'orderIncrementId': '17',
        'statusId': 8,
        'statusTitle': 'Item Canceled',
        'statusColor': '#dc2626',
        'createdAt': '2026-10-05T11:29:18+05:30',
      });

      expect(ret.returnNumber, '#1');
      expect(ret.orderNumber, '#17');
      expect(ret.statusTitle, 'Item Canceled');
      expect(ret.formattedDateTime, contains('October 5, 2026'));
      expect(ret.formattedDateTime, contains('11:29:18'));
    });

    test('ReturnMessage recognizes image attachments and formats timestamp', () {
      final msgWithImage = ReturnMessage.fromJson({
        '_id': 6,
        'rmaId': 1,
        'message': 'hi',
        'isAdmin': false,
        'attachment': 'image.png',
        'attachmentUrl':
            'http://192.168.15.90/mp-app/public/storage/rma-conversation/6/82vLDaMfr116ykqpMzYZXWfdo3mdQ5EsG3NJFvl5.png',
        'createdAt': '2026-10-05T18:37:22+05:30',
      });

      expect(msgWithImage.isAdmin, false);
      expect(msgWithImage.message, 'hi');
      expect(msgWithImage.hasAttachment, true);
      expect(msgWithImage.isImageAttachment, true);
      expect(msgWithImage.attachment, 'image.png');
      expect(msgWithImage.formattedDateTime, contains('05-Oct-2026'));
      expect(msgWithImage.formattedDateTime, contains('18:37'));
    });

    test('ReturnMessage recognizes non-image attachments', () {
      final msgWithDoc = ReturnMessage.fromJson({
        '_id': 7,
        'rmaId': 1,
        'message': 'invoice pdf',
        'isAdmin': true,
        'attachment': 'receipt.pdf',
        'attachmentUrl': 'http://192.168.15.90/receipt.pdf',
        'createdAt': '2026-10-05T11:43:12+05:30',
      });

      expect(msgWithDoc.isAdmin, true);
      expect(msgWithDoc.hasAttachment, true);
      expect(msgWithDoc.isImageAttachment, false);
      expect(msgWithDoc.attachment, 'receipt.pdf');
    });

    test('ReturnMessage handles messages without attachments', () {
      final plainMsg = ReturnMessage.fromJson({
        '_id': 4,
        'rmaId': 1,
        'message': 'Your rma status has been changed to Approved',
        'isAdmin': true,
        'attachment': null,
        'attachmentUrl': null,
        'createdAt': '2026-10-05T11:43:12+05:30',
      });

      expect(plainMsg.isAdmin, true);
      expect(plainMsg.hasAttachment, false);
      expect(plainMsg.isImageAttachment, false);
      expect(plainMsg.attachment, isNull);
    });

    test('ReturnMessage recognizes attachment when only attachmentUrl is provided', () {
      final msg = ReturnMessage.fromJson({
        '_id': 10,
        'rmaId': 26,
        'message': 'look at this',
        'attachment': null,
        'attachmentUrl': 'https://example.com/storage/photo.jpg',
      });

      expect(msg.hasAttachment, true);
      expect(msg.isImageAttachment, true);
    });
  });

  group('ReturnDetailBloc attachment message sending', () {
    test('ReturnDetailBloc sends message with attachment', () async {
      final repo = _FakeRmaAccountRepository();
      final bloc = ReturnDetailBloc(repository: repo);

      bloc.add(const SendReturnMessage(
        returnId: 26,
        message: 'Here is the proof',
        attachment: 'data:image/png;base64,abc123',
        attachmentName: 'proof.png',
      ));

      final state = await bloc.stream.firstWhere(
        (s) => !s.sendingMessage && s.messages.isNotEmpty,
      );

      expect(repo.sentMessages, hasLength(1));
      expect(repo.sentMessages.first['returnId'], 26);
      expect(repo.sentMessages.first['message'], 'Here is the proof');
      expect(
        repo.sentMessages.first['attachment'],
        'data:image/png;base64,abc123',
      );
      expect(repo.sentMessages.first['attachmentName'], 'proof.png');
      expect(state.messages.last.attachment, 'proof.png');
      await bloc.close();
    });

    test(
      'ReturnDetailBloc does not send message when message text is empty even if attachment is present',
      () async {
        final repo = _FakeRmaAccountRepository();
        final bloc = ReturnDetailBloc(repository: repo);

        bloc.add(const SendReturnMessage(
          returnId: 26,
          message: '   ',
          attachment: 'data:image/png;base64,xyz789',
          attachmentName: 'photo.jpg',
        ));

        // Allow bloc event processing
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(repo.sentMessages, isEmpty);
        expect(bloc.state.messages, isEmpty);
        await bloc.close();
      },
    );
  });
}

class _FakeRmaAccountRepository extends AccountRepository {
  final List<Map<String, dynamic>> sentMessages = [];

  _FakeRmaAccountRepository()
      : super(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );

  @override
  Future<ReturnMessage> sendReturnMessage({
    required int returnId,
    required String message,
    String? attachment,
    String? attachmentName,
  }) async {
    sentMessages.add({
      'returnId': returnId,
      'message': message,
      'attachment': attachment,
      'attachmentName': attachmentName,
    });
    return ReturnMessage(
      id: 99,
      rmaId: returnId,
      message: message,
      attachment: attachmentName,
      attachmentUrl: 'https://example.com/storage/$attachmentName',
      createdAt: DateTime.now().toIso8601String(),
    );
  }
}
