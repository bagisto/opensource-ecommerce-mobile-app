import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../utils/mobikul_theme.dart';

class AddEditLoaderView extends StatelessWidget {
  const AddEditLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ??
                  MobikulTheme.primaryColor,
              items: 12,
              builder: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12, 10, 0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
