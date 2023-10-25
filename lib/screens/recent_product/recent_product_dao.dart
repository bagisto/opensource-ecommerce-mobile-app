

import 'package:bagisto_app_demo/screens/recent_product/recent_product_entity.dart';
import 'package:floor/floor.dart';
@dao
abstract class RecentProductDao {
  @Query('SELECT * FROM RecentProduct')
  Future<List<RecentProduct>> getProducts();
  @Query("DELETE FROM RecentProduct")
  Future<void> deleteRecentProducts();

  @insert
  Future<void> insertRecentProduct(RecentProduct product);

}