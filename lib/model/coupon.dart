class Coupon{
  String id;
  String shop_id;
  String time_start;
  String time_end;
  String type_discount;
  String value;
  String count;
  String user_use;
  String created_at;
  String status;
  String updated_at;
  String discount_shop_code_id;
  String all;
  String products;
  String order_id;
  String count_limit;

  Coupon({
    this.all,
    this.id,
    this.status,
    this.value,
    this.count,
    this.created_at,
    this.count_limit,
    this.discount_shop_code_id,
    this.order_id,
    this.products,
    this.shop_id,
    this.time_end,
    this.time_start,
    this.type_discount,
    this.updated_at,
    this.user_use
});
}