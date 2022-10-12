import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/validators/enum.dart';

class FirebaseBroadcastServices {
  Stream<List<BroadcastModel>> getBroadcastsList(String phone) {
    return FirebaseFirestore.instance
        .collection(DbPaths.collectionbroadcasts)
        .where(Dbkeys.broadcastCREATEDBY, isEqualTo: phone)
    // .orderBy(Dbkeys.broadcastCREATEDON, descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => BroadcastModel.fromJson(document.data()))
        .toList());
  }


  sendMessageToBroadcastRecipients({
    @required List<dynamic> recipientList,
    @required BuildContext context,
    @required String content,
    @required String currentUserNo,
    @required String broadcastId,
    @required MessageType type,
    @required DataModel cachedModel,
  }) async {
    content = content.trim();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    if (content.trim() != '') {
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionbroadcasts)
          .doc(broadcastId)
          .collection(DbPaths.collectionbroadcastsChats)
          .doc(timestamp.toString() + '--' + currentUserNo)
          .set({
        Dbkeys.broadcastmsgCONTENT: content,
        Dbkeys.broadcastmsgISDELETED: false,
        Dbkeys.broadcastmsgLISToptional: [],
        Dbkeys.broadcastmsgTIME: timestamp,
        Dbkeys.broadcastmsgSENDBY: currentUserNo,
        Dbkeys.broadcastmsgISDELETED: false,
        Dbkeys.broadcastmsgTYPE: type.index,
        Dbkeys.broadcastLocations: []
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionbroadcasts)
          .doc(broadcastId)
          .update({
        Dbkeys.broadcastLATESTMESSAGETIME: timestamp,
      });
      recipientList.forEach((peer) async {
        await FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(peer)
            .get()
            .then((userDoc) async {
          try {
            // String? sharedSecret = (await e2ee.X25519().calculateSharedSecret(
            //     e2ee.Key.fromBase64(privateKey!, false),
            //     e2ee.Key.fromBase64(userDoc[Dbkeys.publicKey], true)))
            //     .toBase64();
            // final key = encrypt.Key.fromBase64(sharedSecret);
            // cryptor = new encrypt.Encrypter(encrypt.Salsa20(key));

            if (content is String) {
              int timestamp2 = DateTime.now().millisecondsSinceEpoch;
              if (content.trim() != '') {
                var chatId = HelperFunctions.getChatId(currentUserNo, peer);
                await FirebaseFirestore.instance
                    .collection(DbPaths.collectionbroadcasts)
                    .doc(broadcastId)
                    .collection(DbPaths.collectionbroadcastsChats)
                    .doc(timestamp.toString() + '--' + currentUserNo)
                    .set({
                  Dbkeys.broadcastLocations:
                  FieldValue.arrayUnion(['$chatId--BREAK--$timestamp2'])
                }, SetOptions(merge: true)).then((value) async {
                  await FirebaseFirestore.instance
                      .collection(DbPaths.collectionmessages)
                      .doc(chatId)
                      .set({
                    currentUserNo: true,
                    peer: userDoc[Dbkeys.lastSeen],
                    Dbkeys.isbroadcast: true,
                  }, SetOptions(merge: true)).then((value) {
                    Future messaging = FirebaseFirestore.instance
                        .collection(DbPaths.collectionusers)
                        .doc(peer)
                        .collection(Dbkeys.chatsWith)
                        .doc(Dbkeys.chatsWith)
                        .set({
                      currentUserNo: 4,
                    }, SetOptions(merge: true));
                    cachedModel.addMessage(peer, timestamp2, messaging);
                  }).then((value) {
                    Future messaging = FirebaseFirestore.instance
                        .collection(DbPaths.collectionmessages)
                        .doc(chatId)
                        .collection(chatId)
                        .doc('$timestamp2')
                        .set({
                      Dbkeys.from: currentUserNo,
                      Dbkeys.to: peer,
                      Dbkeys.timestamp: timestamp2,
                      Dbkeys.content: content,
                      Dbkeys.messageType: type.index,
                      Dbkeys.isbroadcast: true,
                      Dbkeys.broadcastID: broadcastId,
                      Dbkeys.hasRecipientDeleted: false,
                      Dbkeys.hasSenderDeleted: false,
                    }, SetOptions(merge: true));
                    cachedModel.addMessage(peer, timestamp2, messaging);
                  });
                });
              }
            } else {
              HelperFunctions.toast('Nothing to send');
            }
          } catch (e) {
            HelperFunctions.toast('Failed to Send message. Error:$e');
          }
        }).catchError(((e) {
          HelperFunctions.toast('Failed to Send message. Error:$e');
        }));
      });
    } else {
      HelperFunctions.toast('Nothing to Send !');
    }
  }
}

class BroadcastModel {
  Map<String, dynamic> docmap = {};
  BroadcastModel.fromJson(Map<String, dynamic> parsedJSON)
      : docmap = parsedJSON;
}
