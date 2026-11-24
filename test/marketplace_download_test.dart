import 'package:bagisto_flutter/marketplace/core/io/seller_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every seller download is a link behind the session token, and the platform
/// picks the app to open a file by its extension. Naming the saved file wrongly
/// means a PDF that nothing on the phone will open.
void main() {
  group('SellerDownloader.resolveUrl', () {
    test('keeps an absolute seller download url unchanged', () {
      expect(
        SellerDownloader.resolveUrl(
          'http://example.test/theme/api-4.9/public/api/seller/invoices/3/pdf',
        ),
        'http://example.test/theme/api-4.9/public/api/seller/invoices/3/pdf',
      );
    });

    test(
      'resolves a root-relative seller download url against the api host',
      () {
        expect(
          SellerDownloader.resolveUrl('/api/seller/invoices/3/pdf'),
          'https://demo-mp-api.bagisto.com/api/seller/invoices/3/pdf',
        );
      },
    );

    test(
      'resolves a path-relative seller download url against the api base',
      () {
        expect(
          SellerDownloader.resolveUrl('api/seller/invoices/3/pdf'),
          'https://demo-mp-api.bagisto.com/api/seller/invoices/3/pdf',
        );
      },
    );
  });

  group('SellerDownloader.fileNameFor', () {
    test('a route ending in pdf becomes a pdf', () {
      // What the order detail hands over: /api/seller/invoices/3/pdf
      expect(
        SellerDownloader.fileNameFor(
          'http://host/api/seller/invoices/3/pdf',
          'application/pdf',
        ),
        endsWith('.pdf'),
      );
    });

    test('the format query names the extension', () {
      // The starter sheet is /imports/sample?format=csv -- the path alone
      // would have made it "sample" with no extension at all.
      expect(
        SellerDownloader.fileNameFor(
          'http://host/api/seller/imports/sample?format=csv',
          'text/csv; charset=utf-8',
        ),
        endsWith('.csv'),
      );
      expect(
        SellerDownloader.fileNameFor(
          'http://host/api/seller/imports/sample?format=xlsx',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
        endsWith('.xlsx'),
      );
    });

    test('the content type decides when the url cannot', () {
      expect(
        SellerDownloader.fileNameFor(
          'http://host/api/seller/imports/sample-images',
          'application/zip',
        ),
        endsWith('.zip'),
      );
    });

    test('a url that already names a file keeps that name', () {
      expect(
        SellerDownloader.fileNameFor(
          'http://host/storage/report-2026.xlsx',
          'application/octet-stream',
        ),
        'report-2026.xlsx',
      );
    });

    test('an unrecognised type still produces an openable name', () {
      final name = SellerDownloader.fileNameFor(
        'http://host/api/seller/thing',
        'application/octet-stream',
      );

      expect(name, isNotEmpty);
      expect(name, contains('.'));
    });
  });
  test('the server names the file it sends', () {
    // The barcode sheet arrives as `Content-Disposition: attachment;
    // filename=product-barcode-336.pdf`. Built from the URL's own path it
    // saved as `theme-api-4.9-public-api.pdf`, which says nothing about what
    // it is.
    expect(
      SellerDownloader.fileNameFor(
        'http://host/theme/api-4.9/public/api/seller/products/336/barcode/pdf',
        'application/pdf',
        disposition: 'attachment; filename=product-barcode-336.pdf',
      ),
      'product-barcode-336.pdf',
    );
  });

  test('a name that could climb out of the cache is refused', () {
    expect(
      SellerDownloader.fileNameFor(
        'http://host/api/seller/invoices/3/pdf',
        'application/pdf',
        disposition: 'attachment; filename="../../etc/passwd"',
      ),
      'passwd',
    );
  });

  test('no name from the server still falls back to the URL', () {
    expect(
      SellerDownloader.fileNameFor(
        'http://host/api/seller/products/336/barcode/pdf',
        'application/pdf',
      ),
      endsWith('.pdf'),
    );
  });
}
