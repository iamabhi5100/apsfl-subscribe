import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderCard extends StatelessWidget {
  final List<String> images = [
    'http://bss.apsfl.co.in/sliderimages/slider1.jpg',
    'http://bss.apsfl.co.in/sliderimages/slider2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 10),
      height: width / 2,
      child: CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          viewportFraction: 1.0,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            width: width,
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
