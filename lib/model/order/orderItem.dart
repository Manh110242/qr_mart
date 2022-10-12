import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/model/products_dom_hang.dart';

class OrderItem {
  final int id;
  final String key;
  final String shop_id;
  final String user_id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String district_id;
  final String province_id;
  final String order_total;
  final String payment_status;
  final String payment_method;
  final String status;
  final String order_total_all;
  final String s_avatar_path;
  final String s_avatar_name;
  final String s_name;
  final String unit;
  final String per_unit;
  final String order_label;
  final String created_at;
  final List<ProductsDonHang> products;

  OrderItem({
    this.id,
    this.key,
    this.shop_id,
    this.user_id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.created_at,
    this.district_id,
    this.province_id,
    this.order_total,
    this.payment_status,
    this.payment_method,
    this.status,
    this.order_total_all,
    this.s_avatar_path,
    this.s_avatar_name,
    this.s_name,
    this.products,
    this.per_unit,
    this.unit,
    this.order_label,
  });

}