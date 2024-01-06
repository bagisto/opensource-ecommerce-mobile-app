/*
 * Webkul Software.
 * @package Mobikul Application Code.
 * @Category Mobikul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 * @link https://store.webkul.com/license.html
 */


import 'package:bagisto_app_demo/screens/cart_screen/cart_index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../utils/check_internet_connection.dart';
import '../../../widgets/image_view.dart';
import '../data_model/theme_customization.dart';

class CarousalSlider extends StatefulWidget {
  final ThemeCustomization? sliders;

  const CarousalSlider({Key? key, this.sliders}) : super(key: key);

  @override
  State<CarousalSlider> createState() => _CarousalSliderState();
}

class _CarousalSliderState extends State<CarousalSlider> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.sliders?.translations?.firstOrNull?.options?.images?.length ?? 0,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) {
            Images? image = widget.sliders?.translations?.firstOrNull?.options?.images?[itemIndex];

            return InkWell(
              onTap: (){
                checkInternetConnection().then((value) {
                  if (value) {
                    // Navigator.pushNamed(context, SubCategory,
                    //     arguments: CategoryProductData(
                    //         metaDescription: "",
                    //         categorySlug: widget.sliders?[itemIndex].sliderPath??"",
                    //         title: widget.sliders?[itemIndex].title??"",
                    //         image:widget.sliders?[itemIndex].imageUrl??""));
                  } else {
                    ShowMessage.errorNotification(StringConstants.internetIssue.localized(), context);
                  }
                });

              },
              child: Container(
                padding: const EdgeInsets.only(top: AppSizes.spacingNormal),
                child: ImageView(
                  url:  image?.imageUrl,
                    width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            );
            // );
          },
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 3.2,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            viewportFraction: 1.5,
              onPageChanged: (index, reason) {}
          ),
        )
      ],
    );
  }
}
