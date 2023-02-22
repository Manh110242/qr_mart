/**
 * Created by trungduc.vnu@gmail.com.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class BeforeLogin extends StatelessWidget {

  final SharedPreferences prefs;

  BeforeLogin({this.prefs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: display(context),
    );
  }

  Widget display(context) {
    return new Container(
      padding: EdgeInsets.only(top: 100),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.check_circle,
          //   size: 50,
          //   color: Colors.green,
          // ),
            Image.asset(
            'assets/images/Asset 13.png',
            height: 60,
            width: 60,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5, top: 10),
            child: Text(
              '$appName',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Bạn đã có tài khoản?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: FlatButton(
              color: Color(0xff2F80ED),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Login_Screen(prefs: prefs,)));
              },
              child: Text('Đăng nhập / Đăng ký',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color:  Color(0xff2F80ED), width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ],
      )),
    );
  }
}
