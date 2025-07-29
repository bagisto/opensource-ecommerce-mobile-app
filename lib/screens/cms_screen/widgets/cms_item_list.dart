/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/utils/app_constants.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_widgets.dart';
import 'package:collection/collection.dart';
import '../data_model/cms_model.dart';
import '../../../utils/application_localization.dart';

class CmsItemsList extends StatefulWidget {
  final String? title;
  final CmsData? cmsData;

  const CmsItemsList({Key? key, this.title, this.cmsData}) : super(key: key);

  @override
  State<CmsItemsList> createState() => _CmsItemsListState();
}

class _CmsItemsListState extends State<CmsItemsList> {
  @override
  Widget build(BuildContext context) {
    return buildCmsItems();
  }

  Widget buildCmsItems() {
    if (widget.cmsData == null) {
      return const SizedBox.shrink();
    }

    List<Widget> cmsListItems = [];

    for (int i = 0; i < (widget.cmsData?.data?.length ?? 0); i++) {
      var item = widget.cmsData!.data![i];
      var title = item.translations
          ?.firstWhereOrNull((e) => e.locale == GlobalData.locale);

      if ((item.translations ?? []).isEmpty) continue;

      cmsListItems.add(
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                cmsScreen,
                arguments: CmsDataContent(
                  title: title?.pageTitle ??
                      item.translations?.firstOrNull?.pageTitle ??
                      "",
                  id: int.parse(item.id ?? ""),
                  index: i,
                ),
              );
            },
            title: CommonWidgets().getDrawerTileText(
              title?.pageTitle ??
                  item.translations?.firstOrNull?.pageTitle ??
                  "",
              context,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }

    // Add Contact Us item at the bottom
    cmsListItems.add(
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingSmall,
          vertical: AppSizes.spacingSmall,
        ),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, contactUsScreen);
          },
          title: CommonWidgets().getDrawerTileText(
            StringConstants.contactUs.localized().trim(),
            context,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: cmsListItems,
    );
  }
}
