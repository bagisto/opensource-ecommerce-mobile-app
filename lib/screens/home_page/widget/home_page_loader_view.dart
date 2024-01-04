
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../utils/mobikul_theme.dart';

class HomePageLoader extends StatelessWidget {
  const HomePageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List sliders =[1,2,3,4,5];
    return SingleChildScrollView(
      child: Column(
        children: [
          SkeletonLoader(
            highlightColor: Theme.of(context).highlightColor,
            baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
            builder: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: sliders.length,
                  itemBuilder: (BuildContext context, int itemIndex, int realIndex) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(color: Colors.red,),
                    );
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 3.2,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 1.5,
                  ),
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sliders.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.white
                              : Colors.black)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SkeletonLoader(
            highlightColor: Theme.of(context).highlightColor,
            baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
            builder: SizedBox(
              height: MediaQuery.of(context).size.width / 2.5 + 220,
              child: ListView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,8,0,8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: const Card(
                          color: Colors.red,
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SkeletonLoader(
              highlightColor: Theme.of(context).highlightColor,
              baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
              items: 3,
              builder: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  color: Colors.red,
                ),
              )),
          SkeletonLoader(
            highlightColor: Theme.of(context).highlightColor,
            baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
            builder: SizedBox(
              height: MediaQuery.of(context).size.width / 2.5 + 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,0,8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: const Card(
                          color: Colors.red,
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SkeletonLoader(
            highlightColor: Theme.of(context).highlightColor,
            baseColor: Theme.of(context).appBarTheme.backgroundColor ?? MobikulTheme.primaryColor,
            builder: SizedBox(
              height: MediaQuery.of(context).size.width / 2.5 + 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,0,8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: const Card(
                          color: Colors.red,
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
