import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';

import '../../../common_widget/common_widgets.dart';
import '../../../configuration/app_sizes.dart';

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
            height: 50,
            child: ListTile(
                title: Text(
              headingTitle?.localized().toUpperCase() ?? "",
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
                size: AppSizes.iconSize,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              title: CommonWidgets()
                  .getDrawerTileText(subTitle?.localized() ?? "", context),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.iconSize,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
  }
}
