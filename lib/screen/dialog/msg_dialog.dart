import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:gcaeco_app/screen/Tab_oder/Order_screen.dart';
import 'package:gcaeco_app/screen/layouts/layout_notification/notification_item.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:gcaeco_app/screen/wallet/my_voucher.dart';

class MsgDialog {
  static void showMsgDialog(BuildContext context, String msg, String title, {Function onPressed, bool isRemove = false}) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: Text(msg),
      actions: <Widget>[
        isRemove ? FlatButton(
          child: Text('Đồng ý'),
          onPressed: onPressed,
        ) : SizedBox(),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            if(onPressed != null && !isRemove){
              onPressed();
            }else{
              Navigator.of(context).pop(MsgDialog);
            }
          },
        )
      ],
    ));
  }
  static void showMsgUpdate(BuildContext context, String msg, String title, Function onPressed) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text('Đóng'),
          onPressed: onPressed,
        )
      ],
    ));
  }
  static void showMsgDialogEdt(BuildContext context, TextEditingController sc, String title) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(title,style: TextStyle(color: Colors.blueAccent),),
      ),
      content: TextField(decoration: InputDecoration(
        hintText: title,
      ),
        controller: sc,
        style: TextStyle(fontSize: 14),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Lưu'),
          onPressed: (){
            Navigator.of(context).pop(MsgDialog);
          },
        ),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            Navigator.of(context).pop(MsgDialog);
          },
        ),
      ],
    ));
  }
  static void showMsgDialogGmail(BuildContext context, TextEditingController sc, String title) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(title,style: TextStyle(color: Colors.blueAccent),),
      ),
      content: TextField(decoration: InputDecoration(
        hintText: "Email",
      ),
        controller: sc,
        style: TextStyle(fontSize: 14),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Gửi'),
          onPressed: () async {
          var bloc = new UserBloc();
          var pass = await bloc.forgotpassword(sc.text);
          Navigator.pop(context);
          if(pass != null){
            if(pass["code"] == 1){
               MsgDialog.showMsgDialog(context,'Đã gửi email thành công','Thành công');
            }else{
              MsgDialog.showMsgDialog(context,pass['error'].toString(),'Lỗi');
            }
          }else{
             MsgDialog.showMsgDialog(context,'Kết nối thất bại','Lỗi');
          }
          },
        ),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            Navigator.of(context).pop(MsgDialog);
          },
        ),
      ],
    ));
  }
  static void showMsgDialogNotifi(BuildContext context, var msg, String title) async {

    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(msg['notification']['title'].toString()),
      ),
      content: Text(msg['notification']['body'].toString()),
      actions: <Widget>[
        FlatButton(
          child: Text('Xem'),
          onPressed: (){
            Navigator.of(context).pop(MsgDialog);
            var link;
            if (Platform.isIOS) {
              link = msg['link'];
            } else if (Platform.isAndroid) {
              link = msg['data']['link'];
            }
            if (link.toString().contains('/don-hang') ||
                link.toString().contains('url=%2Fmanagement%2Forder%2Findex')) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Order_Screen(
                    index: 1,
                  )));
            } else if (link.toString().contains('/vi-v') ||
                link.toString().contains('url=%2Fmanagement%2Fgcacoin%2Findex')) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyVoucher()));
            } else if (link.toString().contains('/xu-khoa') ||
                link.toString().contains('url=%2Fmanagement%2Fgcacoin%2Fconfinement')) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyVoucher()));
            } else if (link.toString().startsWith('http')) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      WebViewContainer(link.toString(), 'Thông báo')));
            }else  {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationItem(title: msg['notification']['title'].toString(),noidung: msg['notification']['body'].toString(),)));
            }


          },
        ),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),

      ],
    ));
  }
  static void showDeleteProduc(BuildContext context, var msg, String title,id, Function onPre) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Center(
        child: Text(title),
      ),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text('Xóa'),
          onPressed: () async {
            onPre();
            ShopBloc _bloc = new ShopBloc();
            var res = await _bloc.deletePrd(id);
            if(res){
              showToast("Xóa thành công", context, Colors.grey, Icons.check);
            }else{
              showToast("Xóa thất bại", context, Colors.grey, Icons.error_outline);
            }
            Navigator.of(context).pop(MsgDialog);
          }
            ),
        FlatButton(
          child: Text('Đóng'),
          onPressed: (){
            Navigator.of(context).pop(MsgDialog);
          },
        ),

      ],
    ));
  }
}
