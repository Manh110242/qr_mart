import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/banner_bloc.dart';

// ignore: must_be_immutable
class SliderProduct extends StatelessWidget {
  var slider_home1_bloc = new BannerBloc();
  final List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: slider_home1_bloc.getBanner('1', '5', ''),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: ClipRRect(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 200,
                      viewportFraction: 1.0,
                    ),
                    items: List.generate(snapshot.data.length, (index) =>  Container(
                      child: Image.network(snapshot.data[index].src,
                          fit: BoxFit.cover, width: width),
                    )),
                  ),
                ));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
