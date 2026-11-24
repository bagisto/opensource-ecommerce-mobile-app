import 'package:bagisto_flutter/features/account/presentation/pages/review_video_player_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// The first 12 bytes of an ISO-BMFF file: size, the `ftyp` box, then brand.
List<int> _header(String box, String brand) => [
  0, 0, 0, 0x14,
  ...box.codeUnits,
  ...brand.codeUnits,
];

void main() {
  group('review video container detection', () {
    test('a QuickTime movie is saved as .mov', () {
      // Exactly what the server stores for review 17, whose URL says
      // ".quicktime" and whose Content-Type says application/octet-stream.
      expect(debugVideoExtensionFor(_header('ftyp', 'qt  ')), '.mov');
    });

    test('an MP4 is saved as .mp4', () {
      expect(debugVideoExtensionFor(_header('ftyp', 'isom')), '.mp4');
      expect(debugVideoExtensionFor(_header('ftyp', 'mp42')), '.mp4');
    });

    test('bytes with no ftyp box fall back to .mp4', () {
      expect(debugVideoExtensionFor(_header('mdat', 'qt  ')), '.mp4');
    });

    test('a truncated file does not throw', () {
      expect(debugVideoExtensionFor(const [0, 0, 0]), '.mp4');
      expect(debugVideoExtensionFor(const []), '.mp4');
    });
  });
}
