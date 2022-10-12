import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocCreateChat{
  static createAndUpdate({
    String email,
    String phone,
    String name,
    String id,
    String username,

}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .where(Dbkeys.email, isEqualTo: email)
        .get();

    final List documents = result.docs;

    if (documents.isEmpty) {
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(phone)
          .set({
        Dbkeys.publicKey: '',
        Dbkeys.privateKey: '',
        Dbkeys.countryCode: 'phoneCode',
        Dbkeys.nickname: name,
        Dbkeys.photoUrl: '',
        Dbkeys.id: id,
        Dbkeys.email: email,
        Dbkeys.phone: phone,
        Dbkeys.phoneRaw:phone,
        Dbkeys.authenticationType: '',
        Dbkeys.aboutMe: '',
        //---Additional fields added for Admin app compatible----
        Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
        Dbkeys.joinedOn: DateTime.now().millisecondsSinceEpoch,
        Dbkeys.searchKey: username
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
            email + 'XXX' + 'userapp',
          }
        ])
      });

      await prefs.setString(Dbkeys.email, email);
      await prefs.setString(
          Dbkeys.nickname, username.trim());
      await prefs.setString(Dbkeys.photoUrl, '');
      await prefs.setString(
          Dbkeys.phone, phone.trim());
      await prefs.setString(Dbkeys.countryCode, '');
      String fcmToken = await FirebaseMessaging().getToken();

      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(phone)
          .set({
        Dbkeys.notificationTokens: [fcmToken]
      }, SetOptions(merge: true));

      await prefs.setInt(Dbkeys.id, int.parse(id));
      await prefs
          .setString(Dbkeys.nickname, username);
      await prefs.setString(Dbkeys.photoUrl, '');
      await prefs
          .setString(Dbkeys.phone, phone);
    } else {
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(phone)
          .update(
        !documents[0].data().containsKey(Dbkeys.deviceDetails)
            ? {
          Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
          Dbkeys.joinedOn:
          documents[0].data()[Dbkeys.lastSeen] != true
              ? documents[0].data()[Dbkeys.lastSeen]
              : DateTime.now().millisecondsSinceEpoch,
          Dbkeys.nickname:
          username.trim(),
          Dbkeys.searchKey: username
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
          Dbkeys.searchKey: username
              .trim()
              .substring(0, 1)
              .toUpperCase(),
          Dbkeys.nickname:
          username.trim(),
          Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
        },
      );

      await prefs.setString(Dbkeys.id, id);
      await prefs
          .setString(Dbkeys.nickname, username.trim());
      await prefs.setString(Dbkeys.photoUrl, '');
      await prefs.setString(Dbkeys.phone, phone);
      String fcmToken = await FirebaseMessaging().getToken();

      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(phone)
          .set({
        Dbkeys.notificationTokens: [fcmToken]
      }, SetOptions(merge: true));

    }
  }
}