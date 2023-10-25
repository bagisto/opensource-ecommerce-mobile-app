import 'package:bagisto_app_demo/helper/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../../Configuration/mobikul_theme.dart';
import '../../../../configuration/app_sizes.dart';
import '../../../../models/homepage_model/get_categories_drawer_data_model.dart';
import '../../../../routes/route_constants.dart';
import '../../homepage/view/homepage.dart';

class CategoriesView extends StatelessWidget {
  List<HomeCategories>? data;

  CategoriesView({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).cardColor,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.normalFontSize),
                child: Text(
                  "Categories".localized().toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: data?.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SubCategory,
                              arguments: CategoryProductData(
                                  metaDescription: data?[index].description,
                                  categorySlug: data?[index].slug ?? "",
                                  title: data?[index].name,
                                  image: data?[index].imageUrl));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: AppSizes.size8,
                              left: 16,
                              bottom: AppSizes.normalFontSize),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.size4,
                              horizontal: AppSizes.size8),
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                            color: MobikulTheme.accentColor,
                          ),
                          child: Center(
                              child: Text(
                                data?[index].name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: MobikulTheme.primaryColor),
                              )),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
