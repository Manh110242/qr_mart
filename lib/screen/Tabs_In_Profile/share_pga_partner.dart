import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/Home_Fragments/wallet.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class SharePgaPartner extends StatefulWidget {
  @override
  _SharePgaPartnerState createState() => _SharePgaPartnerState();
}

class _SharePgaPartnerState extends State<SharePgaPartner> {
  String urlImage =
      'https://png.pngtree.com/thumb_back/fw800/background/20190223/ourmid/'
      'pngtree-full-light-effect-grain-black-gold-banner-background-effectblack-'
      'goldgranulebannerbackgroundspecial-effectsgoldhalo-image_84517.jpg';
  String link = '${Const().domain}/dang-ky.html?user_id=';
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    linkShare();
  }

  linkShare() async {
    var user_id = await Const.web_api.getUserId();
    setState(() {
      link = link + user_id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Giới thiệu $appName"),
      ),
      body: Body(),
    );
  }

  Future _coppy(context) async {
    var user_id = await Const.web_api.getUserId();
    Clipboard.setData(ClipboardData(
        text: '${Const().domain}/dang-ky.html?user_id=' + user_id));
  }

  Widget Body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(height: 150, child: Image.network(urlImage)),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link giới thiệu bạn bè',
                    textScaleFactor: 1.2,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade500),
                          ),
                          child: Text(
                            link != null ? link : '',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: MaterialButton(
                            onPressed: () {
                              _coppy(context);
                              showToast("Copy link giới thiệu thành công",
                                  context, Colors.yellow, Icons.check_circle);
                            },
                            color: Config().colorMain,
                            child: Text(
                              'SAO CHÉP',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: Colors.grey.shade200,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhận ngay 100 điểm (100.000 đ) sau khi giới thiệu bạn bè, '
                    'người thân hoàn thành tất cả các bước sau (cả hai đều nhận được quà): ',
                    textScaleFactor: 1.2,
                    style: TextStyle(
                        height: 1.5, color: Colors.black54, fontSize: 15),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.blue),
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Tải app $appName theo link giới thiệu.',
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.blue),
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Đăng ký tài khoản $appName',
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.blue),
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Nhập mã giới thiệu.',
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: Colors.grey.shade200,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhập mã giới thiệu',
                    textScaleFactor: 1.2,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Mời nhập mã giới thiệu của bạn bè',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: MaterialButton(
                            onPressed: () {},
                            color: Config().colorMain,
                            child: Text(
                              'XÁC NHẬN',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Vui lòng nhập mã giới thiệu kích hoạt điểm.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    page: 1,
                                prefs: prefs,
                                  )));
                    },
                    child: Text(
                      ' Ví điểm',
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
