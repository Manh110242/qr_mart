import '../model_shop_voucher.dart';
class ProductItem {
  final String id;
  final String name;
  final String category_id;
  final String category_name;
  final String category_track;
  final int price;
  final int price_market;
  final String currency;
  final String quantity;
  final String status;
  final String avatar_path;
  final String avatar_name;
  final String avatar_id;
  final String isnew;
  final String ishot;
  final String viewed;
  final String shop_id;
  final String shop;
  final String rate_count;
  final double rate;
  final String fee_ship;
  final String alias;
  final bool in_wish;
  final String des;
  final bool check;
  final String quantity_promotion_sale;
  final String quantity_selled_promotion_sale;
  final String vip_active;
  final String logo_vip;
  final int price_promotion_sale;
  ModelShopVoucher shopData;

  ProductItem({
    this.category_name,
    this.check,
    this.des,
    this.alias,
    this.id,
    this.name,
    this.category_id,
    this.category_track,
    this.price,
    this.price_market,
    this.currency,
    this.quantity,
    this.status,
    this.avatar_path,
    this.avatar_name,
    this.avatar_id,
    this.isnew,
    this.ishot,
    this.viewed,
    this.shop_id,
    this.shop,
    this.rate_count,
    this.rate,
    this.fee_ship,
    this.in_wish,
    this.quantity_promotion_sale,
    this.quantity_selled_promotion_sale,
    this.price_promotion_sale,
    this.logo_vip,
    this.vip_active,
    this.shopData,
  });

}
