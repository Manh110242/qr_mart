import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifi extends StatefulWidget {
  @override
  _NotifiState createState() => _NotifiState();
}

class _NotifiState extends State<Notifi> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
    });
  }

  List<Message> messagesList;

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('---------------------------------------------------------onMessage');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('---------------------- onLaunch');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('---------------------- Resum');
        _setMessage(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
    });
  }

  @override
  void initState() {
    super.initState();
    messagesList = new List<Message>();
    //_getToken();
    //_configureFirebaseListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('adfdf'),
      ),
      body:Container(
        margin: EdgeInsets.all(50),
        child: InkWell(
          onTap: (){
            sendAndRetrieveMessage();
          },
          child: Icon(Icons.camera_alt),
        ),
      )
    );
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    final String serverToken = 'AAAAcpDd7nI:APA91bG_rCp0VJMr21jVsFxiG'
        '2KDlKKGwvQgynNjwVzBuXNjfN8mkIp-56KbMMgQXPGDrkC2vzlEuF0NZ63qm3h'
        'g_vjjukj65bUcHyWKFMFTMSRdLIldeeVgWbs68Tya1YRpZf0PBiD7';
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Mạnh óc chó',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            // 'id': '1:492056735346:android:56bbc743b9091b180fdceb',
            'id': '1',
            'status': 'done'
          },
          'to': {""},
        },
      ),
    );
  }
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
