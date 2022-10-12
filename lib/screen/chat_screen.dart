import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/model/message_data.dart';
import 'package:gcaeco_app/provider/firebase_broadcast_service.dart';
import 'package:gcaeco_app/provider/firebase_group_service.dart';
import 'package:gcaeco_app/provider/observer.dart';
import 'package:gcaeco_app/provider/user_provider.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_room.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserNo;
  final SharedPreferences prefs;

  const ChatScreen({
    Key key,
    @required this.currentUserNo,
    this.prefs,
  }) : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(currentUserNo: this.currentUserNo);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({Key key, this.currentUserNo}) {
    _filter.addListener(() {
      _userQuery.add(_filter.text.isEmpty ? '' : _filter.text);
    });
  }

  final TextEditingController _filter = new TextEditingController();
  bool isAuthenticating = false;

  List<StreamSubscription> unreadSubscriptions = [];

  List<StreamController> controllers = [];

  @override
  void initState() {
    super.initState();

    HelperFunctions.internetLookUp();
  }

  getuid(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.getUserDetails(currentUserNo);
  }

  void cancelUnreadSubscriptions() {
    unreadSubscriptions.forEach((subscription) {
      subscription.cancel();
    });
  }

  DataModel _cachedModel;
  bool showHidden = false, biometricEnabled = false;

  String currentUserNo;

  bool isLoading = false;

  Widget buildItem(BuildContext context, Map<String, dynamic> user) {
    if (user[Dbkeys.phone] == currentUserNo) {
      return Container(width: 0, height: 0);
    } else {
      return StreamBuilder(
        stream: getUnread(user).asBroadcastStream(),
        builder: (context, AsyncSnapshot<MessageData> unreadData) {
          int unread = unreadData.hasData &&
                  unreadData.data.snapshot.docs.isNotEmpty
              ? unreadData.data.snapshot.docs
                  .where((t) => t[Dbkeys.timestamp] > unreadData.data.lastSeen)
                  .length
              : 0;
          return Theme(
              data: ThemeData(
                  splashColor: fiberchatBlue,
                  highlightColor: Colors.transparent),
              child: Column(
                children: [
                  ListTile(
                      onLongPress: () {
                        // unawaited(showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AliasForm(user, _cachedModel);
                        //     }));
                      },
                      leading: HelperFunctions.customCircleAvatar(
                          url: user['photoUrl'], radius: 22),
                      title: Text(
                        user[Dbkeys.nickname] ?? "Đang cập nhật",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: fiberchatBlack,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                                prefs: widget.prefs,
                                unread: unread,
                                model: _cachedModel,
                                currentUserNo: widget.prefs.getString("phone") ?? "",
                                peerNo: user[Dbkeys.phone].toString()
                            ),
                          ),
                        );
                      },
                      trailing: unread != 0
                          ? Container(
                              child: Text(unread.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              padding: const EdgeInsets.all(7.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: user[Dbkeys.lastSeen] == true
                                    ? Colors.green[400]
                                    : Colors.blue[400],
                              ),
                            )
                          : Container(
                              child: Container(width: 0, height: 0),
                              padding: const EdgeInsets.all(7.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: user[Dbkeys.lastSeen] == true
                                    ? Colors.green[400]
                                    : Colors.grey,
                              ),
                            )),
                  Divider(),
                ],
              ));
        },
      );
    }
  }

  Stream<MessageData> getUnread(Map<String, dynamic> user) {
    String chatId = HelperFunctions.getChatId(currentUserNo, user[Dbkeys.phone]);
    var controller = StreamController<MessageData>.broadcast();
    unreadSubscriptions.add(FirebaseFirestore.instance
        .collection(DbPaths.collectionmessages)
        .doc(chatId)
        .snapshots()
        .listen((doc) {
      if (doc[currentUserNo] != null && doc[currentUserNo] is int) {
        unreadSubscriptions.add(FirebaseFirestore.instance
            .collection(DbPaths.collectionmessages)
            .doc(chatId)
            .collection(chatId)
            .snapshots()
            .listen((snapshot) {
          controller.add(MessageData(snapshot: snapshot, lastSeen: doc[currentUserNo]));
        }));
      }
    }));
    controllers.add(controller);
    return controller.stream;
  }

  _isHidden(phoneNo) {
    Map<String, dynamic> _currentUser = _cachedModel.currentUser;
    return _currentUser[Dbkeys.hidden] != null &&
        _currentUser[Dbkeys.hidden].contains(phoneNo);
  }

  StreamController<String> _userQuery =
      new StreamController<String>.broadcast();

  List<Map<String, dynamic>> _streamDocSnap = [];

  _chats(Map<String, Map<String, dynamic>> _userData,
      Map<String, dynamic> currentUser) {
    return Consumer<List<GroupModel>>(
        builder: (context, groupList, _child) => Consumer<List<BroadcastModel>>(
                builder: (context, broadcastList, _child) {
              _streamDocSnap = Map.from(_userData)
                  .values
                  .where((_user) => _user.keys.contains(Dbkeys.chatStatus))
                  .toList()
                  .cast<Map<String, dynamic>>();
              Map<String, int> _lastSpokenAt = _cachedModel.lastSpokenAt;
              List<Map<String, dynamic>> filtered =
                  List.from(<Map<String, dynamic>>[]);
              groupList.forEach((element) {
                _streamDocSnap.add(element.docmap);
              });
              broadcastList.forEach((element) {
                _streamDocSnap.add(element.docmap);
              });
              _streamDocSnap.sort((a, b) {
                int aTimestamp = a.containsKey(Dbkeys.groupISTYPINGUSERID)
                    ? a[Dbkeys.groupLATESTMESSAGETIME]
                    : a.containsKey(Dbkeys.broadcastBLACKLISTED)
                        ? a[Dbkeys.broadcastLATESTMESSAGETIME]
                        : _lastSpokenAt[a[Dbkeys.phone]] ?? 0;
                int bTimestamp = b.containsKey(Dbkeys.groupISTYPINGUSERID)
                    ? b[Dbkeys.groupLATESTMESSAGETIME]
                    : b.containsKey(Dbkeys.broadcastBLACKLISTED)
                        ? b[Dbkeys.broadcastLATESTMESSAGETIME]
                        : _lastSpokenAt[b[Dbkeys.phone]] ?? 0;
                return bTimestamp - aTimestamp;
              });

              if (!showHidden) {
                _streamDocSnap.removeWhere((_user) =>
                    !_user.containsKey(Dbkeys.groupISTYPINGUSERID) &&
                    !_user.containsKey(Dbkeys.broadcastBLACKLISTED) &&
                    _isHidden(_user[Dbkeys.phone]));
              }

              return ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                children: [
                  Container(
                      child: _streamDocSnap.isNotEmpty
                          ? StreamBuilder(
                              stream: _userQuery.stream.asBroadcastStream(),
                              builder: (context, snapshot) {
                                if (_filter.text.isNotEmpty ||
                                    snapshot.hasData) {
                                  filtered = this._streamDocSnap.where((user) {
                                    return user[Dbkeys.nickname]
                                        .toLowerCase()
                                        .trim()
                                        .contains(new RegExp(r'' +
                                            _filter.text.toLowerCase().trim() +
                                            ''));
                                  }).toList();
                                  if (filtered.isNotEmpty)
                                    return ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(10.0),
                                      itemBuilder: (context, index) =>
                                          buildItem(context,
                                              filtered.elementAt(index)),
                                      itemCount: filtered.length,
                                    );
                                  else
                                    return ListView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.5),
                                              child: Center(
                                                child: Text('No search result',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: fiberchatGrey,
                                                    )),
                                              ))
                                        ]);
                                }
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 120),
                                  itemBuilder: (context, index) {
                                    if (_streamDocSnap[index].containsKey(
                                        Dbkeys.groupISTYPINGUSERID)) {
                                      ///----- Build Group Chat Tile ----
                                      return Theme(
                                          data: ThemeData(
                                              splashColor: fiberchatBlue,
                                              highlightColor:
                                                  Colors.transparent),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: HelperFunctions
                                                    .customCircleAvatarGroup(
                                                        url: _streamDocSnap[
                                                                index][
                                                            Dbkeys
                                                                .groupPHOTOURL],
                                                        radius: 22),
                                                title: Text(
                                                  _streamDocSnap[index]
                                                      [Dbkeys.groupNAME],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: fiberchatBlack,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '${_streamDocSnap[index][Dbkeys.groupMEMBERSLIST].length} Participants',
                                                  style: TextStyle(
                                                    color: fiberchatGrey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     new MaterialPageRoute(
                                                  //         builder: (context) => GroupChatPage(
                                                  //             model:
                                                  //                 _cachedModel!,
                                                  //             prefs:
                                                  //                 widget.prefs,
                                                  //             joinedTime:
                                                  //                 _streamDocSnap[
                                                  //                         index]
                                                  //                     [
                                                  //                     '${widget.currentUserNo}-joinedOn'],
                                                  //             currentUserno: widget
                                                  //                 .currentUserNo!,
                                                  //             groupID:
                                                  //                 _streamDocSnap[
                                                  //                         index]
                                                  //                     [Dbkeys
                                                  //                         .groupID])));
                                                },
                                                trailing: StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(DbPaths
                                                          .collectiongroups)
                                                      .doc(_streamDocSnap[index]
                                                          [Dbkeys.groupID])
                                                      .collection(DbPaths
                                                          .collectiongroupChats)
                                                      .where(
                                                          Dbkeys.groupmsgTIME,
                                                          isGreaterThan:
                                                              _streamDocSnap[
                                                                      index][
                                                                  widget
                                                                      .currentUserNo])
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      );
                                                    } else if (snapshot
                                                            .hasData &&
                                                        snapshot.data.docs
                                                                .length >
                                                            0) {
                                                      return Container(
                                                        child: Text(
                                                            '${snapshot.data.docs.length}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Colors.blue[400],
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Divider(
                                                height: 8,
                                              ),
                                            ],
                                          ));
                                    } else {
                                      return buildItem(context,
                                          _streamDocSnap.elementAt(index));
                                    }
                                  },
                                  itemCount: _streamDocSnap.length,
                                );
                              })
                          :  Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context)
                                  .size
                                  .height /
                                  3.5),
                          child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Text(
                                    groupList.length != 0
                                        ? ''
                                        : 'Chưa có cuộc hội thoại nào',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.59,
                                      color: fiberchatGrey,
                                    ))),
                          )),
                  ),
                ],
              );
            }));
  }

  Widget buildGroupitem() {
    return Text(
      Dbkeys.groupNAME,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  DataModel getModel() {
    _cachedModel ??= DataModel(currentUserNo);
    return _cachedModel;
  }

  @override
  Widget build(BuildContext context) {
    final observer = Provider.of<Observer>(this.context, listen: false);
    return HelperFunctions.getNTPWrappedWidget(
        child: ScopedModel<DataModel>(
      model: getModel(),
      child:
          ScopedModelDescendant<DataModel>(builder: (context, child, _model) {
        _cachedModel = _model;
        return Scaffold(
          // will implement Google ads here in next update
          backgroundColor: fiberchatWhite,
          appBar: AppBar(
            title: Text('Tin nhắn'),
            backgroundColor: Config().colorMain,
          ),
          // floatingActionButton:
          //     //  _model.loaded
          //     //     ?
          //     Padding(
          //   padding: EdgeInsets.only(
          //       bottom: IsBannerAdShow == true && observer.isadmobshow == true
          //           ? 60
          //           : 0),
          //   child: FloatingActionButton(
          //       backgroundColor: Config().colorMain,
          //       child: Icon(
          //         Icons.chat,
          //         size: 30.0,
          //       ),
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             new MaterialPageRoute(
          //                 builder: (context) => AddunsavedNumber(
          //                     prefs: widget.prefs,
          //                     currentUserNo: currentUserNo,
          //                     model: _cachedModel)));
          //       }),
          // ),
          body: RefreshIndicator(
            onRefresh: () {
              isAuthenticating = !isAuthenticating;
              setState(() {
                showHidden = !showHidden;
              });
              return Future.value(true);
            },
            child: _chats(_model.userData, _model.currentUser),
          ),
        );
      }),
    ));
  }
}
