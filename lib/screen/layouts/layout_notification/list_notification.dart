import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:gcaeco_app/bloc/bloc_notification.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/notification_modle.dart';
import 'package:gcaeco_app/screen/Tab_oder/Order_screen.dart';
import 'package:gcaeco_app/screen/layouts/layout_notification/notification_item.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:gcaeco_app/screen/wallet/my_voucher.dart';
import 'package:intl/intl.dart';

class ListNotification extends StatefulWidget {
  String title;
  String type;

  ListNotification({this.title, this.type});

  @override
  _ListNotificationState createState() => _ListNotificationState();
}

class _ListNotificationState extends State<ListNotification> {
  ScrollController _sc = new ScrollController();
  BlocNotification bloc = new BlocNotification();
  bool loading = false;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.callApiNotification(page, widget.type);
    _sc.addListener(() async  {
      if (_sc.offset >= _sc.position.maxScrollExtent &&
          !_sc.position.outOfRange) {
        setState(() {
          loading = true;
        });
        page++;
        await bloc.callApiNotification(page, widget.type);
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  checkLink(notifi) {
    if (notifi.link.toString().contains('/don-hang') ||
        notifi.link.toString().contains('url=%2Fmanagement%2Forder%2Findex')) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Order_Screen(
            index: 1,
          )));
    } else if (notifi.link.toString().contains('/vi-v') ||
        notifi.link
            .toString()
            .contains('url=%2Fmanagement%2Fgcacoin%2Findex')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyVoucher()));
    } else if (notifi.link.toString().contains('/xu-khoa') ||
        notifi.link
            .toString()
            .contains('url=%2Fmanagement%2Fgcacoin%2Fconfinement')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyVoucher()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationItem(
                title: notifi.title,
                noidung: notifi.description,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Config().colorMain,
      ),
      body: ItemThongBao(),
    );
  }

  Widget ItemThongBao() {
    return StreamBuilder(
        stream: bloc.allNotification,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data.length > 0)
                ? ListView.builder(
                controller: _sc,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  NotificationModle notification = snapshot.data[index];
                  int time = int.parse(notification.created_at) * 1000;
                  String ngay = DateFormat('dd-MM-yyyy', 'en_US')
                      .format(DateTime.fromMillisecondsSinceEpoch(time));
                  String gio = DateFormat('HH: mm', 'en_US')
                      .format(DateTime.fromMillisecondsSinceEpoch(time));
                  var des = notification.description;
                  if(loading == true && index == (snapshot.data.length - 1)){
                    return Center(child:  CircularProgressIndicator(),);
                  }else{
                    return InkWell(
                      onTap: () {
                        bloc.status(notification.id);
                        checkLink(notification);
                      },
                      child: Container(
                        color: (notification.unread == '0')
                            ? Colors.white
                            : Colors.lightBlue.shade50,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (notification.type == '1')
                                      ? Icon(
                                    Icons.flash_on_outlined,
                                    color: Colors.red,
                                  )
                                      : (notification.type == "2")
                                      ? Icon(
                                    Icons.grading_sharp,
                                    color: Colors.blueAccent,
                                  )
                                      : Icon(
                                    Icons
                                        .swap_horizontal_circle_outlined,
                                    color: Colors.deepOrange,
                                  ),
                                  Flexible(
                                    flex: 7,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Html(data: notification.title),
                                          Html(
                                            data: (des.length > 100)
                                                ? des.substring(0, 100) +
                                                '...'
                                                : des,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                                  child: Text(
                                                    '$gio $ngay',
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                })
                : Center(
              child: Text("Không có ${widget.title}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
