import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:gcaeco_app/model/shopItem.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloc {
  List<CartItem> cartProductList = new List<CartItem>();
  List<ShopItem> shopProductList = new List<ShopItem>();
  int totalPrice = 0;

  StreamController totalCreditValueFetcher = new StreamController<int>();
  Stream get totalPriceStream => totalCreditValueFetcher.stream;

  final _ProductListFetcher = BehaviorSubject<dynamic>();
  Stream<dynamic> get products => _ProductListFetcher.stream;

  fetchProducts() async {
    cartProductList = new List<CartItem>();
    totalPrice = 0;
    var token = await Const.web_api.getToken();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    if(cart != null){
      final List<CartItem> decodedData = CartItem.decode(cart);
      List product_ids = new List();
      Map<String, List> request_body = new Map<String, List>();
      Map<int, int> quantity_list = new Map<int, int>();
      decodedData.forEach((element) {
        product_ids.add(element.product_id);
        quantity_list[element.product_id] = element.quantity;
      });
      request_body['id'] = product_ids;
      if(!product_ids.isEmpty){
        var response = await Const.web_api
            .postAsync("/app/product/get-products", token, request_body);
        for (var prd in response['data']) {
          var id = prd['id'].toString();
          totalPrice += prd['price'] * quantity_list[int.parse(id)];
          var cart_item = CartItem(
              product_id: int.parse(id),
              quantity: quantity_list[int.parse(id)],
              name: prd['name'],
              image_url: Const().image_host +
                  prd['avatar_path'] +
                  prd['avatar_name'],
              price: prd['price']);
          cartProductList.add(cart_item);
        }
      }
    }
    totalCreditValueFetcher.sink.add(totalPrice);
    _ProductListFetcher.sink.add(cartProductList);

  }

  cartAdd(int productId) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    List<CartItem> _cartProductList = new List<CartItem>();
    CartItem item = new CartItem();
    cartProductList.forEach((element) {
      if(element.product_id == productId){
        totalPrice += element.price;
        item = CartItem(
          product_id:productId,
          quantity:element.quantity + 1,
          name:element.name,
          price:element.price,
          image_url:element.image_url,
        );
      }else{
        item = element;
      }
      _cartProductList.add(item);
    });
    cartProductList = _cartProductList;
    _ProductListFetcher.sink.add(cartProductList);
    totalCreditValueFetcher.sink.add(totalPrice);
    final String encodedData = CartItem.encode(cartProductList);
    prefs.setString("cart", encodedData);
  }

  cartAbatement(BuildContext context,int productId) async {
    bool check_abat = false;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    List<CartItem> _cartProductList = new List<CartItem>();
    CartItem item = new CartItem();
    cartProductList.forEach((element) {
      if(element.product_id == productId){
        if(element.quantity <= 1){
          showAlertDialog(context,productId);
        }else{
          check_abat = true;
          totalPrice -= element.price;
          item = CartItem(
            product_id:productId,
            quantity:element.quantity - 1,
            name:element.name,
            price:element.price,
            image_url:element.image_url,
          );
        }
      }else{
        item = element;
      }
      _cartProductList.add(item);
    });
    if(check_abat){
      cartProductList = _cartProductList;
      _ProductListFetcher.sink.add(cartProductList);
      totalCreditValueFetcher.sink.add(totalPrice);
      final String encodedData = CartItem.encode(cartProductList);
      prefs.setString("cart", encodedData);
    }
  }

  cartRemove(int productId) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    cartProductList.forEach((element) {
      if(element.product_id == productId){
        totalPrice -= element.quantity * element.price;
      }
    });
    cartProductList.removeWhere((item) => item.product_id == productId);
    _ProductListFetcher.sink.add(cartProductList);
    totalCreditValueFetcher.sink.add(totalPrice);
    final String encodedData = CartItem.encode(cartProductList);
    prefs.setString("cart", encodedData);
  }

  showAlertDialog(BuildContext context,int product_id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Hủy"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Xác nhận"),
      onPressed:  () {
        cartRemove(product_id);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Xóa sản phẩm?"),
      content: Text("Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng của bạn?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  dispose() {
    _ProductListFetcher.close();
    totalCreditValueFetcher.close();
  }
}
