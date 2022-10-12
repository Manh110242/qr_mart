import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_notification.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/screen/before_login.dart';
import 'package:gcaeco_app/screen/layouts/layout_notification/list_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat_screen.dart';

// ignore: camel_case_types
class Notification_Fragment extends StatefulWidget {
  final SharedPreferences prefs;

  Notification_Fragment({this.prefs});

  @override
  _Notification_State createState() => _Notification_State();
}

// ignore: camel_case_types
class _Notification_State extends State<Notification_Fragment> {
  BlocNotification bloc = new BlocNotification();

  @override
  Widget build(BuildContext context) {
    bloc.gettbc();
    bloc.getKM();
    bloc.getDh();
    bloc.getCn();
    bloc.getMsg();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        centerTitle: true,
        title: Text(
          "Thông báo",
        ),
      ),
      body: body(),
    );
  }

  body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ThongBaoChung(),
            Divider(),
            KhuyenMai(),
            Divider(),
            DonHang(),
            Divider(),
            CapNhat(),
            Divider(),
            TinNhan(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget ThongBaoChung() {
    return InkWell(
      onTap: () async {
        await bloc.deleteMsg2();
        await bloc.deleteMsg();
        await bloc.deletecn();
        await bloc.deletedh();
        await bloc.deletekm();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListNotification(
                  title: 'Thông báo chung',
                  type: '',
                )));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.home_outlined,
                  color: Colors.red,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Thông báo chung',
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: bloc.tbcStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.toString() != "0"
                            ? Text("(+${snapshot.data})", style: TextStyle(color: Colors.red,fontSize: 13),)
                            : Text("");
                      } else {
                        return Text("");
                      }
                    }),
                Icon(Icons.chevron_right_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget KhuyenMai() {
    return InkWell(
      onTap: () async {
        await bloc.deletecount("countkm");
        await bloc.deletekm();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListNotification(
                  title: 'Khuyến mãi',
                  type: '1',
                )));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.red,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Khuyến mãi',
                      style: TextStyle(fontSize: 15),
                    ))
              ],
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: bloc.kmmsqStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.toString() != "0"
                            ? Text("(+${snapshot.data})", style: TextStyle(color: Colors.red,fontSize: 13),)
                            : Text("");
                      } else {
                        return Text("");
                      }
                    }),
                Icon(Icons.chevron_right_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget DonHang() {
    return InkWell(
      onTap: () async {
        await bloc.deletecount("countdh");
        await bloc.deletedh();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListNotification(
                  title: 'Đơn hàng',
                  type: '2',
                )));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bookmark_border,
                  color: Colors.red,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Đơn hàng',
                      style: TextStyle(fontSize: 15),
                    ))
              ],
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: bloc.ordermsqStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.toString() != "0"
                            ? Text("(+${snapshot.data})", style: TextStyle(color: Colors.red,fontSize: 13),)
                            : Text("");
                      } else {
                        return Text("");
                      }
                    }),
                Icon(Icons.chevron_right_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget CapNhat() {
    return InkWell(
      onTap: () async {
        await bloc.deletecount("countcn");
        await bloc.deletecn();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListNotification(
                  title: 'Cập nhật',
                  type: '3',
                )));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.red,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Cập nhật',
                      style: TextStyle(fontSize: 15),
                    ))
              ],
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: bloc.updatemsqStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.toString() != "0"
                            ? Text("(+${snapshot.data})", style: TextStyle(color: Colors.red,fontSize: 13),)
                            : Text("");
                      } else {
                        return Text("");
                      }
                    }),
                Icon(Icons.chevron_right_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget TinNhan() {
    return InkWell(
      onTap: () async {
        await bloc.deletecount("countmsg");
        await bloc.deleteMessage();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              currentUserNo: SharedPreference.prefs.getString("phone"),
              prefs: widget.prefs,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.message,
                  color: Colors.red,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Tin nhắn',
                      style: TextStyle(fontSize: 15),
                    ))
              ],
            ),
            Row(
              children: [
                StreamBuilder(
                    stream: bloc.messageStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.toString() != "0"
                            ? Text("(+${snapshot.data})", style: TextStyle(color: Colors.red,fontSize: 13),)
                            : Text("");
                      } else {
                        return Text("");
                      }
                    }),
                Icon(Icons.chevron_right_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget TinNhan() {
  //   return FutureBuilder(
  //       future: Const.web_api.getNotifiWallet(),
  //       builder: (_, snap) {
  //         return InkWell(
  //           onTap: () async {
  //             if (snap.hasData) {
  //               await Const.web_api.saveTotalNotification(-snap.data);
  //               await Const.web_api.deleteNotifiWallet();
  //               setState(() {});
  //             }
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ChatScreen(
  //                   currentUserNo:
  //                       SharedPreference.prefs.getString(Dbkeys.phone),
  //                   prefs: widget.prefs,
  //                 ),
  //               ),
  //             );
  //           },
  //           child: Container(
  //             padding: EdgeInsets.only(top: 10, bottom: 10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.message,
  //                       color: Colors.red,
  //                     ),
  //                     Padding(
  //                         padding: EdgeInsets.only(left: 10),
  //                         child: Text(
  //                           'Tin nhắn',
  //                           style: TextStyle(fontSize: 15),
  //                         ))
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     snap.hasData
  //                         ? Text(
  //                             "+${snap.data}",
  //                             style: TextStyle(color: Colors.red, fontSize: 14),
  //                           )
  //                         : Container(),
  //                     Icon(Icons.chevron_right_outlined)
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
