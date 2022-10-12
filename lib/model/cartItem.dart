import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem extends ChangeNotifier {
  final int product_id;
  final int quantity;
  final String name;
  final String image_url;
  final int price;
  final int shop_id;

  int _count = 0;
  int get count =>_count;

  CartItem({
    this.product_id,
    this.quantity,
    this.name,
    this.price,
    this.image_url,
    this.shop_id,
  });

  addToCart(cart_item) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    bool check_add = true;
    int id_prd = cart_item.product_id;
    assert(id_prd is int);
    int quantity = cart_item.quantity;
    String cart = prefs.getString('cart');
    if(cart?.isEmpty ?? true){
      final String encodedData = CartItem.encode([
        cart_item
      ]);
      prefs.setString("cart", encodedData);
    }else{
      final List<CartItem> decodedData = CartItem.decode(cart);
      final List<CartItem> CartData = new List<CartItem>();
      decodedData.forEach((element) {
        if(element.product_id == id_prd){
          int quantity = element.quantity + 1;
          element = CartItem(product_id: id_prd, quantity:quantity);
          check_add = false;
        }
        CartData.add(element);
      });
      if(check_add){
        CartData.add(CartItem(product_id: id_prd, quantity:1));
      }
      final String encodedData = CartItem.encode(CartData);
      prefs.setString("cart", encodedData);
    }
    return true;
  }

  factory CartItem.fromJson(Map<String, dynamic> jsonData) {
    return CartItem(
      product_id: jsonData['product_id'],
      quantity: jsonData['quantity'],
    );
  }

  static Map<String, dynamic> toMap(CartItem item) => {
    'product_id': item.product_id,
    'quantity': item.quantity,
  };

  static String encode(List<CartItem> items) => json.encode(
    items.map<Map<String, dynamic>>((item) => CartItem.toMap(item)).toList(),
  );

  static List<CartItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<CartItem>((item) => CartItem.fromJson(item))
          .toList();

  getList() async {
    List<CartItem> decodedData = [];
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    if(cart != null){
      decodedData = CartItem.decode(cart);
    }
    _count = decodedData.length;
    print(count);
    notifyListeners();
  }
}