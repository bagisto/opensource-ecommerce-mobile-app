/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */

// ignore_for_file: file_names, must_be_immutable

import 'package:bagisto_app_demo/common_widget/image_view.dart';
import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:bagisto_app_demo/helper/string_constants.dart';
import 'package:bagisto_app_demo/models/homepage_model/advertisement_data.dart';
import 'package:flutter/material.dart';
import '../../../common_widget/show_message.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../routes/route_constants.dart';
import 'homepage.dart';

class AdvertisementDataItem extends StatelessWidget {
  List<AdvertisementSlug>? model;

  AdvertisementDataItem({Key? key, this.model, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: model?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(NormalPadding),
            child: InkWell(
              onTap: () {
                checkInternetConnection().then((value) {
                  if (value) {
                    if((model?[index].slug != "" && model?[index].slug != null )&&(model?[index].slug?.contains("<")!=true)) {
                      Navigator.pushNamed(context, SubCategory,
                          arguments: CategoryProductData(
                              metaDescription:  "",
                              categorySlug:model?[index].slug??"",
                              title: "Categories".localized()/*element.name*/,
                              image: model?[index].image??""));
                    }
                  } else {
                    ShowMessage.showNotification(
                        "InternetIssue".localized(),
                        "",
                        Colors.red,
                        const Icon(
                            Icons.cancel_outlined));
                  }
                });


              },
              child: ImageView(
                url: model?[index].image??"",
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        });
  }
}
