import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../models/compare_model/compare_product_model.dart';
import '../../../routes/route_constants.dart';
import '../../homepage/view/homepage_view.dart';
import '../bloc/compare_screen_bloc.dart';
import 'compare_list.dart';

class CompareView extends StatelessWidget {
  final CompareProductsData  compareScreenModel;
  final CompareScreenBloc ? compareScreenBloc ;
  const CompareView({Key? key,required this.compareScreenModel,this.compareScreenBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CompareList(compareScreenModel:compareScreenModel,compareScreenBloc:compareScreenBloc),
              SizedBox(
                height: 30,
                width: (compareScreenModel.data?.length ?? 0) *
                    MediaQuery.of(context).size.width /
                    2.2,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 12.0, top: 6, bottom: 2),
                    child: Text(
                      "SKU",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 33,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: compareScreenModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ProductPage,
                              arguments: PassProductData(
                                  title: compareScreenModel
                                      .data?[index].productFlat?.name ??
                                      "",
                                  productId: int.parse(compareScreenModel
                                      .data?[index]
                                      .productFlat
                                      ?.product
                                      ?.id ??
                                      "")));},
                        child: Container(
                          // margin: ,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8, right: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Text(
                                compareScreenModel.data?[index].productFlat?.sku ??
                                    "",
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 30,
                width: (compareScreenModel.data?.length ?? 0) *
                    MediaQuery.of(context).size.width /
                    2.2,
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 12.0, top: 6, bottom: 2),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 + 60,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: compareScreenModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ProductPage,
                              arguments: PassProductData(
                                  title: compareScreenModel.data?[index].productFlat?.name ?? "",
                                  productId: int.parse(compareScreenModel
                                      .data?[index]
                                      .productFlat
                                      ?.product
                                      ?.id ??
                                      "")));},
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 2 + 10,
                          decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              )),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 8, right: 8),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                  child: HtmlWidget(
                                    compareScreenModel.data?[index]
                                        .productFlat?.description ??
                                        "",
                                  ),
                                ),
                              ),
                            ],
                          ),
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
