import 'package:flutter/material.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouserlWidget extends StatelessWidget {
  List<dynamic> images = [];
  CarouserlWidget({Key key, @required this.images}) : super(key: key);

  GlobalKey _sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 350,
          child: CarouselSlider.builder(
              autoSliderTransitionTime: Duration(microseconds: 200),
              key: _sliderKey,
              keepPage: true,
              unlimitedMode: true,
              slideBuilder: (index) {
                return Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(15)),
                    child: CachedNetworkImage(
                      height: 350,
                      width: MediaQuery.of(context).size.width * 1,
                      fit: BoxFit.cover,
                      imageUrl: this.images[index],
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 50,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
              slideIndicator: CircularSlideIndicator(
                indicatorRadius: 5,
                indicatorBackgroundColor: Colors.grey[400],
                indicatorBorderColor: Colors.grey[400],
                padding: EdgeInsets.only(bottom: 32),
              ),
              itemCount: this.images.length),
        ),
        Positioned(
          bottom: 310,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 23,
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: () async {},
                  child: Image.asset(
                    'assets/icons/menu-icon.png',
                    width: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
