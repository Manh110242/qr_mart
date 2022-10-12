//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/item_share/my_elevated_button.dart';
import 'package:gcaeco_app/item_share/my_simple_button.dart';
import 'package:gcaeco_app/item_share/pickup_layout.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/screen/chat_room.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddunsavedNumber extends StatefulWidget {
  final String currentUserNo;
  final DataModel model;
  final SharedPreferences prefs;

  const AddunsavedNumber(
      {@required this.currentUserNo,
      @required this.model,
      @required this.prefs});

  @override
  _AddunsavedNumberState createState() => _AddunsavedNumberState();
}

class _AddunsavedNumberState extends State<AddunsavedNumber> {
  bool isLoading, isUser = true;
  bool istyping = true;

  @override
  initState() {
    super.initState();
    // getUser();
    // isLoading = true;
  }

  getUser(String searchphone) {
    FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(searchphone)
        .get()
        .then((user) {
      if (user.exists &&
          user.data().containsKey(Dbkeys.phone) &&
          user.data().containsKey(Dbkeys.phoneRaw) &&
          user.data().containsKey(Dbkeys.countryCode)) {
        setState(() {
          isLoading = false;
          istyping = false;
          isUser = user.exists;

          if (isUser) {
            // var peer = user;
            widget.model.addUser(user);
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) => ChatRoom(
                        prefs: widget.prefs,
                        unread: 0,
                        currentUserNo: widget.currentUserNo,
                        model: widget.model,
                        peerNo: searchphone)));
          }
        });
      } else {
        setState(() {
          isLoading = false;
          isUser = false;
          istyping = false;
        });
      }
    }).catchError((err) {});
  }

  final _phoneNo = TextEditingController();

  Widget buildLoading() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(17, 52, 17, 8),
          child: Container(
            margin: EdgeInsets.only(top: 0),

            // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            // height: 63,
            height: 63,
            // width: w / 1.18,
            child: Form(
              // key: _enterNumberFormKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  hintStyle: TextStyle(
                    color: fiberchatGrey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: fiberchatGrey.withOpacity(0.2),
                      width: 2.0,
                    ),
                  ),
                ),
                controller: _phoneNo,
                onSaved: (phone) {
                  setState(() {
                    istyping = true;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(13, 22, 13, 8),
          child: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(fiberchatLightGreen)),
                )
              : MySimpleButton(
                  buttoncolor: Config().colorMain.withOpacity(0.99),
                  buttontext: 'Tìm kiếm',
                  onpressed: () {
                    RegExp e164 = new RegExp(r'[1-9]\d{1,10}$');

                    String _phone = _phoneNo.text.toString().trim();
                    if ((_phone.isNotEmpty && e164.hasMatch(_phone)) &&
                        widget.currentUserNo != _phone) {
                      setState(() {
                        isLoading = true;
                      });

                      getUser(_phone);
                    } else {
                      HelperFunctions.toast(widget.currentUserNo != _phone
                          ? 'Valid Number'
                          : 'Valid Number');
                    }
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.getNTPWrappedWidget(
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                  color: DESIGN_TYPE == Themetype.whatsapp
                      ? fiberchatWhite
                      : fiberchatBlack,
                ),
              ),
              backgroundColor: Config().colorMain,
              title: Text(
                'Tìm kiếm người dùng',
                style: TextStyle(
                  fontSize: 17,
                  color: DESIGN_TYPE == Themetype.whatsapp
                      ? fiberchatWhite
                      : fiberchatBlack,
                ),
              )),
          body: Stack(children: <Widget>[
            Container(
                child: Center(
                  child: !isUser
                      ? istyping == true
                      ? SizedBox()
                      : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 140,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                              _phoneNo.text.trim() +
                                  ' ' +
                                  'does not exist in ' +
                                  Appname,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fiberchatBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        myElevatedButton(
                          color: fiberchatBlue,
                          child: Text(
                            'Invite',
                            style: TextStyle(color: fiberchatWhite),
                          ),
                          onPressed: () {
                            // Fiberchat.invite(context);
                          },
                        )
                      ])
                      : Container(),
                )),
            // Loading
            buildLoading()
          ]),
          backgroundColor: fiberchatWhite,
        ));
  }
}
