/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/add_edit_address/utils/index.dart';

class AddEditLoaderView extends StatelessWidget {
  const AddEditLoaderView({Key? key}) : super(key: key);

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

              items: 12,
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
            height: 10,
          ),
        ],
      ),
    );
  }
}
