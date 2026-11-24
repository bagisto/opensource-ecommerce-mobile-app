import 'package:bagisto_flutter/marketplace/features/products/data/html_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('htmlToPlain', () {
    test('drops the paragraph tags the web editor adds', () {
      expect(htmlToPlain('<p>dsaasd</p>'), 'dsaasd');
    });

    test('keeps paragraphs apart with a blank line', () {
      expect(htmlToPlain('<p>one</p><p>two</p>'), 'one\n\ntwo');
    });

    test('turns a line break into a newline', () {
      expect(htmlToPlain('<p>a<br>b<br/>c</p>'), 'a\nb\nc');
    });

    test('decodes entities', () {
      expect(
        htmlToPlain('<p>R&amp;D &lt;b&gt; &quot;x&quot;&nbsp;y</p>'),
        'R&D <b> "x" y',
      );
    });

    test('leaves text with no tags alone', () {
      expect(htmlToPlain('just text'), 'just text');
    });
  });

  group('plainToHtml', () {
    test('wraps text in a paragraph', () {
      expect(plainToHtml('hello'), '<p>hello</p>');
    });

    test('splits blank-line separated blocks into paragraphs', () {
      expect(plainToHtml('one\n\ntwo'), '<p>one</p><p>two</p>');
    });

    test('keeps a single newline as a line break', () {
      expect(plainToHtml('a\nb'), '<p>a<br>b</p>');
    });

    test('escapes markup the seller typed', () {
      expect(plainToHtml('a < b & c'), '<p>a &lt; b &amp; c</p>');
    });

    test('empty stays empty', () {
      expect(plainToHtml('  \n '), '');
    });

    test('round trips simple HTML', () {
      const html = '<p>one</p><p>two<br>three</p>';
      expect(plainToHtml(htmlToPlain(html)), html);
    });
  });

  group('htmlIsSimple', () {
    test('paragraphs and breaks are simple', () {
      expect(htmlIsSimple('<p>a</p><p>b<br></p>'), isTrue);
      expect(htmlIsSimple('plain'), isTrue);
      expect(htmlIsSimple(''), isTrue);
    });

    test('formatting is not simple', () {
      expect(htmlIsSimple('<p><strong>a</strong></p>'), isFalse);
      expect(htmlIsSimple('<ul><li>a</li></ul>'), isFalse);
      expect(htmlIsSimple('<p style="text-align:center">a</p>'), isFalse);
      expect(htmlIsSimple('<img src="x.png">'), isFalse);
    });
  });

  group('stripHtml', () {
    test('strips <p> and other tags from text', () {
      expect(stripHtml('<p>dsasd</p>'), 'dsasd');
      expect(stripHtml('<p>sadsad</p>'), 'sadsad');
      expect(stripHtml('<p>Hello <strong>World</strong></p>'), 'Hello World');
      expect(stripHtml('<div><p>Item 1</p><p>Item 2</p></div>'), 'Item 1\n\nItem 2');
    });

    test('converts breaks and list items', () {
      expect(stripHtml('a<br/>b'), 'a\nb');
      expect(stripHtml('<ul><li>one</li><li>two</li></ul>'), '• one\n• two');
    });

    test('decodes HTML entities', () {
      expect(stripHtml('Tom &amp; Jerry &quot;Show&quot;'), 'Tom & Jerry "Show"');
    });

    test('leaves plain text unaffected', () {
      expect(stripHtml('Simple Seller'), 'Simple Seller');
    });
  });
}
