import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(context: context, builder: (context) => new Dialog(
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(msg,style: TextStyle(fontSize: 18),),
            )
          ],
        ),
      ),
    ));
  }

  static void hideLoadingDialog(BuildContext context){
    Navigator.of(context).pop(LoadingDialog);
  }
}
