import 'package:flutter/material.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/utils/report.dart';
import 'package:handicraft_app/utils/util.dart';

class CarouserlWidget extends StatelessWidget {
  List<dynamic> images = [];
  int uid;
  CarouserlWidget({Key key, @required this.images, @required this.uid})
      : super(key: key);

  GlobalKey _sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _test() {}
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
          bottom: 300,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    color: Colors.black,
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, 'home');
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 23,
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: () async {
                    modal(context, 0.10, [
                      {
                        "icon": Icon(Icons.report_rounded, color: Colors.black),
                        "title": Text("Reportar",
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'Montserrat')),
                        "fnc": () async {
                          String temp = await StorageService().getValue("uid");
                          print(temp);
                          if (temp == null || temp == "") {
                            Navigator.pop(context);

                            alert(context);
                          } else {
                            Navigator.pop(context);

                            reportDialog(context, this.uid, 0);
                          }
                        },
                      }
                    ]);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/icons/menu-icon.png',
                      width: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void alert(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Error!"),
              content: Text("Necesita crear una cuenta o iniciar seccion."),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              actions: [
                MaterialButton(
                    child: Text(
                      "Ir a registro",
                      style: TextStyle(color: Colors.black),
                    ),
                    elevation: 3,
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, "register")),
                MaterialButton(
                    child: Text(
                      "ok",
                      style: TextStyle(color: Colors.black),
                    ),
                    elevation: 3,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }
}
