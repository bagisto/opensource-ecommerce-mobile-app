
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/recent_product/utils/index.dart';
import 'package:hive/hive.dart';
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
    Box box = await Hive.openBox("recentProducts");
    List<NewProducts> mRecentProducts = [];

    for (var i = box.length - 1; i >= 0; i--) {
      if (mRecentProducts.length < 5) {
        var product = box.getAt(i) as NewProducts;
        mRecentProducts.add(product);
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
