/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/screen_home.dart';

import '../main.dart';

// ignore: must_be_immutable
class Page404 extends StatelessWidget {
  String err;
  Page404({this.err});
  Widget build(BuildContext context) {
    return Scaffold(
      body: display(),
    );
  }

  Widget display() {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff005030), Config().colorMain])),
      padding: EdgeInsets.only(top: 100, left: 15, right: 15),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              '$appName',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              err ?? 'Kết nối đến server thất bại, quý khách vui lòng thử lại trong giấy lát. Rất xin lỗi vì sự bất tiện này!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
        ],
      )),
    );
  }
}
