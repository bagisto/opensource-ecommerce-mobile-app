import 'package:bagisto_app_demo/configuration/app_global_data.dart';

import '../../../helper/check_internet_connection.dart';
import '../../../helper/prefetching_helper.dart';
import '../../../models/homepage_model/new_product_data.dart';
import '../../product_screen/view/product_screen_index.dart';
import '../bloc/homepage_bloc.dart';
import '../events/add_detelet_item_homepage_event.dart';
import '../events/addtocart_event.dart';
import '../events/addtocompare_homepage_event.dart';
import '../events/homepage_loading_event.dart';
import 'homepage_view.dart';
import 'package:collection/collection.dart';

class NewProductView extends StatefulWidget{
  final List<NewProducts>? model;
  final String title;
  final bool ? isLogin;
  const NewProductView({Key? key, this.model, required this.title, this.isLogin}) : super(key: key);

  @override
  State<NewProductView> createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView>  {
  HomePageBloc ? homepageBloc;
  @override
  void initState() {
     homepageBloc = context.read<HomePageBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(NormalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.normalFontSize,
                    color: Colors.grey[600]),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.model?.length ?? 0,
                itemBuilder: (context, index) {
                  widget.title == "recentProducts".localized()?null:
                  preCacheProductPage( int.parse(widget.model?[index].id??"0"));
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage,
                          arguments: PassProductData(
                              title: widget.model?[index].name ?? "",
                              productId:int.parse( widget.model?[index].id??"")));
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Card(
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Stack(children: [
                                if (widget.model?[index].url != null ||
                                    ((widget.model?[index].images?.length ??
                                                0) >
                                            0 &&
                                        (widget.model?[index].images ?? [])
                                            .isNotEmpty))
                                  ImageView(
                                    url: widget.model?[index].images?[0].url ??
                                        widget.model?[index].url ??
                                        "",
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width / 2,
                                  ),
                                if ((widget.model?[index].productFlats?[0].isNew ?? false) || (widget.model?[index].isNew ?? false))
                                  Positioned(
                                      left: AppSizes.spacingTiny,
                                      top: AppSizes.spacingTiny,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSizes.size8,
                                                right: AppSizes.size8,
                                                top: AppSizes.size2,
                                                bottom: AppSizes.spacingTiny),
                                            child: Text(
                                              "New".localized(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                      )),
                                Positioned(
                                    right: AppSizes.normalPadding,
                                    top: 10,
                                    child: InkWell(
                                      onTap: () {
                                        checkInternetConnection().then((value) {
                                          if (value) {
                                            homepageBloc?.add(
                                                OnClickLoaderEvent(
                                                    isReqToShowLoader: true));
                                            if (widget.isLogin ?? false) {
                                              if (widget.model?[index]
                                                      .isInWishlist ??
                                                  false) {
                                                homepageBloc?.add(
                                                    FetchDeleteAddItemEvent(
                                                        int.parse(widget
                                                                .model?[index]
                                                                .id ??
                                                            ""),
                                                        widget.model?[index]));
                                              } else {
                                                homepageBloc?.add(
                                                    FetchAddWishlistHomepageEvent(
                                                        int.parse(widget
                                                                .model?[index]
                                                                .id ??
                                                            ""),
                                                        widget.model?[index]));
                                              }
                                            } else {
                                              ShowMessage.showNotification(
                                                  "pleaseLogin".localized(),
                                                  "",
                                                  Colors.yellow,
                                                  const Icon(
                                                      Icons.warning_amber));
                                              homepageBloc?.add(
                                                  OnClickLoaderEvent(
                                                      isReqToShowLoader:
                                                          false));
                                            }
                                          } else {
                                            ShowMessage.showNotification(
                                                "InternetIssue".localized(),
                                                "",
                                                Colors.red,
                                                const Icon(
                                                    Icons.cancel_outlined));
                                          }
                                        });
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(18)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.4),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: widget.model?[index].isInWishlist ??
                                                  false
                                                  ?  Icon(
                                                Icons.favorite,
                                                color: Theme.of(context).colorScheme.onBackground,
                                                size: 16,
                                              )
                                                  :
                                              Icon(  Icons.favorite_border,
                                                size: 16,
                                                color:Theme.of(context).colorScheme.onBackground,
                                              )),
                                        )),
                                    Positioned(
                                      right: 8.0,
                                      top: 45,
                                      child: InkWell(
                                        onTap: () {
                                          checkInternetConnection().then((value) {
                                            if (value) {
                                              homepageBloc?.add(OnClickLoaderEvent(
                                                  isReqToShowLoader: true));
                                              if(widget.isLogin ?? false){
                                                homepageBloc?.add(AddToCompareHomepageEvent(
                                                    int.parse(widget.model?[index].productFlats?[0].id ?? widget.model?[index].productId ?? ""), ""));
                                              }else{
                                                ShowMessage.showNotification("pleaseLogin".localized(),"",Colors.yellow,
                                                    const Icon(Icons.warning_amber));
                                                homepageBloc?.add(OnClickLoaderEvent(
                                                    isReqToShowLoader: false));
                                              }
                                            } else {
                                              ShowMessage.showNotification(
                                                  "InternetIssue".localized(),
                                                  "",
                                                  Colors.red,
                                                  const Icon(
                                                      Icons.cancel_outlined));
                                            }
                                          });

                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(18)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.4),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Image.asset("assets/images/compare-icon.png",height: 18,width: 18,color: Colors.grey[500],)),
                                      ),
                                    )
                                  ]),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: NormalPadding,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width/2,
                                    child: CommonWidgets().getDrawerTileText(
                                        widget.model?[index].productFlats?.firstWhereOrNull((element) => element.locale == GlobalData.locale)?.name ?? "",
                                        context),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: NormalPadding, /*top: NormalPadding*/
                                ),
                                child: CommonWidgets().priceText(
                                    widget.model?[index].priceHtml?.regular ??widget.model?[index].price ??
                                        "".toString() )),
                            (widget.model?[index].rating != null || (widget.model?[index].reviews ?? []).isNotEmpty && ((widget.model?[index].reviews?.length ?? 0)>0))?
                            Padding(
                              padding: const EdgeInsets.only(
                                left: NormalPadding, /*top: NormalPadding*/
                              ),
                              child: Row(
                                children: [
                                  Row(
                                      children:
                                      List.generate(5, (idx) =>
                                      (idx >= num.parse(widget.model?[index].reviews?[0].rating.toString() ?? widget.model?[index].rating.toString() ?? "")) ?
                                      Icon(
                                        Icons.star_border,
                                        color: MobikulTheme().getColor(double.parse( widget.model?[index].reviews?[0].rating.toString() ?? widget.model?[index].rating.toString() ?? "")),
                                        size: 16.0,
                                      ) :
                                      Icon(
                                        Icons.star,
                                        color: MobikulTheme().getColor(double.parse(widget.model?[index].reviews?[0].rating.toString() ?? widget.model?[index].rating.toString() ?? "")),
                                        size: 16.0,
                                      )
                                      )),
                                ],
                              ),
                            ):Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: CommonWidgets().appButton(
                                  context,
                                  "AddToCart".localized(),
                                  MediaQuery.of(context).size.width, () {
                                checkInternetConnection().then((value) {
                                  if (value) {
                                    homepageBloc?.add(
                                        OnClickLoaderEvent(isReqToShowLoader: true));
                                    if ((widget.model?[index].priceHtml?.type) ==
                                        simple || widget.model?[index].type == simple) {
                                      _homepageEvent(
                                          widget.model?[index],
                                          HomePageAction.addToCart);
                                    } else {
                                      ShowMessage.showNotification("addOptions".localized(),"",Colors.yellow,
                                          const Icon(Icons.warning_amber));
                                      homepageBloc?.add(
                                          OnClickLoaderEvent(isReqToShowLoader: false));

                                    }
                                  } else {
                                    ShowMessage.showNotification(
                                        "InternetIssue".localized(),
                                        "",
                                        Colors.red,
                                        const Icon(
                                            Icons.cancel_outlined));
                                  }
                                });

                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _homepageEvent(NewProducts? data,  HomePageAction type) {
    switch (type) {
      case HomePageAction.addToCart:
        if (data != null) {
          var dict = <String, dynamic>{};
          dict[productId] =data.id ?? '';
          dict[quantity] = 1;
          homepageBloc?.add(AddToCartEvent(int.parse(data.id??""), 1, ""));
        }

        break;
      case HomePageAction.fetchDeleteAdd:
        if (widget.isLogin ?? false) {
          if (data != null) {
            homepageBloc?.add(FetchAddWishlistHomepageEvent(data.id, data));
          }
        } else {
          homepageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
          ShowMessage.showNotification("pleaseLogin".localized(),"",Colors.yellow,const Icon(Icons.warning_amber));
        }
        break;
      case HomePageAction.addCompare:
        if (widget.isLogin ?? false) {
          if (data != null) {
            homepageBloc?.add(AddToCompareHomepageEvent(data.id, ""));
          }
        } else {
          homepageBloc?.add(OnClickLoaderEvent(isReqToShowLoader: false));
          ShowMessage.showNotification("pleaseLogin".localized(),"",Colors.yellow,
              const Icon(Icons.warning_amber));
        }
        break;
    }
  }
}
