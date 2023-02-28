import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:gcaeco_app/screen/screen_sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */
class Login_Screen extends StatefulWidget {
  SharedPreferences prefs;

  Login_Screen({this.prefs});

  @override
  _Login_Screen_State createState() => _Login_Screen_State();
}

class _Login_Screen_State extends State<Login_Screen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String deviceId;
  var mapDeviceInfo = {};
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceid;

  @override
  void initState() {
    super.initState();
    setdeviceinfo();
    _getToken();
  }

  setdeviceinfo() async {
    if (Platform.isAndroid == true) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceid = androidInfo.id + androidInfo.androidId;
        mapDeviceInfo = {
          Dbkeys.deviceInfoMODEL: androidInfo.model,
          Dbkeys.deviceInfoOS: 'android',
          Dbkeys.deviceInfoISPHYSICAL: androidInfo.isPhysicalDevice,
          Dbkeys.deviceInfoDEVICEID: androidInfo.id,
          Dbkeys.deviceInfoOSID: androidInfo.androidId,
          Dbkeys.deviceInfoOSVERSION: androidInfo.version.baseOS,
          Dbkeys.deviceInfoMANUFACTURER: androidInfo.manufacturer,
          Dbkeys.deviceInfoLOGINTIMESTAMP: DateTime.now(),
        };
      });
    } else if (Platform.isIOS == true) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceid = iosInfo.systemName + iosInfo.model + iosInfo.systemVersion;
        mapDeviceInfo = {
          Dbkeys.deviceInfoMODEL: iosInfo.model,
          Dbkeys.deviceInfoOS: 'ios',
          Dbkeys.deviceInfoISPHYSICAL: iosInfo.isPhysicalDevice,
          Dbkeys.deviceInfoDEVICEID: iosInfo.identifierForVendor,
          Dbkeys.deviceInfoOSID: iosInfo.name,
          Dbkeys.deviceInfoOSVERSION: iosInfo.name,
          Dbkeys.deviceInfoMANUFACTURER: iosInfo.name,
          Dbkeys.deviceInfoLOGINTIMESTAMP: DateTime.now(),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Đăng nhập'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/logo-V.png'),
                    )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Đăng nhập hệ sinh thái $appName',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Config.green,
                        fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      'Đăng nhập $appName để mua, bán, theo dõi đơn hàng, nhận nhiều ưu đãi hấp dẫn.',
                      style: TextStyle(color: Config.green, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Nhập email hoặc số điện thoại',
                      labelStyle: TextStyle(color: Config.green),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Config.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Config.green, width: 3),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Config.green)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Nhập mật khẩu',
                      labelStyle: TextStyle(color: Config.green),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Config.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Config.green, width: 3),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Config.green)),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _onLoginClick,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          MsgDialog.showMsgDialogGmail(
                              context, gmailController, "Quên mật khẩu?");
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sign_Up_Screen()));
                        },
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      deviceId = token;
    });
  }

  void _onLoginClick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      String username = _emailController.text;
      String password = _passController.text;
      final response = await checkLogin(username, password);
      if (response['code'] == 200) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .where(Dbkeys.email, isEqualTo: _emailController.text)
            .get();

        final List documents = result.docs;

        if (documents.isEmpty) {
          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(response['data']['phone'])
              .set({
            Dbkeys.publicKey: '',
            Dbkeys.privateKey: '',
            Dbkeys.countryCode: 'phoneCode',
            Dbkeys.nickname: response['data']['username'],
            Dbkeys.photoUrl: '',
            Dbkeys.id: response['data']['id'],
            Dbkeys.email: response['data']['email'],
            Dbkeys.phone: response['data']['phone'],
            Dbkeys.phoneRaw: response['data']['phone'],
            Dbkeys.authenticationType: '',
            Dbkeys.aboutMe: '',
            //---Additional fields added for Admin app compatible----
            Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
            Dbkeys.joinedOn: DateTime.now().millisecondsSinceEpoch,
            Dbkeys.searchKey: response['data']['username']
                .toString()
                .trim()
                .substring(0, 1)
                .toUpperCase(),
            Dbkeys.videoCallMade: 0,
            Dbkeys.videoCallRecieved: 0,
            Dbkeys.audioCallMade: 0,
            Dbkeys.groupsCreated: 0,
            Dbkeys.groupsJoinedList: [],
            Dbkeys.audioCallRecieved: 0,
            Dbkeys.mssgSent: 0,
            Dbkeys.deviceDetails: mapDeviceInfo,
            Dbkeys.currentDeviceID: deviceid,
            // Dbkeys.phonenumbervariants: phoneNumberVariantsList(
            //     countrycode: phoneCode, phonenumber: _phoneNo.text)
          }, SetOptions(merge: true));
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
                    response['data']['email'] + 'XXX' + 'userapp',
              }
            ])
          });

          await prefs.setString(Dbkeys.email, response['data']['email']);
          await prefs.setString(
              Dbkeys.nickname, response['data']['username'].toString().trim());
          await prefs.setString(Dbkeys.photoUrl, '');
          await prefs.setString(
              Dbkeys.phone, response['data']['phone'].toString().trim());
          await prefs.setString(Dbkeys.countryCode, '');
          String fcmToken = await FirebaseMessaging().getToken();

          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(response['data']['phone'])
              .set({
            Dbkeys.notificationTokens: [fcmToken]
          }, SetOptions(merge: true));

          await prefs.setInt(Dbkeys.id, response['data']['id']);
          await prefs.setString(
              Dbkeys.nickname, response['data']['username'].trim());
          await prefs.setString(Dbkeys.photoUrl, '');
          await prefs.setString(Dbkeys.phone, response['data']['phone']);
          await subscribeToNotification(response['data']['phone']);
        } else {
          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(response['data']['phone'])
              .update(
                !documents[0].data().containsKey(Dbkeys.deviceDetails)
                    ? {
                        Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
                        Dbkeys.joinedOn:
                            documents[0].data()[Dbkeys.lastSeen] != true
                                ? documents[0].data()[Dbkeys.lastSeen]
                                : DateTime.now().millisecondsSinceEpoch,
                        Dbkeys.nickname:
                            response['data']['username'].toString().trim(),
                        Dbkeys.searchKey: response['data']['username']
                            .toString()
                            .trim()
                            .substring(0, 1)
                            .toUpperCase(),
                        Dbkeys.videoCallMade: 0,
                        Dbkeys.videoCallRecieved: 0,
                        Dbkeys.audioCallMade: 0,
                        Dbkeys.audioCallRecieved: 0,
                        Dbkeys.mssgSent: 0,
                      }
                    : {
                        Dbkeys.searchKey: response['data']['username']
                            .toString()
                            .trim()
                            .substring(0, 1)
                            .toUpperCase(),
                        Dbkeys.nickname:
                            response['data']['username'].toString().trim(),
                        Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
                        Dbkeys.deviceDetails: mapDeviceInfo,
                        Dbkeys.currentDeviceID: deviceid,
                        // Dbkeys.phonenumbervariants: phoneNumberVariantsList(
                        //     countrycode: documents[0][Dbkeys.countryCode],
                        //     phonenumber: documents[0][Dbkeys.phoneRaw])
                      },
              );

          await prefs.setString(Dbkeys.id, response['data']['id'].toString());
          await prefs.setString(
              Dbkeys.nickname, response['data']['username'].trim());
          await prefs.setString(Dbkeys.photoUrl, '');
          await prefs.setString(Dbkeys.phone, response['data']['phone']);
          String fcmToken = await FirebaseMessaging().getToken();

          await FirebaseFirestore.instance
              .collection(DbPaths.collectionusers)
              .doc(response['data']['phone'])
              .set({
            Dbkeys.notificationTokens: [fcmToken]
          }, SetOptions(merge: true));

          await subscribeToNotification(documents[0][Dbkeys.phone]);
        }

        LoadingDialog.hideLoadingDialog(context);
        goHome();
      } else {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, response['errors'], 'Đăng nhập');
      }
    } catch (e) {
      print("++++++++");
      print(e.toString());
      print("++++++++");
    }
  }

  subscribeToNotification(String currentUserNo) async {
    await FirebaseMessaging().subscribeToTopic(
        // '${currentUserNo.replaceFirst(new RegExp(r'\+'), '')}',
        currentUserNo).catchError((err) {
      print('ERROR SUBSCRIBING NOTIFICATION' + err.toString());
    });
    await FirebaseMessaging()
        .subscribeToTopic(Dbkeys.topicUSERS)
        .catchError((err) {
      print('ERROR SUBSCRIBING NOTIFICATION' + err.toString());
    });
    await FirebaseMessaging()
        .subscribeToTopic(Platform.isAndroid
            ? Dbkeys.topicUSERSandroid
            : Platform.isIOS
                ? Dbkeys.topicUSERSios
                : Dbkeys.topicUSERSweb)
        .catchError((err) {
      print('ERROR SUBSCRIBING NOTIFICATION' + err.toString());
    });
  }

  goHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  page: 2,
                  prefs: prefs,
                ))).then((onValue) {});
  }

  checkLogin(String username, String password) async {
    var token = await Const.web_api.getToken();
    Map<String, dynamic> response = new Map<String, dynamic>();
    if (token == '') {
      response['code'] = 404;
      response['errors'] = 'Kết nối server thất bại';
    } else {
      Map<String, dynamic> request_body = new Map<String, dynamic>();
      Map<String, String> loginForm = new Map<String, String>();
      loginForm['email'] = username;
      loginForm['password'] = password;
      request_body['LoginForm'] = loginForm;
      request_body['device_id'] = deviceId;
      var res =
          await Const.web_api.postAsync("/app/home/login", token, request_body);

      if (res != null) {
        if (res['code'] == 1) {
          bool status = await saveLogin(res['data']);

          if (status) {
            response['code'] = 200;
            response['data'] = res['data'];
          }
        } else {
          response['code'] = 404;
          response['errors'] = 'Thông tin đăng nhập không đúng.';
        }
      } else {
        response['code'] = 404;
        response['errors'] = 'Kết nối server thất bại';
      }
    }
    return response;
  }

  Future<bool> saveLogin(response) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString('islogin_v2', '1');
    prefs.setString('id', response['id'].toString());
    prefs.setString('username', response['username'].toString());
    prefs.setString('auth_key', response['auth_key'].toString());
    prefs.setString('password-hash', response['password-hash'].toString());
    prefs.setString('phone', response['phone'].toString());
    prefs.setString('email', response['email'].toString());
    prefs.setString('status', response['status'].toString());
    prefs.setString('created_at', response['created_at'].toString());
    prefs.setString('updated_at', response['updated_at'].toString());
    prefs.setString('address', response['address'].toString());
    prefs.setString('facebook', response['facebook'].toString());
    prefs.setString('link_facebook', response['link_facebook'].toString());
    prefs.setString('is_notification', response['is_notification'].toString());
    prefs.setString('sex', response['sex'].toString());
    prefs.setString('birthday', response['birthday'].toString());
    prefs.setString('avatar_path', response['avatar_path'].toString());
    prefs.setString('avatar_name', response['avatar_name'].toString());
    prefs.setString('token_app', response['token_app'].toString());
    prefs.setString('token_user', response['token_app'].toString());
    prefs.setString("tokenA", response['tokenA'].toString());
    if (response['_shop'] != null && response['_shop'].toString() == "0") {
      prefs.setBool("isShop", false);
    } else if (response['_shop'] != null) {
      prefs.setBool("isShop", true);
      prefs.setString("name_Shop", response['_shop']['name'].toString());
    } else {
      prefs.setBool("isShop", false);
    }
    String islogin = prefs.getString('islogin_v2');
    if (islogin == '1') {
      return true;
    }
    return false;
  }
}
