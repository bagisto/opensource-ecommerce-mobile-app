import 'package:graphql_flutter/graphql_flutter.dart';

import '../error/error_mapper.dart';
import '../graphql/queries.dart';
import 'store_config.dart';

class StoreConfigException implements Exception {
  final String message;

  const StoreConfigException(this.message);

  @override
  String toString() => message;
}

/// Reads the public store settings of the current channel.
class StoreConfigRepository {
  final GraphQLClient client;

  StoreConfigRepository({required this.client});

  Future<StoreConfig> fetch() async {
    final result = await client.query(
      QueryOptions(
        document: gql(StoreConfigQueries.getStoreConfig),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw StoreConfigException(
        ErrorMapper.getUserMessage(result.exception!),
      );
    }
    final data = result.data?['storeConfig'];
    if (data is! Map<String, dynamic>) {
      throw const StoreConfigException('Store settings are unavailable');
    }
    return StoreConfig.fromJson(data);
  }
}
