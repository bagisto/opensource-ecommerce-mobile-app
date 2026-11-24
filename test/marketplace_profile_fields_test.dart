import 'package:bagisto_flutter/marketplace/features/account/data/models/seller_profile.dart';
import 'package:flutter_test/flutter_test.dart';

/// The profile form is built from what the marketplace says its fields are, so
/// the mapping from an attribute code to the mutation argument that writes it
/// is the whole contract. Get it wrong and the field silently never saves.
void main() {
  group('SellerProfileAttribute', () {
    test('every field the live profile returns has a mutation argument', () {
      // The 22 codes the marketplace answers with, checked against the 21
      // writable arguments on updateSellerProfileInput.
      const codes = [
        'name',
        'email',
        'phone',
        'slug',
        'business_name',
        'business_description',
        'return_policy',
        'shipping_policy',
        'privacy_policy',
        'meta_title',
        'meta_keywords',
        'meta_description',
        'address',
        'city',
        'country',
        'state',
        'postcode',
        'facebook',
        'instagram',
        'youtube',
        'min_order_amount',
        'google_analytics_id',
      ];

      for (final code in codes) {
        final attribute = SellerProfileAttribute(
          code: code,
          name: code,
          type: 'text',
        );
        expect(
          attribute.inputField,
          isNotNull,
          reason: '$code would never be written',
        );
      }
    });

    test('snake_case codes map to the camelCase the mutation takes', () {
      String? field(String code) =>
          SellerProfileAttribute(code: code, name: '', type: 'text').inputField;

      expect(field('business_name'), 'businessName');
      expect(field('min_order_amount'), 'minOrderAmount');
      expect(field('google_analytics_id'), 'googleAnalyticsId');
      expect(field('meta_description'), 'metaDescription');
    });

    test('an attribute the admin adds later has no argument of its own', () {
      // It travels in the mutation's `attributes` list instead.
      const custom = SellerProfileAttribute(
        code: 'vat_number',
        name: 'VAT number',
        type: 'text',
      );

      expect(custom.inputField, isNull);
    });

    test('the profile parses the attribute list the server sends', () {
      final profile = SellerProfile.fromJson(const {
        'name': 'Ashif',
        'email': 'seller@example.com',
        'profileAttributes': [
          {
            'code': 'business_name',
            'name': 'Business name',
            'type': 'text',
            'value': 'Acme Store',
          },
          {
            'code': 'address',
            'name': 'Address',
            'type': 'textarea',
            'value': '1 Market St',
          },
        ],
      });

      expect(profile.attributes, hasLength(2));
      expect(profile.attributes.last.type, 'textarea');
      expect(profile.attributes.last.value, '1 Market St');
    });

    test('a marketplace that sends no attribute list is empty, not broken', () {
      final profile = SellerProfile.fromJson(const {
        'name': 'Ashif',
        'email': 'seller@example.com',
      });

      expect(profile.attributes, isEmpty);
    });
  });

  group('SellerProfileSection', () {
    test('each field lands on the tab a seller would look for it on', () {
      expect(
        SellerProfileSection.of('business_name'),
        SellerProfileSection.general,
      );
      expect(SellerProfileSection.of('city'), SellerProfileSection.address);
      expect(
        SellerProfileSection.of('return_policy'),
        SellerProfileSection.policies,
      );
      expect(SellerProfileSection.of('meta_title'), SellerProfileSection.seo);
      expect(
        SellerProfileSection.of('google_analytics_id'),
        SellerProfileSection.seo,
      );
      expect(SellerProfileSection.of('instagram'), SellerProfileSection.social);
    });

    test('an unknown attribute still gets a home', () {
      expect(SellerProfileSection.of('vat_number'), SellerProfileSection.other);
    });
  });
}
