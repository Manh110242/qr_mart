import 'package:gcaeco_app/model/cartItem.dart';

class VoucherItem {
  final String code;
  final int shop_id;
  final String time_start;
  final String time_end;
  final int type_discount;
  final String value;
  final String count;
  final String user_use;
  final String status;
  final String discount_shop_code_id;
  final String all;
  final String products;
  final String order_id;

  VoucherItem({
    this.code,
    this.shop_id,
    this.time_start,
    this.time_end,
    this.type_discount,
    this.value,
    this.count,
    this.user_use,
    this.status,
    this.discount_shop_code_id,
    this.all,
    this.products,
    this.order_id,
  });

}