import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/setting_account/Change_pass.dart';
import 'package:gcaeco_app/screen/setting_account/Change_pass2.dart';
import 'package:gcaeco_app/screen/setting_account/Credit_card.dart';
import 'package:gcaeco_app/screen/setting_account/Location.dart';

import '../screen_profile.dart';

class Setting extends StatefulWidget {

  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting>  {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title:Text( "Thiết lập tài khoản"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Hồ sơ cá nhân",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54
              ),
              ),
            ),
            //===========Thông tin cá nhân
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              ScreenProfile()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Thông tin cá nhân",
                          style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54
                    ),),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //===========Địa chỉ
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              Location()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Địa chỉ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54
                          ),),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //===========Tài khoản
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              Credit_card()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tài khoản/thẻ ngân hàng",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54
                          ),),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Tài khoản",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54
                ),
              ),
            ),
            //=========đổi mật khẩu cấp 1
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              change_pass()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đổi mật khẩu",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54
                          ),),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //===========đổi mk cấp 2
            Material(
              color:  Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              Change_pass2()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đổi mật khẩu cấp 2",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54
                          ),),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
