import 'package:bagisto_flutter/features/cart/data/models/cart_model.dart';
import 'package:bagisto_flutter/features/checkout/data/models/checkout_model.dart';
import 'package:bagisto_flutter/features/checkout/data/repository/checkout_repository.dart';
import 'package:bagisto_flutter/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _FakeCheckoutRepository extends CheckoutRepository {
  _FakeCheckoutRepository({required this.suspended})
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );

  final bool suspended;
  int addressCalls = 0;

  @override
  Future<bool> isCustomerSuspended() async => suspended;

  @override
  Future<List<CheckoutAddress>> getCheckoutAddresses() async {
    addressCalls++;
    return const [];
  }

  @override
  Future<List<CheckoutAddress>> getCustomerAddresses() async => const [];

  @override
  Future<List<BagistoCountry>> getCountries() async => const [];
}

void main() {
  test('suspended customer cannot start checkout', () async {
    final repository = _FakeCheckoutRepository(suspended: true);
    final bloc = CheckoutBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const InitCheckout(cart: CartModel(id: 1), isGuest: false));
    final state = await bloc.stream.firstWhere((s) => !s.isLoading);

    expect(state.isAccountSuspended, isTrue);
    expect(state.canPlaceOrder, isFalse);
    expect(repository.addressCalls, 0);
  });

  test('active customer continues to the address step', () async {
    final repository = _FakeCheckoutRepository(suspended: false);
    final bloc = CheckoutBloc(repository: repository);
    addTearDown(bloc.close);

    bloc.add(const InitCheckout(cart: CartModel(id: 1), isGuest: false));
    await bloc.stream.firstWhere((s) => !s.isLoading);

    expect(bloc.state.isAccountSuspended, isFalse);
    expect(repository.addressCalls, 1);
  });
}
