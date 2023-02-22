import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/provider/currentchat_peer.dart';
import 'package:gcaeco_app/provider/download_info_provider.dart';
import 'package:gcaeco_app/provider/observer.dart';
import 'package:gcaeco_app/provider/seen_provider.dart';
import 'package:gcaeco_app/provider/status_provider.dart';
import 'package:gcaeco_app/provider/user_provider.dart';
import 'package:gcaeco_app/screen/404.dart';
import 'package:gcaeco_app/screen/screen_home.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart' as pref;
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bloc_home_new.dart';
import 'configs/db_keys.dart';
import 'helper/const.dart';
import 'helper/home_api.dart';
import 'package:provider/provider.dart';
import 'provider/firebase_broadcast_service.dart';
import 'provider/firebase_group_service.dart';
import 'provider/firestore_data_provider_call_history.dart';
import 'firebase_options.dart';
Fetch_Data fetch_data_token = new Fetch_Data("/app/home/start", {});

bool showCheckVersion = true;
String appName = "QR Mart";
List logoVip = [];

class SharedPreference {
  static pref.SharedPreferences prefs;

  init() async {
    prefs = await pref.SharedPreferences.getInstance();
  }

  String getString(String key) {
    return prefs.getString(key);
  }

  setString(String key, String value) {
    prefs.setString(key, value);
  }

  removeString(String key) {
    prefs.remove(key);
  }

  setBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  removeBool(String key) {
    prefs.remove(key);
  }
}

final prefs = SharedPreference();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefsa = await SharedPreferences.getInstance();
  var checkToken = await Const.web_api.getValueToken();
  print("============");
  print(checkToken);
  var checkLogin = await Const.web_api.checkLogin();
  if (checkToken != "" && checkToken != null) {
    if (checkLogin != '1') {
      prefsa.setString("token_app", checkToken);
    }
    await BlocHomeNew.getLogoVip();
    runApp(
      OverlaySupport(child: App()),
    );
  } else {
    runApp(
      OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Page404(
            err:
            "Lấy thông tin Token không thành công. Vui lòng xóa dữ liệu ứng dụng và khởi động lại.",
          ),
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseGroupServices firebaseGroupServices = FirebaseGroupServices();
  final FirebaseBroadcastServices firebaseBroadcastServices =
      FirebaseBroadcastServices();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentChatPeer(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartItem()..getList(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirestoreDataProviderCALLHISTORY(),
        ),
        ChangeNotifierProvider(
          create: (_) => Observer(),
        ),
        Provider(create: (_) => SeenProvider()),
        ChangeNotifierProvider(create: (_) => DownloadInfoprovider()),
        ChangeNotifierProvider(create: (_) => StatusProvider()),
        //ChangeNotifierProvider(create: (_) => AvailableContactsProvider()),
      ],
      child: FutureBuilder(
        future: pref.SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamProvider<List<BroadcastModel>>(
              initialData: [],
              create: (BuildContext context) =>
                  firebaseBroadcastServices.getBroadcastsList(
                      snapshot.data.getString(Dbkeys.phone) ?? ''),
              child: StreamProvider<List<GroupModel>>(
                initialData: [],
                create: (BuildContext context) => firebaseGroupServices
                    .getGroupsList(snapshot.data.getString(Dbkeys.phone) ?? ''),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Home(
                    prefs: snapshot.data,
                    page: 2,
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
