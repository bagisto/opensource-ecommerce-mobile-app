import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/cart/data/repository/cart_repository.dart';
import 'package:bagisto_flutter/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:bagisto_flutter/features/category/data/models/product_model.dart';
import 'package:bagisto_flutter/features/checkout/data/models/checkout_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeCartRepository extends CartRepository {
  _FakeCartRepository()
      : super(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(store: InMemoryStore()),
          ),
        );

  EstimateShippingResult? fakeEstimateResult;
  List<ProductModel> fakeCrossSells = [];
  bool shouldThrow = false;

  @override
  Future<EstimateShippingResult> estimateShipping({
    required String country,
    String? state,
    String? postcode,
    String? shippingMethod,
  }) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return fakeEstimateResult ??
        const EstimateShippingResult(
          cart: CartModel(id: 1),
          shippingMethods: [
            ShippingRate(
              id: '1',
              code: 'flatrate_flatrate',
              carrier: 'flatrate',
              carrierTitle: 'Flat Rate',
              method: 'flatrate_flatrate',
              methodTitle: 'Flat Rate',
              price: 10.0,
              formattedPrice: '\$10.00',
              basePrice: 10.0,
              baseFormattedPrice: '\$10.00',
            ),
          ],
        );
  }

  @override
  Future<List<ProductModel>> getCartCrossSellProducts() async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return fakeCrossSells;
  }
}

void main() {
  group('StoreConfig Cart Admin Toggles', () {
    test('parses estimateShippingEnabled and cartCrossSellEnabled correctly', () {
      final json = {
        'estimateShippingEnabled': true,
        'cartCrossSellEnabled': false,
      };
      final config = StoreConfig.fromJson(json);
      expect(config.estimateShippingEnabled, isTrue);
      expect(config.showEstimateShipping, isTrue);
      expect(config.cartCrossSellEnabled, isFalse);
      expect(config.showCartCrossSell, isFalse);
    });

    test('defaults to true when keys are missing or null', () {
      final config = StoreConfig.fromJson({});
      expect(config.showEstimateShipping, isTrue);
      expect(config.showCartCrossSell, isTrue);
    });
  });

  group('Estimate Shipping Models', () {
    test('CartModel.hasStockableItems returns true when physical items present', () {
      const cart = CartModel(
        id: 1,
        items: [
          CartItemModel(
            id: 10,
            cartId: 1,
            productId: 100,
            price: 50.0,
            type: 'simple',
            name: 'T-Shirt',
            quantity: 1,
          ),
        ],
      );
      expect(cart.hasStockableItems, isTrue);
      expect(cart.isVirtualOnly, isFalse);
    });

    test('CartModel.hasStockableItems returns false for virtual/downloadable/booking cart', () {
      const cart = CartModel(
        id: 2,
        items: [
          CartItemModel(
            id: 11,
            cartId: 2,
            productId: 101,
            price: 100.0,
            type: 'booking',
            name: 'Hotel Booking',
            quantity: 1,
          ),
          CartItemModel(
            id: 12,
            cartId: 2,
            productId: 102,
            price: 50.0,
            type: 'virtual',
            name: 'Consultation',
            quantity: 1,
          ),
        ],
      );
      expect(cart.hasStockableItems, isFalse);
      expect(cart.isVirtualOnly, isTrue);
    });

    test('CartModel.fromJson parses estimateShipping response cart structure correctly', () {
      final json = {
        'id': '100',
        'shippingAmount': 15.0,
        'formattedShippingAmount': '\$15.00',
        'taxAmount': 5.0,
        'formattedTaxAmount': '\$5.00',
        'grandTotal': 120.0,
        'formattedGrandTotal': '\$120.00',
      };

      final cart = CartModel.fromJson(json);
      expect(cart.id, 100);
      expect(cart.grandTotal, 120.0);
      expect(cart.formattedGrandTotal, '\$120.00');
      expect(cart.shippingAmount, 15.0);
      expect(cart.formattedShippingAmount, '\$15.00');
      expect(cart.taxAmount, 5.0);
      expect(cart.formattedTaxAmount, '\$5.00');
    });
  });

  group('CartBloc Estimate Shipping and Cross-Sell Events', () {
    late _FakeCartRepository repository;
    late CartBloc bloc;

    setUp(() {
      repository = _FakeCartRepository();
      bloc = CartBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('EstimateShippingEvent updates state with shipping methods', () async {
      repository.fakeEstimateResult = const EstimateShippingResult(
        cart: CartModel(id: 1),
        shippingMethods: [
          ShippingRate(
            id: '1',
            code: 'flatrate_flatrate',
            carrier: 'flatrate',
            carrierTitle: 'Flat Rate',
            method: 'flatrate_flatrate',
            methodTitle: 'Flat Rate',
            price: 10.0,
            formattedPrice: '\$10.00',
            basePrice: 10.0,
            baseFormattedPrice: '\$10.00',
          ),
        ],
      );

      bloc.add(const EstimateShippingEvent(
        country: 'US',
        state: 'CA',
        postcode: '90210',
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((s) => s.isEstimatingShipping == true),
          predicate<CartState>((s) =>
              s.isEstimatingShipping == false &&
              s.estimatedShippingMethods.length == 1 &&
              s.estimatedShippingMethods.first.method == 'flatrate_flatrate'),
        ]),
      );
    });

    test('SelectEstimatedShippingMethodEvent updates cart with selected rate', () async {
      repository.fakeEstimateResult = const EstimateShippingResult(
        selectedShippingRate: 'flatrate_flatrate',
        cart: CartModel(
          id: 1,
          grandTotal: 110.0,
          formattedGrandTotal: '\$110.00',
          shippingAmount: 10.0,
          formattedShippingAmount: '\$10.00',
        ),
        shippingMethods: [
          ShippingRate(
            id: '1',
            code: 'flatrate_flatrate',
            carrier: 'flatrate',
            carrierTitle: 'Flat Rate',
            method: 'flatrate_flatrate',
            methodTitle: 'Flat Rate',
            price: 10.0,
            formattedPrice: '\$10.00',
            basePrice: 10.0,
            baseFormattedPrice: '\$10.00',
          ),
        ],
      );

      bloc.add(const SelectEstimatedShippingMethodEvent(
        method: 'flatrate_flatrate',
        country: 'US',
        state: 'CA',
        postcode: '90210',
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((s) => s.isEstimatingShipping == true),
          predicate<CartState>((s) =>
              s.isEstimatingShipping == false &&
              s.selectedEstimatedShippingRate == 'flatrate_flatrate' &&
              s.cart.grandTotal == 110.0 &&
              s.cart.shippingAmount == 10.0),
        ]),
      );
    });

    test('FetchCartCrossSellProductsEvent fetches cross sell items when cart is not empty', () async {
      const product = ProductModel(
        id: '1',
        numericId: 1,
        name: 'Matching Cushion',
        price: 25.0,
        formattedPrice: '\$25.00',
      );
      repository.fakeCrossSells = [product];

      // Simulate cart with item
      bloc.emit(bloc.state.copyWith(
        cart: const CartModel(
          id: 1,
          items: [
            CartItemModel(
              id: 10,
              cartId: 1,
              productId: 100,
              name: 'Sofa',
              price: 300,
              quantity: 1,
            ),
          ],
        ),
      ));

      bloc.add(const FetchCartCrossSellProductsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((s) => s.isLoadingCrossSells == true),
          predicate<CartState>((s) =>
              s.isLoadingCrossSells == false &&
              s.crossSellProducts.length == 1 &&
              s.crossSellProducts.first.name == 'Matching Cushion'),
        ]),
      );
    });

    test('ResetEstimateShippingEvent resets all estimated shipping fields and rates', () async {
      // Simulate state with active estimate values
      bloc.emit(bloc.state.copyWith(
        estimatedCountry: 'US',
        estimatedState: 'CA',
        estimatedPostcode: '90210',
        selectedEstimatedShippingRate: 'flatrate_flatrate',
        estimatedShippingMethods: const [
          ShippingRate(
            id: '1',
            code: 'flatrate_flatrate',
            carrier: 'flatrate',
            method: 'flatrate_flatrate',
            price: 10.0,
          ),
        ],
      ));

      expect(bloc.state.estimatedCountry, 'US');
      expect(bloc.state.estimatedShippingMethods.isNotEmpty, isTrue);

      bloc.add(const ResetEstimateShippingEvent());

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((s) =>
            s.estimatedCountry == null &&
            s.estimatedState == null &&
            s.estimatedPostcode == null &&
            s.selectedEstimatedShippingRate == null &&
            s.estimatedShippingMethods.isEmpty &&
            s.isEstimatingShipping == false)),
      );
    });
  });
}
