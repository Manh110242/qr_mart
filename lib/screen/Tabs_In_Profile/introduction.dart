import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/banner_bloc.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  String urlImage = Const().image_host +
      '/media/files/banners/881_1611832423_69460129c6751e00.jpg';
  String link = '${Const().domain}/dang-ky.html?user_id=';
  String us_id = '';
  TextEditingController controller = TextEditingController();
  var user_before = '';
  BannerBloc blocBanner = new BannerBloc();
  bool isUserBefore = false;
  var bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = UserBloc();
    linkShare();
    getuserbefore();
  }

  getuserbefore() async {
    //user_before = await Const.web_api.getUserBefore();
    var user = await bloc.getUser();
    user_before = user.user_before;
    var user_gt_app = user.user_gt_app;
    if (user_gt_app == '1') {
      setState(() {
        isUserBefore = true;
      });
    } else {
      setState(() {
        isUserBefore = false;
      });
    }
  }

  linkShare() async {
    var user_id = await Const.web_api.getUserId();
    setState(() {
      link = link + user_id;
      us_id = user_id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        centerTitle: true,
        title: Text(
          "Giới thiệu $appName",
          style: TextStyle(fontSize: 16),
        ),
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
            FutureBuilder(
                future: blocBanner.getBanner("15", "1", ""),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Container();
                  if(snapshot.data.length == 0) return Container();
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewContainer(
                                    snapshot.data[0].link,
                                    "Giới thiệu Vzoneland")));
                      },
                      child: Image.network(snapshot.data[0].src, fit: BoxFit.contain,));
                },
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhận ngay voucher sau khi giới thiệu bạn bè, '
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
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Tải app $appName',
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
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Đăng ký tài khoản $appName và nhập ID người giới thiệu (nếu có)',
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
                    'Link giới thiệu bạn bè',
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
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade600),
                          ),
                          child: Text(
                            link != null ? link : '',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black87),
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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          'ID giới thiệu: ',
                          textScaleFactor: 1.2,
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Text(
                          us_id,
                          textScaleFactor: 1.2,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 5,
              color: Colors.grey.shade200,
            ),
            isUserBefore
                ? Container(
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
                                    labelText: 'Mã giới thiệu của bạn bè',
                                    isDense: true, // Added this
                                    contentPadding:
                                        EdgeInsets.all(9), // Added this
                                  ),
                                )),
                            Flexible(
                                flex: 3,
                                child: MaterialButton(
                                  onPressed: () async {
                                    var res = await bloc
                                        .postUserBefore(controller.text);
                                    var res1 = await bloc.postAffilliate();
                                    if (res['code'].toString() == "1") {
                                      showToast(res['message'].toString(),
                                          context, Colors.grey, Icons.check);
                                      Navigator.pop(context);
                                    } else {
                                      showToast(
                                          res['error'].toString(),
                                          context,
                                          Colors.grey,
                                          Icons.error_outline);
                                    }
                                  },
                                  color: Config().colorMain,
                                  child: Text(
                                    'XÁC NHẬN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                        Text(
                          'Vui lòng nhập mã giới thiệu để kích hoạt Voucher thưởng vào ví của bạn.',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          page: 1,
                                        )));
                          },
                          child: Text(
                            ' Ví của tôi',
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                'Bạn đã nhập mã giới thiệu: ',
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                              Text(
                                user_before,
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          page: 1,
                                          prefs: prefs,
                                        )));
                          },
                          child: Text(
                            ' Ví của tôi',
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 15),
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
