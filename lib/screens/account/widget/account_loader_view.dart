/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */
import 'package:bagisto_app_demo/screens/account/utils/index.dart';


class AccountLoaderView extends StatelessWidget {
  const AccountLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              builder: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                height: 135,
                child: const Card(
                  color: Colors.red,
                ),
              )),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,
              items: 5,
              builder: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12, 10, 0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
          const SizedBox(
            height: 25,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).scaffoldBackgroundColor,

              items: 3,
              builder: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red,
                  height: 35,
                ),
              )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
