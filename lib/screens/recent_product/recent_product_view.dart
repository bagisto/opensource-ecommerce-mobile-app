import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/screens/recent_product/recent_product_entity.dart';
import 'package:bagisto_app_demo/screens/recent_product/recent_view_controller.dart';
import 'package:flutter/material.dart';

import '../../configuration/app_sizes.dart';
import '../../models/homepage_model/new_product_data.dart';
import '../homepage/view/new_product_view.dart';
import 'database.dart';

class RecentView extends StatefulWidget {
  final bool ? islogin;

  const RecentView({Key? key, this.islogin}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  List<NewProducts>? _recentProductList;
  double ? size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    size = (AppSizes.width / 2.5) - AppSizes.linePadding;
    fetchRecentProducts();
     RecentViewController.controller.stream.listen((event) {
      fetchRecentProducts();
     });

    super.initState();
  }

  void fetchRecentProducts() async {
    List<RecentProduct> recentProducts =
    await (await AppDatabase.getDatabase()).recentProductDao.getProducts();
    List<NewProducts> mRecentProducts = [];

    for (var i = recentProducts.length - 1; i >= 0; i--) {
      if (mRecentProducts.length < 5) {
        mRecentProducts.add(NewProducts(
          id:recentProducts[i].id,
          type:recentProducts[i].type,
          productId:recentProducts[i].productId,
          name: recentProducts[i].name,
          isInWishlist: recentProducts[i].isInWishlist,
          rating: recentProducts[i].rating.toString(),
          price: recentProducts[i].price,
          isNew: recentProducts[i].isNew,
          url:recentProducts[i].url,

        ));
      }
    }

    _recentProductList = mRecentProducts;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ((_recentProductList ?? []).isNotEmpty) ?
    ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight:
            (MediaQuery.of(context).size.width / 2.5) + 220),child: NewProductView(title: "recentProducts".localized(),isLogin:widget.islogin,model: _recentProductList)):
    Container();
  }

}
