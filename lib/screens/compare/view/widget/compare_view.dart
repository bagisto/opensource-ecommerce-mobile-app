/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bagisto_app_demo/screens/compare/utils/index.dart';

class CompareView extends StatelessWidget {
  final CompareProductsData compareScreenModel;
  final CompareScreenBloc? compareScreenBloc;
  final ScrollController? scrollController;

  const CompareView(
      {Key? key,
      required this.compareScreenModel,
      this.compareScreenBloc,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CompareList(
                  compareScreenModel: compareScreenModel,
                  compareScreenBloc: compareScreenBloc),
              SizedBox(
                height: 30,
                width: (compareScreenModel.data?.length ?? 0) *
                    MediaQuery.of(context).size.width /
                    2.0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.spacingMedium,
                        top: AppSizes.spacingNormal,
                        bottom: AppSizes.spacingSmall),
                    child: Text(
                      StringConstants.sku.localized(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppSizes.spacingLarge * 2,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: compareScreenModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, productScreen,
                              arguments: PassProductData(
                                  title: compareScreenModel
                                          .data?[index].product?.name ??
                                      "",
                                  urlKey: compareScreenModel
                                      .data?[index].product?.urlKey,
                                  productId: int.parse(compareScreenModel
                                          .data?[index].product?.id ??
                                      "")));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: AppSizes.spacingNormal,
                                top: AppSizes.spacingNormal,
                                right: AppSizes.spacingNormal),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                compareScreenModel.data?[index].product?.sku ??
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
                    2.0,
                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, top: 6, bottom: 2),
                    child: Text(
                      StringConstants.description.localized(),
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
                          Navigator.pushNamed(context, productScreen,
                              arguments: PassProductData(
                                  title: compareScreenModel
                                          .data?[index].product?.name ??
                                      "",
                                  urlKey: compareScreenModel
                                      .data?[index].product?.urlKey,
                                  productId: int.parse(compareScreenModel
                                          .data?[index].product?.id ??
                                      "")));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.0,
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
                          child: SingleChildScrollView(
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
                                      compareScreenModel.data?[index].product
                                              ?.description ??
                                          "",
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
