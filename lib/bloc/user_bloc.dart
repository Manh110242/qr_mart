import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/groups.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';
import 'package:gcaeco_app/model/user.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class UserBloc {
  StreamController addGroups = new StreamController<LocationManh>();

  Stream<LocationManh> get addGroupsDefaultStream => addGroups.stream;

  // đăng ký
  signUp(Map request, String token) async {
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['SignupForm'] = request;
    var res =
        await Const.web_api.postAsync("/app/home/signup", token, request_body);
    return res;
  }

// updateUser
  update(String username, String sex, String birthday, String email,
      String phone, File avt, String pass2, String cmt,File certificate,) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req_body = new Map<String, dynamic>();
    req_body["user_id"] = user_id;
    req_body["User"] = {
      "username": username,
      "sex": sex,
      "birthday": (birthday == '') ? null : birthday,
      "email": email,
      "phone": phone,
      "cmt": cmt,
    };
    if (pass2 != "") {
      req_body["password2"] = pass2;
    }
    if (avt != null) {
      req_body["avatar"] = await MultipartFile.fromFile(avt.path,
          filename: avt.path.split('/').last);
    }
    if (certificate != null) {
      req_body["certificate"] = await MultipartFile.fromFile(certificate.path,
          filename: certificate.path.split('/').last);
    }
    FormData formData = new FormData.fromMap(req_body);
    var response = await dio.post(Const().api_host + "/app/user/update-user",
        data: formData, options: Options(headers: {'token': token}));
    return response.data;
  }

//pass
  updatePass(String newPass, String pass) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req_body = new Map<String, dynamic>();
    req_body["user_id"] = user_id;
    req_body["User"] = {"password_hash": newPass};
    req_body["password"] = pass;
    var res =
        await Const.web_api.postAsync("/app/user/update-user", token, req_body);
    return res;
  }

  //pass2
  updatepass2(String newPass, String pass) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req_body = new Map<String, dynamic>();
    req_body["user_id"] = user_id;
    req_body["User"] = {"password_hash2": newPass};
    req_body["password2"] = pass;
    var res =
        await Const.web_api.postAsync("/app/user/update-user", token, req_body);
    return res;
  }

  forgotpassword(String email) async {
    var token = await getToken();
    Map<String, String> req_body = new Map<String, String>();
    req_body["email"] = email;
    var res = await Const.web_api
        .postAsync("/app/home/request-password-reset", token, req_body);
    return res;
  }

  getUser() async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    var _user = new User();

    Map<String, String> req_body = new Map<String, String>();
    req_body['user_id'] = user_id;

    var res =
        await Const.web_api.postAsync("/app/user/get-user", token, req_body);

    if (res != null) {
      if (res["code"] == 1) {
        if (res["data"]["_address"] != null) {
          var address = new AddressItem(
            id: res["data"]["_address"]["id"].toString(),
            province_name: res["data"]["_address"]["province_name"].toString(),
            district_name: res["data"]["_address"]["district_name"].toString(),
            ward_name: res["data"]["_address"]["ward_name"].toString(),
            address: res["data"]["_address"]["address"].toString(),

          );
          var user = new User(
            id: res["data"]['id'].toString(),
            username: res["data"]['username'].toString(),
            email: res["data"]['email'].toString(),
            phone: res["data"]['phone'].toString(),
            sex: res["data"]['sex'].toString(),
            avatar_path: res["data"]['avatar_path'].toString(),
            avatar_name: res["data"]['avatar_name'].toString(),
            addressItem: address,
            birthday: res["data"]['birthday'].toString(),
            password_hash2: res["data"]['password_hash2'].toString(),
            user_before: res["data"]['user_before'].toString(),
            user_gt_app: res["data"]['user_gt_app'].toString(),
              cmt: res["data"]['cmt'].toString()
          );
          _user = user;
        } else {
          var user = new User(
            id: res["data"]['id'].toString(),
            username: res["data"]['username'].toString(),
            email: res["data"]['email'].toString(),
            phone: res["data"]['phone'].toString(),
            sex: res["data"]['sex'].toString(),
            avatar_path: res["data"]['avatar_path'].toString(),
            avatar_name: res["data"]['avatar_name'].toString(),
            addressItem: null,
            birthday: res["data"]['birthday'].toString(),
            password_hash2: res["data"]['password_hash2'].toString(),
            user_before: res["data"]['user_before'].toString(),
            user_gt_app: res["data"]['user_gt_app'].toString(),
            cmt: res["data"]['cmt'].toString()
          );
          _user = user;
        }
      }
    }
    return _user;
  }

  getToken() async {
    String token_response = '';
    DateTime now = new DateTime.now();
    var param = now.toString();
    var token = sha1.convert(utf8.encode(param + Const().key));
    var response = await Const.web_api
        .getAsync("/app/home/start?string=" + param, token.toString());
    if (response != null) {
      if (response['code'] == 1) {
        token_response = response['data']['token'];
      }
    }
    return token_response;
  }

  getGroups() async {
    var token = await getToken();
    var res = await Const.web_api.getAsync("/app/home/get-groups", token);
    List<LocationManh> listGroups = new List<LocationManh>();
    if (res != null) {
      if (res['data'].length > 0) {
        var groups = res['data'];
        groups.forEach((key, value) {
          var group =
              new LocationManh(id: key.toString(), name: value.toString());
          listGroups.add(group);
        });
      }
    }
    return listGroups;
  }

  postGroup(String id, File avt) async {
    Dio dio = new Dio();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req_body = new Map<String, dynamic>();
    req_body["user_id"] = user_id;
    req_body["UserInGroup"] = [id];
    if (avt != null) {
      req_body["image$id"] = await MultipartFile.fromFile(avt.path,
          filename: avt.path.split('/').last);
    }
    FormData formData = new FormData.fromMap(req_body);

    var response = await dio.post(Const().api_host + "/app/user/set-in-group",
        data: formData, options: Options(headers: {'token': token}));
    return response.data;
  }

  getGroupUser() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    List<Groups> listGroups = new List<Groups>();
    List<Groups> listGroups1 = new List<Groups>();
    Map<String, dynamic> req_body = new Map<String, dynamic>();
    req_body["user_id"] = user_id;
    var res =
        await Const.web_api.postAsync("/app/user/get-groups", token, req_body);
    if (res != null) {
      if (res['code'] == 1) {
        for (var data in res['data']) {
          var group = new Groups(
              id: data['id'],
              name: data['name'],
              product_categorys: data['product_categorys'],
              created_at: data['created_at'],
              updated_at: data['updated_at'],
              status: data['status'],
              user_id: data['user_id'],
              image: data['image'],
              user_in_group_id: data['user_in_group_id']);
          listGroups.add(group);
        }
        for (var abc in listGroups) {
          if (abc.status == "1") {
            var group = new Groups(
              id: abc.id,
              name: abc.name,
              status: abc.status,
            );
            listGroups1.add(group);
          }
        }
      } else {
        listGroups1 = [];
      }
    }

    return listGroups1;
  }

  postAffilliate() async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map();
    req['user_id'] = user_id;
    var res = await Const.web_api
        .postAsync('/app/coin/add-affilliate-app', token, req);
    return res;
  }

  postUserBefore(String userBefore) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, dynamic> req = new Map();
    req['user_id'] = user_id;
    req['User'] = {'user_before': userBefore};
    var res =
        await Const.web_api.postAsync('/app/user/update-user', token, req);
    return res;
  }

  insertShop(
    name,
    type,
    province_id,
    district_id,
    ward_id,
    name_contact,
    phone,
    cmt,
    address,
    description,
    scale,
    number_paper_auth,
    date_auth,
    address_auth,
  ) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    var email = await Const.web_api.getUserEmail();

    Map<String, dynamic> req = new Map();
    req['user_id'] = user_id;
    req['Shop'] = {
      'email': '$email',
      'name': '$name',
      'type': type,
      'province_id': '$province_id',
      'district_id': '$district_id',
      'ward_id': '$ward_id',
      'name_contact': '$name_contact',
      'phone': '$phone',
      'cmt': '$cmt',
      'address': '$address',
      'description': '$description',
      'scale': '$scale',
      'number_paper_auth': number_paper_auth,
      'date_auth': date_auth,
      'address_auth': address_auth,
    };

    var res =
        await Const.web_api.postAsync('/app/user/register-shop', token, req);
    return res;
  }

  setDefault(item) {
    addGroups.sink.add(item);
  }

  @override
  dispose() {}
}
