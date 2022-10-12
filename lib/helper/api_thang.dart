import 'dart:convert';
import 'dart:io';

import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/home_api.dart';
import 'package:gcaeco_app/main.dart';
import 'package:http/http.dart';
class api_thang {
  String api;
  var param;

  api_thang(api, param) {
    this.api = api;
    this.param = param;
  }

  postMethod() async {
    String url2 = Const.web_api.toString() + this.api;
    Map<String, String> headers = {"token": prefs.getString("tokenA")};
    var params = this.param;
    Response response = await post(url2, headers: headers, body: params);

    final res = jsonDecode(response.body);
    return res;
  }

  getMethod() async {
    String url2 = Const.web_api.toString() + this.api;
    Map<String, String> headers = {"token": prefs.getString("tokenA")};
    Response response = await get(url2, headers: headers);
    final res = jsonDecode(response.body);
    return res;
  }
}