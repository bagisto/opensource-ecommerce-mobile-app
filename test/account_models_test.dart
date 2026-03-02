import 'package:flutter_test/flutter_test.dart';
import 'package:bagisto_flutter/features/account/data/models/account_models.dart';

void main() {
  group('CustomerProfile', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': '1',
        'firstName': 'John',
        'lastName': 'Smith',
        'email': 'john_smith@mail.com',
        'dateOfBirth': '1990-01-15',
        'gender': 'male',
        'phone': '+1234567890',
      };

      final profile = CustomerProfile.fromJson(json);
      expect(profile.id, '1');
      expect(profile.firstName, 'John');
      expect(profile.lastName, 'Smith');
      expect(profile.email, 'john_smith@mail.com');
      expect(profile.displayName, 'John Smith');
      expect(profile.initials, 'JS');
      expect(profile.phone, '+1234567890');
    });

    test('displayName trims correctly', () {
      final profile = CustomerProfile.fromJson({
        'firstName': 'John',
        'lastName': '',
        'email': 'john@mail.com',
      });
      expect(profile.displayName, 'John');
    });

    test('initials handles empty names', () {
      final profile = CustomerProfile.fromJson({
        'firstName': '',
        'lastName': '',
        'email': 'user@mail.com',
      });
      expect(profile.initials, '');
    });

    test('handles null fields gracefully', () {
      final profile = CustomerProfile.fromJson({});
      expect(profile.firstName, '');
      expect(profile.lastName, '');
      expect(profile.email, '');
      expect(profile.displayName, '');
    });
  });

  group('CustomerAddress', () {
    test('fromJson parses correctly with string address', () {
      final json = {
        'id': '10',
        'firstName': 'John',
        'lastName': 'Deo',
        'companyName': 'Littel Group',
        'address': '3650 Court Street',
        'city': 'California',
        'state': 'FL',
        'country': 'US',
        'postcode': '90006',
        'phone': '+1234567890',
        'defaultAddress': true,
        'addressType': 'billing',
        'useForShipping': false,
      };

      final address = CustomerAddress.fromJson(json);
      expect(address.firstName, 'John');
      expect(address.lastName, 'Deo');
      expect(address.companyName, 'Littel Group');
      expect(address.fullName, 'John Deo (Littel Group)');
      expect(address.address, '3650 Court Street');
      expect(address.city, 'California');
      expect(address.state, 'FL');
      expect(address.country, 'US');
      expect(address.zipCode, '90006');
      expect(address.isDefault, true);
      expect(address.useForShipping, false);
      expect(address.formattedAddress, '3650 Court Street, California, FL, US, 90006');
    });

    test('fromJson parses list address', () {
      final json = {
        'firstName': 'Jane',
        'lastName': 'Doe',
        'address': ['123 Main St', 'Apt 4B'],
        'city': 'NY',
        'state': 'NY',
        'country': 'US',
        'postcode': '10001',
      };

      final address = CustomerAddress.fromJson(json);
      expect(address.address, '123 Main St, Apt 4B');
    });

    test('fullName without company', () {
      final address = CustomerAddress.fromJson({
        'firstName': 'John',
        'lastName': 'Smith',
        'address': 'Test',
        'city': 'City',
        'state': 'ST',
        'country': 'US',
        'postcode': '00000',
      });
      expect(address.fullName, 'John Smith');
    });

    test('isDefault handles different value types', () {
      expect(
        CustomerAddress.fromJson({
          'firstName': '', 'lastName': '', 'address': '',
          'city': '', 'state': '', 'country': '', 'postcode': '',
          'defaultAddress': true,
        }).isDefault,
        true,
      );
      expect(
        CustomerAddress.fromJson({
          'firstName': '', 'lastName': '', 'address': '',
          'city': '', 'state': '', 'country': '', 'postcode': '',
          'defaultAddress': 1,
        }).isDefault,
        true,
      );
      expect(
        CustomerAddress.fromJson({
          'firstName': '', 'lastName': '', 'address': '',
          'city': '', 'state': '', 'country': '', 'postcode': '',
          'defaultAddress': '1',
        }).isDefault,
        true,
      );
      expect(
        CustomerAddress.fromJson({
          'firstName': '', 'lastName': '', 'address': '',
          'city': '', 'state': '', 'country': '', 'postcode': '',
          'defaultAddress': false,
        }).isDefault,
        false,
      );
    });

    test('useForShipping is parsed correctly', () {
      final addr = CustomerAddress.fromJson({
        'firstName': 'A',
        'lastName': 'B',
        'address': 'Test',
        'city': 'C',
        'state': 'ST',
        'country': 'US',
        'postcode': '00000',
        'useForShipping': true,
      });
      expect(addr.useForShipping, true);
    });
  });

  group('RecentOrder', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': '5',
        'incrementId': 3845,
        'status': 'processing',
        'createdAt': '2025-10-08T10:30:00.000Z',
        'grandTotal': 1645.00,
        'orderCurrencyCode': 'USD',
        'items': {
          'edges': [
            {
              'node': {
                'id': '1',
                'name': 'Item 1',
                'product': {
                  'name': 'Product 1',
                  'baseImageUrl': 'https://example.com/img.jpg',
                },
              },
            },
            {
              'node': {'id': '2', 'name': 'Item 2', 'product': {}},
            },
          ],
        },
      };

      final order = RecentOrder.fromJson(json);
      expect(order.orderNumber, '#00003845');
      expect(order.status, 'processing');
      expect(order.grandTotal, 1645.00);
      expect(order.itemCount, 2);
      expect(order.formattedTotal, '\$1645.00');
      expect(order.formattedDate, '8 Oct 2025');
      expect(order.baseImageUrl, 'https://example.com/img.jpg');
    });

    test('orderNumber pads with zeros', () {
      final order = RecentOrder.fromJson({
        'incrementId': 42,
        'status': 'pending',
        'grandTotal': 0,
      });
      expect(order.orderNumber, '#00000042');
    });

    test('handles string grand total', () {
      final order = RecentOrder.fromJson({
        'status': 'completed',
        'grandTotal': '25.50',
      });
      expect(order.grandTotal, 25.50);
    });

    test('handles missing items gracefully', () {
      final order = RecentOrder.fromJson({
        'status': 'pending',
        'grandTotal': 100,
      });
      expect(order.itemCount, 0);
    });
  });

  group('WishlistItem', () {
    test('fromJson parses from product wrapper', () {
      final json = {
        'id': '1',
        'product': {
          'name': 'Abominable Hodiees',
          'price': 25.00,
          'baseImageUrl': 'https://example.com/hoodie.jpg',
          'urlKey': 'abominable-hoodies',
        },
      };

      final item = WishlistItem.fromJson(json);
      expect(item.name, 'Abominable Hodiees');
      expect(item.price, 25.00);
      expect(item.formattedPrice, '\$25.00');
      expect(item.baseImageUrl, 'https://example.com/hoodie.jpg');
    });

    test('fromJson handles string price', () {
      final json = {
        'product': {
          'name': 'Test',
          'price': '49.99',
        },
      };

      final item = WishlistItem.fromJson(json);
      expect(item.price, 49.99);
    });
  });

  group('ProductReview', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': '1',
        'name': 'John Smith',
        'title': 'Looks Fine but Not Impressive',
        'rating': 4,
        'comment': 'Absolutely love this dress!',
        'status': 1,
        'createdAt': '2024-11-25T00:00:00.000Z',
        'product': {
          'name': 'Arctic Frost Winter Accessories Bundle',
          'baseImageUrl': 'https://example.com/arctic.jpg',
        },
      };

      final review = ProductReview.fromJson(json);
      expect(review.name, 'John Smith');
      expect(review.title, 'Looks Fine but Not Impressive');
      expect(review.rating, 4);
      expect(review.comment, 'Absolutely love this dress!');
      expect(review.productName, 'Arctic Frost Winter Accessories Bundle');
      expect(review.productImageUrl, 'https://example.com/arctic.jpg');
      expect(review.formattedDate, '25 Nov 2024');
    });

    test('ratingLabel returns correct label', () {
      expect(
        ProductReview.fromJson({
          'name': '', 'title': '', 'rating': 5, 'comment': '',
        }).ratingLabel,
        'Excellent',
      );
      expect(
        ProductReview.fromJson({
          'name': '', 'title': '', 'rating': 3, 'comment': '',
        }).ratingLabel,
        'Average',
      );
      expect(
        ProductReview.fromJson({
          'name': '', 'title': '', 'rating': 2, 'comment': '',
        }).ratingLabel,
        'Below Average',
      );
      expect(
        ProductReview.fromJson({
          'name': '', 'title': '', 'rating': 1, 'comment': '',
        }).ratingLabel,
        'Poor',
      );
    });

    test('handles missing product gracefully', () {
      final review = ProductReview.fromJson({
        'name': 'Test',
        'title': 'Title',
        'rating': 3,
        'comment': 'Good',
      });
      expect(review.productName, null);
      expect(review.productImageUrl, null);
    });
  });

  group('AccountDashboardState', () {
    // Import-less test of the state's default address logic
    test('default addresses work with empty list', () {
      const addresses = <CustomerAddress>[];
      // Simulate the state logic
      CustomerAddress? billing;
      CustomerAddress? shipping;

      for (final a in addresses) {
        if (a.isDefault) {
          billing ??= a;
          if (billing != a) {
            shipping ??= a;
          }
        }
      }

      expect(billing, null);
      expect(shipping, null);
    });
  });
}
