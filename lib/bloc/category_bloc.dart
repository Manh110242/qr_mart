import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/products/CategoryItem.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {

  final _ProductListFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get allProducts => _ProductListFetcher.stream;
  List<ProductItem> products = new List<ProductItem>();

  fetchProductsByCategory(String page,int category_id,int limit) async {
    var token = await Const.web_api.getToken();
    var user_id = await Const.web_api.getUserId();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
    request_body['category_id'] = category_id;
    request_body['limit'] = limit;
    request_body['page'] = page;
    request_body['user_id'] = user_id;
    var response = await Const.web_api
        .postAsync("/app/product/get-products", token,request_body);
    if (response != null) {
      if (response['code'] == 1) {
        for(var item in response['data']){
          var productItem = new ProductItem(
            id: item['id'].toString(),
            name: item['name'].toString(),
            avatar_path: item['avatar_path'].toString(),
            avatar_name: item['avatar_name'].toString(),
            price: item['price'],
            price_market: item['price_market'],
            fee_ship: item['fee_ship'].toString(),
            rate_count: item['rate_count'].toString(),
            rate: item['rate'] == null ? 0 : double.parse(item['rate']),
            in_wish: item['in_wish'],
          );
          products.add(productItem);
        }
      }
    }
    _ProductListFetcher.sink.add(products);
  }

  getCategoryChildren(int category_id) async {
    List<CategoryItem> categories = new List<CategoryItem>();
    Map<String, dynamic> request_body = new Map<String, dynamic>();
      request_body['category_id'] = category_id;
    var token = await Const.web_api.getToken();
    var response = await Const.web_api
        .postAsync("/app/product/get-product-categories", token,request_body);
    if (response != null) {
      if(response['code'] == 1){
        if (response['data']?.isEmpty ?? true) {

        }else{
          response['data'].forEach((k,item){
            var category_item = new CategoryItem(
              id: int.parse(item['id']),
              name: item['name'],
              icon_path: item['icon_path'],
              icon_name: item['icon_name'],
              avatar_path: item['avatar_path'],
              avatar_name: item['avatar_name'],
            );
            categories.add(category_item);
          });
        }
      }
    }
    return categories;
  }

  getCategoryShowHome() async {
    List<CategoryItem> categories = new List<CategoryItem>();
    var token = await Const.web_api.getToken();
    var response = await Const.web_api
        .getAsync("/app/home/get-productcat-showhome", token);
    if (response != null) {
      if(response['code'] == 1){
        for(var item in response['data']){
          var category_item = new CategoryItem(
            id: item['id'],
            name: item['name'],
            icon_path: item['icon_path'],
            icon_name: item['icon_name'],
            avatar_path: item['avatar_path'],
            avatar_name: item['avatar_name'],
            bgr_path: item['bgr_path'],
            bgr_name: item['bgr_name'],
          );
          categories.add(category_item);
        }
      }
    }
    return categories;
  }

  getCharity() async {
    String res = '';
    var token = await Const.web_api.getToken();
    var response = await Const.web_api
        .getAsync("/app/home/total-charity", token);
    if (response != null) {
      if(response['code'] == 1){
        res = response['data']['total_text'];
      }
    }
    return res;
  }

  @override
  dispose() {
    _ProductListFetcher.close();
    products = [];
  }
}
