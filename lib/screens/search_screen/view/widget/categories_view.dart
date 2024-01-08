
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import '../../../../data_model/app_route_arguments.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/string_constants.dart';
import '../../../home_page/data_model/get_categories_drawer_data_model.dart';

class CategoriesView extends StatelessWidget {
  final List<HomeCategories>? data;

  const CategoriesView({Key? key, this.data}) : super(key: key);

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
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                child: Text(
                  StringConstants.categories.localized().toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: data?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, categoryScreen,
                              arguments: CategoriesArguments(
                                  metaDescription: data?[index].description,
                                  categorySlug: data?[index].slug ?? "",
                                  id: data?[index].categoryId.toString(),
                                  title: data?[index].name,
                                  image: data?[index].imageUrl));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: AppSizes.spacingNormal,
                              left: 16,
                              bottom: AppSizes.spacingMedium),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.spacingNormal,
                              horizontal: AppSizes.spacingMedium),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(AppSizes.spacingWide)),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Center(
                              child: Text(
                            data?[index].name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary
                            ),
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
