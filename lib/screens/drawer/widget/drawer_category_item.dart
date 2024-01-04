import 'package:bagisto_app_demo/screens/home_page/data_model/get_categories_drawer_data_model.dart';
import 'package:bagisto_app_demo/utils/application_localization.dart';
import 'package:flutter/material.dart';
import '../../../data_model/app_route_arguments.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/route_constants.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/common_widgets.dart';

class DrawerCategoryItem extends StatefulWidget {
  final HomeCategories element;
  const DrawerCategoryItem(this.element, {Key? key}) : super(key: key);

  @override
  State<DrawerCategoryItem> createState() => _DrawerCategoryItemState();
}

class _DrawerCategoryItemState extends State<DrawerCategoryItem> {
  List<Widget> childWidgets = [];
  bool showChild = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ListTile(
            title: CommonWidgets()
                .getDrawerTileText(widget.element.name ?? "", context),
            trailing: InkWell(
              child: Icon(
                showChild ? Icons.keyboard_arrow_down : Icons.chevron_right,
              ),
              onTap: (){
                childWidgets.clear();
                setState(() {
                  showChild = !showChild;
                  widget.element.children?.forEach((child) {
                    childWidgets.add(
                        ChildrenWidget(child)
                    );
                  });

                  if((widget.element.children ?? []).isEmpty){
                    childWidgets.add(
                        Text(StringConstants.noCategoryFound.localized())
                    );
                  }
                });
              },
            ),
            onTap: (){
              Navigator.pushNamed(context, categoryScreen, arguments:
              CategoriesArguments(categorySlug: widget.element.slug, title: widget.element.name, id: widget.element.categoryId.toString()));
            },
          ),
        ),
        if(showChild)...childWidgets
      ],
    );
  }
}

class ChildrenWidget extends StatefulWidget {
  final Children element;
  const ChildrenWidget(this.element,{Key? key}) : super(key: key);

  @override
  State<ChildrenWidget> createState() => _ChildrenWidgetState();
}

class _ChildrenWidgetState extends State<ChildrenWidget> {
  List<Widget> childWidgets = [];
  bool showChild = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.spacingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppSizes.buttonHeight,
            child: ListTile(
              title: CommonWidgets()
                  .getDrawerTileText(widget.element.name ?? "", context),
              trailing: InkWell(
                child: Icon(
                  showChild ? Icons.keyboard_arrow_down : Icons.chevron_right,
                ),
                onTap: (){
                  childWidgets.clear();
                  setState(() {
                    showChild = !showChild;
                    widget.element.children?.forEach((child) {
                      childWidgets.add(
                        ChildrenWidget(child)
                      );
                    });

                    if((widget.element.children ?? []).isEmpty){
                      childWidgets.add(
                        Padding(
                          padding: const EdgeInsets.only(left: AppSizes.spacingLarge),
                          child: Text(StringConstants.noCategoryFound.localized()),
                        )
                      );
                    }
                  });
                },
              ),
              onTap: (){
                Navigator.pushNamed(context, categoryScreen, arguments:
                CategoriesArguments(categorySlug: widget.element.slug, title: widget.element.name,
                    id: widget.element.id.toString()));
              },
            ),
          ),
          if(showChild)...childWidgets
        ],
      ),
    );
  }
}
