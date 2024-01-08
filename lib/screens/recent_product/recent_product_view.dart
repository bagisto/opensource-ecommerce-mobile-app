
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_product_entity.dart';
import 'package:bagisto_app_demo/screens/recent_product/utils/recent_view_controller.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../../utils/string_constants.dart';
import '../home_page/data_model/new_product_data.dart';
import '../home_page/widget/new_product_view.dart';
import 'utils/database.dart';

class RecentView extends StatefulWidget {
  final bool? isLogin;

  const RecentView({Key? key, this.isLogin}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  List<NewProducts>? _recentProductList;
  double? size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    size = (AppSizes.screenWidth / 2.5) - AppSizes.spacingSmall;
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
          id: recentProducts[i].id,
          type: recentProducts[i].type,
          productId: recentProducts[i].productId,
          name: recentProducts[i].name,
          isInWishlist: recentProducts[i].isInWishlist,
          rating: recentProducts[i].rating.toString(),
          price: recentProducts[i].price,
          specialPrice: recentProducts[i].specialPrice,
          isNew: recentProducts[i].isNew,
          isInSale: recentProducts[i].isInSale,
          url: recentProducts[i].url,
          urlKey: recentProducts[i].urlKey
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
    return ((_recentProductList ?? []).isNotEmpty)
        ? SizedBox(
                height: (MediaQuery.of(context).size.width / 1.5) + 220,
            child: NewProductView(
                title: StringConstants.recentProducts.localized(),
                isLogin: widget.isLogin,
                isRecentProduct: true,
                model: _recentProductList))
        : const SizedBox();
  }
}
