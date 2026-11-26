import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/store_config/store_config_repository.dart';
import 'package:bagisto_flutter/features/home/presentation/home_refresh.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _CountingRepository extends StoreConfigRepository {
  _CountingRepository()
    : super(
        client: GraphQLClient(
          link: HttpLink('https://example.com/graphql'),
          cache: GraphQLCache(),
        ),
      );

  int fetches = 0;

  @override
  Future<StoreConfig> fetch() async {
    fetches++;
    return const StoreConfig(wishlistEnabled: false);
  }
}

void main() {
  test('home pull-to-refresh reloads home and store config', () async {
    final repository = _CountingRepository();
    final cubit = StoreConfigCubit(repository: repository);
    addTearDown(cubit.close);
    var homeReloads = 0;

    await refreshHomeData(
      reloadHome: () async => homeReloads++,
      storeConfig: cubit,
    );

    expect(homeReloads, 1);
    expect(repository.fetches, 1);
    expect(cubit.state.showWishlist, isFalse);
  });

  test('home refresh still works without a store config cubit', () async {
    var homeReloads = 0;

    await refreshHomeData(reloadHome: () async => homeReloads++);

    expect(homeReloads, 1);
  });
}
