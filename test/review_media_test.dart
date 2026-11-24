import 'package:bagisto_flutter/features/account/data/models/review_attachment.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/review_attachments_strip.dart';
import 'package:bagisto_flutter/features/account/presentation/widgets/review_video_thumbnail.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('ReviewAttachment file type validation', () {
    test('detects video from the explicit type field', () {
      final parsed = ReviewAttachment.parseList(
        '[{"type":"video","url":"https://x.test/a.bin"}]',
      );

      expect(parsed, hasLength(1));
      expect(parsed.single.isVideo, isTrue);
    });

    test('detects video from a mime-style type prefix', () {
      final parsed = ReviewAttachment.parseList([
        {'type': 'video/mp4', 'url': 'https://x.test/a.bin'},
      ]);

      expect(parsed.single.isVideo, isTrue);
    });

    test('falls back to the url extension when type is absent', () {
      final parsed = ReviewAttachment.parseList([
        {'url': 'https://x.test/clip.mov'},
        {'url': 'https://x.test/photo.jpg'},
        {'url': 'https://x.test/clip.webm?v=2'},
      ]);

      expect(parsed.map((a) => a.isVideo), [true, false, true]);
    });

    test('treats an unknown extension as an image', () {
      final parsed = ReviewAttachment.parseList([
        {'url': 'https://x.test/file.xyz'},
      ]);

      expect(parsed.single.isVideo, isFalse);
    });

    test('never throws on malformed data', () {
      expect(ReviewAttachment.parseList(null), isEmpty);
      expect(ReviewAttachment.parseList(''), isEmpty);
      expect(ReviewAttachment.parseList('not json'), isEmpty);
      expect(ReviewAttachment.parseList('{"a":1}'), isEmpty);
      // Entries without a usable url are dropped.
      expect(
        ReviewAttachment.parseList([
          {'type': 'video'},
          {'url': '   '},
          'junk',
        ]),
        isEmpty,
      );
    });
  });

  group('ReviewAttachmentsStrip video thumbnails', () {
    testWidgets('renders nothing when there are no attachments', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ReviewAttachmentsStrip(attachments: [])),
      );

      expect(find.byType(ReviewVideoThumbnail), findsNothing);
      expect(find.byType(Wrap), findsNothing);
    });

    testWidgets('gives a video attachment a ReviewVideoThumbnail', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const ReviewAttachmentsStrip(
            attachments: [
              ReviewAttachment(
                type: ReviewAttachmentType.video,
                url: 'https://x.test/clip.mp4',
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ReviewVideoThumbnail), findsOneWidget);
      // Play affordance is visible even before the frame decodes.
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an image attachment gets no video thumbnail', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ReviewAttachmentsStrip(
            attachments: [
              ReviewAttachment(
                type: ReviewAttachmentType.image,
                url: 'https://x.test/photo.jpg',
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ReviewVideoThumbnail), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('mixed attachments only thumbnail the videos', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ReviewAttachmentsStrip(
            attachments: [
              ReviewAttachment(
                type: ReviewAttachmentType.image,
                url: 'https://x.test/photo.jpg',
              ),
              ReviewAttachment(
                type: ReviewAttachmentType.video,
                url: 'https://x.test/clip.mp4',
              ),
              ReviewAttachment(
                type: ReviewAttachmentType.video,
                url: 'https://x.test/clip2.mov',
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(ReviewVideoThumbnail), findsNWidgets(2));
      expect(find.byKey(const ValueKey('review_attachment_0')), findsOneWidget);
      expect(find.byKey(const ValueKey('review_attachment_2')), findsOneWidget);
    });
  });
}
