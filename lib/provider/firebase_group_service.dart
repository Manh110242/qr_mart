import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';

class FirebaseGroupServices {
  Stream<List<GroupModel>> getGroupsList(String phone) {
    return FirebaseFirestore.instance
        .collection(DbPaths.collectiongroups)
        .where(Dbkeys.groupMEMBERSLIST, arrayContains: phone)
        .orderBy(Dbkeys.groupCREATEDON, descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => GroupModel.fromJson(document.data()))
        .toList());
  }
}

class GroupModel {
  Map<String, dynamic> docmap = {};

  GroupModel.fromJson(Map<String, dynamic> parsedJSON) : docmap = parsedJSON;
}
