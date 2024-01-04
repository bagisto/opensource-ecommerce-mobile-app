

import 'package:bagisto_app_demo/screens/recent_product/utils/recent_product_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class RecentProductDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecentProduct(RecentProduct product);

  @Query('SELECT * FROM RecentProduct')
  Future<List<RecentProduct>> getProducts();
  @Query("DELETE FROM RecentProduct")
  Future<void> deleteRecentProducts();

}