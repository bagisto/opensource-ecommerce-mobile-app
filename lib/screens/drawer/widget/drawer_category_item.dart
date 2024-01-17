import 'package:bagisto_app_demo/screens/home_page/data_model/get_categories_drawer_data_model.dart';
import 'package:flutter/material.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/route_constants.dart';
import '../../../widgets/common_widgets.dart';

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
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ListTile(
            title: CommonWidgets()
                .getDrawerTileText(widget.element.name ?? "", context),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: (){
              if((widget.element.children ?? []).isNotEmpty){
                Navigator.pushNamed(context, drawerSubCategoryScreen, arguments:
                CategoriesArguments(categorySlug: widget.element.slug, title: widget.element.name, id: widget.element.id.toString()));
              }
              else{
                Navigator.pushNamed(context, categoryScreen,
                    arguments: CategoriesArguments(
                        metaDescription: widget.element.description,
                        categorySlug: widget.element.slug ?? "",
                        title: widget.element.name,
                        id: widget.element.id,
                        image: widget.element.imageUrl ?? ""));
              }
            },
          ),
        ),
      ],
    );
  }
}
