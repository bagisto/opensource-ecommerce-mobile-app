import 'dart:async';
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_product_dao.dart';
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_product_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [RecentProduct])

abstract class AppDatabase extends FloorDatabase {
  RecentProductDao get recentProductDao;

  static AppDatabase? _database;

  static Future<AppDatabase> getDatabase() async {
    _database ??= await $FloorAppDatabase
        .databaseBuilder("bagisto_database.db")
        .build();
    return _database!;
  }
}