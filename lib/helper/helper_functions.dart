import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperFunctions {
  static String getChatId(String currentUserNo, String peerNo) {
    if (currentUserNo.hashCode <= peerNo.hashCode)
      return '$currentUserNo-$peerNo';
    return '$peerNo-$currentUserNo';
  }

  static void internetLookUp() async {
    try {
      await InternetAddress.lookup('google.com').catchError((e) {
        HelperFunctions.toast('No internet connection ${e.toString()}');
      });
    } catch (err) {
      HelperFunctions.toast('No internet connection. ${err.toString()}');
    }
  }

  static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green.withOpacity(0.95),
      textColor: Colors.white,
    );
  }

  static String getInitials(String name) {
    try {
      List<String> names = name
          .trim()
          .replaceAll(new RegExp(r'[\W]'), '')
          .toUpperCase()
          .split(' ');
      names.retainWhere((s) => s.trim().isNotEmpty);
      if (names.length >= 2)
        return names.elementAt(0)[0] + names.elementAt(1)[0];
      else if (names.elementAt(0).length >= 2)
        return names.elementAt(0).substring(0, 2);
      else
        return names.elementAt(0)[0];
    } catch (e) {
      return '?';
    }
  }

  static String getNickname(Map<String, dynamic> user) {
    if(user[Dbkeys.aliasName] != null){
      return user[Dbkeys.aliasName] ;
    }
    if(user[Dbkeys.nickname] != null){
      return user[Dbkeys.nickname];
    }
    if(user[Dbkeys.phone] != null){
      return user[Dbkeys.phone];
    }
    return user[Dbkeys.email];
  }

  static Widget avatar(Map<String, dynamic> user,
      {File image, double radius = 22.5}) {
    if (image == null) {
      if (user[Dbkeys.aliasAvatar] == null)
        return (user[Dbkeys.photoUrl] ?? '').isNotEmpty
            ? CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    CachedNetworkImageProvider(user[Dbkeys.photoUrl]),
                radius: radius)
            : CircleAvatar(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Text(
                  getInitials(
                    HelperFunctions.getNickname(user),
                  ),
                ),
                radius: radius,
              );
      return CircleAvatar(
        backgroundImage: Image.file(File(user[Dbkeys.aliasAvatar])).image,
        radius: radius,
      );
    }
    return CircleAvatar(
        backgroundImage: Image.file(image).image, radius: radius);
  }

  static Future<int> getNTPOffset() {
    return NTP.getNtpOffset();
  }

  static Widget getNTPWrappedWidget({Widget child}) {
    return FutureBuilder(
        future: NTP.getNtpOffset(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data > Duration(minutes: 1).inMilliseconds ||
                snapshot.data < -Duration(minutes: 1).inMilliseconds)
              return Material(
                  color: Colors.black,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            'Giờ đồng hồ của bạn không đồng bộ với giờ máy chủ. Vui lòng đặt nó ngay để tiếp tục.',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))));
          }
          return child;
        });
  }

  static Widget customCircleAvatarGroup({String url, double radius}) {
    if (url == null || url == '') {
      return CircleAvatar(
        backgroundColor: Color(0xffE6E6E6),
        radius: radius ?? 30,
        child: Icon(
          Icons.people,
          color: Color(0xffCCCCCC),
        ),
      );
    } else {
      return CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            backgroundImage: NetworkImage('$url'),
          ),
          placeholder: (context, url) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            child: Icon(
              Icons.people,
              color: Color(0xffCCCCCC),
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            child: Icon(
              Icons.people,
              color: Color(0xffCCCCCC),
            ),
          ));
    }
  }

  static Widget customCircleAvatar({String url, double radius}) {
    if (url == null || url == '') {
      return CircleAvatar(
        backgroundColor: Color(0xffE6E6E6),
        radius: radius ?? 30,
        child: Icon(
          Icons.person,
          color: Color(0xffCCCCCC),
        ),
      );
    } else {
      return CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            backgroundImage: NetworkImage('$url'),
          ),
          placeholder: (context, url) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            child: Icon(
              Icons.person,
              color: Color(0xffCCCCCC),
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: Color(0xffE6E6E6),
            radius: radius ?? 30,
            child: Icon(
              Icons.person,
              color: Color(0xffCCCCCC),
            ),
          ));
    }
  }

  static Future<bool> checkAndRequestPermission(Permission permission) {
    Completer<bool> completer = new Completer<bool>();
    permission.request().then((status) {
      if (status != PermissionStatus.granted) {
        permission.request().then((_status) {
          bool granted = _status == PermissionStatus.granted;
          completer.complete(granted);
        });
      } else
        completer.complete(true);
    });
    return completer.future;
  }
}
