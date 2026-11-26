import 'package:bagisto_flutter/core/store_config/store_config.dart';
import 'package:bagisto_flutter/core/store_config/store_config_cubit.dart';
import 'package:bagisto_flutter/core/store_config/store_config_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// A [StoreConfigCubit] that starts with [json] parsed as the store config.
StoreConfigCubit seededStoreConfigCubit(Map<String, dynamic> json) {
  return _SeededStoreConfigCubit(StoreConfig.fromJson(json));
}

class _SeededStoreConfigCubit extends StoreConfigCubit {
  _SeededStoreConfigCubit(StoreConfig config)
    : super(
        repository: StoreConfigRepository(
          client: GraphQLClient(
            link: HttpLink('https://example.com/graphql'),
            cache: GraphQLCache(),
          ),
        ),
      ) {
    emit(config);
  }

  @override
  Future<void> load() async {}
}
