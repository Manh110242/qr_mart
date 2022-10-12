import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentItem {
  final String method_key;
  final String method_name;

  PaymentItem({
    this.method_key,
    this.method_name,
  });


  factory PaymentItem.fromJson(Map<String, dynamic> jsonData) {
    return PaymentItem(
      method_key: jsonData['method_key'],
      method_name: jsonData['method_name'],
    );
  }

  static Map<String, dynamic> toMap(PaymentItem item) => {
    'method_key': item.method_key,
    'method_name': item.method_name,
  };

  static String encode(List<PaymentItem> items) => json.encode(
    items.map<Map<String, dynamic>>((item) => PaymentItem.toMap(item)).toList(),
  );

  static List<PaymentItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<PaymentItem>((item) => PaymentItem.fromJson(item))
          .toList();
}