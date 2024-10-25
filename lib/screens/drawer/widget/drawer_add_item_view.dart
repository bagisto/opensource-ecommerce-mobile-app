/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/drawer/utils/index.dart';

class DrawerAddItemList extends StatelessWidget {
  final String? headingTitle;
  final String? subTitle;
  final IconData? icon;
  final void Function()? onTap;

  const DrawerAddItemList(
      {Key? key, this.headingTitle, this.subTitle, this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return headingTitle != null
        ? SizedBox(
            height: 40,
            child: ListTile(
                title: Text(
             " headingTitle?.localized().toUpperCase() "?? "",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.grey[500],
              ),
            )),
          )
        : SizedBox(
            height: 50,
            child: ListTile(
              onTap: onTap,
              leading: Icon(
                icon,
                size: AppSizes.spacingWide,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              title: CommonWidgets()
                  .getDrawerTileText(subTitle?.localized() ?? "", context),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
  }
}
