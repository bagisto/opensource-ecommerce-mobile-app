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

class DrawerCategoryItem extends StatefulWidget {
  final HomeCategories element;
  const DrawerCategoryItem(this.element, {Key? key}) : super(key: key);

  @override
  State<DrawerCategoryItem> createState() => _DrawerCategoryItemState();
}

class _DrawerCategoryItemState extends State<DrawerCategoryItem> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () {
            checkInternetConnection().then((value) {
              if (value) {
                Navigator.pushNamed(context, categoryScreen,
                    arguments: CategoriesArguments(
                        metaDescription: widget.element.description,
                        categorySlug: widget.element.slug ?? "",
                        title: widget.element.name,
                        id: widget.element.id,
                        image: widget.element.bannerUrl ?? ""));

              } else {
                ShowMessage.showNotification(StringConstants.failed.localized(),StringConstants.internetIssue.localized(),
                    Colors.red, const Icon(Icons.cancel_outlined));
              }
            });
          },
          child: SizedBox(
            height: AppSizes.buttonHeight,
            child: ListTile(
              title: CommonWidgets()
                  .getDrawerTileText(widget.element.name ?? "", context),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              contentPadding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(
                    widget.element.logoUrl ?? ""
                ),
                backgroundImage: const AssetImage(AssetConstants.placeHolder),
              ),
              onTap: (){
                if((widget.element.children ?? []).isNotEmpty){
                  Navigator.pushNamed(context, drawerSubCategoryScreen, arguments:
                  CategoriesArguments(categorySlug: widget.element.slug, title: widget.element.name, id: widget.element.id.toString(),
                  image: widget.element.bannerUrl ?? "", parentId: "1"));
                }
                else{
                  Navigator.pushNamed(context, categoryScreen,
                      arguments: CategoriesArguments(
                          metaDescription: widget.element.description,
                          categorySlug: widget.element.slug ?? "",
                          title: widget.element.name,
                          id: widget.element.id,
                          image: widget.element.bannerUrl ?? ""));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}


