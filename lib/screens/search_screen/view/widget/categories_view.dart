
/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/search_screen/utils/index.dart';

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
                          if((data?[index].children ?? []).isNotEmpty){
                            Navigator.pushNamed(context, drawerSubCategoryScreen, arguments:
                            CategoriesArguments(categorySlug: data?[index].slug,
                                title: data?[index].name, id: data?[index].id.toString(),
                                image: data?[index].bannerUrl ?? "", parentId: "1"));
                          }
                          else{
                            Navigator.pushNamed(context, categoryScreen,
                                arguments: CategoriesArguments(
                                    metaDescription: data?[index].description,
                                    categorySlug: data?[index].slug ?? "",
                                    id: data?[index].id.toString(),
                                    title: data?[index].name,
                                    image: data?[index].bannerUrl));
                          }
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
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          child: Center(
                              child: Text(
                            data?[index].name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondaryContainer
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
