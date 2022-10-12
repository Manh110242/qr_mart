import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MSGItem  extends StatelessWidget {
  String title;
  String msg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
            child: Text('Xóa'),
            onPressed: (){
              Navigator.of(context).pop(context);
            }
        ),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            Navigator.of(context).pop(context);
          },
        ),

      ],
    );
  }
}
