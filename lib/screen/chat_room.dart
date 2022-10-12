//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/helper/permission.dart';
import 'package:gcaeco_app/item_share/audio_record.dart';
import 'package:gcaeco_app/item_share/bubble.dart';
import 'package:gcaeco_app/item_share/hybird_image_picker.dart';
import 'package:gcaeco_app/item_share/hybird_video_picker.dart';
import 'package:gcaeco_app/item_share/hybrid_document_picker.dart';
import 'package:gcaeco_app/item_share/my_elevated_button.dart';
import 'package:gcaeco_app/item_share/pdf_viewer_cached_from_url.dart';
import 'package:gcaeco_app/item_share/photo_view.dart';
import 'package:gcaeco_app/item_share/pickup_layout.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/model/detail_product.dart';
import 'package:gcaeco_app/model/message.dart';
import 'package:gcaeco_app/provider/currentchat_peer.dart';
import 'package:gcaeco_app/provider/observer.dart';
import 'package:gcaeco_app/provider/seen_provider.dart';
import 'package:gcaeco_app/provider/seen_state.dart';
import 'package:gcaeco_app/screen/preview_video.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/chat_controller.dart';
import 'package:gcaeco_app/validators/delete_chat_media.dart';
import 'package:gcaeco_app/validators/download_media.dart';
import 'package:gcaeco_app/validators/enum.dart';
import 'package:gcaeco_app/validators/key_fcm.dart';
import 'package:gcaeco_app/validators/sound_player_pro.dart';
import 'package:gcaeco_app/validators/unwaited.dart';
import 'package:gcaeco_app/validators/upload_media_with_progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_info/media_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:gcaeco_app/validators/save.dart';
import 'package:gcaeco_app/validators/call_utils.dart';
import 'package:http/http.dart' as http;

hidekeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

class ChatRoom extends StatefulWidget {
  final String peerNo, currentUserNo, linkPrd;
  final DataModel model;
  DetailProduct detaiPrd;
  final int unread;
  final SharedPreferences prefs;

  ChatRoom(
      {Key key,
      @required this.currentUserNo,
      @required this.peerNo,
      @required this.model,
      @required this.prefs,
      this.linkPrd,
      this.detaiPrd,
      @required this.unread});

  @override
  State createState() => new _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  String peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;
  bool locked, hidden;
  Map<String, dynamic> peer, currentUser;
  int chatStatus, unread;
  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: 'qqqeqeqsseaadsqeqe');

  String chatId;
  bool isMessageLoading = true;
  bool typing = false;
  File thumbnailFile;
  File imageFile;
  bool isLoading = true;
  bool isgeneratingThumbnail = false;
  String imageUrl;
  SeenState seenState;
  List<Message> messages = new List.from(<Message>[]);
  List<Map<String, dynamic>> _savedMessageDocs =
      new List.from(<Map<String, dynamic>>[]);

  int uploadTimestamp;

  StreamSubscription seenSubscription, msgSubscription, deleteUptoSubscription;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController realtime = new ScrollController();
  final ScrollController saved = new ScrollController();
  DataModel _cachedModel;

  Duration duration;
  Duration position;

  // AudioPlayer audioPlayer = AudioPlayer();

  String localFilePath;

  PlayerState playerState = PlayerState.ended;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  shopSendlinkPrd() async {
    if (widget.linkPrd != null && widget.linkPrd != "") {
      chatId = HelperFunctions.getChatId(currentUserNo, peerNo);
      print(chatId);
      ChatController.request(currentUserNo, peerNo, chatId);
      FirebaseFirestore.instance
          .collection(DbPaths.collectionmessages)
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        Dbkeys.from: currentUserNo,
        Dbkeys.to: peerNo,
        Dbkeys.timestamp: DateTime.now().millisecondsSinceEpoch,
        Dbkeys.content: widget.linkPrd,
        Dbkeys.messageType: 7,
        Dbkeys.hasSenderDeleted: false,
        Dbkeys.hasRecipientDeleted: false,
        Dbkeys.sendername: _cachedModel.currentUser[Dbkeys.nickname],
      }, SetOptions(merge: true));
    }
  }

  @override
  void initState() {
    super.initState();
    _cachedModel = widget.model;
    peerNo = widget.peerNo;
    currentUserNo = widget.currentUserNo;
    unread = widget.unread;

    // initAudioPlayer();
    // _load();
    HelperFunctions.internetLookUp();

    updateLocalUserData(_cachedModel);
    shopSendlinkPrd();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final observer = Provider.of<Observer>(this.context, listen: false);
      var currentpeer =
          Provider.of<CurrentChatPeer>(this.context, listen: false);
      currentpeer.setpeer(newpeerid: widget.peerNo);
      seenState = new SeenState(false);
      WidgetsBinding.instance.addObserver(this);
      chatId = '';
      unread = widget.unread;
      isLoading = false;
      imageUrl = '';
      loadSavedMessages();

      Future.delayed(const Duration(milliseconds: 00), () {
        readLocal(this.context);
      });
    });
  }

  loadAdmob(BuildContext context) {}

  updateLocalUserData(model) {
    peer = model.userData[peerNo];
    currentUser = _cachedModel.currentUser;
    if (currentUser != null && peer != null) {
      hidden = currentUser[Dbkeys.hidden] != null &&
          currentUser[Dbkeys.hidden].contains(peerNo);
      locked = currentUser[Dbkeys.locked] != null &&
          currentUser[Dbkeys.locked].contains(peerNo);
      chatStatus = peer[Dbkeys.chatStatus];
      peerAvatar = peer[Dbkeys.photoUrl];
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    setLastSeen();
    // audioPlayer.stop();
    msgSubscription?.cancel();
    seenSubscription?.cancel();
    deleteUptoSubscription?.cancel();
  }

  void setLastSeen() async {
    if (chatStatus != ChatStatus.blocked.index) {
      if (chatId != null) {
        await FirebaseFirestore.instance
            .collection(DbPaths.collectionmessages)
            .doc(chatId)
            .update(
          {'$currentUserNo': DateTime.now().millisecondsSinceEpoch},
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      setIsActive();
    else
      setLastSeen();
  }

  void setIsActive() async {
    await FirebaseFirestore.instance
        .collection(DbPaths.collectionmessages)
        .doc(chatId)
        .set({'$currentUserNo': true}, SetOptions(merge: true));
  }

  dynamic lastSeen;

  readLocal(
    BuildContext context,
  ) async {
    try {
      seenState.value = widget.prefs.getInt(getLastSeenKey());
    } catch (e) {
      seenState.value = false;
    }
    chatId = HelperFunctions.getChatId(currentUserNo, peerNo);
    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty && typing == false) {
        lastSeen = peerNo;
        FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(currentUserNo)
            .update(
          {Dbkeys.lastSeen: peerNo},
        );
        typing = true;
      }
      if (textEditingController.text.isEmpty && typing == true) {
        lastSeen = true;
        FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(currentUserNo)
            .update(
          {Dbkeys.lastSeen: true},
        );
        typing = false;
      }
    });
    setIsActive();
    // deleteUptoSubscription = FirebaseFirestore.instance
    //     .collection(DbPaths.collectionmessages)
    //     .doc(chatId)
    //     .snapshots()
    //     .listen((doc) {
    //   // ignore: unnecessary_null_comparison
    //   if (doc != null && mounted) {
    //     deleteMessagesUpto(doc.data()![Dbkeys.deleteUpto]);
    //   }
    // });
    seenSubscription = FirebaseFirestore.instance
        .collection(DbPaths.collectionmessages)
        .doc(chatId)
        .snapshots()
        .listen((doc) {
      // ignore: unnecessary_null_comparison
      if (doc != null && mounted && doc.data().containsKey(peerNo)) {
        seenState.value = doc[peerNo] ?? false;
        if (seenState.value is int) {
          widget.prefs.setInt(getLastSeenKey(), seenState.value);
        }
      }
    });
    loadMessagesAndListen();
  }

  String getLastSeenKey() {
    return "$peerNo-${Dbkeys.lastSeen}";
  }

  int thumnailtimestamp;

  getImage(File image) {
    final observer = Provider.of<Observer>(this.context, listen: false);
    // ignore: unnecessary_null_comparison
    if (image != null) {
      setStateIfMounted(() {
        imageFile = image;
      });
    }
    return observer.isPercentProgressShowWhileUploading
        ? uploadFileWithProgressIndicator(false)
        : uploadFile(false);
  }

  getThumbnail(String url) async {
    final observer = Provider.of<Observer>(this.context, listen: false);
    // ignore: unnecessary_null_comparison
    setStateIfMounted(() {
      isgeneratingThumbnail = true;
    });

    String path = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        // maxHeight: 150,
        // maxWidth:300,
        // timeMs: r.timeMs,
        quality: 30);

    thumbnailFile = File(path);

    setStateIfMounted(() {
      isgeneratingThumbnail = false;
    });
    return observer.isPercentProgressShowWhileUploading
        ? uploadFileWithProgressIndicator(true)
        : uploadFile(true);
  }

  getWallpaper(File image) {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      _cachedModel.setWallpaper(peerNo, image);
    }
    return Future.value(false);
  }

  String videometadata;

  Future uploadFile(bool isthumbnail) async {
    uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = getFileName(
        currentUserNo,
        isthumbnail == false
            ? '$uploadTimestamp'
            : '${thumnailtimestamp}Thumbnail');
    Reference reference =
        FirebaseStorage.instance.ref("+00_CHAT_MEDIA/$chatId/").child(fileName);
    TaskSnapshot uploading = await reference
        .putFile(isthumbnail == true ? thumbnailFile : imageFile);
    if (isthumbnail == false) {
      setStateIfMounted(() {
        thumnailtimestamp = uploadTimestamp;
      });
    }
    if (isthumbnail == true) {
      MediaInfo _mediaInfo = MediaInfo();

      await _mediaInfo.getMediaInfo(thumbnailFile.path).then((mediaInfo) {
        setStateIfMounted(() {
          videometadata = jsonEncode({
            "width": mediaInfo['width'],
            "height": mediaInfo['height'],
            "orientation": null,
            "duration": mediaInfo['durationMs'],
            "filesize": null,
            "author": null,
            "date": null,
            "framerate": null,
            "location": null,
            "path": null,
            "title": '',
            "mimetype": mediaInfo['mimeType'],
          }).toString();
        });
      }).catchError((onError) {
        HelperFunctions.toast('Sending failed !');
        print('ERROR SENDING FILE: $onError');
      });
    } else {
      FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(widget.currentUserNo)
          .set({
        Dbkeys.mssgSent: FieldValue.increment(1),
      }, SetOptions(merge: true));
      FirebaseFirestore.instance
          .collection(DbPaths.collectiondashboard)
          .doc(DbPaths.docchatdata)
          .set({
        Dbkeys.mediamessagessent: FieldValue.increment(1),
      }, SetOptions(merge: true));
    }

    return uploading.ref.getDownloadURL();
  }

  Future uploadFileWithProgressIndicator(bool isthumbnail) async {
    uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = getFileName(
        currentUserNo,
        isthumbnail == false
            ? '$uploadTimestamp'
            : '${thumnailtimestamp}Thumbnail');
    Reference reference =
        FirebaseStorage.instance.ref("+00_CHAT_MEDIA/$chatId/").child(fileName);
    UploadTask uploading =
        reference.putFile(isthumbnail == true ? thumbnailFile : imageFile);

    showDialog<void>(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  // side: BorderSide(width: 5, color: Colors.green)),
                  key: _keyLoader,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: StreamBuilder(
                          stream: uploading.snapshotEvents,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              final TaskSnapshot snap = uploading.snapshot;

                              return openUploadDialog(
                                context: context,
                                percent: bytesTransferred(snap) / 100,
                                title: isthumbnail == true
                                    ? 'Genereting thumbnail'
                                    : 'uploading',
                                subtitle:
                                    "${((((snap.bytesTransferred / 1024) / 1000) * 100).roundToDouble()) / 100}/${((((snap.totalBytes / 1024) / 1000) * 100).roundToDouble()) / 100} MB",
                              );
                            } else {
                              return openUploadDialog(
                                context: context,
                                percent: 0.0,
                                title: isthumbnail == true
                                    ? 'Genereting thumbnail'
                                    : 'uploading',
                                subtitle: '',
                              );
                            }
                          }),
                    ),
                  ]));
        });

    TaskSnapshot downloadTask = await uploading;
    String downloadedurl = await downloadTask.ref.getDownloadURL();

    if (isthumbnail == false) {
      setStateIfMounted(() {
        thumnailtimestamp = uploadTimestamp;
      });
    }
    if (isthumbnail == true) {
      MediaInfo _mediaInfo = MediaInfo();

      await _mediaInfo.getMediaInfo(thumbnailFile.path).then((mediaInfo) {
        setStateIfMounted(() {
          videometadata = jsonEncode({
            "width": mediaInfo['width'],
            "height": mediaInfo['height'],
            "orientation": null,
            "duration": mediaInfo['durationMs'],
            "filesize": null,
            "author": null,
            "date": null,
            "framerate": null,
            "location": null,
            "path": null,
            "title": '',
            "mimetype": mediaInfo['mimeType'],
          }).toString();
        });
      }).catchError((onError) {
        HelperFunctions.toast('Sending failed !');
        print('ERROR SENDING FILE: $onError');
      });
    } else {
      FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(widget.currentUserNo)
          .set({
        Dbkeys.mssgSent: FieldValue.increment(1),
      }, SetOptions(merge: true));
      FirebaseFirestore.instance
          .collection(DbPaths.collectiondashboard)
          .doc(DbPaths.docchatdata)
          .set({
        Dbkeys.mediamessagessent: FieldValue.increment(1),
      }, SetOptions(merge: true));
    }
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop(); //
    return downloadedurl;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      HelperFunctions.toast(
          'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        HelperFunctions.toast(
            'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        HelperFunctions.toast(
            'Location permissions are pdenied. Please go to settings & allow location tracking permission.');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      HelperFunctions.toast(
        'Detecting',
      );
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void onSendMessage(BuildContext context, String content, MessageType type,
      int timestamp) async {
    chatId = HelperFunctions.getChatId(currentUserNo, peerNo);
    if (content.trim() != '') {
      try {
        content = content.trim();
        if (chatStatus == null || chatStatus == 4)
          ChatController.request(currentUserNo, peerNo, chatId);
        textEditingController.clear();
        Future messaging = FirebaseFirestore.instance
            .collection(DbPaths.collectionmessages)
            .doc(chatId)
            .collection(chatId)
            .doc('$timestamp')
            .set({
          Dbkeys.from: currentUserNo,
          Dbkeys.to: peerNo,
          Dbkeys.timestamp: timestamp,
          Dbkeys.content: content,
          Dbkeys.messageType:
              content.startsWith("http") && type == MessageType.link
                  ? 7
                  : type.index,
          Dbkeys.hasSenderDeleted: false,
          Dbkeys.hasRecipientDeleted: false,
          Dbkeys.sendername: _cachedModel.currentUser[Dbkeys.nickname],
        }, SetOptions(merge: true));
        _cachedModel.addMessage(peerNo, timestamp, messaging);
        var tempDoc = {
          Dbkeys.timestamp: timestamp,
          Dbkeys.to: peerNo,
          Dbkeys.messageType:
              content.startsWith("http") && type == MessageType.link
                  ? 7
                  : type.index,
          Dbkeys.content: content,
          Dbkeys.from: currentUserNo,
          Dbkeys.hasSenderDeleted: false,
          Dbkeys.hasRecipientDeleted: false,
          Dbkeys.sendername: _cachedModel.currentUser[Dbkeys.nickname],
        };
        setStateIfMounted(() {
          messages = List.from(messages)
            ..add(Message(
              buildTempMessage(
                  context,
                  content.startsWith("http") && type == MessageType.link
                      ? MessageType.link
                      : type,
                  content,
                  timestamp,
                  messaging,
                  tempDoc),
              onTap: (tempDoc[Dbkeys.from] == widget.currentUserNo &&
                          tempDoc[Dbkeys.hasSenderDeleted] == true) ==
                      true
                  ? () {}
                  : type == MessageType.image
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewWrapper(
                                  message: content,
                                  tag: timestamp.toString(),
                                  imageProvider:
                                      CachedNetworkImageProvider(content),
                                ),
                              ));
                        }
                      : null,
              onDismiss: null,
              onDoubleTap: () {
                // save(tempDoc);
              },
              onLongPress: () {
                if (tempDoc.containsKey(Dbkeys.hasRecipientDeleted) &&
                    tempDoc.containsKey(Dbkeys.hasSenderDeleted)) {
                  if ((tempDoc[Dbkeys.from] == widget.currentUserNo &&
                          tempDoc[Dbkeys.hasSenderDeleted] == true) ==
                      false) {
                    //--Show Menu only if message is not deleted by current user already
                    contextMenuNew(this.context, tempDoc, true);
                  }
                } else {
                  contextMenuOld(context, tempDoc);
                }
              },
              from: currentUserNo,
              timestamp: timestamp,
            ));
        });

        try {
          http.post(
            "https://fcm.googleapis.com/fcm/send",
            headers: {
              "Authorization": keyFcm,
              "Content-Type": "application/json",
            },
            body: json.encode({
              "to": widget.peerNo,
              "notification": {
                "title": currentUser[Dbkeys.nickname] + " nhắn tin cho bạn",
                "body": content,
                "type": "message"
              },
              "data": {
                "title": currentUser[Dbkeys.nickname] + " nhắn tin cho bạn",
                "body": content,
                "type": "message"
              }
            }),
          );
        } catch (e) {}

        unawaited(realtime.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut));
        // _playPopSound();

      } on Exception catch (_) {}
    }
  }

  delete(int ts) {
    setStateIfMounted(() {
      messages.removeWhere((msg) => msg.timestamp == ts);
      messages = List.from(messages);
    });
  }

  updateDeleteBySenderField(int ts, updateDoc, context) {
    setStateIfMounted(() {
      int i = messages.indexWhere((msg) => msg.timestamp == ts);
      var child = buildTempMessage(
          context,
          MessageType.text,
          updateDoc[Dbkeys.content],
          updateDoc[Dbkeys.timestamp],
          true,
          updateDoc);
      var timestamp = messages[i].timestamp;
      var from = messages[i].from;
      // var onTap = messages[i].onTap;
      var onDoubleTap = messages[i].onDoubleTap;
      var onDismiss = messages[i].onDismiss;
      var onLongPress = () {};
      if (i >= 0) {
        messages.removeWhere((msg) => msg.timestamp == ts);
        messages.insert(
            i,
            Message(child,
                timestamp: timestamp,
                from: from,
                onTap: () {},
                onDoubleTap: onDoubleTap,
                onDismiss: onDismiss,
                onLongPress: onLongPress));
      }
      messages = List.from(messages);
    });
  }

  contextMenuForSavedMessage(
    BuildContext context,
    Map<String, dynamic> doc,
  ) {
    List<Widget> tiles = List.from(<Widget>[]);
    tiles.add(ListTile(
        dense: true,
        leading: Icon(Icons.delete_outline),
        title: Text(
          'Xóa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          Save.deleteMessage(peerNo, doc);
          _savedMessageDocs.removeWhere(
              (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
          setStateIfMounted(() {
            _savedMessageDocs = List.from(_savedMessageDocs);
          });
          Navigator.pop(context);
        }));
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: tiles);
        });
  }

  //-- New context menu with Delete for Me & Delete For Everyone feature
  contextMenuNew(BuildContext context, Map<String, dynamic> doc, bool isTemp,
      {bool saved = false}) {
    List<Widget> tiles = List.from(<Widget>[]);
    //####################----------------------- Delete Msgs for SENDER ---------------------------------------------------
    if ((doc[Dbkeys.from] == currentUserNo &&
            doc[Dbkeys.hasSenderDeleted] == false) &&
        saved == false) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.delete_outline),
          title: Text(
            'Xóa bởi tôi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            HelperFunctions.toast('Đang xóa');
            await FirebaseFirestore.instance
                .collection(DbPaths.collectionmessages)
                .doc(chatId)
                .collection(chatId)
                .doc('${doc[Dbkeys.timestamp]}')
                .get()
                .then((chatDoc) async {
              if (!chatDoc.exists) {
                HelperFunctions.toast('Please reload this screen !');
              } else if (chatDoc.exists) {
                Map<String, dynamic> realtimeDoc = chatDoc.data();
                if (realtimeDoc[Dbkeys.hasRecipientDeleted] == true) {
                  if ((doc.containsKey(Dbkeys.isbroadcast) == true
                          ? doc[Dbkeys.isbroadcast]
                          : false) ==
                      true) {
                    // -------Delete broadcast message completely as recipient has already deleted
                    await FirebaseFirestore.instance
                        .collection(DbPaths.collectionmessages)
                        .doc(chatId)
                        .collection(chatId)
                        .doc('${realtimeDoc[Dbkeys.timestamp]}')
                        .delete();
                    delete(realtimeDoc[Dbkeys.timestamp]);
                    Save.deleteMessage(peerNo, realtimeDoc);
                    _savedMessageDocs.removeWhere((msg) =>
                        msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                    setStateIfMounted(() {
                      _savedMessageDocs = List.from(_savedMessageDocs);
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.maybePop(this.context);
                      HelperFunctions.toast(
                        'Đã xóa',
                      );
                      hidekeyboard(context);
                    });
                  } else {
                    // -------Delete message completely as recipient has already deleted
                    await deleteMsgMedia(realtimeDoc, chatId)
                        .then((isDeleted) async {
                      if (isDeleted == false || isDeleted == null) {
                        HelperFunctions.toast(
                            'Could not delete. Please try again!');
                      } else {
                        await FirebaseFirestore.instance
                            .collection(DbPaths.collectionmessages)
                            .doc(chatId)
                            .collection(chatId)
                            .doc('${realtimeDoc[Dbkeys.timestamp]}')
                            .delete();
                        delete(realtimeDoc[Dbkeys.timestamp]);
                        Save.deleteMessage(peerNo, realtimeDoc);
                        _savedMessageDocs.removeWhere((msg) =>
                            msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                        setStateIfMounted(() {
                          _savedMessageDocs = List.from(_savedMessageDocs);
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.maybePop(this.context);
                          HelperFunctions.toast(
                            'Đã xóa',
                          );
                          hidekeyboard(context);
                        });
                      }
                    });
                  }
                } else {
                  //----Don't Delete Media from server, as recipient has not deleted the message from thier message list-----
                  FirebaseFirestore.instance
                      .collection(DbPaths.collectionmessages)
                      .doc(chatId)
                      .collection(chatId)
                      .doc('${realtimeDoc[Dbkeys.timestamp]}')
                      .set({Dbkeys.hasSenderDeleted: true},
                          SetOptions(merge: true));

                  Save.deleteMessage(peerNo, doc);
                  _savedMessageDocs.removeWhere(
                      (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                  setStateIfMounted(() {
                    _savedMessageDocs = List.from(_savedMessageDocs);
                  });

                  Map<String, dynamic> tempDoc = realtimeDoc;
                  setStateIfMounted(() {
                    tempDoc[Dbkeys.hasSenderDeleted] = true;
                  });
                  updateDeleteBySenderField(
                      realtimeDoc[Dbkeys.timestamp], tempDoc, context);

                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.maybePop(this.context);
                    HelperFunctions.toast(
                      'Đã xóa',
                    );
                    hidekeyboard(context);
                  });
                }
              }
            });
          }));

      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.delete),
          title: Text(
            'Xóa bởi tất cả mọi người',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            if ((doc.containsKey(Dbkeys.isbroadcast) == true
                    ? doc[Dbkeys.isbroadcast]
                    : false) ==
                true) {
              // -------Delete broadcast message completely for everyone
              await FirebaseFirestore.instance
                  .collection(DbPaths.collectionmessages)
                  .doc(chatId)
                  .collection(chatId)
                  .doc('${doc[Dbkeys.timestamp]}')
                  .delete();
              delete(doc[Dbkeys.timestamp]);
              Save.deleteMessage(peerNo, doc);
              _savedMessageDocs.removeWhere(
                  (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
              setStateIfMounted(() {
                _savedMessageDocs = List.from(_savedMessageDocs);
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.maybePop(this.context);
                HelperFunctions.toast(
                  'Đã xóa',
                );
                hidekeyboard(context);
              });
            } else {
              // -------Delete message completely for everyone
              HelperFunctions.toast(
                'Đang xóa',
              );
              await deleteMsgMedia(doc, chatId).then((isDeleted) async {
                if (isDeleted == false || isDeleted == null) {
                  HelperFunctions.toast('Could not delete. Please try again!');
                } else {
                  await FirebaseFirestore.instance
                      .collection(DbPaths.collectionmessages)
                      .doc(chatId)
                      .collection(chatId)
                      .doc('${doc[Dbkeys.timestamp]}')
                      .delete();
                  delete(doc[Dbkeys.timestamp]);
                  Save.deleteMessage(peerNo, doc);
                  _savedMessageDocs.removeWhere(
                      (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                  setStateIfMounted(() {
                    _savedMessageDocs = List.from(_savedMessageDocs);
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.maybePop(this.context);
                    HelperFunctions.toast(
                      'Đã xóa',
                    );
                    hidekeyboard(context);
                  });
                }
              });
            }
          }));
    }
    //####################-------------------- Delete Msgs for RECIPIENTS---------------------------------------------------
    if ((doc[Dbkeys.to] == currentUserNo &&
            doc[Dbkeys.hasRecipientDeleted] == false) &&
        saved == false) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.delete_outline),
          title: Text(
            'Xóa bởi tôi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            HelperFunctions.toast(
              'Đang xóa',
            );
            await FirebaseFirestore.instance
                .collection(DbPaths.collectionmessages)
                .doc(chatId)
                .collection(chatId)
                .doc('${doc[Dbkeys.timestamp]}')
                .get()
                .then((chatDoc) async {
              if (!chatDoc.exists) {
                HelperFunctions.toast('Please reload this screen !');
              } else if (chatDoc.exists) {
                Map<String, dynamic> realtimeDoc = chatDoc.data();
                if (realtimeDoc[Dbkeys.hasSenderDeleted] == true) {
                  if ((doc.containsKey(Dbkeys.isbroadcast) == true
                          ? doc[Dbkeys.isbroadcast]
                          : false) ==
                      true) {
                    // -------Delete broadcast message completely as sender has already deleted
                    await FirebaseFirestore.instance
                        .collection(DbPaths.collectionmessages)
                        .doc(chatId)
                        .collection(chatId)
                        .doc('${realtimeDoc[Dbkeys.timestamp]}')
                        .delete();
                    delete(realtimeDoc[Dbkeys.timestamp]);
                    Save.deleteMessage(peerNo, realtimeDoc);
                    _savedMessageDocs.removeWhere((msg) =>
                        msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                    setStateIfMounted(() {
                      _savedMessageDocs = List.from(_savedMessageDocs);
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.maybePop(this.context);
                      HelperFunctions.toast(
                        'Đã xóa',
                      );
                      hidekeyboard(context);
                    });
                  } else {
                    // -------Delete message completely as sender has already deleted
                    await deleteMsgMedia(realtimeDoc, chatId)
                        .then((isDeleted) async {
                      if (isDeleted == false || isDeleted == null) {
                        HelperFunctions.toast(
                            'Could not delete. Please try again!');
                      } else {
                        await FirebaseFirestore.instance
                            .collection(DbPaths.collectionmessages)
                            .doc(chatId)
                            .collection(chatId)
                            .doc('${realtimeDoc[Dbkeys.timestamp]}')
                            .delete();
                        delete(realtimeDoc[Dbkeys.timestamp]);
                        Save.deleteMessage(peerNo, realtimeDoc);
                        _savedMessageDocs.removeWhere((msg) =>
                            msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                        setStateIfMounted(() {
                          _savedMessageDocs = List.from(_savedMessageDocs);
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.maybePop(this.context);
                          HelperFunctions.toast(
                            'Đã xóa',
                          );
                          hidekeyboard(context);
                        });
                      }
                    });
                  }
                } else {
                  //----Don't Delete Media from server, as recipient has not deleted the message from thier message list-----
                  FirebaseFirestore.instance
                      .collection(DbPaths.collectionmessages)
                      .doc(chatId)
                      .collection(chatId)
                      .doc('${realtimeDoc[Dbkeys.timestamp]}')
                      .set({Dbkeys.hasRecipientDeleted: true},
                          SetOptions(merge: true));

                  Save.deleteMessage(peerNo, doc);
                  _savedMessageDocs.removeWhere(
                      (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
                  setStateIfMounted(() {
                    _savedMessageDocs = List.from(_savedMessageDocs);
                  });
                  if (isTemp == true) {
                    Map<String, dynamic> tempDoc = realtimeDoc;
                    setStateIfMounted(() {
                      tempDoc[Dbkeys.hasRecipientDeleted] = true;
                    });
                    updateDeleteBySenderField(
                        realtimeDoc[Dbkeys.timestamp], tempDoc, context);
                  }
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.maybePop(this.context);
                    HelperFunctions.toast(
                      'Đã xóa',
                    );
                    hidekeyboard(context);
                  });
                }
              }
            });
          }));
    }
    if (doc.containsKey(Dbkeys.broadcastID) &&
        doc[Dbkeys.to] == widget.currentUserNo) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.block),
          title: Text(
            'Chặn',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            HelperFunctions.toast(
              'Vui lòng đợi',
            );
            Future.delayed(const Duration(milliseconds: 200), () {
              FirebaseFirestore.instance
                  .collection(DbPaths.collectionbroadcasts)
                  .doc(doc[Dbkeys.broadcastID])
                  .update({
                Dbkeys.broadcastMEMBERSLIST:
                    FieldValue.arrayRemove([widget.currentUserNo]),
                Dbkeys.broadcastBLACKLISTED:
                    FieldValue.arrayUnion([widget.currentUserNo]),
              }).then((value) {
                Navigator.pop(context);
                hidekeyboard(context);
                HelperFunctions.toast(
                  'Blocked this Broadcast',
                );
              }).catchError((error) {
                Navigator.pop(context);

                hidekeyboard(context);
              });
            });
          }));
    }

    //####################--------------------- ALL BELOW DIALOG TILES FOR COMMON SENDER & RECIPIENT-------------------------###########################------------------------------
    if (((doc[Dbkeys.from] == currentUserNo &&
                doc[Dbkeys.hasSenderDeleted] == false) ||
            (doc[Dbkeys.to] == currentUserNo &&
                doc[Dbkeys.hasRecipientDeleted] == false)) &&
        saved == false) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.save_outlined),
          title: Text(
            'Lưu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            save(doc);
            hidekeyboard(context);
            Navigator.pop(context);
          }));
    }
    if (doc[Dbkeys.messageType] == MessageType.text.index &&
        !doc.containsKey(Dbkeys.broadcastID)) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.content_copy),
          title: Text(
            'Sao chép',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: doc[Dbkeys.content]));
            Navigator.pop(context);
            hidekeyboard(context);
            HelperFunctions.toast(
              'Đã sao chép',
            );
          }));
    }

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: tiles);
        });
  }

  contextMenuOld(BuildContext context, Map<String, dynamic> doc,
      {bool saved = false}) {
    List<Widget> tiles = List.from(<Widget>[]);
    if (saved == false && !doc.containsKey(Dbkeys.broadcastID)) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.save_outlined),
          title: Text(
            'Lưu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            save(doc);
            hidekeyboard(context);
            Navigator.pop(context);
          }));
    }
    if ((doc[Dbkeys.from] != currentUserNo) && saved == false) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.delete),
          title: Text(
            'Xóa bởi tôi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            await FirebaseFirestore.instance
                .collection(DbPaths.collectionmessages)
                .doc(chatId)
                .collection(chatId)
                .doc('${doc[Dbkeys.timestamp]}')
                .update({Dbkeys.hasRecipientDeleted: true});
            Save.deleteMessage(peerNo, doc);
            _savedMessageDocs.removeWhere(
                (msg) => msg[Dbkeys.timestamp] == doc[Dbkeys.timestamp]);
            setStateIfMounted(() {
              _savedMessageDocs = List.from(_savedMessageDocs);
            });

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.maybePop(this.context);
              HelperFunctions.toast(
                'Đã xóa',
              );
            });
          }));
    }

    if (doc[Dbkeys.messageType] == MessageType.text.index) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.content_copy),
          title: Text(
            'Sao chép',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: doc[Dbkeys.content]));
            Navigator.pop(context);
            HelperFunctions.toast(
              'Đã sao chép',
            );
          }));
    }
    if (doc.containsKey(Dbkeys.broadcastID) &&
        doc[Dbkeys.to] == widget.currentUserNo) {
      tiles.add(ListTile(
          dense: true,
          leading: Icon(Icons.block),
          title: Text(
            'Chặn',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            HelperFunctions.toast(
              'Vui lòng đợi',
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              FirebaseFirestore.instance
                  .collection(DbPaths.collectionbroadcasts)
                  .doc(doc[Dbkeys.broadcastID])
                  .update({
                Dbkeys.broadcastMEMBERSLIST:
                    FieldValue.arrayRemove([widget.currentUserNo]),
                Dbkeys.broadcastBLACKLISTED:
                    FieldValue.arrayUnion([widget.currentUserNo]),
              }).then((value) {
                HelperFunctions.toast(
                  'Blocked this Broadcast',
                );
                hidekeyboard(context);
                Navigator.pop(context);
              }).catchError((error) {
                HelperFunctions.toast(
                  'Blocked this Broadcast',
                );
                Navigator.pop(context);
                hidekeyboard(context);
              });
            });
          }));
    }
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: tiles);
        });
  }

  save(Map<String, dynamic> doc) async {
    HelperFunctions.toast(
      'Saved',
    );
    if (!_savedMessageDocs
        .any((_doc) => _doc[Dbkeys.timestamp] == doc[Dbkeys.timestamp])) {
      String content;
      if (doc[Dbkeys.messageType] == MessageType.image.index) {
        content = doc[Dbkeys.content].toString().startsWith('http')
            ? await Save.getBase64FromImage(
                imageUrl: doc[Dbkeys.content] as String)
            : doc[Dbkeys
                .content]; // if not a url, it is a base64 from saved messages
      } else {
        // If text
        content = doc[Dbkeys.content];
      }
      doc[Dbkeys.content] = content;
      Save.saveMessage(peerNo, doc);
      _savedMessageDocs.add(doc);
      setStateIfMounted(() {
        _savedMessageDocs = List.from(_savedMessageDocs);
      });
    }
  }

  Widget selectablelinkify(String text, double fontsize) {
    print(text);
    return Linkify(
      onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      style: TextStyle(fontSize: fontsize, color: Colors.black87),
      text: text ?? "",
    );
  }

  Widget getTextMessage(bool isMe, Map<String, dynamic> doc, bool saved) {
    return selectablelinkify(doc[Dbkeys.content], 16);
  }

  Widget getTempTextMessage(String message) {
    return selectablelinkify(message, 16);
  }

  Widget getTempLinkMessage(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            if (await canLaunch(message)) {
              await launch(message);
            } else {
              throw 'Could not launch $message';
            }
          },
          child: Text(
            message,
            style: TextStyle(
                color: Config().colorMain,
                fontSize: 16,
                decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        FlutterLinkPreview(
          key: ValueKey("${message}211"),
          url: message,
          builder: (info) {
            if (info == null) return const SizedBox();
            if (info is WebImageInfo) {
              return CachedNetworkImage(
                imageUrl: info.image,
                fit: BoxFit.contain,
              );
            }

            final WebInfo webInfo = info;
            if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF0F1F2),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: webInfo.icon ?? "",
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            fit: BoxFit.contain,
                            width: 30,
                            height: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.link);
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          webInfo.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
                    const SizedBox(height: 8),
                    Text(
                      webInfo.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                    const SizedBox(height: 8),
                    CachedNetworkImage(
                      imageUrl: webInfo.image,
                      fit: BoxFit.contain,
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getLocationMessage(String message, {bool saved = false}) {
    return InkWell(
      onTap: () {
        launch(message);
      },
      child: Image.asset(
        'assets/images/mapview.jpg',
      ),
    );
  }

  Widget getAudiomessage(BuildContext context, String message,
      {bool saved = false, bool isMe = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      // width: 250,
      // height: 116,
      // child: Column(
      //   children: [
      //     SizedBox(
      //       width: 200,
      //       height: 80,
      //       child: MultiPlayback(
      //         isMe: isMe,
      //         onTapDownloadFn: Platform.isIOS
      //             ? () {
      //                 launch(message.split('-BREAK-')[0]);
      //               }
      //             : () async {
      //                 await downloadFile(
      //                   context: _scaffold.currentContext,
      //                   fileName:
      //                       'Recording_' + message.split('-BREAK-')[1] + '.mp3',
      //                   isonlyview: false,
      //                   keyloader: _keyLoader,
      //                   uri: message.split('-BREAK-')[0],
      //                 );
      //               },
      //         url: message.split('-BREAK-')[0],
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  Widget getDocmessage(BuildContext context, String message,
      {bool saved = false}) {
    return SizedBox(
      width: 220,
      height: 116,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(4),
            isThreeLine: false,
            leading: Container(
              decoration: BoxDecoration(
                color: message.split('-BREAK-')[1].endsWith('.pdf')
                    ? Colors.red[400]
                    : Colors.cyan[700],
                borderRadius: BorderRadius.circular(7.0),
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.attach_file_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
            title: Text(
              message.split('-BREAK-')[1],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
          ),
          Divider(
            height: 3,
          ),
          message.split('-BREAK-')[1].endsWith('.pdf')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (_) => PDFViewerCachedFromUrl(
                                title: message.split('-BREAK-')[1],
                                url: message.split('-BREAK-')[0],
                              ),
                            ),
                          );
                        },
                        child: Text('Xem trước',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[400]))),
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: Platform.isIOS
                            ? () {
                                launch(message.split('-BREAK-')[0]);
                              }
                            : () async {
                                await downloadFile(
                                  context: _scaffold.currentContext,
                                  fileName: message.split('-BREAK-')[1],
                                  isonlyview: false,
                                  keyloader: _keyLoader,
                                  uri: message.split('-BREAK-')[0],
                                );
                              },
                        child: Text('Tải về',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[400]))),
                  ],
                )
              //ignore: deprecated_member_use
              : FlatButton(
                  onPressed: Platform.isIOS
                      ? () {
                          launch(message.split('-BREAK-')[0]);
                        }
                      : () async {
                          await downloadFile(
                            context: _scaffold.currentContext,
                            fileName: message.split('-BREAK-')[1],
                            isonlyview: false,
                            keyloader: _keyLoader,
                            uri: message.split('-BREAK-')[0],
                          );
                        },
                  child: Text('Tải về',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[400]))),
        ],
      ),
    );
  }

  Widget getVideoMessage(BuildContext context, String message,
      {bool saved = false}) {
    Map<dynamic, dynamic> meta =
        jsonDecode((message.split('-BREAK-')[2]).toString());
    return InkWell(
      onTap: () {
        Navigator.push(
            this.context,
            new MaterialPageRoute(
                builder: (context) => PreviewVideo(
                      isdownloadallowed: true,
                      filename: message.split('-BREAK-')[1],
                      id: null,
                      videourl: message.split('-BREAK-')[0],
                      aspectratio: meta["width"] / meta["height"],
                    )));
      },
      child: Container(
        color: Colors.blueGrey,
        height: 197,
        width: 197,
        child: Stack(
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue),
                ),
                width: 197,
                height: 197,
                padding: EdgeInsets.all(80.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
              ),
              errorWidget: (context, str, error) => Material(
                child: Image.asset(
                  'assets/images/img_not_available.jpeg',
                  width: 197,
                  height: 197,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: message.split('-BREAK-')[1],
              width: 197,
              height: 197,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
              height: 197,
              width: 197,
            ),
            Center(
              child: Icon(
                Icons.play_circle_fill_outlined,
                color: Colors.white70,
                size: 65,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContactMessage(BuildContext context, String message,
      {bool saved = false}) {
    return SizedBox(
      width: 250,
      height: 130,
      child: Column(
        children: [
          ListTile(
            isThreeLine: false,
            leading: HelperFunctions.customCircleAvatar(url: null),
            title: Text(
              message.split('-BREAK-')[0],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue[400]),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                message.split('-BREAK-')[1],
                style: TextStyle(
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
          ),
          Divider(
            height: 7,
          ),
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () async {
                String peer = message.split('-BREAK-')[1];
                String peerphone;
                bool issearching = true;
                bool issearchraw = false;
                bool isUser = false;
                String formattedphone;

                setStateIfMounted(() {
                  peerphone = peer.replaceAll(new RegExp(r'-'), '');
                  peerphone.trim();
                });

                formattedphone = peerphone;
                //
                // if (!peerphone.startsWith('+')) {
                //   if ((peerphone.length > 11)) {
                //     CountryCodes.forEach((code) {
                //       if (peerphone!.startsWith(code) && issearching == true) {
                //         setStateIfMounted(() {
                //           formattedphone = peerphone!
                //               .substring(code.length, peerphone!.length);
                //           issearchraw = true;
                //           issearching = false;
                //         });
                //       }
                //     });
                //   } else {
                //     setStateIfMounted(() {
                //       setStateIfMounted(() {
                //         issearchraw = true;
                //         formattedphone = peerphone;
                //       });
                //     });
                //   }
                // } else {
                //   setStateIfMounted(() {
                //     issearchraw = false;
                //     formattedphone = peerphone;
                //   });
                // }

                Query query = issearchraw == true
                    ? FirebaseFirestore.instance
                        .collection(DbPaths.collectionusers)
                        .where(Dbkeys.phoneRaw,
                            isEqualTo: formattedphone ?? peerphone)
                        .limit(1)
                    : FirebaseFirestore.instance
                        .collection(DbPaths.collectionusers)
                        .where(Dbkeys.phone,
                            isEqualTo: formattedphone ?? peerphone)
                        .limit(1);

                await query.get().then((user) {
                  setStateIfMounted(() {
                    isUser = user.docs.length == 0 ? false : true;
                  });
                  if (isUser) {
                    Map<String, dynamic> peer = user.docs[0].data();
                    widget.model.addUser(user.docs[0]);
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ChatRoom(
                                prefs: widget.prefs,
                                unread: 0,
                                currentUserNo: widget.currentUserNo,
                                model: widget.model,
                                peerNo: peer[Dbkeys.phone])));
                  } else {
                    Query queryretrywithoutzero = issearchraw == true
                        ? FirebaseFirestore.instance
                            .collection(DbPaths.collectionusers)
                            .where(Dbkeys.phoneRaw,
                                isEqualTo: formattedphone == null
                                    ? peerphone.substring(1, peerphone.length)
                                    : formattedphone.substring(
                                        1, formattedphone.length))
                            .limit(1)
                        : FirebaseFirestore.instance
                            .collection(DbPaths.collectionusers)
                            .where(Dbkeys.phoneRaw,
                                isEqualTo: formattedphone == null
                                    ? peerphone.substring(1, peerphone.length)
                                    : formattedphone.substring(
                                        1, formattedphone.length))
                            .limit(1);
                    queryretrywithoutzero.get().then((user) {
                      setStateIfMounted(() {
                        isLoading = false;
                        isUser = user.docs.length == 0 ? false : true;
                      });
                      if (isUser) {
                        Map<String, dynamic> peer = user.docs[0].data();
                        widget.model.addUser(user.docs[0]);
                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ChatRoom(
                                    prefs: widget.prefs,
                                    unread: 0,
                                    currentUserNo: widget.currentUserNo,
                                    model: widget.model,
                                    peerNo: peer[Dbkeys.phone])));
                      }
                    });
                  }
                });

                // ignore: unnecessary_null_comparison
                if (isUser == null || isUser == false) {
                  HelperFunctions.toast('User not joined' + ' $Appname');
                }
              },
              child: Text('Message',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.blue[400])))
        ],
      ),
    );
  }

  // _onEmojiSelected(Emoji emoji) {
  //   // String text = textEditingController.text;
  //   // TextSelection textSelection = textEditingController.selection;
  //   // String newText =
  //   //     text.replaceRange(textSelection.start, textSelection.end, emoji.emoji);
  //   // final emojiLength = emoji.emoji.length;
  //   // textEditingController.text = newText;
  //   // textEditingController.selection = textSelection.copyWith(
  //   //   baseOffset: textSelection.start + emojiLength,
  //   //   extentOffset: textSelection.start + emojiLength,
  //   // );
  //   textEditingController
  //     ..text += emoji.emoji
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: textEditingController.text.length));
  // }

  _onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  Widget getImageMessage(Map<String, dynamic> doc, {bool saved = false}) {
    return Container(
      child: saved
          ? Material(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Save.getImageFromBase64(doc[Dbkeys.content]).image,
                      fit: BoxFit.cover),
                ),
                width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                height: doc[Dbkeys.content].contains('giphy') ? 102 : 200.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
            )
          : CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue),
                ),
                width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                padding: EdgeInsets.all(80.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              errorWidget: (context, str, error) => Material(
                child: Image.asset(
                  'assets/images/img_not_available.jpeg',
                  width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                  height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: doc[Dbkeys.content],
              width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
              height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget getTempImageMessage({String url}) {
    return imageFile != null
        ? Container(
            child: Image.file(
              imageFile,
              width: url.contains('giphy') ? 120 : 200.0,
              height: url.contains('giphy') ? 120 : 200.0,
              fit: BoxFit.cover,
            ),
          )
        : getImageMessage({Dbkeys.content: url});
  }

  Widget buildMessage(BuildContext context, Map<String, dynamic> doc,
      {bool saved = false, List<Message> savedMsgs}) {
    final observer = Provider.of<Observer>(context, listen: false);
    final bool isMe = doc[Dbkeys.from] == currentUserNo;
    bool isContinuing;
    if (savedMsgs == null)
      isContinuing =
          messages.isNotEmpty ? messages.last.from == doc[Dbkeys.from] : false;
    else {
      isContinuing = savedMsgs.isNotEmpty
          ? savedMsgs.last.from == doc[Dbkeys.from]
          : false;
    }
    return SeenProvider(
        timestamp: doc[Dbkeys.timestamp].toString(),
        data: seenState,
        child: Bubble(
            is24hrsFormat: observer.is24hrsTimeformat,
            isMssgDeleted: (doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                    doc.containsKey(Dbkeys.hasSenderDeleted))
                ? isMe
                    ? (doc[Dbkeys.from] == widget.currentUserNo
                        ? doc[Dbkeys.hasSenderDeleted]
                        : false)
                    : (doc[Dbkeys.from] != widget.currentUserNo
                        ? doc[Dbkeys.hasRecipientDeleted]
                        : false)
                : false,
            isBroadcastMssg: doc.containsKey(Dbkeys.isbroadcast) == true
                ? doc[Dbkeys.isbroadcast]
                : false,
            messagetype: doc[Dbkeys.messageType] == MessageType.text.index
                ? MessageType.text
                : doc[Dbkeys.messageType] == MessageType.link.index
                    ? MessageType.link
                    : doc[Dbkeys.messageType] == MessageType.contact.index
                        ? MessageType.contact
                        : doc[Dbkeys.messageType] == MessageType.location.index
                            ? MessageType.location
                            : doc[Dbkeys.messageType] == MessageType.image.index
                                ? MessageType.image
                                : doc[Dbkeys.messageType] ==
                                        MessageType.video.index
                                    ? MessageType.video
                                    : doc[Dbkeys.messageType] ==
                                            MessageType.doc.index
                                        ? MessageType.doc
                                        : doc[Dbkeys.messageType] ==
                                                MessageType.audio.index
                                            ? MessageType.audio
                                            : MessageType.text,
            child: doc[Dbkeys.messageType] == MessageType.text.index
                ? getTextMessage(isMe, doc, saved)
                : doc[Dbkeys.messageType] == MessageType.link.index
                    ? getTempLinkMessage(doc[Dbkeys.content])
                    : doc[Dbkeys.messageType] == MessageType.location.index
                        ? getLocationMessage(doc[Dbkeys.content], saved: false)
                        : doc[Dbkeys.messageType] == MessageType.doc.index
                            ? getDocmessage(context, doc[Dbkeys.content],
                                saved: false)
                            : doc[Dbkeys.messageType] == MessageType.audio.index
                                ? getAudiomessage(context, doc[Dbkeys.content],
                                    isMe: isMe, saved: false)
                                : doc[Dbkeys.messageType] ==
                                        MessageType.video.index
                                    ? getVideoMessage(
                                        context, doc[Dbkeys.content],
                                        saved: false)
                                    : doc[Dbkeys.messageType] ==
                                            MessageType.contact.index
                                        ? getContactMessage(
                                            context, doc[Dbkeys.content],
                                            saved: false)
                                        : getImageMessage(
                                            doc,
                                            saved: saved,
                                          ),
            isMe: isMe,
            timestamp: doc[Dbkeys.timestamp],
            delivered:
                _cachedModel.getMessageStatus(peerNo, doc[Dbkeys.timestamp]),
            isContinuing: isContinuing));
  }

  Widget buildTempMessage(BuildContext context, MessageType type, content,
      timestamp, delivered, tempDoc) {
    final observer = Provider.of<Observer>(this.context, listen: false);
    final bool isMe = true;
    return SeenProvider(
        timestamp: timestamp.toString(),
        data: seenState,
        child: Bubble(
          is24hrsFormat: observer.is24hrsTimeformat,
          isMssgDeleted: ((tempDoc.containsKey(Dbkeys.hasRecipientDeleted) &&
                      tempDoc.containsKey(Dbkeys.hasSenderDeleted)) ==
                  true)
              ? (isMe == true
                  ? (tempDoc[Dbkeys.from] == widget.currentUserNo
                      ? tempDoc[Dbkeys.hasSenderDeleted]
                      : false)
                  : (tempDoc[Dbkeys.from] != widget.currentUserNo
                      ? tempDoc[Dbkeys.hasRecipientDeleted]
                      : false))
              : false,
          isBroadcastMssg: false,
          messagetype: type,
          child: type == MessageType.text
              ? getTempTextMessage(content)
              : type == MessageType.link
                  ? getTempLinkMessage(content)
                  : type == MessageType.location
                      ? getLocationMessage(content, saved: false)
                      : type == MessageType.doc
                          ? getDocmessage(context, content, saved: false)
                          : type == MessageType.audio
                              ? getAudiomessage(context, content,
                                  saved: false, isMe: isMe)
                              : type == MessageType.video
                                  ? getVideoMessage(this.context, content,
                                      saved: false)
                                  : type == MessageType.contact
                                      ? getContactMessage(context, content,
                                          saved: false)
                                      : getTempImageMessage(url: content),
          isMe: isMe,
          timestamp: timestamp,
          delivered: delivered,
          isContinuing:
              messages.isNotEmpty && messages.last.from == currentUserNo,
        ));
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue)),
              ),
              color: DESIGN_TYPE == Themetype.whatsapp
                  ? fiberchatBlack.withOpacity(0.6)
                  : fiberchatWhite.withOpacity(0.6),
            )
          : Container(),
    );
  }

  Widget buildLoadingThumbnail() {
    return Positioned(
      child: isgeneratingThumbnail
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(fiberchatBlue)),
              ),
              color: DESIGN_TYPE == Themetype.whatsapp
                  ? fiberchatBlack.withOpacity(0.6)
                  : fiberchatWhite.withOpacity(0.6),
            )
          : Container(),
    );
  }

  shareMedia(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return Container(
            padding: EdgeInsets.all(12),
            height: 250,
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        RawMaterialButton(
                          disabledElevation: 0,
                          onPressed: () {
                            hidekeyboard(context);
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HybridDocumentPicker(
                                          title: 'Chọn tài liệu',
                                          callback: getImage,
                                        ))).then((url) async {
                              if (url != null) {
                                HelperFunctions.toast(
                                  'Vui lòng đợi',
                                );

                                onSendMessage(
                                    this.context,
                                    url +
                                        '-BREAK-' +
                                        basename(imageFile.path).toString(),
                                    MessageType.doc,
                                    uploadTimestamp);
                                // Fiberchat.toast(
                                //     getTranslated(this.context, 'sent'));
                              } else {}
                            });
                          },
                          elevation: .5,
                          fillColor: Colors.indigo,
                          child: Icon(
                            Icons.file_copy,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Tài liệu',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        RawMaterialButton(
                          disabledElevation: 0,
                          onPressed: () {
                            hidekeyboard(context);
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HybridVideoPicker(
                                          title: 'Chọn Video',
                                          callback: getImage,
                                        ))).then((url) async {
                              if (url != null) {
                                HelperFunctions.toast(
                                  'Vui lòng đợi',
                                );
                                String thumbnailurl = await getThumbnail(url);
                                onSendMessage(
                                    context,
                                    url +
                                        '-BREAK-' +
                                        thumbnailurl +
                                        '-BREAK-' +
                                        videometadata,
                                    MessageType.video,
                                    thumnailtimestamp);
                                HelperFunctions.toast('Đã gửi');
                              } else {}
                            });
                          },
                          elevation: .5,
                          fillColor: Colors.pink[600],
                          child: Icon(
                            Icons.video_collection_sharp,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Video',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        RawMaterialButton(
                          disabledElevation: 0,
                          onPressed: () {
                            hidekeyboard(context);
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HybridImagePicker(
                                          title: 'Chọn Ảnh',
                                          callback: getImage,
                                        ))).then((url) {
                              if (url != null) {
                                onSendMessage(this.context, url,
                                    MessageType.image, uploadTimestamp);
                              } else {}
                            });
                          },
                          elevation: .5,
                          fillColor: Colors.purple,
                          child: Icon(
                            Icons.image_rounded,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Ảnh',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SizedBox(
                  //   child: Column(
                  //     children: [
                  //       RawMaterialButton(
                  //         disabledElevation: 0,
                  //         onPressed: () {
                  //           hidekeyboard(context);
                  //
                  //           // Navigator.of(context).pop();
                  //           // Navigator.push(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //         builder: (context) => AudioRecord(
                  //           //               title: 'record',
                  //           //               callback: getImage,
                  //           //             ))).then((url) {
                  //           //   if (url != null) {
                  //           //     onSendMessage(
                  //           //         context,
                  //           //         url +
                  //           //             '-BREAK-' +
                  //           //             uploadTimestamp.toString(),
                  //           //         MessageType.audio,
                  //           //         uploadTimestamp);
                  //           //   } else {}
                  //           // });
                  //         },
                  //         elevation: .5,
                  //         fillColor: Colors.yellow[900],
                  //         child: Icon(
                  //           Icons.mic_rounded,
                  //           size: 25.0,
                  //           color: Colors.white,
                  //         ),
                  //         padding: EdgeInsets.all(15.0),
                  //         shape: CircleBorder(),
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Text(
                  //         'Audio',
                  //         style: TextStyle(color: Colors.grey[700]),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    child: Column(
                      children: [
                        RawMaterialButton(
                          disabledElevation: 0,
                          onPressed: () async {
                            hidekeyboard(context);
                            Navigator.of(context).pop();
                            await _determinePosition().then(
                              (location) async {
                                var locationstring =
                                    'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
                                onSendMessage(
                                    context,
                                    locationstring,
                                    MessageType.location,
                                    DateTime.now().millisecondsSinceEpoch);
                                setStateIfMounted(() {});
                                HelperFunctions.toast(
                                  'Đã gửi',
                                );
                              },
                            );
                          },
                          elevation: .5,
                          fillColor: Colors.cyan[700],
                          child: Icon(
                            Icons.location_on,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Vị trí',
                          style: TextStyle(color: Colors.grey[700]),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   child: Column(
                  //     children: [
                  //       RawMaterialButton(
                  //         disabledElevation: 0,
                  //         onPressed: () async {
                  //           // hidekeyboard(context);
                  //           // Navigator.of(context).pop();
                  //           // await Navigator.push(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //         builder: (context) => ContactsSelect(
                  //           //             currentUserNo: widget.currentUserNo,
                  //           //             model: widget.model,
                  //           //             biometricEnabled: false,
                  //           //             prefs: widget.prefs,
                  //           //             onSelect: (name, phone) {
                  //           //               onSendMessage(
                  //           //                   context,
                  //           //                   '$name-BREAK-$phone',
                  //           //                   MessageType.contact,
                  //           //                   DateTime.now()
                  //           //                       .millisecondsSinceEpoch);
                  //           //             })));
                  //         },
                  //         elevation: .5,
                  //         fillColor: Colors.blue[800],
                  //         child: Icon(
                  //           Icons.person,
                  //           size: 25.0,
                  //           color: Colors.white,
                  //         ),
                  //         padding: EdgeInsets.all(15.0),
                  //         shape: CircleBorder(),
                  //       ),
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Text(
                  //         'Contact',
                  //         style: TextStyle(color: Colors.grey[700]),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ]),
          );
        });
  }

  FocusNode keyboardFocusNode = new FocusNode();

  Widget buildInputAndroid(BuildContext context, bool isemojiShowing,
      Function refreshThisInput, bool keyboardVisible) {
    final observer = Provider.of<Observer>(context, listen: true);
    if (chatStatus == ChatStatus.requested.index) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Text(
          'Bắt đầu trò chuyện với ' + '${peer[Dbkeys.phone]} ?',
          style: TextStyle(color: fiberchatBlack),
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              child: Text('Từ chối'),
              onPressed: () {
                ChatController.block(currentUserNo, peerNo);
                setStateIfMounted(() {
                  chatStatus = ChatStatus.blocked.index;
                });
              }),
          // ignore: deprecated_member_use
          FlatButton(
              child: Text('Đồng ý', style: TextStyle(color: fiberchatgreen)),
              onPressed: () {
                ChatController.accept(currentUserNo, peerNo);
                setStateIfMounted(() {
                  chatStatus = ChatStatus.accepted.index;
                });
              })
        ],
      );
    }
    return Column(children: [
      Container(
        margin: EdgeInsets.only(bottom: Platform.isIOS == true ? 20 : 0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                decoration: BoxDecoration(
                    color: fiberchatWhite,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Row(
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                            child: IconButton(
                                color: fiberchatWhite,
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(
                                  Icons.gif,
                                  size: 40,
                                  color: fiberchatGrey,
                                ),
                                onPressed: observer.ismediamessagingallowed ==
                                        false
                                    ? () {
                                        HelperFunctions.toast(
                                            'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                      }
                                    : () async {
                                        GiphyGif gif = await GiphyGet.getGif(
                                          tabColor: fiberchatgreen,
                                          context: context,
                                          apiKey:
                                              GiphyAPIKey, //YOUR API KEY HERE
                                          lang: GiphyLanguage.english,
                                        );
                                        if (gif != null && mounted) {
                                          onSendMessage(
                                              context,
                                              gif.images.original.url,
                                              MessageType.image,
                                              DateTime.now()
                                                  .millisecondsSinceEpoch);
                                          hidekeyboard(context);
                                          setStateIfMounted(() {});
                                        }
                                      }),
                          ),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              icon: new Icon(
                                Icons.attachment_outlined,
                                color: fiberchatGrey,
                              ),
                              padding: EdgeInsets.all(0.0),
                              onPressed:
                                  observer.ismediamessagingallowed == false
                                      ? () {
                                          HelperFunctions.toast(
                                              'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                        }
                                      : chatStatus == ChatStatus.blocked.index
                                          ? () {
                                              HelperFunctions.toast(
                                                  'Unblock chat to Share Media');
                                            }
                                          : () {
                                              hidekeyboard(context);
                                              shareMedia(context);
                                            },
                              color: fiberchatWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        onTap: () {
                          keyboardFocusNode.requestFocus();
                        },
                        showCursor: true,
                        focusNode: keyboardFocusNode,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: 16.0, color: fiberchatBlack),
                        controller: textEditingController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          hoverColor: Colors.transparent,
                          focusedBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          contentPadding: EdgeInsets.fromLTRB(10, 4, 7, 4),
                          hintText: 'Nhập tin nhắn',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button send message
            Container(
              height: 47,
              width: 47,
              // alignment: Alignment.center,
              margin: EdgeInsets.only(left: 6, right: 10),
              decoration: BoxDecoration(
                  color: Config().colorMain,
                  // border: Border.all(
                  //   color: Colors.red[500],
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IconButton(
                  icon: new Icon(
                    Icons.send,
                    color: fiberchatWhite.withOpacity(0.99),
                  ),
                  onPressed: observer.ismediamessagingallowed == true
                      ? textEditingController.text.length == 0 ||
                              isMessageLoading == true
                          ? () {
                              hidekeyboard(context);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => AudioRecord(
                              //               title: 'Record',
                              //               callback: getImage,
                              //             ))).then((url) {
                              //   if (url != null) {
                              //     onSendMessage(
                              //         context,
                              //         url +
                              //             '-BREAK-' +
                              //             uploadTimestamp.toString(),
                              //         MessageType.audio,
                              //         uploadTimestamp);
                              //   } else {}
                              // });
                            }
                          : observer.istextmessagingallowed == false
                              ? () {
                                  HelperFunctions.toast(
                                      'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                }
                              : chatStatus == ChatStatus.blocked.index
                                  ? null
                                  : () => onSendMessage(
                                      context,
                                      textEditingController.text,
                                      MessageType.text,
                                      DateTime.now().millisecondsSinceEpoch)
                      : () {
                          HelperFunctions.toast(
                              'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                        },
                  color: fiberchatWhite,
                ),
              ),
            ),
          ],
        ),
        width: double.infinity,
        height: 60.0,
        decoration: new BoxDecoration(
          // border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.transparent,
        ),
      ),
      // isemojiShowing == true && keyboardVisible == false
      //     ? Offstage(
      //         offstage: !isemojiShowing,
      //         child: SizedBox(
      //           height: 300,
      //           child: EmojiPicker(
      //               onEmojiSelected: (emojipic.Category category, Emoji emoji) {
      //                 _onEmojiSelected(emoji);
      //               },
      //               onBackspacePressed: _onBackspacePressed,
      //               config: Config(
      //                   columns: 7,
      //                   emojiSizeMax: 32.0,
      //                   verticalSpacing: 0,
      //                   horizontalSpacing: 0,
      //                   initCategory: emojipic.Category.RECENT,
      //                   bgColor: Color(0xFFF2F2F2),
      //                   indicatorColor: fiberchatgreen,
      //                   iconColor: Colors.grey,
      //                   iconColorSelected: fiberchatgreen,
      //                   progressIndicatorColor: Colors.blue,
      //                   backspaceColor: fiberchatgreen,
      //                   showRecentsTab: true,
      //                   recentsLimit: 28,
      //                   noRecentsText: 'No Recents',
      //                   noRecentsStyle:
      //                       TextStyle(fontSize: 20, color: Colors.black26),
      //                   categoryIcons: CategoryIcons(),
      //                   buttonMode: ButtonMode.MATERIAL)),
      //         ),
      //       )
      //     : SizedBox(),
    ]);
  }

  Widget buildInputIos(
    BuildContext context,
  ) {
    final observer = Provider.of<Observer>(context, listen: true);
    if (chatStatus == ChatStatus.requested.index) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Text(
          'Chấp nhận ' + '${peer[Dbkeys.nickname] ?? "Đang cập nhật"} ?',
          style: TextStyle(color: fiberchatBlack),
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              child: Text('Từ chối'),
              onPressed: () {
                ChatController.block(currentUserNo, peerNo);
                setStateIfMounted(() {
                  chatStatus = ChatStatus.blocked.index;
                });
              }),
          // ignore: deprecated_member_use
          FlatButton(
              child: Text('Chấp nhận', style: TextStyle(color: fiberchatgreen)),
              onPressed: () {
                ChatController.accept(currentUserNo, peerNo);
                setStateIfMounted(() {
                  chatStatus = ChatStatus.accepted.index;
                });
              })
        ],
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: Platform.isIOS == true ? 20 : 0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              decoration: BoxDecoration(
                  color: fiberchatWhite,
                  // border: Border.all(
                  //   color: Colors.red[500],
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            color: fiberchatWhite,
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(
                              Icons.gif,
                              size: 40,
                              color: fiberchatGrey,
                            ),
                            onPressed: observer.ismediamessagingallowed == false
                                ? () {
                                    HelperFunctions.toast(
                                        'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                  }
                                : () async {
                                    GiphyGif gif = await GiphyGet.getGif(
                                      tabColor: fiberchatgreen,
                                      context: context,
                                      apiKey: GiphyAPIKey, //YOUR API KEY HERE
                                      lang: GiphyLanguage.english,
                                    );
                                    if (gif != null && mounted) {
                                      onSendMessage(
                                          context,
                                          gif.images.original.url,
                                          MessageType.image,
                                          DateTime.now()
                                              .millisecondsSinceEpoch);
                                      hidekeyboard(context);
                                      setStateIfMounted(() {});
                                    }
                                  }),
                        IconButton(
                          icon: new Icon(
                            Icons.attachment_outlined,
                            color: fiberchatGrey,
                          ),
                          padding: EdgeInsets.all(0.0),
                          onPressed: observer.ismediamessagingallowed == false
                              ? () {
                                  HelperFunctions.toast(
                                      'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                }
                              : chatStatus == ChatStatus.blocked.index
                                  ? () {
                                      HelperFunctions.toast('Unlock');
                                    }
                                  : () {
                                      hidekeyboard(context);
                                      shareMedia(context);
                                    },
                          color: fiberchatWhite,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      style: TextStyle(fontSize: 18.0, color: fiberchatBlack),
                      controller: textEditingController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.5),
                        ),
                        hoverColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(color: Colors.transparent)),
                        contentPadding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        hintText: 'Nhập tin nhắn',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button send message
          Container(
            height: 47,
            width: 47,
            // alignment: Alignment.center,
            margin: EdgeInsets.only(left: 6, right: 10),
            decoration: BoxDecoration(
                color: DESIGN_TYPE == Themetype.whatsapp
                    ? fiberchatgreen
                    : fiberchatLightGreen,
                // border: Border.all(
                //   color: Colors.red[500],
                // ),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: IconButton(
                icon: new Icon(
                  Icons.send,
                  color: fiberchatWhite.withOpacity(0.99),
                ),
                onPressed: observer.ismediamessagingallowed == true
                    ? textEditingController.text.length == 0 ||
                            isMessageLoading == true
                        ? () {
                            hidekeyboard(context);
                            //
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => AudioRecord(
                            //               title: 'Record',
                            //               callback: getImage,
                            //             ))).then((url) {
                            //   if (url != null) {
                            //     onSendMessage(
                            //         context,
                            //         url +
                            //             '-BREAK-' +
                            //             uploadTimestamp.toString(),
                            //         MessageType.audio,
                            //         uploadTimestamp);
                            //   } else {}
                            // });
                          }
                        : observer.istextmessagingallowed == false
                            ? () {
                                HelperFunctions.toast(
                                    'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                              }
                            : chatStatus == ChatStatus.blocked.index
                                ? () {
                                    HelperFunctions.toast(
                                        'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                                  }
                                : () => onSendMessage(
                                    context,
                                    textEditingController.text,
                                    MessageType.text,
                                    DateTime.now().millisecondsSinceEpoch)
                    : () {
                        HelperFunctions.toast(
                            'Quản trị viên tạm thời tắt tính năng gửi Tin nhắn phương tiện.');
                      },
                color: fiberchatWhite,
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 60.0,
      decoration: new BoxDecoration(
        // border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.transparent,
      ),
    );
  }

  bool empty = true;

  loadMessagesAndListen() async {
    await FirebaseFirestore.instance
        .collection(DbPaths.collectionmessages)
        .doc(chatId)
        .collection(chatId)
        .orderBy(Dbkeys.timestamp)
        .get()
        .then((docs) {
      if (docs.docs.isNotEmpty) {
        empty = false;
        docs.docs.forEach((doc) {
          Map<String, dynamic> _doc = Map.from(doc.data());
          int ts = _doc[Dbkeys.timestamp];
          messages.add(Message(buildMessage(this.context, _doc),
              onDismiss:
                  // _doc[Dbkeys.from] == peerNo
                  //     ? () {
                  //         if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                  //             _doc.containsKey(Dbkeys.hasSenderDeleted)) {
                  //           contextMenuNew(context, _doc, false);
                  //         } else {
                  //           contextMenuOld(context, _doc);
                  //         }
                  //       }
                  //     :
                  null,
              onTap: (_doc[Dbkeys.from] == widget.currentUserNo &&
                          _doc[Dbkeys.hasSenderDeleted] == true) ==
                      true
                  ? () {}
                  : _doc[Dbkeys.messageType] == MessageType.image.index
                      ? () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewWrapper(
                                  message: _doc[Dbkeys.content],
                                  tag: ts.toString(),
                                  imageProvider: CachedNetworkImageProvider(
                                      _doc[Dbkeys.content]),
                                ),
                              ));
                        }
                      : null,
              onDoubleTap: _doc.containsKey(Dbkeys.broadcastID)
                  ? () {}
                  : () {
                      // save(_doc);
                    }, onLongPress: () {
            if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                _doc.containsKey(Dbkeys.hasSenderDeleted)) {
              if ((_doc[Dbkeys.from] == widget.currentUserNo &&
                      _doc[Dbkeys.hasSenderDeleted] == true) ==
                  false) {
                //--Show Menu only if message is not deleted by current user already
                contextMenuNew(this.context, _doc, false);
              }
            } else {
              contextMenuOld(this.context, _doc);
            }
          }, from: _doc[Dbkeys.from], timestamp: ts));

          if (doc.data()[Dbkeys.timestamp] ==
              docs.docs.last.data()[Dbkeys.timestamp]) {
            setStateIfMounted(() {
              isMessageLoading = false;
              print('All message loaded..........');
            });
          }
        });
      } else {
        setStateIfMounted(() {
          isMessageLoading = false;
          print('All message loaded..........');
        });
      }
      if (mounted) {
        setStateIfMounted(() {
          messages = List.from(messages);
        });
      }
      msgSubscription = FirebaseFirestore.instance
          .collection(DbPaths.collectionmessages)
          .doc(chatId)
          .collection(chatId)
          .where(Dbkeys.from, isEqualTo: peerNo)
          .snapshots()
          .listen((query) {
        if (empty == true || query.docs.length != query.docChanges.length) {
          //----below action triggers when peer new message arrives
          query.docChanges.where((doc) {
            return doc.oldIndex <= doc.newIndex &&
                doc.type == DocumentChangeType.added;

            //  &&
            //     query.docs[doc.oldIndex][Dbkeys.timestamp] !=
            //         query.docs[doc.newIndex][Dbkeys.timestamp];
          }).forEach((change) {
            Map<String, dynamic> _doc = Map.from(change.doc.data());
            int ts = _doc[Dbkeys.timestamp];

            messages.add(Message(
              buildMessage(this.context, _doc),
              onLongPress: () {
                if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                    _doc.containsKey(Dbkeys.hasSenderDeleted)) {
                  if ((_doc[Dbkeys.from] == widget.currentUserNo &&
                          _doc[Dbkeys.hasSenderDeleted] == true) ==
                      false) {
                    //--Show Menu only if message is not deleted by current user already
                    contextMenuNew(this.context, _doc, false);
                  }
                } else {
                  contextMenuOld(this.context, _doc);
                }
              },
              onTap: (_doc[Dbkeys.from] == widget.currentUserNo &&
                          _doc[Dbkeys.hasSenderDeleted] == true) ==
                      true
                  ? () {}
                  : _doc[Dbkeys.messageType] == MessageType.image.index
                      ? () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewWrapper(
                                  message: _doc[Dbkeys.content],
                                  tag: ts.toString(),
                                  imageProvider: CachedNetworkImageProvider(
                                      _doc[Dbkeys.content]),
                                ),
                              ));
                        }
                      : null,
              onDoubleTap: _doc.containsKey(Dbkeys.broadcastID)
                  ? () {}
                  : () {
                      // save(_doc);
                    },
              from: _doc[Dbkeys.from],
              timestamp: ts,
              onDismiss: () {
                // if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                //     _doc.containsKey(Dbkeys.hasSenderDeleted)) {
                //   contextMenuNew(context, _doc, false);
                // } else {
                //   contextMenuOld(context, _doc);
                // }
              },
            ));
          });
          //----below action triggers when peer message get deleted
          query.docChanges.where((doc) {
            return doc.type == DocumentChangeType.removed;
          }).forEach((change) {
            Map<String, dynamic> _doc = Map.from(change.doc.data());

            int i = messages.indexWhere(
                (element) => element.timestamp == _doc[Dbkeys.timestamp]);
            if (i >= 0) messages.removeAt(i);
            Save.deleteMessage(peerNo, _doc);
            _savedMessageDocs.removeWhere(
                (msg) => msg[Dbkeys.timestamp] == _doc[Dbkeys.timestamp]);
            setStateIfMounted(() {
              _savedMessageDocs = List.from(_savedMessageDocs);
            });
          }); //----below action triggers when peer message gets modified
          query.docChanges.where((doc) {
            return doc.type == DocumentChangeType.modified;
          }).forEach((change) {
            Map<String, dynamic> _doc = Map.from(change.doc.data());

            int i = messages.indexWhere(
                (element) => element.timestamp == _doc[Dbkeys.timestamp]);
            if (i >= 0) {
              messages.removeAt(i);
              setStateIfMounted(() {});
              int ts = _doc[Dbkeys.timestamp];
              messages.insert(
                  i,
                  Message(
                    buildMessage(this.context, _doc),
                    onLongPress: () {
                      if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                          _doc.containsKey(Dbkeys.hasSenderDeleted)) {
                        if ((_doc[Dbkeys.from] == widget.currentUserNo &&
                                _doc[Dbkeys.hasSenderDeleted] == true) ==
                            false) {
                          //--Show Menu only if message is not deleted by current user already
                          contextMenuNew(this.context, _doc, false);
                        }
                      } else {
                        contextMenuOld(this.context, _doc);
                      }
                    },
                    onTap: (_doc[Dbkeys.from] == widget.currentUserNo &&
                                _doc[Dbkeys.hasSenderDeleted] == true) ==
                            true
                        ? () {}
                        : _doc[Dbkeys.messageType] == MessageType.image.index
                            ? () {
                                Navigator.push(
                                    this.context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoViewWrapper(
                                        message: _doc[Dbkeys.content],
                                        tag: ts.toString(),
                                        imageProvider:
                                            CachedNetworkImageProvider(
                                                _doc[Dbkeys.content]),
                                      ),
                                    ));
                              }
                            : null,
                    onDoubleTap: _doc.containsKey(Dbkeys.broadcastID)
                        ? () {}
                        : () {
                            // save(_doc);
                          },
                    from: _doc[Dbkeys.from],
                    timestamp: ts,
                    onDismiss: () {
                      // if (_doc.containsKey(Dbkeys.hasRecipientDeleted) &&
                      //     _doc.containsKey(Dbkeys.hasSenderDeleted)) {
                      //   contextMenuNew(context, _doc, false);
                      // } else {
                      //   contextMenuOld(context, _doc);
                      // }
                    },
                  ));
            }
          });
          if (mounted) {
            setStateIfMounted(() {
              messages = List.from(messages);
            });
          }
        }
      });
    });
  }

  void loadSavedMessages() {
    if (_savedMessageDocs.isEmpty) {
      Save.getSavedMessages(peerNo).then((_msgDocs) {
        // ignore: unnecessary_null_comparison
        if (_msgDocs != null) {
          setStateIfMounted(() {
            _savedMessageDocs = _msgDocs;
          });
        }
      });
    }
  }

  List<Widget> sortAndGroupSavedMessages(
      BuildContext context, List<Map<String, dynamic>> _msgs) {
    _msgs.sort((a, b) => a[Dbkeys.timestamp] - b[Dbkeys.timestamp]);
    List<Message> _savedMessages = new List.from(<Message>[]);
    List<Widget> _groupedSavedMessages = new List.from(<Widget>[]);
    _msgs.forEach((msg) {
      _savedMessages.add(Message(
          buildMessage(context, msg, saved: true, savedMsgs: _savedMessages),
          saved: true,
          from: msg[Dbkeys.from],
          onDoubleTap: () {}, onLongPress: () {
        contextMenuForSavedMessage(context, msg);
      },
          onDismiss: null,
          onTap: (msg[Dbkeys.from] == widget.currentUserNo &&
                      msg[Dbkeys.hasSenderDeleted] == true) ==
                  true
              ? () {}
              : msg[Dbkeys.messageType] == MessageType.image.index
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoViewWrapper(
                              tag: "saved_" + msg[Dbkeys.timestamp].toString(),
                              imageProvider: msg[Dbkeys.content]
                                      .toString()
                                      .startsWith(
                                          'http') // See if it is an online or saved
                                  ? CachedNetworkImageProvider(
                                      msg[Dbkeys.content])
                                  : Save.getImageFromBase64(msg[Dbkeys.content])
                                      .image,
                              message: msg[Dbkeys.content],
                            ),
                          ));
                    }
                  : null,
          timestamp: msg[Dbkeys.timestamp]));
    });

    _groupedSavedMessages
        .add(Center(child: Chip(label: Text('Saved Conversations'))));

    groupBy<Message, String>(_savedMessages, (msg) {
      return getWhen(DateTime.fromMillisecondsSinceEpoch(msg.timestamp));
    }).forEach((when, _actualMessages) {
      _groupedSavedMessages.add(Center(
          child: Chip(
        label: Text(
          when,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      )));
      _actualMessages.forEach((msg) {
        _groupedSavedMessages.add(msg.child);
      });
    });
    return _groupedSavedMessages;
  }

//-- GROUP BY DATE ---
  List<Widget> getGroupedMessages() {
    List<Widget> _groupedMessages = new List.from(<Widget>[
      // Card(
      //   elevation: 0.5,
      //   color: Color(0xffFFF2BE),
      //   margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      //   child: Container(
      //       padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      //       child: RichText(
      //         textAlign: TextAlign.center,
      //         text: TextSpan(
      //           children: [
      //             WidgetSpan(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(bottom: 2.5, right: 4),
      //                 child: Icon(
      //                   Icons.lock,
      //                   color: Color(0xff78754A),
      //                   size: 14,
      //                 ),
      //               ),
      //             ),
      //             TextSpan(
      //                 text:
      //                     "Messages & calls are end-to-end encrypted. No one outside of this chat can read them",
      //                 style: TextStyle(
      //                     color: Color(0xff78754A),
      //                     height: 1.3,
      //                     fontSize: 13,
      //                     fontWeight: FontWeight.w400)),
      //           ],
      //         ),
      //       )),
      // ),
    ]);
    int count = 0;
    groupBy<Message, String>(messages, (msg) {
      return getWhen(DateTime.fromMillisecondsSinceEpoch(msg.timestamp));
    }).forEach((when, _actualMessages) {
      _groupedMessages.add(Center(
          child: Chip(
        backgroundColor: Colors.blue[50],
        label: Text(
          when,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      )));
      _actualMessages.forEach((msg) {
        count++;
        if (unread != 0 && (messages.length - count) == unread - 1) {
          _groupedMessages.add(Center(
              child: Chip(
            backgroundColor: Colors.blueGrey[50],
            label: Text('$unread' + ' Tin nhắn chưa đọc'),
          )));
          unread = 0; // reset
        }
        _groupedMessages.add(msg.child);
      });
    });
    return _groupedMessages.reversed.toList();
  }

  Widget buildSavedMessages(
    BuildContext context,
  ) {
    return Flexible(
        child: ListView(
      padding: EdgeInsets.all(10.0),
      children: _savedMessageDocs.isEmpty
          ? [
              Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Text('Không có tin nhắn đã lưu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18)))
            ]
          : sortAndGroupSavedMessages(context, _savedMessageDocs),
      controller: saved,
    ));
  }

  Widget buildMessages(
    BuildContext context,
  ) {
    if (chatStatus == ChatStatus.blocked.index) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: Text(
          'Unblock' + ' ${peer[Dbkeys.nickname]}?',
          style: TextStyle(color: fiberchatBlack),
        ),
        actions: <Widget>[
          myElevatedButton(
              color: fiberchatWhite,
              child: Text(
                'Cancel',
                style: TextStyle(color: fiberchatBlack),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          myElevatedButton(
              color: fiberchatLightGreen,
              child: Text(
                'Unblock',
                style: TextStyle(color: fiberchatWhite),
              ),
              onPressed: () {
                ChatController.accept(currentUserNo, peerNo);
                setStateIfMounted(() {
                  chatStatus = ChatStatus.accepted.index;
                });
              })
        ],
      );
    }
    return Flexible(
        child: chatId == '' || messages.isEmpty
            ? ListView(
                children: <Widget>[
                  Card(),
                  Padding(
                      padding: EdgeInsets.only(top: 200.0),
                      child: isMessageLoading == true
                          ? Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      fiberchatLightGreen)),
                            )
                          : Text('Chat ngay',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: DESIGN_TYPE == Themetype.whatsapp
                                      ? Config().colorMain
                                      : fiberchatGrey,
                                  fontSize: 18))),
                ],
                controller: realtime,
              )
            : ListView(
                padding: EdgeInsets.all(10.0),
                children: getGroupedMessages(),
                controller: realtime,
                reverse: true,
              ));
  }

  getWhen(date) {
    DateTime now = DateTime.now();
    String when;
    if (date.day == now.day)
      when = 'Hôm nay';
    else if (date.day == now.subtract(Duration(days: 1)).day)
      when = 'Hôm qua';
    else
      when = DateFormat.MMMd().format(date);
    return when;
  }

  getPeerStatus(val) {
    final observer = Provider.of<Observer>(this.context, listen: false);
    if (val is bool && val == true) {
      return 'Online';
    } else if (val is int) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(val);
      String at = observer.is24hrsTimeformat == false
              ? DateFormat.jm().format(date)
              : DateFormat('HH:mm').format(date),
          when = getWhen(date);
      return 'Last Seen' + ' $when, $at';
    } else if (val is String) {
      if (val == currentUserNo) return 'Typing...';
      return 'Online';
    }
    return 'Loading';
  }

  bool isBlocked() {
    return chatStatus == ChatStatus.blocked.index;
  }

  // call(BuildContext context, bool isvideocall) async {
  //   var mynickname = widget.prefs.getString(Dbkeys.nickname) ?? '';
  //
  //   var myphotoUrl = widget.prefs.getString(Dbkeys.photoUrl) ?? '';
  //
  //   CallUtils.dial(
  //       currentuseruid: widget.currentUserNo,
  //       fromDp: myphotoUrl,
  //       toDp: peer["photoUrl"],
  //       fromUID: widget.currentUserNo,
  //       fromFullname: mynickname,
  //       toUID: widget.peerNo,
  //       toFullname: peer["nickname"],
  //       context: context,
  //       isvideocall: isvideocall);
  // }

  bool isemojiShowing = false;

  refreshInput() {
    setStateIfMounted(() {
      if (isemojiShowing == false) {
        // hidekeyboard(this.context);
        keyboardFocusNode.unfocus();
        isemojiShowing = true;
      } else {
        isemojiShowing = false;
        keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final observer = Provider.of<Observer>(context, listen: true);
    var _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return HelperFunctions.getNTPWrappedWidget(
        child: WillPopScope(
            onWillPop: isgeneratingThumbnail == true
                ? () async {
                    return Future.value(false);
                  }
                : isemojiShowing == true
                    ? () {
                        setState(() {
                          isemojiShowing = false;
                          keyboardFocusNode.unfocus();
                        });
                        return Future.value(false);
                      }
                    : () async {
                        setLastSeen();
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) async {
                          var currentpeer = Provider.of<CurrentChatPeer>(
                              this.context,
                              listen: false);
                          currentpeer.setpeer(newpeerid: '');
                          if (lastSeen == peerNo)
                            await FirebaseFirestore.instance
                                .collection(DbPaths.collectionusers)
                                .doc(currentUserNo)
                                .update(
                              {Dbkeys.lastSeen: true},
                            );
                        });

                        return Future.value(true);
                      },
            child: ScopedModel<DataModel>(
                model: _cachedModel,
                child: ScopedModelDescendant<DataModel>(
                    builder: (context, child, _model) {
                  _cachedModel = _model;
                  updateLocalUserData(_model);
                  return peer != null
                      ? Stack(
                          children: [
                            Scaffold(
                                key: _scaffold,
                                appBar: AppBar(
                                  titleSpacing: -19,
                                  leading: Container(
                                    margin: EdgeInsets.only(right: 0),
                                    width: 10,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        size: 20,
                                        color: DESIGN_TYPE == Themetype.whatsapp
                                            ? fiberchatWhite
                                            : fiberchatBlack,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  backgroundColor: Config().colorMain,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 7, 0, 7),
                                        child: HelperFunctions.avatar(peer,
                                            radius: 20),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Expanded(
                                          child: Text(
                                        HelperFunctions.getNickname(peer) ??
                                            "Đang cập nhật",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: DESIGN_TYPE ==
                                                    Themetype.whatsapp
                                                ? fiberchatWhite
                                                : fiberchatBlack,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ],
                                  ),
                                  // actions: [
                                  //   observer.isCallFeatureTotallyHide == true
                                  //       ? SizedBox()
                                  //       : SizedBox(
                                  //     width: 35,
                                  //     child: IconButton(
                                  //         icon: Icon(
                                  //           Icons.video_call,
                                  //           color: DESIGN_TYPE ==
                                  //               Themetype.whatsapp
                                  //               ? fiberchatWhite
                                  //               : fiberchatgreen,
                                  //         ),
                                  //         onPressed: observer
                                  //             .iscallsallowed ==
                                  //             false
                                  //             ? () {
                                  //           HelperFunctions.toast(
                                  //               'Call not Allowed');
                                  //         }
                                  //             : () async {
                                  //           final observer =
                                  //           Provider.of<
                                  //               Observer>(
                                  //               this.context,
                                  //               listen:
                                  //               false);
                                  //           if (IsInterstitialAdShow ==
                                  //               true &&
                                  //               observer.isadmobshow ==
                                  //                   true) {}
                                  //
                                  //           await Permissions
                                  //               .cameraAndMicrophonePermissionsGranted()
                                  //               .then(
                                  //                   (isgranted) {
                                  //                 if (isgranted ==
                                  //                     true) {
                                  //                   call(context,
                                  //                       true);
                                  //                 } else {
                                  //                   HelperFunctions.toast(
                                  //                       'Cần cấp quyền');
                                  //                   // Navigator.push(
                                  //                   //     context,
                                  //                   //     new MaterialPageRoute(
                                  //                   //         builder:
                                  //                   //             (context) =>
                                  //                   //                 OpenSettings()));
                                  //                 }
                                  //               }).catchError(
                                  //                   (onError) {
                                  //                 HelperFunctions.toast(
                                  //                     'Cần cấp quyền');
                                  //                 // Navigator.push(
                                  //                 //     context,
                                  //                 //     new MaterialPageRoute(
                                  //                 //         builder:
                                  //                 //             (context) =>
                                  //                 //                 OpenSettings()));
                                  //               });
                                  //         }),
                                  //   ),
                                  //   observer.isCallFeatureTotallyHide == true
                                  //       ? SizedBox()
                                  //       : SizedBox(
                                  //     width: 55,
                                  //     child: IconButton(
                                  //         icon: Icon(
                                  //           Icons.phone,
                                  //           color: DESIGN_TYPE ==
                                  //               Themetype.whatsapp
                                  //               ? fiberchatWhite
                                  //               : fiberchatgreen,
                                  //         ),
                                  //         onPressed: observer
                                  //             .iscallsallowed ==
                                  //             false
                                  //             ? () {
                                  //           HelperFunctions.toast(
                                  //               'Cần cấp quyền');
                                  //         }
                                  //             : () async {
                                  //           final observer =
                                  //           Provider.of<
                                  //               Observer>(
                                  //               this.context,
                                  //               listen:
                                  //               false);
                                  //           if (IsInterstitialAdShow ==
                                  //               true &&
                                  //               observer.isadmobshow ==
                                  //                   true) {}
                                  //
                                  //           await Permissions
                                  //               .cameraAndMicrophonePermissionsGranted()
                                  //               .then(
                                  //                   (isgranted) {
                                  //                 if (isgranted ==
                                  //                     true) {
                                  //                   call(context,
                                  //                       false);
                                  //                 } else {
                                  //                   HelperFunctions.toast(
                                  //                       'Cần cấp quyền');
                                  //                   // Navigator.push(
                                  //                   //     context,
                                  //                   //     new MaterialPageRoute(
                                  //                   //         builder:
                                  //                   //             (context) =>
                                  //                   //                 OpenSettings()));
                                  //                 }
                                  //               }).catchError(
                                  //                   (onError) {
                                  //                 HelperFunctions.toast(
                                  //                     'Cần cấp quyền');
                                  //                 // Navigator.push(
                                  //                 //     context,
                                  //                 //     new MaterialPageRoute(
                                  //                 //         builder:
                                  //                 //             (context) =>
                                  //                 //                 OpenSettings()));
                                  //               });
                                  //         }),
                                  //   ),
                                  // SizedBox(
                                  //   width:
                                  //       observer.isCallFeatureTotallyHide ==
                                  //               true
                                  //           ? 45
                                  //           : 25,
                                  //   child: PopupMenuButton(
                                  //       padding: EdgeInsets.all(0),
                                  //       icon: Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             right: 0),
                                  //         child: Icon(
                                  //           Icons.more_vert_outlined,
                                  //           color: DESIGN_TYPE ==
                                  //                   Themetype.whatsapp
                                  //               ? fiberchatWhite
                                  //               : fiberchatBlack,
                                  //         ),
                                  //       ),
                                  //       color: fiberchatWhite,
                                  //       onSelected: (dynamic val) {
                                  //         switch (val) {
                                  //           case 'hide':
                                  //             ChatController.hideChat(
                                  //                 currentUserNo, peerNo);
                                  //             break;
                                  //           case 'unhide':
                                  //             ChatController.unhideChat(
                                  //                 currentUserNo, peerNo);
                                  //             break;
                                  //           case 'lock':
                                  //             ChatController.lockChat(
                                  //                 currentUserNo, peerNo);
                                  //             break;
                                  //           case 'unlock':
                                  //             ChatController.unlockChat(
                                  //                 currentUserNo, peerNo);
                                  //             break;
                                  //           case 'block':
                                  //             ChatController.block(
                                  //                 currentUserNo, peerNo);
                                  //             break;
                                  //           case 'unblock':
                                  //             ChatController.accept(
                                  //                 currentUserNo, peerNo);
                                  //             HelperFunctions.toast(
                                  //                 'Unblock');
                                  //             break;
                                  //           // case 'tutorial':
                                  //           //   Fiberchat.toast(getTranslated(
                                  //           //       this.context, 'vsmsg'));
                                  //           //
                                  //           //   break;
                                  //           case 'remove_wallpaper':
                                  //             _cachedModel
                                  //                 .removeWallpaper(peerNo);
                                  //             // Fiberchat.toast('Wallpaper removed.');
                                  //             break;
                                  //           case 'set_wallpaper':
                                  //             Navigator.push(
                                  //                 context,
                                  //                 MaterialPageRoute(
                                  //                     builder: (context) =>
                                  //                         HybridImagePicker(
                                  //                           title:
                                  //                               'Pick Image',
                                  //                           callback:
                                  //                               getWallpaper,
                                  //                         )));
                                  //             break;
                                  //         }
                                  //       },
                                  //       itemBuilder: ((context) =>
                                  //           <PopupMenuItem<String>>[
                                  //             PopupMenuItem<String>(
                                  //               value: hidden
                                  //                   ? 'unhide'
                                  //                   : 'hide',
                                  //               child: Text(
                                  //                 hidden
                                  //                     ? 'UnHide Chat'
                                  //                     : 'Hide chat',
                                  //               ),
                                  //             ),
                                  //             PopupMenuItem<String>(
                                  //               value: locked
                                  //                   ? 'unlock'
                                  //                   : 'lock',
                                  //               child: Text(locked
                                  //                   ? 'unlockchat'
                                  //                   : 'lockchat'),
                                  //             ),
                                  //             PopupMenuItem<String>(
                                  //               value: isBlocked()
                                  //                   ? 'unblock'
                                  //                   : 'block',
                                  //               child: Text(isBlocked()
                                  //                   ? 'unlockchat'
                                  //                   : 'lockchat'),
                                  //             ),
                                  //             peer[Dbkeys.wallpaper] != null
                                  //                 ? PopupMenuItem<String>(
                                  //                     value:
                                  //                         'remove_wallpaper',
                                  //                     child: Text(
                                  //                       'Remove Wall',
                                  //                     ),
                                  //                   )
                                  //                 : PopupMenuItem<String>(
                                  //                     value:
                                  //                         'set_wallpaper',
                                  //                     child: Text(
                                  //                       'Set Wall',
                                  //                     )),
                                  //             // PopupMenuItem<String>(
                                  //             //   child: Text(getTranslated(
                                  //             //       this.context,
                                  //             //       'showtutor')),
                                  //             //   value: 'tutorial',
                                  //             // )
                                  //             // ignore: unnecessary_null_comparison
                                  //           ].toList())),
                                  // ),
                                  // ],
                                ),
                                body: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: DESIGN_TYPE == Themetype.whatsapp
                                            ? fiberchatChatbackground
                                            : fiberchatWhite,
                                        image: DecorationImage(
                                            image: peer[Dbkeys.wallpaper] ==
                                                    null
                                                ? AssetImage(
                                                    "assets/images/background.png")
                                                : Image.file(File(
                                                        peer[Dbkeys.wallpaper]))
                                                    .image,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    PageView(
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            // List of messages

                                            buildMessages(context),
                                            // Input content
                                            isBlocked()
                                                ? Container()
                                                : Platform.isAndroid
                                                    ? buildInputAndroid(
                                                        context,
                                                        isemojiShowing,
                                                        refreshInput,
                                                        _keyboardVisible)
                                                    : buildInputIos(context)
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            // List of saved messages
                                            buildSavedMessages(context)
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Loading
                                    buildLoading()
                                  ],
                                )),
                            buildLoadingThumbnail(),
                          ],
                        )
                      : Container();
                }))));
  }
}
