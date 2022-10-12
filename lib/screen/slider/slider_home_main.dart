import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/banner_bloc.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

// ignore: must_be_immutable
class SliderHome1 extends StatelessWidget {
  var slider_home1_bloc = new BannerBloc();
  final List<String> imgList = [];

  Future<void> urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Lỗi $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: slider_home1_bloc.getBanner('1', '5', ''),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 150,
                      viewportFraction: 1.0,
                    ),
                    items: List.generate(
                        snapshot.data.length,
                            (index) => InkWell(
                          onTap: () async {
                            if (snapshot.data[index].link
                                .startsWith(Const().domain)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WebViewContainer(
                                              snapshot.data[index].link,
                                              "$appName")));
                            } else {
                              await urlLauncher(snapshot.data[index].link);
                            }
                          },
                          child: Image.network(snapshot.data[index].src,
                              fit: BoxFit.cover, width: 1000),
                        )),
                  ),
                ));
          } else {
            return Container(
              child: Center(),
              height: 180,
            );
          }
        });
  }
}
