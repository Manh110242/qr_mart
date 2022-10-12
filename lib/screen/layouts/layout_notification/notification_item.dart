import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gcaeco_app/helper/Config.dart';

class NotificationItem extends StatefulWidget {
  String title,noidung;

  NotificationItem({this.title,this.noidung});
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text(widget.title, style: TextStyle(fontSize: 16),),
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Html(data: widget.noidung,),
        ),
      ),
    );
  }
}
