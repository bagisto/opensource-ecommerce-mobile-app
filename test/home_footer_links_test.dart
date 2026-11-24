import 'package:bagisto_flutter/features/home/data/models/home_models.dart';
import 'package:bagisto_flutter/features/home/presentation/widgets/footer_links_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Install base as `ApiEnv.base` stores it: no trailing slash, and with a
/// subpath that must survive URL resolution.
const String _base = 'http://192.168.15.239/theme/api-4.9/public';

void main() {
  group('HomeFooterLink.columnsFromOptions', () {
    test('parses both columns in order and drops unusable entries', () {
      final columns = HomeFooterLink.columnsFromOptions({
        'column_1': [
          {'title': 'About Us', 'url': 'http://localhost/page/about-us'},
          {'title': '  ', 'url': 'http://localhost/page/blank-title'},
          {'title': 'No Url', 'url': ''},
          'malformed',
        ],
        'column_2': [
          {
            'title': 'Privacy Policy',
            'url': 'http://localhost/page/privacy-policy',
          },
        ],
      });

      expect(columns, hasLength(2));
      expect(columns.first.map((link) => link.title), ['About Us']);
      expect(columns.last.map((link) => link.title), ['Privacy Policy']);
    });

    test('a section saved without columns yields two empty columns', () {
      final columns = HomeFooterLink.columnsFromOptions(const {
        'column_1': 'not-a-list',
      });

      expect(columns, hasLength(2));
      expect(columns.every((column) => column.isEmpty), isTrue);
    });
  });

  group('HomeFooterLink.resolveUrl', () {
    test('rewrites admin localhost urls onto the install base', () {
      const link = HomeFooterLink(
        title: 'About Us',
        url: 'http://localhost/page/about-us',
      );

      expect(
        link.resolveUrl(_base),
        'http://192.168.15.239/theme/api-4.9/public/page/about-us',
      );
    });

    test('keeps the install subpath for a base without a trailing slash', () {
      const link = HomeFooterLink(title: 'Terms', url: 'page/terms');

      expect(
        link.resolveUrl(_base),
        'http://192.168.15.239/theme/api-4.9/public/page/terms',
      );
    });

    test('keeps query and fragment of a relative url', () {
      const link = HomeFooterLink(title: 'Help', url: '/page/help?x=1#top');

      expect(
        link.resolveUrl(_base),
        'http://192.168.15.239/theme/api-4.9/public/page/help?x=1#top',
      );
    });

    test('passes an absolute remote url through untouched', () {
      const link = HomeFooterLink(
        title: 'Blog',
        url: 'https://shop.example.com/blog',
      );

      expect(link.resolveUrl(_base), 'https://shop.example.com/blog');
    });

    test('rejects non-http schemes and empty paths', () {
      expect(
        const HomeFooterLink(
          title: 'Bad',
          url: 'javascript:alert(1)',
        ).resolveUrl(_base),
        '',
      );
      expect(
        const HomeFooterLink(
          title: 'Mail',
          url: 'mailto:hi@example.com',
        ).resolveUrl(_base),
        '',
      );
      expect(
        const HomeFooterLink(title: 'Host only', url: 'http://localhost')
            .resolveUrl(_base),
        '',
      );
    });
  });

  group('FooterLinksSection', () {
    testWidgets('renders both columns and reports the tapped link', (
      tester,
    ) async {
      final columns = HomeFooterLink.columnsFromOptions({
        'column_1': [
          {'title': 'About Us', 'url': 'http://localhost/page/about-us'},
        ],
        'column_2': [
          {
            'title': 'Privacy Policy',
            'url': 'http://localhost/page/privacy-policy',
          },
        ],
      });
      HomeFooterLink? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FooterLinksSection(
              title: 'Footer Links',
              columns: columns,
              onLinkTap: (link) => tapped = link,
            ),
          ),
        ),
      );

      expect(find.text('Footer Links'), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);

      await tester.tap(find.text('About Us'));
      expect(tapped?.title, 'About Us');
      expect(tapped?.url, 'http://localhost/page/about-us');
    });

    testWidgets('renders nothing when every column is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FooterLinksSection(
              title: 'Footer Links',
              columns: [[], []],
              onLinkTap: _ignore,
            ),
          ),
        ),
      );

      expect(find.text('Footer Links'), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });
}

void _ignore(HomeFooterLink link) {}
