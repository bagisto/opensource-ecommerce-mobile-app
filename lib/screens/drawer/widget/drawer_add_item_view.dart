import 'package:flutter/material.dart';
import '../../../utils/application_localization.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/common_widgets.dart';


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
