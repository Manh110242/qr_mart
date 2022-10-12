/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/Home_Fragments/wallet.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

// ignore: must_be_immutable
class TransferSuccess extends StatelessWidget {
  String content;

  TransferSuccess(this.content);

  Widget build(BuildContext context) {
    return Scaffold(
      body: display(context),
    );
  }

  Widget display(context) {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff005030), Config().colorMain])),
      padding: EdgeInsets.only(top: 100),
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
            Icons.check_circle,
            size: 50,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              this.content,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: FlatButton(
              color: Colors.orange,
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              page: 1,
                              prefs: prefs,
                            )),
                    ModalRoute.withName("/"));
              },
              child: Text('Thực hiên giao dịch khác',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.orange, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ],
      )),
    );
  }
}
