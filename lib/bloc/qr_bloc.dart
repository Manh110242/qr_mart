import 'dart:async';
import 'dart:convert';

import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/model_shop_voucher.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/validators/validations.dart';

import 'bloc_home_new.dart';

class QrBloc {
  var orderItem;
  Map orderResponse = new Map();

  StreamController _moneyController = new StreamController();

  Stream get moneyStream => _moneyController.stream;

  StreamController _passController = new StreamController();

  Stream get passStream => _passController.stream;

  bool isValidMoneyInfo(String str) {
    if (!Validations.isValidMoney(str)) {
      _moneyController.sink.addError("Số tiền không được bỏ trống");
      return false;
    }
    _moneyController.sink.add("ok");
    return true;
  }

  bool isValidPassInfo(String str) {
    if (!Validations.isValidMoney(str)) {
      _passController.sink.addError("Mật khẩu không được bỏ trống");
      return false;
    }
    _passController.sink.add("ok");
    return true;
  }

  payment(pass, money, token_qr) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['otp'] = pass;
    request_body['token'] = token_qr;
    request_body['money'] = money;
    print(json.encode(request_body));
    print(token);
    var response = await Const.web_api
        .postAsync("/app/coin/payment-qr", token, request_body);
    if (response != null) {
      if (response['code'] == 0) {
        return response['error'];
      }
      if (response['code'] == 1) {
        return 'success';
      }
    }
    return null;
  }

  paymentOrder(pass, token_qr) async {
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['otp'] = pass;
    request_body['token'] = token_qr;
    var response = await Const.web_api
        .postAsync("/app/coin/payment-qr", token, request_body);
    if (response['code'] == 1) {
      orderItem = new OrderItem(
        id: response['data']['success'][0]['id'],
        key: response['data']['success'][0]['key'],
        s_name: response['data']['success'][0]['s_name'],
        order_total_all:
            response['data']['success'][0]['order_total_all'].toString(),
      );
      orderResponse['code'] = 200;
    } else {
      orderItem = new OrderItem();
      orderResponse['errors'] = response['error'];
      orderResponse['code'] = 0;
    }
    orderResponse['order'] = orderItem;
    return orderResponse;
  }

  getInfoToken(token_qr) async {
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    var res = new Map();
    request_body['token'] = token_qr;
    var response = await Const.web_api
        .postAsync("/app/home/get-info-qr", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['type'] = response['data']['type'];
        res['user'] = response['data']['user'];
        res['shop'] = response['data']['shop'];
        res['product_service'] = response['data']['product_service'];
        res['fee_tranpost'] = response['data']['fee_tranpost'];
      } else {
        res['code'] = 0;
        res['errors'] = response['error'];
      }
    } else {
      res['code'] = 500;
      res['errors'] = 'Kết nối đên server thất bại.';
    }
    return res;
  }

  getVoucher() async {
    Map res = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/coin/get-info-voucher", token, request_body);
    res['code'] = 0;
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['v'] = response['data']['text_coin'];
      }
    }
    return res;
  }

  getOrder(String qr_token) async {
    Map res = new Map();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['token'] = qr_token;
    var response = await Const.web_api
        .postAsync("/app/home/get-order-qr", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        res['code'] = 200;
        res['order'] = new OrderItem(
            id: response['data']['orders'][0]['id'],
            key: response['data']['key'],
            order_total: response['data']['total'].toString());
      } else {
        res['code'] = 0;
        res['errors'] = response['error'];
      }
    } else {
      res['code'] = 0;
      res['errors'] = 'Kết nối đên server thất bại.';
    }
    return res;
  }

  getImageMyQr() async {
    var res = new Map();
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/home/get-image-qrs", token, request_body);
    res['response'] = response;
    res['user_id'] = user_id;
    return res;
  }

  static getPrdVoucher(code) async {
    List list = [];
    var user_id = await Const.web_api.getUserId();
    var token = await Const.web_api.getToken();
    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['code'] = code;
    var response = await Const.web_api
        .postAsync("/app/shopping/add-voucher", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        ModelShopVoucher modelShopVoucher = ModelShopVoucher.fromJson(response['data']['shop']);
        for(var prd in response['data']['products']){
          var productItem = new ProductItem(
            id: prd['id'].toString(),
            name: prd['name'].toString(),
            avatar_path: prd['avatar_path'].toString(),
            avatar_name: prd['avatar_name'].toString(),
            price: prd['price'] != null ? double.parse(prd['price'].toString()).round() : 0,
            price_market: prd['price_market'] != null ? double.parse(prd['price_market'].toString()).round() : 0,
            fee_ship: prd['fee_ship'].toString(),
            rate_count: prd['rate_count'] == null ? "0" : prd['rate_count'].toString(),
            in_wish: prd['in_wish'] ?? false,
            rate: prd['rate'] == null ? 0 : double.parse(prd['rate']),
            vip_active: prd['vip_active'] != null
                ? prd['vip_active'].toString()
                : "",
            logo_vip: BlocHomeNew.getImageVip(prd['vip'].toString()),
            shopData: modelShopVoucher,
          );
          list.add(productItem);
        }
      }
    }

    return list;
  }

  @override
  dispose() {
    _moneyController.close();
    _passController.close();
  }
}
