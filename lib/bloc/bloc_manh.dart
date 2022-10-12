import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/media/imageItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocTest {
  List<ProductItem> addressList = new List<ProductItem>();
  final _AddressListFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get allAddress => _AddressListFetcher.stream;

  StreamController addressDefaultValue = new StreamController<ProductItem>();
  Stream<AddressItem> get addressDefaultStream => addressDefaultValue.stream;

  getProductDetail(String category_id, int page) async {
    var product = new ProductItem();
    var token = await Const.web_api.getToken();


    Map<String, String> request_body = new Map<String, String>();
    request_body['limit'] = '12';
    request_body['page'] = '$page';
    request_body['category_id'] = '$category_id';

    var response = await Const.web_api.postAsync(
        "/app/product/get-products", token, request_body);

    if (response != null) {
      if (response['code'] == 1) {
        for (var item in response['data']) {
          product = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: item['price'],
            price_market: item['price_market'],
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : item['rate'].toDouble(),
          );
          addressList.add(product);
        }
      }
    }
    _AddressListFetcher.sink.add(addressList);
  }

  setDefault(item){
    addressDefaultValue.sink.add(item);
  }


  dispose() {
    addressDefaultValue.close();
    _AddressListFetcher.close();
  }
}
