import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckVersion {
  static check(BuildContext context, {String ios, String android}) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String appName = packageInfo.appName;

      int ves1 = int.parse(version.replaceAll(".", ""));
      print("Loca $ves1");
      ModelVersion modelVersion;
      if (Platform.isAndroid) {
        modelVersion = await CheckVersion().getAndroidStoreVersion(android);
      }
      if (Platform.isIOS) {
        modelVersion = await CheckVersion().getIosStoreVersion2(ios);
      }

      int ves2 = int.parse(modelVersion.version.replaceAll(".", ""));

      print("Store $ves2");

      if (version != modelVersion.version && ves2 > ves1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Cập nhật"),
            content: Text(
                "Đã có phiên bản mới của $appName.\nPhiên bản ${modelVersion.version} đã sẵn sàng.\nBạn đang dùng $version."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Đóng")),
              TextButton(
                  onPressed: () async {
                    await launch(modelVersion.url);
                  },
                  child: Text("Cập nhật")),
            ],
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getAndroidStoreVersion(String id) async {
    final url = 'https://play.google.com/store/apps/details?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print('Can\'t find an app in the Play Store with the id: $id');
      return null;
    }
    var document = parse(response.body);
    var data = document.body.getElementsByTagName("script").where((element) =>
        element.text.startsWith("AF_initDataCallback({key: 'ds:4'"));
    var list = data.first.text
        .substring("AF_initDataCallback({".length,
            data.first.text.length - "sideChannel: {}})".length)
        .split(",");
    var dataVersion =
        list.where((element) => element.startsWith('"version')).first;
    var listVersion =
        dataVersion.substring(1, dataVersion.length - 2).split(" ");

    return ModelVersion(url: url, version: listVersion.last);
  }

  getIosStoreVersion(String id) async {
    final url = 'http://itunes.apple.com/vn/lookup?bundleId=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print('Can\'t find an app in the App Store with the id: $id');
      return null;
    }
    final jsonObj = json.decode(response.body);
    print(jsonObj['results'][0]['version']);
    return ModelVersion(
        url: jsonObj['results'][0]['trackViewUrl'],
        version: jsonObj['results'][0]['version']);
  }

  getIosStoreVersion2(String id) async {
    final url = 'https://itunes.apple.com/vn/lookup?bundleId=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print('Can\'t find an app in the App Store with the id: $id');
      return null;
    }
    final jsonObj = json.decode(response.body);
    print(jsonObj['results'][0]['version']);
    return ModelVersion(
        url: jsonObj['results'][0]['trackViewUrl'],
        version: jsonObj['results'][0]['version']);
  }
}

class ModelVersion {
  String url;
  String version;

  ModelVersion({this.version, this.url});
}
