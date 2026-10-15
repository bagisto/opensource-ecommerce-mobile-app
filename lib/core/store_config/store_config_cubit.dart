import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'store_config.dart';
import 'store_config_repository.dart';

/// App-wide store settings. Starts empty (every feature on) and is replaced
/// by the API values once [load] succeeds.
class StoreConfigCubit extends Cubit<StoreConfig> {
  final StoreConfigRepository repository;

  StoreConfigCubit({required this.repository}) : super(const StoreConfig());

  /// Fetches the settings. On failure the previous settings stay in place.
  Future<void> load() async {
    try {
      final config = await repository.fetch();
      if (!isClosed) emit(config);
    } catch (e) {
      debugPrint('⚠️ StoreConfigCubit: load failed: $e');
    }
  }
}
