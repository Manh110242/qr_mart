import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screen_login.dart';

// ignore: camel_case_types
class Sign_Up_Screen extends StatefulWidget {
  @override
  _Sign_Up_Screen_State createState() => _Sign_Up_Screen_State();
}

// ignore: camel_case_types
class _Sign_Up_Screen_State extends State<Sign_Up_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var userBloc;

  // ignore: non_constant_identifier_names
  TextEditingController full_name_controller = new TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController email_controller = new TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController password_controller = new TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController cmt = new TextEditingController();

  // ignore: non_constant_identifier_names
  TextEditingController repass_controller = new TextEditingController();
  TextEditingController before_controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = new UserBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Đăng ký'),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 10, right: 10, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Center(
                      child: Text(
                        'Đăng ký tài khoản $appName',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8f8b21),
                            fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 40, right: 40),
                    child: SizedBox(
                      child: Text(
                        'Tạo tài khoản để mua, bán, theo dõi đơn hàng, nhận nhiều ưu đãi hấp dẫn cùng $appName',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Họ và tên
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: TextFormField(
                      controller: full_name_controller,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        errorText: null,
                        labelText: "Họ và tên",
                        labelStyle: TextStyle(color: Color(0xff8f8b21)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffc4a95a)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8f8b21), width: 3),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffc4a95a))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Họ và tên không được để trống';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Số điện thoại
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: phone_controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        errorText: null,
                        labelText: "Số điện thoại",
                        labelStyle: TextStyle(color: Color(0xff8f8b21)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffc4a95a)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8f8b21), width: 3),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffc4a95a))),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Số điện thoại không được bỏ trống';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Email
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: email_controller,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        errorText: null,
                        labelText: "Email",
                        labelStyle: TextStyle(color: Color(0xff8f8b21)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffc4a95a)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8f8b21), width: 3),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffc4a95a))),
                      ),
                      validator: (value) => EmailValidator.validate(value)
                          ? null
                          : "Vui lòng nhập email hợp lệ",
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  //cmt
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 15, left: 10, right: 10),
                  //   child: TextFormField(
                  //     controller: cmt,
                  //     style: TextStyle(fontSize: 16),
                  //     decoration: InputDecoration(
                  //       errorText: null,
                  //       labelText: "CMT/CCCD",
                  //       labelStyle: TextStyle(color: Color(0xff8f8b21)),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: Color(0xffc4a95a)),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide:
                  //             BorderSide(color: Color(0xff8f8b21), width: 3),
                  //       ),
                  //       border: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Color(0xffc4a95a))),
                  //     ),
                  //   ),
                  // ),

                  // Mật khẩu
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: password_controller,
                          obscureText: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: "Nhập mật khẩu",
                            errorText: null,
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
                          controller: repass_controller,
                          obscureText: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            labelText: "Nhập lại mật khẩu",
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
                            if (value.isEmpty)
                              return 'Mật khẩu không được bỏ trống';
                            if (value != password_controller.text)
                              return 'Mật khẩu không khớp';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  //Id giới thiệu
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: before_controller,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            errorText: null,
                            labelText: "ID giới thiệu",
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
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Text(
                      'Ví dụ: ${Const().domain}/dang-ky.html?user_id=523 thì ID giới thiệu sẽ là 523',
                      style: TextStyle(color: Color(0xff8f8b21)),
                    ),
                  ),
                  // Đăng ký

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            singUp();
                          }
                        },
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Bạn đã có tài khoản, đăng nhập '),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                _scaffoldKey.currentContext,
                                new MaterialPageRoute(
                                    builder: (context) => Login_Screen()));
                          },
                          child: Text(
                            'tại đây',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffdbbf6d)),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  singUp() async {
    var request = new Map();
    LoadingDialog.showLoadingDialog(context, 'Loading...');

    request['username'] = full_name_controller.text;
    request['email'] = email_controller.text;
    request['phone'] = phone_controller.text;
    request['password'] = password_controller.text;
    request['user_before'] = before_controller.text;
    if (cmt.text != "") {
      request['cmt'] = cmt.text;
    }
    request['is_notification'] = 1;
    print(request);
    final response = await checksingUp(request);
    if (response['code'] == 200) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .where(Dbkeys.email, isEqualTo: email_controller.text)
          .get();

      final List documents = result.docs;

      if (documents.isEmpty) {
        await FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(phone_controller.text)
            .set({
          Dbkeys.publicKey: '',
          Dbkeys.privateKey: '',
          Dbkeys.countryCode: 'phoneCode',
          Dbkeys.nickname: full_name_controller.text,
          Dbkeys.photoUrl: '',
          Dbkeys.id: 'id',
          Dbkeys.email: email_controller.text.trim(),
          Dbkeys.phone: phone_controller.text,
          Dbkeys.phoneRaw: phone_controller.text,
          Dbkeys.authenticationType: '',
          Dbkeys.aboutMe: '',
          //---Additional fields added for Admin app compatible----
          Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
          Dbkeys.joinedOn: DateTime.now().millisecondsSinceEpoch,
          Dbkeys.searchKey:
              full_name_controller.text.trim().substring(0, 1).toUpperCase(),
          Dbkeys.videoCallMade: 0,
          Dbkeys.videoCallRecieved: 0,
          Dbkeys.audioCallMade: 0,
          Dbkeys.groupsCreated: 0,
          Dbkeys.groupsJoinedList: [],
          Dbkeys.audioCallRecieved: 0,
          Dbkeys.mssgSent: 0,
          // Dbkeys.deviceDetails: mapDeviceInfo,
          // Dbkeys.currentDeviceID: deviceid,
          // Dbkeys.phonenumbervariants: phoneNumberVariantsList(
          //     countrycode: phoneCode, phonenumber: _phoneNo.text)
        }, SetOptions(merge: true));
      }

      await FirebaseFirestore.instance
          .collection(DbPaths.collectionnotifications)
          .doc(DbPaths.adminnotifications)
          .set({
        Dbkeys.nOTIFICATIONxxaction: 'PUSH',
        Dbkeys.nOTIFICATIONxxtitle: 'New User Joined',
        Dbkeys.nOTIFICATIONxximageurl: null,
        Dbkeys.nOTIFICATIONxxlastupdate: DateTime.now(),
        'list': FieldValue.arrayUnion([
          {
            Dbkeys.docid: DateTime.now().millisecondsSinceEpoch.toString(),
            // Dbkeys.nOTIFICATIONxxdesc: widget
            //     .isaccountapprovalbyadminneeded ==
            //     true
            //     ? '${_name.text.trim()} has Joined $Appname. APPROVE the user account. You can view the user profile from All Users List.'
            //     : '${_name.text.trim()} has Joined $Appname. You can view the user profile from All Users List.',
            Dbkeys.nOTIFICATIONxxtitle: 'New User Joined',
            Dbkeys.nOTIFICATIONxximageurl: null,
            Dbkeys.nOTIFICATIONxxlastupdate: DateTime.now(),
            Dbkeys.nOTIFICATIONxxauthor:
                email_controller.text + 'XXX' + 'userapp',
          }
        ])
      });

      // await SharedPreference.prefs
      //     .setString(Dbkeys.email, email_controller.text);
      // await SharedPreference.prefs
      //     .setString(Dbkeys.nickname, full_name_controller.text.trim());
      // await SharedPreference.prefs.setString(Dbkeys.photoUrl, '');
      // await SharedPreference.prefs
      //     .setString(Dbkeys.phone, phone_controller.text.trim());
      // await SharedPreference.prefs.setString(Dbkeys.countryCode, '');
      // String fcmToken = await FirebaseMessaging().getToken();
      //
      // await FirebaseFirestore.instance
      //     .collection(DbPaths.collectionusers)
      //     .doc(phone_controller.text)
      //     .set({
      //   Dbkeys.notificationTokens: [fcmToken]
      // }, SetOptions(merge: true));
      //
      // await subscribeToNotification(phone_controller.text);

      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, 'Đăng ký thành công', 'Thành công');
    } else {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, response['errors'].toString(), 'Lỗi');
    }
  }

  checksingUp(Map request) async {
    var token = await getToken();
    Map<String, dynamic> response = new Map<String, dynamic>();
    if (token == '') {
      response['code'] = 404;
      response['errors'] = 'Kết nối server thất bại';
    } else {
      var res = await userBloc.signUp(request, token);
      if (res != null) {
        if (res['code'] == 1) {
          response['code'] = 200;
        } else {
          response['code'] = 404;
          if (res['data'].length > 0) {
            res['data'].forEach((k, v) {
              response['errors'] = res['data'][k][0];
            });
          }
        }
      } else {
        response['code'] = 404;
        response['errors'] = 'Kết nối server thất bại';
      }
    }
    return response;
  }

  getToken() async {
    String token_response = '';
    DateTime now = new DateTime.now();
    var param = now.toString();
    var token = sha1.convert(utf8.encode(param + Const().key));
    var response = await Const.web_api
        .getAsync("/app/home/start?string=" + param, token.toString());
    if (response != null) {
      if (response['code'] == 1) {
        token_response = response['data']['token'];
      }
    }
    return token_response;
  }
}
