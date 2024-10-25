/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */



import 'package:bagisto_app_demo/screens/product_screen/utils/index.dart';


class ProductReviewSummaryView extends StatefulWidget {
  final List<Reviews>? review;
  final String? productId;
  final String? averageRating;
  final dynamic percentage;
  final String? productName;
  final String? productImage;
  final bool? isLogin;

  const ProductReviewSummaryView(
      {Key? key,
      this.review,
      this.productName,
      this.productImage,
      this.averageRating,
      this.percentage,
      this.productId,
      this.isLogin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductReviewSummaryViewState();
  }
}

class ProductReviewSummaryViewState extends State<ProductReviewSummaryView> {
  dynamic percentage;

  @override
  void initState() {
    percentage = (widget.percentage.toString()) != "[]"
        ? json.decode(widget.percentage.toString())
        : [];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Theme.of(context).colorScheme.onPrimary,
        tilePadding:const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge) ,
        title: Text(
          StringConstants.customerRating.localized(),
          style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600,fontSize: AppSizes.spacingLarge),
        ),
        initiallyExpanded: true,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(AppSizes.spacingNormal),
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if ((widget.review?.length ?? 0) > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Column(children: [
                              Text(
                                  "${widget.averageRating?.toString() ?? ''} ${StringConstants.star.localized()}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              RatingBar(
                                starCount: 5,
                                color: Theme.of(context).colorScheme.onPrimary,
                                rating: num.tryParse(widget.averageRating.toString())?.toDouble() ??0.0,
                              ),

                              const SizedBox(height: 6),
                              Text(
                                  "${widget.averageRating?.toString() ?? ''} Rating & "
                                  "${widget.review?.length.toString() ?? ''} Reviews",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12
                                  )),
                              const SizedBox(height: 8),
                            ]),
                          ),
                          ReviewLinearProgressIndicator(percentage: percentage),
                        ],
                      ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            8, ((widget.review?.length ?? 0) > 0 ? 8 : 0), 0, 0),
                        child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15)),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.onBackground),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground)))),
                            onPressed: () {
                              widget.isLogin ?? false
                                  ? Navigator.pushNamed(context, addReviewScreen,
                                      arguments: AddReviewDetail(
                                          imageUrl: widget.productImage,
                                          productId: widget.productId,
                                          productName: widget.productName))
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content:
                                          Text(StringConstants.pleaseLoginReview.localized()),
                                      duration: const Duration(seconds: 3),
                                    ));
                            },
                            child: Text(StringConstants.writeReview.localized().toUpperCase(), style: const TextStyle(fontSize: 17)))),
                  ])),
        ],
      ),
    );
  }
}
