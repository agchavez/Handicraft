import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width, this.height})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  final double height;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: onTap,
              child: ClipRRect(
                child: Image.network(
                  photo,
                  height: height,
                  width: width,
                ),
                borderRadius: BorderRadius.circular(8),
              )),
        ),
      ),
    );
  }
}

Widget carousel(List<dynamic> images) {
  return CarouselSlider(
    options: CarouselOptions(height: 300.0),
    items: images.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(color: Colors.grey),
            child: PhotoHero(
              photo: i.toString(),
              onTap: () {
                Navigator.of(context).pop();
              },
              width: 400,
              height: 300,
            ),
          );
        },
      );
    }).toList(),
  );
}
