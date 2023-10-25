// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RecentProductDao? _recentProductDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecentProduct` (`id` TEXT, `rating` INTEGER, `type` TEXT, `name` TEXT, `productId` TEXT, `shortDescription` TEXT, `price` TEXT, `url` TEXT, `isInWishlist` INTEGER, `isNew` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RecentProductDao get recentProductDao {
    return _recentProductDaoInstance ??=
        _$RecentProductDao(database, changeListener);
  }
}

class _$RecentProductDao extends RecentProductDao {
  _$RecentProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recentProductInsertionAdapter = InsertionAdapter(
            database,
            'RecentProduct',
            (RecentProduct item) => <String, Object?>{
                  'id': item.id,
                  'rating': item.rating,
                  'type': item.type,
                  'name': item.name,
                  'productId': item.productId,
                  'shortDescription': item.shortDescription,
                  'price': item.price,
                  'url': item.url,
                  'isInWishlist': item.isInWishlist == null
                      ? null
                      : (item.isInWishlist! ? 1 : 0),
                  'isNew': item.isNew == null ? null : (item.isNew! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecentProduct> _recentProductInsertionAdapter;

  @override
  Future<List<RecentProduct>> getProducts() async {
    return _queryAdapter.queryList('SELECT * FROM RecentProduct',
        mapper: (Map<String, Object?> row) => RecentProduct(
            url: row['url'] as String?,
            rating: row['rating'] as int?,
            id: row['id'] as String?,
            type: row['type'] as String?,
            name: row['name'] as String?,
            productId: row['productId'] as String?,
            shortDescription: row['shortDescription'] as String?,
            isInWishlist: row['isInWishlist'] == null
                ? null
                : (row['isInWishlist'] as int) != 0,
            isNew: row['isNew'] == null ? null : (row['isNew'] as int) != 0,
            price: row['price'] as String?));
  }

  @override
  Future<void> deleteRecentProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM RecentProduct');
  }

  @override
  Future<void> insertRecentProduct(RecentProduct product) async {
    await _recentProductInsertionAdapter.insert(
        product, OnConflictStrategy.abort);
  }
}
