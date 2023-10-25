/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable, implementation_imports

import 'package:bagisto_app_demo/common_widget/common_widgets.dart';
import 'package:bagisto_app_demo/models/cms_model/cms_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../../configuration/app_global_data.dart';
import '../../../configuration/app_sizes.dart';
import '../../../routes/route_constants.dart';
import '../bloc/cms_bloc.dart';


class CmsItemsList extends StatefulWidget {
  String? title;
  CmsData? cmsData;

  CmsItemsList({Key? key, this.title, this.cmsData}) : super(key: key);

  @override
  State<CmsItemsList> createState() => _CmsItemsListState();
}

class _CmsItemsListState extends State<CmsItemsList> {
  late CmsBloc cmsBloc;
  String? pageTitle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildContainer();
  }

  ///build container method
  Widget buildContainer() {
    if (widget.cmsData != null) {
      return _cmsDataList(widget.cmsData!);
    }
    return _cmsDataList(widget.cmsData!);
  }

  ///ui method
  _cmsDataList(
    CmsData cmsData,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: cmsData.data?.length,
              itemBuilder: (context, index) {
              var title = (cmsData.data?[index].translations?.firstWhereOrNull((e) => e.locale==GlobalData.locale));
                return SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, CmsContentData,
                          arguments: CmsDataContent(
                              title: title?.pageTitle??cmsData.data?[index].translations?[0].pageTitle??"",
                              id: int.parse(cmsData.data?[index].id ?? ""),
                              index: index));
                    },
                    title:
                    CommonWidgets().getDrawerTileText(title?.pageTitle??cmsData.data?[index].translations?[0].pageTitle??"", context),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.iconSize,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

///class use to pass data on cms screens
class CmsDataContent {
  CmsDataContent({
    this.title,
    this.id,
    this.index,
  });

  String? title;
  int? id;
  int? index;
}
