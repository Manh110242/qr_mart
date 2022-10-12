import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/historys_don_hang.dart';
import 'package:gcaeco_app/model/info_don_hang.dart';
import 'package:gcaeco_app/model/order/orderItem.dart';
import 'package:gcaeco_app/model/products_dom_hang.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:gcaeco_app/model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gcaeco_app/helper/const.dart';

class Donhang {
  List<OrderItem> addDonHangMoi = new List<OrderItem>();
  List<User> addlistuser = new List<User>();

  final _addDonHangFetcher = BehaviorSubject<dynamic>();

  Stream<dynamic> get allAddress => _addDonHangFetcher.stream;


  StreamController addDonHangDefaultValue = new StreamController<OrderItem>();

  Stream<AddressItem> get addDonHangDefaultStream =>
      addDonHangDefaultValue.stream;

  //test bloc
  getThongTinDonHang(String id) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    List<HistorysDonHang> hisDonHang = new List<HistorysDonHang>();
    Map<String, String> request_body = new Map<String, String>();

    request_body['user_id'] = '$user_id';
    request_body['id'] = '$id';
    request_body['info_shop'] = '1';
    request_body['info_historys'] = '1';

    var response = await Const.web_api
        .postAsync("/app/user/get-order", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        if (response['data']['_info'].length > 0) {
          if (response['data']['_info']['historys'].length > 0) {
            for (var his in response['data']['_info']['historys']) {
              var history = new HistorysDonHang(
                id: his['id'].toString(),
                order_id: his['order_id'].toString(),
                time: his['time'].toString(),
                status: his['status'].toString(),
                content: his['content'].toString(),
                created_at: his['created_at'].toString(),
              );
              hisDonHang.add(history);
            }
          }
          var shop = new Shop(
            id: response['data']['_info']['shop']['id'].toString(),
            name: response['data']['_info']['shop']['name'].toString(),
            phone: response['data']['_info']['shop']['phone'].toString(),
            email: response['data']['_info']['shop']['email'].toString(),
            name_contact:
            response['data']['_info']['shop']['name_contact'].toString(),
          );
          var info = new InfoDonHang(
            shop: shop,
            historys: hisDonHang
          );

          var userct = new User(
            id: response['data']['id'].toString(),
            username: response['data']['name'].toString(),
            email: response['data']['email'].toString(),
            address: response['data']['address'].toString(),
            phone: response['data']['phone'].toString(),
            payment_method: response['data']['payment_method'].toString(),
            info: info,
          );
          return userct;
        }
      }else{
        return 0;
      }
    }
    return null;
  }


  getProductByListCategoryHome(int status, int page, check) async {
    if(check){
      addDonHangMoi = [];
    }
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();

    Map<String, int> request_body = new Map<String, int>();
    request_body['user_id'] = int.parse(user_id);
    request_body['info_products'] = 1;
    request_body['status'] = status;
    request_body['page'] = page;
    request_body['limit'] = 12;

    var response = await Const.web_api
        .postAsync("/app/user/get-order-list", token, request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          List<ProductsDonHang> products = new List<ProductsDonHang>();
          if (item['products'].length > 0) {
            for (var prd in item['products']) {
              var productItem = new ProductsDonHang(
                id: prd['id'].toString(),
                name: prd['name'].toString(),
                avatar_path: prd['avatar_path'].toString(),
                avatar_name: prd['avatar_name'].toString(),
                price: prd['price'],
                alias: prd['alias'],
                quantity: prd['quantity'],
              );
              products.add(productItem);
            }
          }
          var ord = new OrderItem(
            id: int.parse(item['id']),
            key: item['key'].toString(),
            shop_id: item['shop_id'].toString(),
            user_id: item['user_id'].toString(),
            name: item['name'].toString(),
            email: item['email'].toString(),
            phone: item['phone'].toString(),
            address: item['address'].toString(),
            district_id: item['district_id'].toString(),
            province_id: item['province_id'].toString(),
            order_total: item['order_total'].toString(),
            status: item['status'].toString(),
            payment_status: item['payment_status'].toString(),
            payment_method: item['payment_method'].toString(),
            order_total_all: item['order_total_all'].toString(),
            s_avatar_path: item['s_avatar_path'].toString(),
            s_avatar_name: item['s_avatar_name'].toString(),
            s_name: item['s_name'].toString(),
            unit: item['unit'].toString(),
            per_unit: item['per_unit'].toString(),
            order_label: item['order_label'].toString(),
            products: products,
          );
          addDonHangMoi.add(ord);
        }
      }
    }
    _addDonHangFetcher.sink.add(addDonHangMoi);
  }

  huydon(id, status, context) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();

    Map<String, String> request_body = new Map<String, String>();
    request_body['user_id'] = user_id;
    request_body['id'] = id;
    request_body['status'] = status;

    var response = await Const.web_api
        .postAsync("/app/user/update-order-status", token, request_body);
    showToast("Hủy đơn hàng thành công", context, Colors.green, Icons.check);
    return response;

  }

  setDefault(item) {
    addDonHangDefaultValue.sink.add(item);
  }

  dispose() {
    addDonHangDefaultValue.close();
    _addDonHangFetcher.close();
  }
}
