import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastSnackBar(BuildContext context, String a) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(a),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

void showToast(String text, BuildContext context, Color c, IconData i) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: c,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          flex: 8,
          child: Text(text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ],
    ),
  );

  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

void showToastErr(String text, BuildContext context, Color c, IconData i) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey.shade300,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i, color: Colors.red,),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          flex: 8,
          child: Text(text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: c,
            ),
          ),
        )
      ],
    ),
  );

  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

void showToastDone(String text, BuildContext context, Color c, IconData i) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey.shade200,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i, color: Colors.red,),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          flex: 8,
          child: Text(text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: c),
          ),
        )
      ],
    ),
  );

  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
