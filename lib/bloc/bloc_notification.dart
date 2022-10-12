import 'dart:async';

import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/notification_modle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocNotification {
  List<NotificationModle> addListNotification = new List<NotificationModle>();
  SharedPreferences prefs;

  StreamController addNotification = new StreamController<dynamic>();

  Stream<dynamic> get allNotification => addNotification.stream;

  StreamController allmsg = new StreamController.broadcast();

  Stream<dynamic> get adllmsgStream => allmsg.stream;

  StreamController tbc = new StreamController.broadcast();

  Stream<dynamic> get tbcStream => tbc.stream;

  StreamController updatemsq = new StreamController.broadcast();

  Stream<dynamic> get updatemsqStream => updatemsq.stream;

  StreamController ordermsq = new StreamController.broadcast();

  Stream<dynamic> get ordermsqStream => ordermsq.stream;

  StreamController kmmsq = new StreamController.broadcast();

  Stream<dynamic> get kmmsqStream => kmmsq.stream;

  StreamController message = new StreamController.broadcast();

  Stream<dynamic> get messageStream => message.stream;

  callApiNotification(int page, String type) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body = {"user_id": user_id, "page": page, "type": type};
    var response = await Const.web_api
        .postAsync('/app/user/get-notifycations', token, request_body);
    if (response != null) {
      if (response['data'] != null) {
        if (response['data'].length > 0) {
          for (var res in response['data']) {
            var notification = new NotificationModle(
              id: res['id'],
              title: res['title'],
              description: res['description'],
              link: res['link'],
              type: res['type'],
              recipient_id: res['recipient_id'],
              sender_id: res['sender_id'],
              unread: res['unread'],
              created_at: res['created_at'],
              updated_at: res['updated_at'],
            );

            addListNotification.add(notification);
          }
        }
      }
    }
    addNotification.sink.add(addListNotification);
  }

  status(String id) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body = {
      "user_id": user_id,
      "id": id,
    };
    var response = await Const.web_api
        .postAsync('/app/user/read-notifycation', token, request_body);
    return response;
  }

  setNotifiHome() async {
    prefs = await SharedPreferences.getInstance();
    int count =
        prefs.getInt("countHome") != null ? prefs.getInt("countHome") : 0;
    count++;
    prefs.setInt("countHome", count);
    allmsg.sink.add(count);
  }

  deleteHome() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("countHome");
    allmsg.sink.add(null);
  }

  getNotifiHome() async {
    prefs = await SharedPreferences.getInstance();
    int count =
        prefs.getInt("countHome") != null ? prefs.getInt("countHome") : 0;
    prefs.setInt("countHome", count);
    allmsg.sink.add(count);
  }

  gettbc() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("count") != null ? prefs.getInt("count") : 0;
    tbc.sink.add(count);
  }

  getKM() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countkm") != null ? prefs.getInt("countkm") : 0;
    kmmsq.sink.add(count);
  }

  getDh() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countdh") != null ? prefs.getInt("countdh") : 0;
    ordermsq.sink.add(count);
  }

  getCn() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countcn") != null ? prefs.getInt("countcn") : 0;
    updatemsq.sink.add(count);
  }

  getMsg() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countmsg") != null ? prefs.getInt("countmsg") : 0;
    message.sink.add(count);
  }

  getAllmsg() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("count") != null ? prefs.getInt("count") : 0;
    count++;
    prefs.setInt("count", count);
    tbc.sink.add(count);
  }

  getCountkm() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countkm") != null ? prefs.getInt("countkm") : 0;
    count++;
    prefs.setInt("countkm", count);
  }

  getCountMessage() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countmsg") != null ? prefs.getInt("countmsg") : 0;
    count++;
    prefs.setInt("countmsg", count);
  }

  getCountdh() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countdh") != null ? prefs.getInt("countdh") : 0;
    count++;
    prefs.setInt("countdh", count);
  }

  getCountcn() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("countcn") != null ? prefs.getInt("countcn") : 0;
    count++;
    prefs.setInt("countcn", count);
  }

  deleteMsg() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('count');
    tbc.sink.add(null);
  }

  deleteMsg2() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('count');
    tbc.sink.add(null);
  }

  delete1Msg() async {
    prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("count") != null ? prefs.getInt("count") : 0;
    if (count > 0) {
      count--;
    }
    prefs.setInt("count", count);
    tbc.sink.add(count);
  }

  deletecount1(key) async {
    prefs = await SharedPreferences.getInstance();
    int count1 = prefs.getInt("$key") != null ? prefs.getInt("$key") : 0;
    int count2 =
        prefs.getInt("countHome") != null ? prefs.getInt("countHome") : 0;

    if (count1 > 0) {
      count1--;
    }
    if (count2 > 0 && count2 > count1) {
      count2 = count2 - count1;
    }
    prefs.setInt("$key", count1);
    prefs.setInt("countHome", count2);
    allmsg.sink.add(count2);
  }

  deletecount(key) async {
    prefs = await SharedPreferences.getInstance();
    int count;
    int count1;
    count = prefs.getInt("count") != null ? prefs.getInt("count") : 0;
    count1 = prefs.getInt("$key") != null ? prefs.getInt("$key") : 0;
    if (count >= count1) {
      count = count - count1;
    }
    prefs.setInt("count", count);
    tbc.sink.add(count);
  }

  deleteMessage() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('countmsg');
    kmmsq.sink.add(null);
  }

  deletekm() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('countkm');
    kmmsq.sink.add(null);
  }

  deletedh() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('countdh');
    ordermsq.sink.add(null);
  }

  deletecn() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('countcn');
    updatemsq.sink.add(null);
  }

  dispose() {
    addNotification.close();
    allmsg.close();
    ordermsq.close();
    updatemsq.close();
    kmmsq.close();
    message.close();
  }
}
