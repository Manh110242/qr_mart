import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as local;
import 'package:gcaeco_app/bloc/bloc_getsite.dart';
import 'package:gcaeco_app/bloc/bloc_notification.dart';
import 'package:gcaeco_app/bloc/check_version.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/configs/db_path.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/item_share/pickup_layout.dart';
import 'package:gcaeco_app/main.dart';
import 'package:gcaeco_app/model/data_model.dart';
import 'package:gcaeco_app/model/media/model_site.dart';
import 'package:gcaeco_app/provider/available_contacts_provider.dart';
import 'package:gcaeco_app/provider/currentchat_peer.dart';
import 'package:gcaeco_app/provider/firestore_data_provider_call_history.dart';
import 'package:gcaeco_app/provider/status_provider.dart';
import 'package:gcaeco_app/provider/user_provider.dart';
import 'package:gcaeco_app/screen/Home_Fragments/wallet.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/layout_notification/notification_item.dart';
import 'package:gcaeco_app/screen/layouts/webview/WebViewContainer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Home_Fragments/home.dart';
import 'Home_Fragments/notification.dart';
import 'Home_Fragments/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Home_Fragments/screen_fragment.dart';
import 'Tab_oder/Order_screen.dart';
import 'before_login.dart';
import 'chat_screen.dart';
import 'wallet/my_voucher.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandlerAndroid(
    Map<String, dynamic> message) async {
  if (message['data']['title'] == 'Call Ended' ||
      message['data']['title'] == 'Missed Call') {
    flutterLocalNotificationsPlugin..cancelAll();
    final data = message['data'];
    final titleMultilang = data['titleMultilang'];
    final bodyMultilang = data['bodyMultilang'];

    await _showNotificationWithDefaultSound(
        'Missed Call', 'You have Missed a Call', titleMultilang, bodyMultilang);
  } else {
    if (message['data']['title'] == 'You have new message(s)' ||
        message['data']['title'] == 'New message in Group') {
      //-- need not to do anythig for these message type as it will be automatically popped up.

    } else if (message['data']['title'] == 'Incoming Audio Call...' ||
        message['data']['title'] == 'Incoming Video Call...') {
      // print("message['data']['title']");
      // print(message['data']['title']);
      final data = message['data'];
      final title = data['title'];
      final body = data['body'];
      final titleMultilang = data['titleMultilang'];
      final bodyMultilang = data['bodyMultilang'];

      await _showNotificationWithDefaultSound(
          title, body, titleMultilang, bodyMultilang);
    }
  }

  return Future<void>.value();
}

Future _showNotificationWithDefaultSound(String title, String message,
    String titleMultilang, String bodyMultilang) async {
  // if (Platform.isAndroid) {
  //   flutterLocalNotificationsPlugin.cancelAll();
  // }

  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics =
      title == 'Missed Call' || title == 'Call Ended'
          ? local.AndroidNotificationDetails(
              'channel_id', 'channel_name', 'channel_description',
              importance: local.Importance.max,
              priority: local.Priority.high,
              sound: RawResourceAndroidNotificationSound('whistle2'),
              playSound: true,
              ongoing: true,
              visibility: NotificationVisibility.public,
              timeoutAfter: 28000)
          : local.AndroidNotificationDetails(
              'channel_id', 'channel_name', 'channel_description',
              sound: RawResourceAndroidNotificationSound('ringtone'),
              playSound: true,
              ongoing: true,
              importance: local.Importance.max,
              priority: local.Priority.high,
              visibility: NotificationVisibility.public,
              timeoutAfter: 28000);
  var iOSPlatformChannelSpecifics = local.IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    sound:
        title == 'Missed Call' || title == 'Call Ended' ? '' : 'ringtone.caf',
    presentSound: true,
  );
  var platformChannelSpecifics = local.NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(
    0,
    '$titleMultilang',
    '$bodyMultilang',
    platformChannelSpecifics,
    payload: 'payload',
  )
      .catchError((err) {
    print('ERROR DISPLAYING NOTIFICATION: $err');
  });
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  int page = 2;
  SharedPreferences prefs;

  Home({Key key, this.page, this.prefs}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<Home> with WidgetsBindingObserver {
  Home home;
  bool isHome;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  BlocNotification bloc = new BlocNotification();
SiteBloc siteBloc=new SiteBloc();
  DataModel _cachedModel;

  DataModel getModel() {
    _cachedModel ??= DataModel(widget.prefs.getString(Dbkeys.phone) ?? '');
    return _cachedModel;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      setIsActive();
    else
      setLastSeen();
  }

  void setIsActive() async {
    if (widget.prefs.getString("phone") != null)
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(widget.prefs.getString("phone"))
          .update(
        {Dbkeys.lastSeen: true},
      );
  }

  void setLastSeen() async {
    if (widget.prefs.getString("phone") != null)
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(widget.prefs.getString("phone"))
          .update(
        {Dbkeys.lastSeen: DateTime.now().millisecondsSinceEpoch},
      );
  }

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return ScreenFragment();
      case 1:
        bloc.deletecount('countcn');
        bloc.deletecn();
        return FutureBuilder<String>(
          future: Const.web_api.checkLogin(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == '1') {
                return Wallet(
                  prefs: widget.prefs,
                );
              } else {
                return BeforeLogin();
              }
            } else {
              return Text('');
            }
          },
        );
      case 2:
        return HomePage(
          prefs: widget.prefs,
        );
      case 3:
        bloc.deleteHome();
        return FutureBuilder<String>(
          future: Const.web_api.checkLogin(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == '1') {
                return Notification_Fragment(
                  prefs: widget.prefs,
                );
              } else {
                return BeforeLogin();
              }
            } else {
              return Text('');
            }
          },
        );
      case 4:
        return FutureBuilder<String>(
          future: Const.web_api.checkLogin(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == '1') {
                return Profile(
                  prefs: widget.prefs,
                );
              } else {
                return BeforeLogin();
              }
            } else {
              return Text('');
            }
          },
        );
      default:
        return HomePage(
          prefs: widget.prefs,
        );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdeviceinfo();
    if (widget.prefs.getString(Dbkeys.phone) != null) getModel();
    prefs.init();
    _getToken();
    CheckVersion.check(context,
        ios: "vn.com.ocop.mart", android: "com.ocop.mart");
    getSignedInUserOrRedirect();
    _configureFirebaseListeners();
  }

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Token: " + token.toString());
    });
  }

  Future<void> urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Lỗi $url';
    }
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('---------------------- onMessage $message');
        await bloc.setNotifiHome();
        if (message['data']['title'] != 'Call Ended' &&
            message['data']['title'] != 'Missed Call' &&
            message['data']['title'] != 'You have new message(s)' &&
            message['data']['title'] != 'Incoming Video Call...' &&
            message['data']['title'] != 'Incoming Audio Call...' &&
            message['data']['title'] != 'Incoming Call ended' &&
            message['data']['title'] != 'New message in Group' &&
            message['data']['type'] != 'message') {
          // showNotification(message);
          widgetNotifi(msg: message);
          saverNotifi(message);
          setState(() {});
        } else {
          flutterLocalNotificationsPlugin..cancelAll();
          if (message['data']['title'] == 'New message in Group') {
            var currentpeer =
                Provider.of<CurrentChatPeer>(this.context, listen: false);
            if (currentpeer.groupChatId != message['groupid']) {
              flutterLocalNotificationsPlugin..cancelAll();
              showOverlayNotification((context) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: ListTile(
                      title: Text(
                        message['data']['titleMultilang'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        message['data']['bodyMultilang'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            OverlaySupportEntry.of(context).dismiss();
                          }),
                    ),
                  ),
                );
              }, duration: Duration(milliseconds: 2000));
            }
          } else if (message['data']['title'] == 'Call Ended') {
            flutterLocalNotificationsPlugin..cancelAll();
          } else {
            flutterLocalNotificationsPlugin..cancelAll();
            if (message['data']['title'] == 'Incoming Audio Call...' ||
                message['data']['title'] == 'Incoming Video Call...') {
              final data = message['data'];
              final title = data['title'];
              final body = data['body'];
              final titleMultilang = data['titleMultilang'];
              final bodyMultilang = data['bodyMultilang'];
              await _showNotificationWithDefaultSound(
                  title, body, titleMultilang, bodyMultilang);
            } else if (message['data']['title'] == 'You have new message(s)') {
              flutterLocalNotificationsPlugin..cancelAll();
              var currentpeer =
                  Provider.of<CurrentChatPeer>(this.context, listen: false);
              if (currentpeer.peerid != message['data']['peerid']) {
                // FlutterRingtonePlayer.playNotification();
                final data = message['data'];
                final title = data['title'];
                final body = data['body'];
                final titleMultilang = data['titleMultilang'];
                final bodyMultilang = data['bodyMultilang'];
                // await _showNotificationWithDefaultSound(
                //     title, body, titleMultilang, bodyMultilang);
              }
            } else {}
          }
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('---------------------- onLaunch $message');

        if (message['data']['title'] != 'Call Ended' &&
            message['data']['title'] != 'Missed Call' &&
            message['data']['title'] != 'You have new message(s)' &&
            message['data']['title'] != 'Incoming Video Call...' &&
            message['data']['title'] != 'Incoming Audio Call...' &&
            message['data']['title'] != 'Incoming Call ended' &&
            message['data']['title'] != 'New message in Group') {
          checkScreen(message);
        } else if (message['data']['title'] == 'You have new message(s)') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getString(Dbkeys.phone) != null)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  currentUserNo: prefs.getString(Dbkeys.phone),
                  prefs: prefs,
                ),
              ),
            );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('---------------------- Resum $message');

        if (message['data']['title'] != 'Call Ended' &&
            message['data']['title'] != 'Missed Call' &&
            message['data']['title'] != 'You have new message(s)' &&
            message['data']['title'] != 'Incoming Video Call...' &&
            message['data']['title'] != 'Incoming Audio Call...' &&
            message['data']['title'] != 'Incoming Call ended' &&
            message['data']['title'] != 'New message in Group') {
          checkScreen(message);
        } else if (message['data']['title'] == 'You have new message(s)') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getString(Dbkeys.phone) != null)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  currentUserNo: prefs.getString(Dbkeys.phone),
                  prefs: prefs,
                ),
              ),
            );
        }
      },
      onBackgroundMessage: myBackgroundMessageHandlerAndroid,
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  showNotification(Map<String, dynamic> msg) async {
    var data;
    if (Platform.isIOS) {
      data = msg["aps"]['alert'];
    } else if (Platform.isAndroid) {
      data = msg['notification'];
    }

    var android = new AndroidNotificationDetails(
      "channel_id",
      'channel_name',
      'channel_description',
      icon: "ic_launcher",
      showWhen: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOS = new IOSNotificationDetails(
        presentBadge: true, presentAlert: true, presentSound: true);
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      0,
      data['title'].toString(),
      data['body'].toString(),
      platform,
    );
  }

  checkScreen(message) async {
    var link;
    var data;
    var type;
    if (Platform.isIOS) {
      link = message['link'];
      type = message['type'];
      data = message;
    } else if (Platform.isAndroid) {
      link = message['data']['link'];
      data = message['data'];
      type = message['data']['type'];
    }

    await bloc.delete1Msg();
    if (link.toString().contains('/don-hang') ||
        link.toString().contains('url=%2Fmanagement%2Forder%2Findex')) {
      await bloc.deletecount1("countdh");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Order_Screen(
                index: 1,
              )));
    } else if (link.toString().contains('/vi-v') ||
        link.toString().contains('url=%2Fmanagement%2Fgcacoin%2Findex')) {
      await bloc.deletecount1("countcn");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyVoucher()));
    } else if (link.toString().contains('/xu-khoa') ||
        link.toString().contains('url=%2Fmanagement%2Fgcacoin%2Fconfinement')) {
      await bloc.deletecount1("countcn");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyVoucher()));
    } else if (link.toString().startsWith('http')) {
      await bloc.deletecount1("countkm");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              WebViewContainer(link.toString(), 'Thông báo')));
    } else if (type == 'message') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            currentUserNo: prefs.getString(Dbkeys.phone),
            prefs: prefs,
          ),
        ),
      );
    } else {
      await bloc.deletecount1("countkm");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationItem(
                    title: data['title'],
                    noidung: data['body'],
                  )));
    }
    await bloc.getNotifiHome();
  }

  saverNotifi(message) async {
    var type;
    if (Platform.isIOS) {
      type = message['type'];
    } else if (Platform.isAndroid) {
      type = message['data']['type'];
    }
    if (type.toString() == "2") {
      await bloc.getAllmsg();
      await bloc.getCountdh();
    } else if (type.toString() == "3") {
      await bloc.getAllmsg();
      await bloc.getCountcn();
      await bloc.getCn();
    } else if (type.toString() == "1") {
      await bloc.getAllmsg();
      await bloc.getCountkm();
    } else if (type.toString() == "message") {
      await bloc.getCountMessage();
    }
  }

  Widget widgetNotifi({msg}) {
    var data;
    if (Platform.isIOS) {
      data = msg;
    } else if (Platform.isAndroid) {
      data = msg['data'];
    }
    showOverlayNotification(
      (context) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 25),
          elevation: 16,
          color: Colors.white,
          child: ListTile(
            onTap: () async {
              OverlaySupportEntry.of(context).dismiss();
              checkScreen(msg);
              setState(() {});
            },
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  "assets/images/icon app 2.png",
                  width: 40,
                  height: 40,
                )),
            title: Text(
              data['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              data['body'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                OverlaySupportEntry.of(context).dismiss();
              },
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 1500),
    );
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast("Nhấn trở lại hai lần để thoát", context, Colors.grey,
          Icons.exit_to_app);
      return Future.value(false);
    }
    return Future.value(true);
  }

  String deviceid;

  var mapDeviceInfo = {};

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

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

  getSignedInUserOrRedirect() async {
    if (widget.prefs.getString(Dbkeys.phone) != null)
      await FirebaseFirestore.instance
          .collection(DbPaths.collectionusers)
          .doc(widget.prefs.getString(Dbkeys.phone))
          .get()
          .then((userDoc) async {
        getuid(context);
        // setIsActive();
        String fcmToken = await FirebaseMessaging().getToken();

        await FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(widget.prefs.getString(Dbkeys.phone))
            .set({
          Dbkeys.notificationTokens: [fcmToken],
          Dbkeys.deviceDetails: mapDeviceInfo,
          Dbkeys.currentDeviceID: deviceid,
        }, SetOptions(merge: true));

        incrementSessionCount(userDoc[Dbkeys.phone]);
      });
    else
      return;
  }

  incrementSessionCount(String myphone) async {
    final StatusProvider statusProvider =
        Provider.of<StatusProvider>(context, listen: false);
    final FirestoreDataProviderCALLHISTORY firestoreDataProviderCALLHISTORY =
        Provider.of<FirestoreDataProviderCALLHISTORY>(context, listen: false);
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiondashboard)
        .doc(DbPaths.docuserscount)
        .set(
            Platform.isAndroid
                ? {
                    Dbkeys.totalvisitsANDROID: FieldValue.increment(1),
                  }
                : {
                    Dbkeys.totalvisitsIOS: FieldValue.increment(1),
                  },
            SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection(DbPaths.collectionusers)
        .doc(myphone)
        .set(
            Platform.isAndroid
                ? {
                    Dbkeys.isNotificationStringsMulitilanguageEnabled: true,
                    Dbkeys.notificationStringsMap: {
                      Dbkeys.notificationStringNewTextMessage: "Tin nhắn mới",
                      Dbkeys.notificationStringNewImageMessage: "📷 Ảnh",
                      Dbkeys.notificationStringNewVideoMessage: "🎥 Video",
                      Dbkeys.notificationStringNewAudioMessage: "🎙️ Ghi âm",
                      Dbkeys.notificationStringNewContactMessage:
                          "👤 Contact shared",
                      Dbkeys.notificationStringNewDocumentMessage:
                          "📄 Tài liệu",
                      Dbkeys.notificationStringNewLocationMessage:
                          "📍 Current Location shared",
                      Dbkeys.notificationStringNewIncomingAudioCall:
                          "📞 Cuộc gọi đến",
                      Dbkeys.notificationStringNewIncomingVideoCall:
                          "🎥 Incoming Video Call",
                      Dbkeys.notificationStringCallEnded: "Cuộc gọi kết thúc",
                      Dbkeys.notificationStringMissedCall: "Cuộc gọi nhỡ",
                      Dbkeys.notificationStringAcceptOrRejectCall:
                          "Accept Or Reject the Call",
                      Dbkeys.notificationStringCallRejected:
                          "Cuộc gọi bị từ chối",
                    },
                    Dbkeys.totalvisitsANDROID: FieldValue.increment(1),
                  }
                : {
                    Dbkeys.isNotificationStringsMulitilanguageEnabled: true,
                    Dbkeys.notificationStringsMap: {
                      Dbkeys.notificationStringNewTextMessage: "Tin nhắn mới",
                      Dbkeys.notificationStringNewImageMessage: "📷 Ảnh",
                      Dbkeys.notificationStringNewVideoMessage: "🎥 Video",
                      Dbkeys.notificationStringNewAudioMessage: "🎙️ Ghi âm",
                      Dbkeys.notificationStringNewContactMessage:
                          "👤 Contact shared",
                      Dbkeys.notificationStringNewDocumentMessage:
                          "📄 Tài liệu",
                      Dbkeys.notificationStringNewLocationMessage:
                          "📍 Current Location shared",
                      Dbkeys.notificationStringNewIncomingAudioCall:
                          "📞 Cuộc gọi đến",
                      Dbkeys.notificationStringNewIncomingVideoCall:
                          "🎥 Incoming Video Call",
                      Dbkeys.notificationStringCallEnded: "Cuộc gọi kết thúc",
                      Dbkeys.notificationStringMissedCall: "Cuộc gọi nhỡ",
                      Dbkeys.notificationStringAcceptOrRejectCall:
                          "Accept Or Reject the Call",
                      Dbkeys.notificationStringCallRejected:
                          "Cuộc gọi bị từ chối",
                    },
                    Dbkeys.totalvisitsANDROID: FieldValue.increment(1),
                  },
            SetOptions(merge: true));
    firestoreDataProviderCALLHISTORY.fetchNextData(
        'CALLHISTORY',
        FirebaseFirestore.instance
            .collection(DbPaths.collectionusers)
            .doc(myphone)
            .collection(DbPaths.collectioncallhistory)
            .orderBy('TIME', descending: true)
            .limit(10),
        true);
    //  await statusProvider.searchContactStatus(
    //       myphone, contactsProvider.joinedUserPhoneStringAsInServer);
    statusProvider.triggerDeleteMyExpiredStatus(myphone);
    statusProvider.triggerDeleteOtherUsersExpiredStatus();
  }

  getuid(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.getUserDetails(widget.prefs.getString(Dbkeys.phone));
  }

  @override
  Widget build(BuildContext context) {
    bloc.getNotifiHome();
    bloc.getCn();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: true,
        body: callPage(widget.page),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                textTheme: Theme.of(context).textTheme.copyWith(
                    caption:
                        TextStyle(color: Colors.black26.withOpacity(0.15)))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: widget.page,
              unselectedItemColor: Colors.black38,
              fixedColor: Config().colorMain,
              onTap: (value) {
                widget.page = value;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.bookmark_border,
                      size: 23.0,
                    ),
                    title: Text(
                      "Sự kiện",
                      style: TextStyle(fontSize: 12),
                    )),
                BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 23,
                        ),
                        StreamBuilder(
                            stream: bloc.updatemsqStream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.toString() != "0"
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(
                                              snapshot.data.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text('');
                              } else {
                                return Text('');
                              }
                            }),
                      ],
                    ),
                    title: Text(
                      "Ví của tôi",
                      style: TextStyle(fontSize: 12),
                    )),
                BottomNavigationBarItem(
                    icon:

                    FutureBuilder(
                     future: siteBloc.getSite(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){

ModelSite model= snapshot.data as ModelSite;

                        return Image.network(
                        'https://ocopmart.org/static/media/images/siteinfo/2021_07_30/s150_150/logo-web-1627642464.png',
                          height: 40,
                          width: 40,
                        );
                      },
                      // child:
                      // Image.asset(
                      //   "assets/images/logo_bottom.jpg",
                      //   height: 40,
                      //   width: 40,
                      // ),
                    ),
                    title: Padding(padding: EdgeInsets.all(0))),
                BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 23,
                        ),
                        StreamBuilder(
                            stream: bloc.adllmsgStream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.toString() != "0"
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(
                                              snapshot.data.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text('');
                              } else {
                                return Text('');
                              }
                            }),
                      ],
                    ),
                    title: Text(
                      "Thông báo",
                      style: TextStyle(fontSize: 12),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 23.0,
                    ),
                    title: Text(
                      "Tài khoản",
                      style: TextStyle(fontSize: 12),
                    )),
              ],
            )),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await urlLauncher("https://m.me/ocopmartvn");
        //   },
        //   child: Image.asset("assets/images/message.png"),
        // ),
      ),
    );
  }
}
