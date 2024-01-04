import 'package:bagisto_app_demo/utils/route_constants.dart';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final int? index;
  const CommonAppBar(this.title, {Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.spacingLarge),
      ),
      actions: [
        IconButton(
            onPressed: () {
              if(index != 0){
                Navigator.pushNamed(context, searchScreen);
              }
            },
            icon: const Icon(
              Icons.search,
            )),
        IconButton(
            onPressed: () {
              if(index != 1){
                Navigator.pushNamed(context, compareScreen);
              }
            },
            icon: const Icon(
              Icons.compare_arrows,
            )),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: () {
            if(index != 2){
              Navigator.pushNamed(context, cartScreen);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
