import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/wallet/history.dart';
import 'package:gcaeco_app/model/wallet/historyVr.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/wallet/transfer_success.dart';
import 'package:gcaeco_app/validators/validations.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc {
  final _HistoryList = BehaviorSubject<dynamic>();
  Stream<dynamic> get allHistory => _HistoryList.stream;

  final _HistoryListVr = BehaviorSubject<dynamic>();
  Stream<dynamic> get allHistoryVr => _HistoryListVr.stream;

  List<HistoryItem> listHistory = new List<HistoryItem>();
  List<HistoryVrItem> listVrHistory = new List<HistoryVrItem>();

  final _userInfo = BehaviorSubject<dynamic>();
  Stream<dynamic> get userInfo => _userInfo.stream;

  StreamController _userController = new StreamController();
  Stream get userStream => _userController.stream;
  StreamController _passController = new StreamController();
  Stream get passStream => _passController.stream;
  StreamController _coinController = new StreamController();
  Stream get coinStream => _coinController.stream;

  getVoucher() async {
    Map res = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/coin/get-info-voucher", token, request_body);
    res['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['data'] = response['data'];
      }
    }
    return res;
  }

  searchUser(String str) async {
    Map res = new Map();
    var token = await Const.web_api.getTokenUser();
    var user_id = await Const.web_api.getUserId();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['keyword'] = str;
    var response = await Const.web_api
        .postAsync("/app/coin/get-user", token, request_body);
    res['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['data'] = response['data'];
      }else{
        res['errors'] = response['error'];
      }
    }else{
      res['errors'] = 'Kết nối server thất bại';
    }
    _userInfo.sink.add(res);
  }

  checkUser(String str) async {
    Map res = new Map();
    var token = await Const.web_api.getTokenUser();
    var user_id = await Const.web_api.getUserId();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['keyword'] = str;
    var response = await Const.web_api
        .postAsync("/app/coin/get-user", token, request_body);
    res['code'] = 0;
    res['id'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['id'] = response['data']['id'];
      }else{
        res['errors'] = response['error'];
      }
    }else{
      res['errors'] = 'Kết nối server thất bại';
    }
    return res;
  }

  //Chuyển V
  transfer(context,coin,otp,user_recive_id) async {
    var token = await Const.web_api.getTokenUser();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['coin'] = coin;
    request_body['otp'] = otp;
    request_body['user_recive_id'] = user_recive_id;
    var response = await Const.web_api
        .postAsync("/app/coin/voucher-transfer", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TransferSuccess('Chuyển V thành công')
            ),
            ModalRoute.withName("/")
        );
      }else{
        MsgDialog.showMsgDialog(context, response['error'], 'Lỗi!');
      }
    }else{
      MsgDialog.showMsgDialog(context, 'Kết nối server thất bại', 'Lỗi!');
    }
  }

  // Rút Vr
  bankWithdrawal(infoVr) async {
    var map = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['coin'] = infoVr['coin'];
    request_body['bank_id'] = infoVr['bank_id'];
    request_body['otp'] = infoVr['otp'];
    var response = await Const.web_api
        .postAsync("/app/coin/voucher-convert", token, request_body);

    map['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        map['code'] = 200;
      } else {
        map['errors'] = response['error'];
      }
    } else {
      map['errors'] = 'Kết nối server thất bại.';
    }
    return map;
  }

  // Chuyển Vr sang V
  transfervrtov(infoVr) async {
    var map = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['coin'] = infoVr['coin'];
    request_body['otp'] = infoVr['otp'];
    var response = await Const.web_api
        .postAsync("/app/coin/voucher-transfervrtov", token, request_body);

    map['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        map['code'] = 200;
      } else {
        map['errors'] = response['error'];
      }
    } else {
      map['errors'] = 'Kết nối server thất bại.';
    }
    return map;
  }

  removesearchUser(){
    Map res = new Map();
    res['errors'] = '';
    res['code'] = 0;
    _userInfo.sink.add(res);
  }

  //Lịch sử V
  historyV(int limit, int page) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/app/coin/get-voucher-history", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var historyItem = new HistoryItem(
            gca_coin: item['gca_coin'],
            created_at: item['created_at'],
            text_gca_coin: item['text_gca_coin'],
            data: item['data'],
          );
          listHistory.add(historyItem);
        }
      }
    }
    _HistoryList.sink.add(listHistory);
  }

  // Lịch sử rút voucher red
  historyVr(int limit, int page) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/app/coin/get-history-convert", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var historyItem = new HistoryVrItem(
            value: item['value'],
            status: item['status'],
            bank_id: item['bank_id'],
            created_at: item['created_at'],
            text_value: item['text_value'],
          );
          listVrHistory.add(historyItem);
        }
      }
    }
    _HistoryListVr.sink.add(listVrHistory);
  }

  //Lịch sử chuyển V
  historyTransfer(int limit, int page) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getTokenUser();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['user_id'] = user_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
    var response = await Const.web_api
        .postAsync("/app/coin/get-voucher-history", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          var historyItem = new HistoryItem(
            gca_coin: item['gca_coin'],
            created_at: item['created_at'],
            text_gca_coin: item['text_gca_coin'],
            data: item['data'],
          );
          listHistory.add(historyItem);
        }
      }
    }
    _HistoryList.sink.add(listHistory);
  }

  bool isValidUser(String str,type) {
    if (!Validations.isValidMoney(str)) {
      if(type == 'user'){
        _userController.sink.addError("Thông tin người nhận không được bỏ trống");
      }
      if(type == 'password'){
        _passController.sink.addError("Mật khẩu cấp 2 không được bỏ trống");
      }
      if(type == 'coin'){
        _coinController.sink.addError("Số V không được bỏ trống");
      }
      return false;
    }
    _userController.sink.add("ok");
    _passController.sink.add("ok");
    _coinController.sink.add("ok");
    return true;
  }

  @override
  dispose() {
    _HistoryList.close();
    _HistoryListVr.close();
    _userController.close();
    _passController.close();
    _coinController.close();
    _userInfo.close();
  }
}
