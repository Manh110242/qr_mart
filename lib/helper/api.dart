import 'dart:async';
import 'dart:convert';
import "dart:core";
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetAPI {
  String url;
  String token;
  bool isHttps;
  String access_token = '';

  GetAPI(url, token) {
    this.url = url;
    this.token = token;

    if (this.url.startsWith("https")) {
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }
  }

  Future<dynamic> getToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    this.access_token = prefs.getString("token_app");
    return this.access_token;
  }

  Future<dynamic> getTokenUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    this.access_token = prefs.getString("token_user");
    return this.access_token;
  }

  Future<String> checkLogin() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString("islogin_v2") == '1') {
      return '1';
    }
    return '';
  }

  Future<dynamic> getUserId() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var user_id = prefs.getString("id");
    return user_id;
  }

  Future<dynamic> getNameShop() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var name = prefs.getString("name_Shop");
    return name;
  }

  Future<dynamic> getUserEmail() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var email = prefs.getString("email");
    return email;
  }

  Future<dynamic> getUserPhone() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var phone = prefs.getString("phone");
    return phone;
  }

  Future<dynamic> getUserBefore() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var user_before = prefs.getString("user_before");
    return user_before;
  }

  Future<dynamic> postAsync(String endPoint, String token, Map data) async {
    var url = this.url + endPoint;
    Map<String, String> headers = {"token": token};
    var jsonData;
    try {
      var response = await http
          .post(url, headers: headers, body: json.encode(data))
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      jsonData = await json.decode(response.body);

    } catch (e) {
      jsonData = null;
    }
    return jsonData;
  }

  Future<dynamic> getAsync(String endPoint, String token) async {
    var url = this.url + endPoint;
    Map<String, String> headers = {"token": token};
    var jsonData;
    try {
      final response = await http.get(url, headers: headers).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      jsonData = await json.decode(response.body);
    } catch (e) {
      jsonData = null;
    }
    return jsonData;
  }

  Future<dynamic> getValueToken() async {
    String token_response = '';
    var rng = new Random();
    var randText = rng.nextInt(1000000000);
    var token = sha1.convert(utf8.encode(randText.toString() + Const().key));
    var url = this.url + "/app/home/start?string=" + randText.toString();
    Map<String, String> headers = {"token": token.toString()};

    var jsonData;
    try {
      final response = await http.get(url, headers: headers).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      jsonData = await json.decode(response.body);
      print(response);
      token_response = jsonData['data']['token'];
    } catch (e) {
      print("=======");
      print(e);
      jsonData = null;
      token_response = token.toString();
    }
    return token_response;
  }

  Future<dynamic> saveTotalNotification(int count) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int total = 0;
    int notification = prefs.getInt("notification");
    if (notification is int) {
      total = notification + count;
    } else {
      total = count;
    }
    prefs.setInt("notification", total);
    return true;
  }


  Future<dynamic> getTotalNotification() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int notification = prefs.getInt("notification");
    return notification;
  }

  Future<dynamic> deleteTotalNotification() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.remove('notification');
    prefs.remove('notificationWallet');
    prefs.remove('notificationKhuyenMai');
    prefs.remove('notificationDonHang');
    prefs.remove('notificationCapNhat');
    return true;
  }

  Future<dynamic> checkShop() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    bool shop = prefs.getBool('isShop');
    return shop;
  }

  Future<dynamic> saveNotifiWallet(int count) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int total = 0;
    int notification = prefs.getInt("notificationWallet");
    if (notification is int) {
      total = notification + count;
    } else {
      total = count;
    }
    prefs.setInt("notificationWallet", total);
    return true;
  }
  Future<dynamic> saveNotifiKhuyenMai(int count) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int total = 0;
    int notification = prefs.getInt("notificationKhuyenMai");
    if (notification is int) {
      total = notification + count;
    } else {
      total = count;
    }
    prefs.setInt("notificationKhuyenMai", total);
    return true;
  }
  Future<dynamic> saveNotifiDonHang(int count) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int total = 0;
    int notification = prefs.getInt("notificationDonHang");
    if (notification is int) {
      total = notification + count;
    } else {
      total = count;
    }
    prefs.setInt("notificationDonHang", total);
    return true;
  }

  Future<dynamic> getNotifiWallet() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int notification = prefs.getInt("notificationWallet");
    return notification;
  }
  Future<dynamic> getNotifiKhuyenMai() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int notification = prefs.getInt("notificationKhuyenMai");
    return notification;
  }
  Future<dynamic> getNotifiDonHang() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int notification = prefs.getInt("notificationDonHang");
    return notification;
  }


  Future<dynamic> deleteNotifiWallet() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.remove('notificationWallet');
    return true;
  }
  Future<dynamic> deleteNotifiKhuyenMai() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.remove('notificationKhuyenMai');
    return true;
  }
  Future<dynamic> deleteNotifiDonHang() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.remove('notificationDonHang');
    return true;
  }


}
