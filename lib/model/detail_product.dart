import 'package:gcaeco_app/model/shop.dart';

class DetailProduct {
  String id,
      name,
      // ignore: non_constant_identifier_names
      category_id,
      price,
      price_market,
      // ignore: non_constant_identifier_names
      avatar_path,
      // ignore: non_constant_identifier_names
      avatar_name,
      // ignore: non_constant_identifier_names
      short_description,
      description,
      // ignore: non_constant_identifier_names
      shop_id,
      // ignore: non_constant_identifier_names
      created_at,
      rate,
      // ignore: non_constant_identifier_names
      flash_sale,
      unit,
      // ignore: non_constant_identifier_names
      note_fee_ship,
      status,
      viewed,
      ishot,
      affiliate_gt_product,
      alias,
      // ignore: non_constant_identifier_names
      check_in_cart;
  Shop shop;

  DetailProduct(
    this.id,
    this.name,
    this.category_id,
    this.price,
    this.price_market,
    this.avatar_path,
    this.avatar_name,
    this.short_description,
    this.description,
    this.shop_id,
    this.rate,
    this.flash_sale,
    this.unit,
    this.note_fee_ship,
    this.check_in_cart,
    this.created_at,
    this.status,
    this.shop,
    this.viewed,
    this.ishot,
    this.affiliate_gt_product,
    this.alias,
  );
}
