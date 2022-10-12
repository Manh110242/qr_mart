import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
class Change_pass2 extends StatefulWidget {
  // change_pass({Key key, this.title,this.mail}) : super(key: key);
  // final String title;
  // String mail;
  @override
  _Change_pass2 createState() => _Change_pass2();
}

class _Change_pass2 extends State<Change_pass2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var bloc;

  TextEditingController pass = new TextEditingController();
  TextEditingController newpass = new TextEditingController();
  TextEditingController newpass2 = new TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new UserBloc();
  }
  updatepass2() async {
    LoadingDialog.showLoadingDialog(context, "Đang tải...");
    var updatePass = await  bloc.updatepass2(newpass2.text, pass.text);
    LoadingDialog.hideLoadingDialog(context);
    if(updatePass!= null){
      if(updatePass['code'] == 1){
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, 'Đổi mật khẩu thành công', 'Thành công');
      }else{
        MsgDialog.showMsgDialog(context, "Mật khẩu củ không chính xác", 'Lỗi');
      }
    }else{
      MsgDialog.showMsgDialog(context, 'Lỗi kết nối', 'Lỗi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Đổi mật khẩu"),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 10, right: 10,bottom: 30),
              child: Column(
                children: [
                  SizedBox(
                    child: Text(
                      'Đổi mật khẩu cấp 2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8f8b21),
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Pass
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: TextFormField(
                      controller: pass,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        errorText:null,
                        labelText: "Mật khẩu cũ",
                        labelStyle: TextStyle(color: Color(0xff8f8b21)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffc4a95a)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xff8f8b21), width: 3),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xffc4a95a))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mật khẩu cũ không được để trống';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Mật khẩu
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: newpass,
                          obscureText: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: "Nhập mật khẩu",
                            errorText: null,
                            labelStyle: TextStyle(color: Color(0xff8f8b21)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Mật khẩu không được bỏ trống';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  // Nhập lại mật khẩu
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: newpass2,
                          obscureText: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            labelText: "Nhập lại mật khẩu",
                            labelStyle: TextStyle(color: Color(0xff8f8b21)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xffc4a95a)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff8f8b21), width: 3),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffc4a95a))),
                          ),
                          validator: (value) {
                            if(value.isEmpty)
                              return 'Mật khẩu không được bỏ trống';
                            if(value != newpass.text)
                              return 'Mật khẩu không khớp';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  // Đổi mật khẩu
                  Padding(
                    padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            updatepass2();
                          }
                        },
                        child: Text('Đổi mật khẩu',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
