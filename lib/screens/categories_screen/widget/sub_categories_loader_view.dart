/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/categories_screen/utils/index.dart';


class SubCategoriesLoader extends StatelessWidget {
  const SubCategoriesLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              builder: Padding(
                padding:  const EdgeInsets.fromLTRB(8,8,8,0),
                child: Container(
                  height: 400,
                  color: Colors.red,
                ),
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              builder: Padding(
                padding:  const EdgeInsets.all(8),
                child: Container(
                  height: 60,
                  color: Colors.red,
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
            child: SkeletonGridLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              items: 10,
              builder:const Card(color: Colors.red,margin: EdgeInsets.zero,),childAspectRatio:0.5,mainAxisSpacing: 4,crossAxisSpacing: 4,),
          )
        ],
      ),
    );
  }
}
