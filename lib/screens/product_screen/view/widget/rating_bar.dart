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

typedef RatingChangeCallback = void Function(double rating);

//ignore: must_be_immutable
class RatingBar extends StatefulWidget {
  final int starCount;
  double? rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final double? size;
  final bool isCenter;


   RatingBar(
      {this.starCount = 5,
        this.rating = .0,
        this.isCenter = true,
        this.onRatingChanged,
        this.color,
        Key? key, this.size})
      : super(key: key);

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= widget.rating!) {
      icon = Icon(
        Icons.star_border,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size ?? 20,
      );
    } else if (index > widget.rating! - 1 && index < widget.rating!) {
      icon = Icon(
        Icons.star_half,
        color: widget.color ?? Theme.of(context).primaryColor,
        size:widget.size ?? 20,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size ?? 20,
      );
    }
    return InkResponse(
      onTap: widget.onRatingChanged == null
          ? null
          : () => setState(() {
        widget.rating = index + 1.0;
        widget.onRatingChanged!(index + 1.0);
      }),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Row(
         mainAxisAlignment: widget.isCenter ?  MainAxisAlignment.center :MainAxisAlignment.start ,
        children: List.generate(
            widget.starCount, (index) => buildStar(context, index))
    );
  }
}
