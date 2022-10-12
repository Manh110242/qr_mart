import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/Home_Fragments/profile.dart';
import 'package:gcaeco_app/screen/screen_home.dart';

// ignore: camel_case_types
class Screen_Success_Order extends StatefulWidget {
  @override
  _Screen_Success_Order_State createState() => _Screen_Success_Order_State();
}

// ignore: camel_case_types
class _Screen_Success_Order_State extends State<Screen_Success_Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Đặt hàng thành công"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment(0, 0),
                children: [
                  Icon(Icons.circle, size: 90, color: Config().colorMain,),
                  Icon(Icons.check, size: 50, color: Colors.white,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Đặt hàng thành công".toUpperCase(),
                  style: TextStyle(color: Config().colorMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Mã số đơn hàng của bạn là: ", style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 16),),
                    Text("OR1606440499", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Key: ", style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 16)),
                    Text("1606440499904615fc056337324d", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child:
                Text("Vui lòng lưu lại mã đơn hàng và key của bạn",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child:

                SizedBox(
                    width: 1.9 * MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    child: Text(
                      "Nếu có yêu cầu gì đặc biệt xin vui lòng liên hệ với số điện thoại " +
                          "02466623632", style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,)),
                // Text("02466623632", style: TextStyle(fontSize: 16, color: Colors.red),),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child:

                SizedBox(
                    width: 1.9 * MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    child: Text("Cảm ơn bạn đã đặt hàng", style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,)),
                // Text("02466623632", style: TextStyle(fontSize: 16, color: Colors.red),),

              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FlatButton(
                    color: Colors.blueGrey,
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => Home(page: 3,)),ModalRoute.withName('/'));
                    },
                    child: Text("Đơn hàng của tôi", style: TextStyle(color: Colors.white),),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
